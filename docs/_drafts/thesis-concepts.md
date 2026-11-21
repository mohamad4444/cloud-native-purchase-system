# Thesis concept diagrams — Mermaid drafts

Reconstructions of the conceptual flows described in the bachelor thesis but never drawn as figures. These diagrams are editable Mermaid so they can be dropped into the real docs. Draft only; not in navigation.

## Authentication and security

### Authorization Code Flow (confidential client)

Source: thesis §2.11.3, "Authorization Code Flow". Client `my-thymeleaf-app` (confidential), redirect `http://localhost:8080/login/oauth2/code/keycloak`.

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
  App->>KC: POST /token (code + client_secret)
  KC-->>App: access_token + id_token + refresh_token
  App-->>User: Protected resource
```

### Authorization Code Flow with PKCE (public client)

Source: thesis §2.11.3, "Authorization Code Flow with PKCE". Client `web-frontend-client` / `my-spa-app` (public), challenge method `S256`. No client secret.

```mermaid
sequenceDiagram
  autonumber
  actor User
  participant SPA as Browser SPA
  participant KC as Keycloak
  User->>SPA: Open protected route
  SPA->>SPA: Generate code_verifier<br/>code_challenge = SHA256(verifier)
  SPA->>KC: GET /auth + code_challenge + method=S256
  KC-->>User: Login form
  User->>KC: POST credentials
  KC-->>SPA: 302 redirect with code + state
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

Source: thesis §2.11–2.11.2 (NIST SP 800-207). "Never trust, always verify".

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
    ENC --> POL["Policy decision<br/>per request"]
    POL --> OK["Grant / deny"]
  end
  OLD -.->|"dissolved perimeter"| NEW
  classDef bad fill:#fdecea,stroke:#c62828,color:#b71c1c;
  classDef good fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20;
  class U1,FW,T1 bad;
  class REQ,AUTH,ENC,POL,OK good;
```

### JWT validation and role mapping in Spring

Source: thesis §2.12, §4.3.2 (JwtAuthConverter, SecurityConfig).

```mermaid
flowchart TB
  REQ["API request + Bearer JWT"] --> SF["Spring Security filter chain"]
  SF --> VERIFY["Verify signature via JWKS<br/>(internal Keycloak URL)"]
  VERIFY --> ISS["Check issuer claim matches configured URI"]
  ISS --> CONV["JwtAuthConverter"]
  CONV --> R1["realm_access.roles"]
  CONV --> R2["resource_access.web-frontend-client.roles"]
  R1 --> MAP["uppercase + prefix ROLE_"]
  R2 --> MAP
  MAP --> CTX["SecurityContext: ROLE_USER, ..."]
  CTX --> AUTHZ{"@PreAuthorize hasRole('USER')?"}
  AUTHZ -->|yes| OK["Controller executes"]
  AUTHZ -->|no| DENY["403 JSON response"]
  classDef flow fill:#e3f2fd,stroke:#1565c0,color:#0d47a1;
  class REQ,SF,VERIFY,ISS,CONV,R1,R2,MAP,CTX,OK flow;
```

## Aspect-Oriented Programming

### Proxy interception chain

Source: thesis §2.13, "Client → Proxy → Advice Execution → Target Object".

```mermaid
flowchart LR
  C["Client"] --> P["Spring proxy<br/>(injected bean)"]
  P --> A1["Advice: @Before / security"]
  A1 --> A2["Advice: @Around / LoggingAspect"]
  A2 --> T["Target object<br/>(original method)"]
  T --> A2B["@Around after / @AfterReturning"]
  A2B --> P2["Proxy returns"]
  P2 --> C
  classDef proxy fill:#ede7f6,stroke:#5e35b1,color:#311b92;
  class P,A1,A2,A2B,P2 proxy;
```

### Advice chain and proceed() unwind

Source: thesis §2.13, "Advice chain" (1–5).

```mermaid
sequenceDiagram
  autonumber
  actor Client
  participant Proxy
  participant A1 as Interceptor 1 (security)
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

