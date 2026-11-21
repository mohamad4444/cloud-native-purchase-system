# Thesis concept diagrams — Mermaid drafts

Reconstructions of the conceptual flows described in the bachelor thesis but never drawn as figures. These diagrams are editable Mermaid so they can be dropped into the real docs. Draft only; not in navigation.

Each diagram is verified against the thesis and the checked-in source. Where the thesis uses an **illustrative example** that differs from the deployed system, this is stated explicitly.

## Authentication and security

### Authorization Code Flow (confidential client)

**Thesis illustration** (§2.11.3). The client `my-thymeleaf-app`, redirect `http://localhost:8080/login/oauth2/code/keycloak`, and secret `abc123` are the thesis's teaching example — they are **not** in the deployed realm. The deployed confidential client is `purchase-service-client`; the browser client is the public `web-frontend-client`.

```mermaid
sequenceDiagram
  autonumber
  actor User
  participant App as Spring Boot app
  participant KC as Keycloak
  User->>App: GET /protected
  App->>App: Security detects unauthenticated request
  App-->>User: 302 redirect to Keycloak /auth
  Note over App,KC: response_type=code · client_id · redirect_uri<br/>scope · state · nonce
  User->>KC: GET authorization endpoint
  KC-->>User: Login form
  User->>KC: POST credentials
  KC-->>User: 302 redirect with code + state
  User->>App: GET redirect_uri?code&state
  App->>App: validate state (CSRF protection)
  App->>KC: POST /token (code + client_secret)
  KC-->>App: access_token + id_token + refresh_token
  App-->>User: Protected resource
```

### Authorization Code Flow with PKCE (public client)

The deployed browser client is `web-frontend-client` (`publicClient: true`, PKCE `S256`, redirects `http://localhost:4200/*` and `https://frontend.local/*`) — `my-spa-app` / `localhost:3000` in the thesis (§2.11.3) are illustrative.

```mermaid
sequenceDiagram
  autonumber
  actor User
  participant SPA as Browser SPA (web-frontend-client)
  participant KC as Keycloak
  User->>SPA: Open protected route (localhost:4200)
  SPA->>SPA: Generate code_verifier<br/>code_challenge = SHA256(verifier)
  SPA->>KC: GET /auth + code_challenge + method=S256 + state + nonce
  KC-->>User: Login form
  User->>KC: POST credentials
  KC-->>SPA: 302 redirect with code + state
  SPA->>SPA: validate state
  SPA->>KC: POST /token (code + code_verifier, no secret)
  KC->>KC: Hash verifier, compare to stored challenge
  alt Challenge matches
    KC-->>SPA: access_token + id_token + refresh_token
  else Mismatch
    KC-->>SPA: error (denied)
  end
  SPA->>SPA: Store tokens, send Bearer on API calls
```

### Zero Trust: from perimeter to identity-centric

Source: thesis §2.11–2.11.2 (NIST SP 800-207). "Never trust, always verify". The project implements the IAM foundation, not a service mesh.

```mermaid
flowchart TB
  subgraph OLD["Castle-and-moat (obsolete)"]
    direction LR
    U1["Untrusted<br/>outside"] -->|"cross perimeter"| FW["Firewall / VPN"]
    FW --> T1["Trusted inside<br/>(implicit trust)"]
  end
  subgraph NEW["Zero Trust (this project's direction)"]
    direction LR
    REQ["Every request<br/>user · service · device"] --> AUTH["Authenticate + authorize"]
    AUTH --> ENC["Encrypt in transit"]
    ENC --> POL["Continuous assessment<br/>and adaptive policy"]
    POL --> OK["Grant / deny"]
  end
  OLD -.->|"dissolved perimeter"| NEW
  classDef bad fill:#fdecea,stroke:#c62828,color:#b71c1c;
  classDef good fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20;
  class U1,FW,T1 bad;
  class REQ,AUTH,ENC,POL,OK good;
```

### JWT validation and role mapping in Spring

Source: thesis §2.12, §4.3.2 (`JwtAuthConverter`, `SecurityConfig`). The uppercase step matches the code (`"ROLE_" + role.toUpperCase()`), which is more precise than the thesis listing.

