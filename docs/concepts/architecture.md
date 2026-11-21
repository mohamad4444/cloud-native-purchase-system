# System architecture

The application separates purchase records from stock management. The browser communicates with both services over HTTP, while the services coordinate stock decisions through a broker.

```mermaid
flowchart TB
 Browser[Browser] --> Frontend[Nginx frontend]
 Browser --> Keycloak[Keycloak]
 Browser --> Routing[Ingress or dev port forwards]
 Routing --> Purchase[Purchase service]
 Routing --> Inventory[Inventory service]
 Purchase --> PurchaseDB[(Purchase PostgreSQL)]
 Inventory --> InventoryDB[(Inventory PostgreSQL)]
 Keycloak --> AuthDB[(Keycloak PostgreSQL)]
 Purchase -->|purchase.requested| Artemis[ActiveMQ Artemis]
 Artemis -->|purchase.requested| Inventory
 Inventory -->|purchase.result| Artemis
 Artemis -->|purchase.result| Purchase
```

In staging, ingress-nginx routes `frontend.local` paths to the frontend and API Services and exposes Keycloak at `keycloak.local`. In development, ingress is disabled and the browser reaches the forwarded ports directly.

Namespaces provide the isolation between the two environment instances. Platform tooling lives in shared namespaces that are not selected by `dev` or `staging`.

```mermaid
flowchart TB
 ING["ingress-nginx<br/>frontend.local · keycloak.local<br/>staging only"]

 subgraph DEV["namespace: dev — HTTP + port forward"]
 direction LR
 DF["frontend"]
 DP["purchase + DB"]
 DI["inventory + DB"]
 DK["keycloak + DB"]
 DA["artemis"]
 end

 subgraph STAGING["namespace: staging — HTTPS + ingress"]
 direction LR
 SF["frontend"]
 SP["purchase + DB"]
 SI["inventory + DB"]
 SK["keycloak + DB"]
 SA["artemis"]
 end

 subgraph SHARED["shared platform namespaces"]
 direction LR
 MON["monitoring<br/>Alloy · Loki · Grafana"]
 CA["cert-manager<br/>local CA issuer"]
 RUN["gitlab-runner<br/>temporary build pods"]
 end

 ING --> STAGING
 SHARED -.->|"logs · TLS · CI"| DEV
 SHARED -.->|"logs · TLS · CI"| STAGING

 classDef env fill:#e3f2fd,stroke:#1565c0,color:#0d47a1;
 classDef platform fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20;
 classDef ingress fill:#fff3e0,stroke:#ef6c00,color:#e65100;
 class DF,DP,DI,DK,DA,SF,SP,SI,SK,SA env;
 class MON,CA,RUN platform;
 class ING ingress;
```

## Responsibilities

| Component | Responsibility | Source directory |
| --- | --- | --- |
| Frontend | Sign in, display inventory, submit purchases, query history | `services/web-client` |
| Purchase | Save purchase requests, publish events, apply result status | `services/purchase-service` |
| Inventory | List available stock and reduce quantities for requests | `services/inventory-service` |
| Common Java module | Security, event types, JMS conversion, logging, AOP | `services/common` |
| Keycloak | Realm, clients, users, and access tokens | `services/keycloak` and `charts/keycloak-chart` |
| Artemis | Queues between the business services | `services/artemis` and `charts/message-broker-chart` |
| Alloy, Loki, Grafana | Collect, store, and query logs | `charts/monitoring-stack-chart` and `environments/values/charts` |

The Java module structure reflects shared infrastructure code, while each business service keeps its controller, service, repository, entity, and migration files. PostgreSQL instances are deployed separately by the relevant charts. Flyway migrations define the business schemas.

## Why use asynchronous messages?

Purchase does not directly call Inventory to reserve stock. It saves a request and publishes a message. Inventory consumes that message and sends a result later. That makes the intermediate `PENDING` state part of the application model and introduces a useful learning problem: observing a workflow that spans processes and does not complete in one HTTP exchange.

This small implementation does not include an outbox, a complete distributed transaction strategy, or an idempotency mechanism for repeated inventory processing. The [messaging page](messaging.md) explains those boundaries so that the example is not mistaken for a complete order-processing design.

## What Kubernetes contributes

Deployments keep application containers running, Services provide stable names, ConfigMaps and Secrets supply runtime configuration, and persistent volume claims back the stateful components. Helm packages those resources, and Helmfile passes environment values to each release.

Kubernetes is the maintained runtime because the project evolved toward learning orchestration. The [history](../project-history.md) describes the move during the final development month. Continue with [Kubernetes, Helm, and Helmfile](kubernetes-and-helm.md) to follow a value into a manifest.
