# Spring Boot and request flow

How a Spring Boot service works internally, and exactly what happens to an HTTP request from the moment it reaches the container until a response goes back — including the logging that runs **before Spring sees the request at all**. This page is about deep understanding of the runtime, not configuration; see [authentication and roles](../concepts/authentication.md) for token rules and [observability](observability.md) for where the logs go afterwards.

## What Spring Boot adds

A plain Spring application needs a lot of setup: which beans exist, which web server to use, how configuration is loaded. Spring Boot removes that boilerplate with four mechanisms:

| Mechanism | What it does | In this project |
| --- | --- | --- |
| **`@SpringBootApplication`** | Combines `@Configuration`, `@EnableAutoConfiguration` and `@ComponentScan` | On each service's main class, plus `@EnableJms` and `@Import(CommonConfig.class)` |
| **Auto-configuration** | Creates beans conditionally based on what is on the classpath | Add `spring-boot-starter-web` → embedded Tomcat appears; add the OAuth2 resource-server starter → a JWT decoder is configured; add JPA → a DataSource and EntityManager appear |
| **Starters** | Curated dependency bundles | `web`, `security`, `oauth2-resource-server`, `data-jpa`, `actuator`, `artemis`, `aop` in the base POM |
| **Externalised configuration** | Values come from properties, environment variables and profiles | `application-common.properties` uses `${DATASOURCE_URL:...}` placeholders injected by Kubernetes ConfigMaps/Secrets |

The application is a **fat JAR** with a `main()` method and an **embedded Tomcat** — there is no separate web server process. `server.port=${SERVER_PORT:8080}` is why every backend container listens on 8080.

### The IoC container

Spring's Inversion-of-Control container creates and wires beans. When a class needs a dependency, it receives it rather than constructing it. This project uses constructor injection throughout, mostly via Lombok's `@RequiredArgsConstructor`:

```java
@RequiredArgsConstructor
@RestController
@RequestMapping("inventory-api")
public class ProductController {
    private final LagerService productService;
}
```

Spring sees `final` fields, generates the constructor at compile time, and injects the `LagerService` bean at runtime. The same pattern supplies `MeterRegistry` to `LoggingAspect` and `JwtAuthConverter` to `SecurityConfig`.

### Configuration import and profiles

Each service's `application.properties` imports the shared file:

```properties
spring.config.import=classpath:/application-common.properties
```