```mermaid
flowchart TB
  REQ["API request + Bearer JWT"] --> SF["Spring Security filter chain"]
  SF --> VERIFY["Verify signature via JWKS<br/>(internal Keycloak URL)"]
  VERIFY --> ISS["Check issuer claim matches configured URI"]
  ISS --> CONV["JwtAuthConverter"]
  CONV --> SCP["OAuth2 scope authorities<br/>(JwtGrantedAuthoritiesConverter)"]
  CONV --> R1["realm_access.roles"]
  CONV --> R2["resource_access.web-frontend-client.roles"]
  R1 --> MAP["uppercase + prefix ROLE_"]
  R2 --> MAP
  SCP --> CTX["SecurityContext authorities"]
  MAP --> CTX
  CTX --> AUTHZ{"@PreAuthorize hasRole('USER')?"}
  AUTHZ -->|yes| OK["Controller executes"]
  AUTHZ -->|no| DENY["403 JSON response"]
  classDef flow fill:#e3f2fd,stroke:#1565c0,color:#0d47a1;
  class REQ,SF,VERIFY,ISS,CONV,SCP,R1,R2,MAP,CTX,OK flow;
```

## Aspect-Oriented Programming

### Generic Spring AOP proxy flow (theory)

Source: thesis §2.13, "Client → Proxy → Advice Execution → Target Object". **Generic model** — in this project the only advice is a single `@Around` `LoggingAspect`; there is no security AOP advice (Spring Security is a servlet filter).

```mermaid
flowchart LR
  C["Client"] --> P["Spring proxy<br/>(injected bean)"]
  P --> A1["Generic advice<br/>(e.g. @Before)"]
  A1 --> A2["@Around advice<br/>(LoggingAspect in this project)"]
  A2 --> T["Target object<br/>(original method)"]
  T --> A2B["@Around after / @AfterReturning<br/>(unwind)"]
  A2B --> P2["Proxy returns"]
  P2 --> C
  classDef proxy fill:#ede7f6,stroke:#5e35b1,color:#311b92;
  class P,A1,A2,A2B,P2 proxy;
```

### Advice chain and proceed() unwind (generic model)

Source: thesis §2.13. The thesis example lists a security interceptor before logging, but the implemented project has only `LoggingAspect` — the diagram below is the **generic AOP model**, not this project's runtime chain.

```mermaid
sequenceDiagram
  autonumber
  actor Client
  participant Proxy
  participant A1 as Interceptor 1 (example: security)
  participant A2 as Interceptor 2 (LoggingAspect)
  participant Target
  Client->>Proxy: method call
  Proxy->>A1: invoke chain
  A1->>A2: proceed()
  A2->>Target: proceed() → invoke target
  Target-->>A2: return value
  A2-->>A1: after-advice (log duration)
  A1-->>Proxy: after-advice
  Proxy-->>Client: result
```

## Messaging and event flow

### Implemented request/reply over two fixed queues

**Implementation version** (code + thesis §4.3.3). The thesis §2.14.4 Figure 2.2 shows an illustrative JMSReplyTo pattern with `PurchaseMadeEvent`/`ResultEvent`. The actual code uses two **fixed named queues** (`purchase.requested`, `purchase.result`) and `PurchaseRequestedEvent`/`PurchaseResultEvent`; there is no JMSReplyTo header.

```mermaid
sequenceDiagram
  autonumber
  participant P as Purchase Service
  participant RQ as purchase.requested
  participant I as Inventory Service
  participant PQ as purchase.result
  P->>RQ: PurchaseRequestedEvent
  RQ->>I: deliver event
  I->>I: check and reduce stock
  I->>PQ: PurchaseResultEvent
  PQ->>P: deliver result
  P->>P: set CONFIRMED or REJECTED
```

### BaseEvent polymorphic message contract

Source: thesis §4.3.3, Listings 4.23–4.25, and `JmsConfig`. The `_type` discriminator is the key to polymorphic deserialization.

```mermaid
classDiagram
  class BaseEvent {
    <<abstract>>
    +String eventId
    +Instant eventTimestamp
    +String eventType
    +_type discriminator: PurchaseRequested | PurchaseResult
  }
  class PurchaseRequestedEvent {
    +String product
    +int quantity
    +Integer purchaseId
    +Long lagerItemId
  }
  class PurchaseResultEvent {
    +Integer purchaseId
    +boolean success
    +String message
  }
  BaseEvent <|-- PurchaseRequestedEvent
  BaseEvent <|-- PurchaseResultEvent
```

## Observability

### Layered request logging (thesis §4.3.3)

