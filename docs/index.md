# Cloud Native Purchase System

This project explores how a small purchase application fits together across application code, authentication, messaging, Kubernetes, and observability. It is built around two Java services and a static browser client, with infrastructure kept beside the code.

## Choose a starting point

| Your goal | Read next |
| --- | --- |
| See how the project was learned and what it demonstrates | [Learning process](learning-process.md) |
| See problems faced and how they were fixed | [Problems and fixes](problems-and-fixes.md) |
| Run the project for the first time | [Prerequisites](getting-started/prerequisites.md), then [local Kubernetes](tutorials/local-kubernetes.md) |
| See the complete business flow | [Make your first purchase](tutorials/first-purchase.md) or [end-to-end use cases](concepts/use-cases.md) |
| Understand the design and the choices behind it | [Architecture](concepts/architecture.md), [design decisions](concepts/design-decisions.md), [authentication](concepts/authentication.md), and [messaging](concepts/messaging.md) |
| Understand the deployment files | [Kubernetes and Helm](concepts/kubernetes-and-helm.md) |
| Understand the technologies | [Technology stack, explained](technologies/overview.md) |
| Understand one technology in depth | [Grafana Alloy, explained](technologies/grafana-alloy.md) |
| Follow a log from Java to Grafana | [Grafana Alloy, explained](technologies/grafana-alloy.md), then [Grafana Alloy and logging](monitoring-and-logging.md) |
| Change or repair something | [Development](guides/development.md) and [troubleshooting](guides/troubleshooting.md) |
| Look up a value or endpoint | [Configuration](reference/configuration.md) and [HTTP API](reference/api.md) |

Tutorials lead to an observable result. Concept pages explain why the pieces exist, and the learning process connects them to the work behind the project. The technology section explains one tool in depth. Guides cover a specific task, and reference pages describe the checked-in interfaces and configuration.

## What runs

The Nginx frontend calls the Purchase and Inventory services. Each service owns a PostgreSQL database. Keycloak issues access tokens; ActiveMQ Artemis carries purchase requests and results. Kubernetes runs the workloads, Helm renders their manifests, and Helmfile coordinates releases. Alloy reads container logs, Loki stores them, and Grafana lets you search them.

The Spring services expose Prometheus metrics, but Helmfile currently deploys no Prometheus server. Promtail belongs to earlier project context; the maintained Kubernetes logging configuration uses Alloy.

## Scope and history

The initial implementation developed over **three months**, with the move from Docker Compose to Kubernetes happening **only in the final month**. The [project history](project-history.md) explains the learning process, documentation study, use of ChatGPT, and the later use of Codex for these docs.

Kubernetes is the maintained deployment. The Compose version remains available at `Docker-Compsoe-Version` (the tag's original spelling). These guides describe a local learning system rather than a verified production deployment.

To edit, preview, or publish this site, see [contributing to the docs](contributing.md).