### Request-reply with JMS reply queues

Source: thesis §2.14.4, Figure 2.2 description (PurchaseMadeEvent / ResultEvent).

```mermaid
sequenceDiagram
  autonumber
  participant P as Purchase Service
  participant RQ as Request Queue
  participant I as Inventory Service
  participant PQ as Reply Queue
  P->>RQ: 1. PurchaseMadeEvent (JMSReplyTo header)
  RQ->>I: 2. Deliver Event
  I->>PQ: 3. ResultEvent
  PQ->>P: 4. Deliver Result
```

### BaseEvent polymorphic message contract

Source: thesis §4.3.3, "Event-Driven Communication Foundation".

```mermaid
classDiagram
  class BaseEvent {
    +String eventId
    +Instant eventTimestamp
    +String eventType
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

### Layered logging: four components around a request

Source: thesis §4.3.3 "Layered Logging Strategy", §4.8.

```mermaid
flowchart TB
  V["EarlyLoggingValve<br/>Tomcat: raw request + final status"]
  S["Spring Security<br/>authenticate + authorize"]
  M["MdcJwtFilter<br/>userId + username into MDC"]
  C["Controllers"]
  A["LoggingAspect<br/>method entry/exit/duration + Micrometer"]
  B["Business logic"]
  L["logback-spring.xml<br/>human-readable (dev) / JSON (staging)"]
  V --> S --> M --> C --> A --> B
  A -.-> L
  M -.-> L
  V -.-> L
  classDef log fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20;
  class V,M,A,L log;
```

### Log pipeline to Grafana

Source: thesis §4.8.1, Figure description for Alloy/Loki/Grafana.

```mermaid
flowchart LR
  J["Spring JSON to stdout"] --> F["Node container log files"]
  F --> AL["Alloy discovery + relabel + file_match"]
  AL --> W["Loki gateway (write)"]
  G["Grafana Explore (read)"] --> W
  classDef obs fill:#fff3e0,stroke:#ef6c00,color:#e65100;
  class AL,W,G obs;
```

## Data and build

### Flyway migration flow

Source: thesis §2.22, §4.4.1 (V1__init.sql, V2__addData.sql).

```mermaid
flowchart LR
  START["Service startup"] --> F["Flyway enabled"]
  F --> LOC["Scan classpath:db/migration"]
  LOC --> V1["V1__init.sql<br/>create table"]
  V1 --> V2["V2__addData.sql<br/>seed rows"]
  V2 --> HIST["flyway_schema_history updated"]
  HIST --> APP["Application ready"]
```

### Docker Bake build order

Source: thesis §4.5.7 (base-images → application-images → local registry).

```mermaid
flowchart TB
  ENV[".env<br/>image versions"] --> BAKE["docker-bake.hcl"]
  BAKE --> BASE["base-images: builder-common"]
  BASE --> APP["application-images<br/>inventory · purchase · frontend<br/>keycloak · artemis · dind"]
  APP --> PUSH["push to localhost:5000"]
  PUSH --> K8S["Pods pull images in-cluster"]
```

## CI/CD

### GitLab Runner Kubernetes executor lifecycle

Source: thesis §3.4.2, §4 (CI/CD), Figure 3.3 description.

```mermaid
sequenceDiagram
  autonumber
  actor Dev
  participant GL as GitLab
  participant R as GitLab Runner
  participant K as Kubernetes API
  participant Pod as Build Pod (dind)
  Dev->>GL: git push
  GL->>R: new pipeline job
  R->>K: create Build Pod
  K-->>Pod: schedule
  Pod->>Pod: clone repo
  Pod->>Pod: build & push images
  Pod->>Pod: helmfile sync (deploy)
  Pod-->>R: job status
  R->>K: delete Build Pod
  R-->>GL: report status
```