`SPRING_PROFILES_ACTIVE` selects `dev` or `staging`. That profile changes the Logback appenders (JSON in both, but different logger levels) and the logging configuration — see [observability](observability.md#how-the-application-produces-logs).

## The request journey: what gets accessed first

This is the part that shows how the pieces really fit. A `GET /inventory-api/inventory` with a bearer token passes through these layers **in this order**:

```mermaid
sequenceDiagram
  autonumber
  participant C as Browser
  participant T as Tomcat connector
  participant V as EarlyLoggingValve
  participant SF as Spring Security filter chain
  participant LOG as Inline logging filter
  participant JWT as Bearer-token filter + JwtAuthConverter
  participant MDC as MdcJwtFilter
  participant DS as DispatcherServlet
  participant PX as AOP proxy (LoggingAspect)
  participant CTRL as Controller
  participant SVC as Service
  participant REPO as Repository
  participant DB as PostgreSQL

  C->>T: HTTP request
  T->>V: Tomcat context valve
  V->>V: log "EARLY TOMCAT Incoming Request: method, uri"
  V->>SF: getNext().invoke(...)
  Note over SF: Spring sees the request only NOW
  SF->>LOG: filter added before pre-auth filter
  LOG->>LOG: method, URI, IP, User-Agent,<br/>Authorization length, JWT head, auth state
  LOG->>JWT: continue chain
  JWT->>JWT: validate signature, issuer, expiry;<br/>map roles → ROLE_USER
  JWT->>MDC: SecurityContext now populated
  MDC->>MDC: MDC.put(userId=sub, username=preferred_username)
  MDC->>DS: continue chain
  DS->>DS: HandlerMapping selects controller method
  DS->>PX: invoke proxied controller
  PX->>PX: MDC.put(method, class); start timer
  PX->>CTRL: proceed()
  CTRL->>SVC: call proxied service
  SVC->>SVC: aspect logs again (nested)
  SVC->>REPO: call proxied repository
  REPO->>DB: SQL query
  DB-->>REPO: rows
  REPO-->>SVC: entities
  SVC-->>CTRL: result
  CTRL-->>PX: return
  PX->>PX: log exit + duration; record Micrometer meters;<br/>MDC.remove(method, class)
  PX-->>DS: response
  DS-->>MDC: unwind filters
  MDC->>MDC: finally → MDC.clear()
  MDC-->>SF: continue
  SF-->>V: response
  V->>V: log "EARLY TOMCAT Outgoing Response: status"
  V-->>C: HTTP response
```

### 1. Tomcat and the valve — logging before Spring exists

The request first hits the embedded Tomcat connector. A context **valve** (`EarlyLoggingValve`) is installed through `WebServerFactoryCustomizer`. Valves are a Tomcat concept that sits *outside* the servlet API, so this code runs before any Spring filter, interceptor or controller is involved:

```java
log.info("EARLY TOMCAT Incoming Request: method={}, uri={}", ...);
getNext().invoke(request, response);   // continue into Spring
log.info("EARLY TOMCAT Outgoing Response: status={}", response.getStatus());
```

This is the "smart logging even before the request arrives" idea: because the valve wraps the entire chain, it records the raw request even if authentication rejects it later, and it always records the final status on the way out. Nothing in Spring can suppress those two lines. See [the shared library](../concepts/common-library.md#how-a-request-is-observed).

### 2. The Spring Security filter chain

Tomcat hands the request to the servlet filter chain. Spring Security registers a single `FilterChainProxy` containing several security filters. Two things happen here:

**An inline diagnostic filter** is inserted before `AbstractPreAuthenticatedProcessingFilter` in `SecurityConfig`. It logs method, URI, client IP and User-Agent, the length of the `Authorization` header (truncated to 50 characters), the first 20 characters of the JWT header and first 30 of the payload, and whether the `SecurityContext` holds an authenticated principal. At this point the token has **not** been validated yet, so `auth` is commonly null — the log says "Unauthenticated request" even for a valid token that has not been processed yet.

**The bearer-token filter** then extracts the JWT and asks Spring to validate it: signature against Keycloak's JWKS, `iss` against the configured issuer, and expiry. `JwtAuthConverter` converts the validated `Jwt` into a `JwtAuthenticationToken` with `ROLE_`-prefixed authorities and stores it in the `SecurityContextHolder`. Only now is the request authenticated.

### 3. MdcJwtFilter — user context for every log line

A separate servlet filter, `MdcJwtFilter`, reads the principal from `SecurityContextHolder` and puts two values into the thread-local **MDC**:

```java
MDC.put("userId", jwt.getClaimAsString("sub"));
MDC.put("username", jwt.getClaimAsString("preferred_username"));
```

Its `finally` block calls `MDC.clear()` so values cannot leak into the next request on a pooled thread.

A subtlety worth understanding: `LoggingConfig` registers this filter with `Ordered.LOWEST_PRECEDENCE - 10`. The source comment claims this makes it "run early", but in Spring a *lower* order value means *higher* precedence — `LOWEST_PRECEDENCE - 10` actually places it very **late** in the chain. That is precisely what the filter needs: it must run after Spring Security so the principal exists. The [observability page](observability.md) notes the same point.

### 4. DispatcherServlet and the MVC layer

The `DispatcherServlet` is Spring MVC's front controller. It asks a `HandlerMapping` which controller method matches the path and verb, then invokes it (through any configured interceptors — none in this project). The controller is not called directly; it is an AOP proxy.

### 5. AOP proxies — nested method interception

Because `LoggingAspect` has a pointcut over `service..*`, `controller..*` and `repository..*`, all three layers are proxied. One logical request therefore produces nested aspect entries:

```text
Method Entered: InventoryController.getAllProducts
  Method Entered: InventoryService.getAllProducts
    Method Entered: ProductRepository.findAll
    Method Exited:  ProductRepository.findAll [45ms]
  Method Exited:  InventoryService.getAllProducts [47ms]
Method Exited:  InventoryController.getAllProducts [48ms]
```

Each proxy puts `method` and `class` into the MDC, starts a timer, calls `proceed()` (the real method), then records duration and Micrometer meters, warns if the call took more than one second, and removes its MDC keys. See [AOP explained](aop.md#the-projects-loggingaspect).

### 6. The unwind

Responses travel back through the same layers in reverse. The aspects log exits, the `DispatcherServlet` renders the JSON, the `MdcJwtFilter` clears the MDC in `finally`, Spring Security adds its headers, and the Tomcat valve emits the final status line. Even an exception thrown in the repository is caught by the aspect (which logs it and rethrows), then handled by the shared `GlobalExceptionHandler` at the MVC layer — and the valve still sees the response.

## Why this design matters

- **There is always a first and last log line** for a request, regardless of where it fails, because the Tomcat valve sits outside Spring.
- **User context is available automatically** on every application log line through the MDC, without passing `userId` through every method signature.
- **Cross-cutting timing is centralised** — no `log.info("Entering...")` in business code.
- **The ordering is deliberate**: raw capture before security, user context after authentication, method detail inside the proxied beans.

The trade-offs are also real: the diagnostic filter logs token fragments, `PropertyLogger` logs configuration values including passwords, and none of the layers propagate a trace ID across services. Those are recorded in [Zero Trust](zero-trust.md#verbose-logging-as-a-security-risk) and [limitations](limitations.md#observability-gaps).

## Where to read next

- [AOP explained](aop.md) — the proxy mechanism in full.
- [Observability explained](observability.md) — what happens to these log lines after stdout.
- [The shared Java library](../concepts/common-library.md#how-a-request-is-observed) — the five components in code.
- [Keycloak and OIDC](keycloak.md#from-token-to-authority) — how the token becomes a Spring Security principal.
