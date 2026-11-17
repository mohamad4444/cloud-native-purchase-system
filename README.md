# Cloud Native Purchase System

A learning project that follows a purchase from a browser through two Spring Boot services, PostgreSQL databases, and ActiveMQ Artemis. Keycloak handles authentication; Kubernetes, Helm, and Helmfile run the system; Grafana Alloy, Loki, and Grafana provide the log pipeline.

The maintained deployment uses **Kubernetes**. The older Docker Compose implementation is preserved under the `Docker-Compsoe-Version` Git tag and is no longer maintained. The project was developed on EndeavourOS (Arch Linux).

## How the project evolved

I developed this project over three months. I started with Docker and Docker Compose, without knowing what Kubernetes was; the move to Kubernetes happened only in the final month, and this was my first time using it. As I learned more, Compose no longer fit the orchestration I wanted to explore, and maintaining both deployments would have been too much work.

I worked through the implementation file by file, wrote and understood the code, diagnosed problems using logs, and tested it myself. I used ChatGPT to explore concepts and work through technical questions alongside TechWorld with Nana's Kubernetes tutorial and intensive study of the official Kubernetes, Spring AOP, and other project documentation. Grafana Alloy was new to me at the time: videos and tutorials were scarce, and I could find only one relevant YouTube video, so I spent substantial time reading its documentation directly. Reading other people's GitHub code also helped, from small libraries and focused examples to larger libraries and complete implementations.

I now use Codex to help write and organize the documentation. The local `pre-codex` tag marks the committed version before this documentation migration. See [the project history](docs/project-history.md) for the fuller account and learning resources.

## Documentation

The documentation lives in [`docs/`](docs/index.md) and builds with [Zensical](https://zensical.org/docs/). Start with:

- [Prerequisites](docs/getting-started/prerequisites.md) and [local Kubernetes setup](docs/tutorials/local-kubernetes.md).
- [Your first purchase](docs/tutorials/first-purchase.md) and [system architecture](docs/concepts/architecture.md).
- [Kubernetes and Helm](docs/concepts/kubernetes-and-helm.md), [authentication](docs/concepts/authentication.md), and [asynchronous messaging](docs/concepts/messaging.md).
- [Grafana Alloy and logging](docs/monitoring-and-logging.md), [certificates](docs/certificate-management.md), and [troubleshooting](docs/guides/troubleshooting.md).
- [Configuration](docs/reference/configuration.md), [API reference](docs/reference/api.md), and [development workflow](docs/guides/development.md).

Preview the docs from the repository root (Python 3.11 or newer):

```bash
python3 -m venv .venv-docs
source .venv-docs/bin/activate
python -m pip install -r requirements-docs.txt
zensical serve
```

Open <http://localhost:8000>. Build static files with `zensical build --strict`; output goes to `site/`. Documentation needs no running cluster or Node.js installation. See [maintaining and publishing the docs](docs/contributing.md) for details.

## Running the application

Follow the [Kubernetes tutorial](docs/tutorials/local-kubernetes.md), which explains cluster creation, the local image registry, image builds, and deployment in order. Application development uses `make build-and-push`, `make deploy`, and `make release`; the latter two target **staging**.

This is a local learning environment. The docs describe the checked-in behavior and its limitations, including development credentials, incomplete metrics deployment, and setup scripts that need care. The documentation build does not verify a live Kubernetes deployment.

Contributions: [CONTRIBUTING.md](CONTRIBUTING.md). License: [MIT](LICENSE).
