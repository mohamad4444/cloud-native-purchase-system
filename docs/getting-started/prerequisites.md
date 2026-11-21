# Prerequisites

The application was developed on EndeavourOS (Arch Linux), using Minikube with the Docker driver. The commands in these guides assume a Linux shell and that you are in the repository root. Other systems may need changes to registry access, host routing, and certificate trust.

## For the documentation alone

Install Python 3.11 or newer with `pip` and virtual environment support. No Java, Docker, Kubernetes, or Node.js is needed to preview the docs. Follow [the documentation workflow](../contributing.md).

## For the application

A single script installs every required tool and verifies the result:

```bash
./scripts/install-tools.sh --check     # see what is missing
./scripts/install-tools.sh             # install missing tools
./scripts/install-tools.sh --optional  # also install k9s and stern
```

It supports Arch/EndeavourOS, Debian/Ubuntu and Fedora, reads pinned versions from `.env`, skips anything already installed, and never deletes a cluster. After it finishes you may need to log out and back in for Docker group membership to take effect.

Two optional sets of tools are available:

```bash
./scripts/install-tools.sh --optional    # k9s, stern, lazydocker, Lens, Freelens, Headlamp
./scripts/install-tools.sh --dashboards  # Portainer (:9000), Yacht (:8000), Dockge (:2201)
```

The first adds terminal and desktop inspectors for Kubernetes and Docker. The second starts browser-based dashboards as Docker containers. See [runtime notes](../guides/runtime-notes.md#where-to-read-next) for related environment notes.

| Tool | Purpose | Upstream instructions |
| --- | --- | --- |
| Docker Engine and Buildx | Run Minikube and build images | [Docker installation](https://docs.docker.com/engine/install/) and [Buildx](https://docs.docker.com/build/concepts/overview/) |
| Minikube | Local Kubernetes cluster | [Minikube start](https://minikube.sigs.k8s.io/docs/start/) |
| kubectl | Inspect and manage cluster resources | [kubectl installation](https://kubernetes.io/docs/tasks/tools/) |
| Helm | Render and install charts | [Helm installation](https://helm.sh/docs/intro/install/) |
| Helmfile | Coordinate chart releases and environment values | [Helmfile documentation](https://helmfile.readthedocs.io/en/latest/) |
| GNU Make | Load image versions and run build/deploy targets | Usually provided by your Linux package manager |
| OpenSSL | Generate a local certificate authority for staging TLS | Your system's OpenSSL package |

Java **21** and Maven are needed if you build outside Docker. The current parent POM uses Spring Boot **3.5.3**. Container builds supply Maven and a Java runtime themselves. Stern and jq are optional for the log commands in the Makefile.

Verify the main tools:

```bash
docker info
docker buildx version
minikube version
kubectl version --client
helm version
helmfile --version
make --version
```

The historical startup script requests **4 CPUs and 8 GiB of memory** for Minikube. The full stack includes several databases and a relatively large Loki deployment, so this is a starting allocation, not a measured minimum or a guarantee that the full stack fits. The first tutorial deploys only the core application releases.

## Configuration to inspect first

Read `.env` for base image versions, `docker-bake.hcl` for image targets, and `environments/values/env/dev.yaml` for the HTTP development configuration. Staging uses `frontend.local` and `keycloak.local` over HTTPS and needs a trusted local CA.

Use a dedicated learning cluster. The checked-in values include development credentials and the GitLab runner configuration is specific to the original setup. The tutorial selects the application releases so that a first run does not depend on that runner.

Continue with [run on local Kubernetes](../tutorials/local-kubernetes.md).