Source: thesis §4.3.3 "Layered Logging Strategy", §4.8. The five components are PropertyLogger (startup), EarlyLoggingValve, MdcJwtFilter, LoggingAspect, and Logback. The return path clears the MDC and logs the final status.

```mermaid
flowchart TB
  PL["PropertyLogger<br/>(startup configuration log)"]
  V["EarlyLoggingValve<br/>Tomcat: raw request + final status"]
  S["Spring Security<br/>authenticate + authorize"]
  M["MdcJwtFilter<br/>userId + username into MDC"]
  C["Controllers"]
  A["LoggingAspect (@Around)<br/>entry/exit/duration + Micrometer"]
  B["Business logic"]
  L["logback-spring.xml<br/>human-readable (dev) / JSON (staging)"]
  V --> S --> M --> C --> A --> B
  A -.->|"clear method/class"| A
  M -.->|"clear MDC on return"| M
  V -.->|"final status"| L
  A -.-> L
  M -.-> L
  classDef log fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20;
  class PL,V,M,A,L log;
```

### Log pipeline to Grafana

Source: thesis §4.8.1 and `alloy-configmap.yaml`. The same `loki-gateway` serves both writes (`/loki/api/v1/push`) and Grafana queries.

```mermaid
flowchart LR
  J["Spring JSON to stdout"] --> F["Node container log files"]
  F --> AL["Alloy discovery + relabel + file_match + source.file"]
  AL --> GW_W["loki-gateway<br/>(write /push)"]
  GW_W --> LS["Loki storage (singleBinary + MinIO/S3)"]
  G["Grafana Explore"] --> GW_R["loki-gateway<br/>(read/query)"]
  LS --> GW_R
  classDef obs fill:#fff3e0,stroke:#ef6c00,color:#e65100;
  class AL,GW_W,LS,GW_R,G obs;
```

## Data and build

### Flyway migration flow (Inventory Service)

The Inventory Service has `V1__init.sql` (creates `lager_item`) and `V2__addData.sql` (seed rows). Other services own their own scripts (e.g. Purchase has `V1__init.sql`, `V2__status.sql`, `V3__userId.sql`).

```mermaid
flowchart LR
  START["Service startup"] --> F["Flyway enabled"]
  F --> HIST["Create / validate<br/>flyway_schema_history"]
  HIST --> LOC["Scan classpath:db/migration"]
  LOC --> V1["V1__init.sql<br/>create table"]
  V1 --> H1["history updated"]
  H1 --> V2["V2__addData.sql<br/>seed rows"]
  V2 --> H2["history updated"]
  H2 --> APP["Application ready"]
```

### Docker Bake build order

Only `inventory-service` and `purchase-service` inherit `builder-common`; the frontend, Artemis, Keycloak and dind images build independently. In CI the registry is rewritten from `localhost:5000/` to `registry.kube-system.svc.cluster.local:80/`.

```mermaid
flowchart TB
  ENV[".env<br/>image versions"] --> BAKE["docker-bake.hcl"]
  BAKE --> BASE["base-images: builder-common"]
  BAKE --> IND["independent targets:<br/>nginx-frontend · artemis · keycloak · dind"]
  BASE --> JAVA["inventory-service · purchase-service<br/>(inherit builder-common)"]
  JAVA --> PUSH["push to registry<br/>host: localhost:5000/<br/>CI: registry.kube-system.svc.cluster.local:80/"]
  IND --> PUSH
  PUSH --> K8S["Pods pull images in-cluster"]
```

## CI/CD

### GitLab Runner Kubernetes executor lifecycle

Source: thesis §3.4.2, Figure 3.3. The actual `.gitlab-ci.yml` has three stages (`test`, `build`, `deploy`) plus a conditional `docs-build`; with the Kubernetes executor each job runs in its own ephemeral Pod. The thesis's two-stage single-Pod view is simplified.

```mermaid
sequenceDiagram
  autonumber
  actor Dev
  participant GL as GitLab
  participant R as GitLab Runner
  participant K as Kubernetes API
  participant Pod as Ephemeral Build Pod (dind)
  Dev->>GL: git push
  GL->>R: pipeline jobs (test, build, deploy)
  loop one ephemeral Pod per job
    R->>K: create Build Pod
    K-->>Pod: schedule
    Pod->>Pod: clone repo
    Pod->>Pod: job script (test / build+push / helmfile sync)
    Pod-->>R: job status
    R->>K: delete Build Pod
  end
  R-->>GL: report pipeline status
```
