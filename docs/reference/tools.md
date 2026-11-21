# Tools reference

Every tool used to build, run and inspect this project, with what it does and how it is installed. The installer lives at [`scripts/install-tools.sh`](../../scripts/install-tools.sh); see [prerequisites](../getting-started/prerequisites.md) for the basic setup.

## Required tools

These are installed by default (`./scripts/install-tools.sh`).

| Tool | Purpose | Where it is used here |
| --- | --- | --- |
| **Docker** + **Buildx** | Build container images and run the Minikube container | `docker-bake.hcl`, `Makefile`, `services/*/Dockerfile` |
| **minikube** | Local Kubernetes cluster | [local Kubernetes tutorial](../tutorials/local-kubernetes.md) |
| **kubectl** | Inspect and operate cluster resources | all tutorials and guides |
| **Helm** | Render charts into Kubernetes manifests | `charts/` |
| **Helmfile** | Coordinate releases and select environments | `environments/helmfile.yaml` |
| **Make** | Shortcuts for build, deploy and restarts | `Makefile` |
| **OpenSSL** | Generate the local certificate authority | [certificate management](../certificate-management.md) |
| **curl** | HTTP requests and health checks | tutorials, install scripts |
| **Java 21** (JDK) | Compile and run the Spring services locally | [development workflow](../guides/development.md) |
| **jq** | Filter JSON logs in the `stern-*` Make targets | `Makefile` |

## Optional inspectors

Installed with `./scripts/install-tools.sh --optional`.

### Kubernetes

| Tool | Interface | What it offers | Why pick it |
| --- | --- | --- | --- |
| **k9s** | Terminal | Live Pod/Deployment views, logs, YAML editing, port-forwarding | Fastest for terminal users; open source |
| **Lens** | Desktop (AppImage) | Cluster GUI: workloads, logs, shells, Helm releases, resource usage | The "Kubernetes IDE"; needs a free Lens ID on first launch |
| **Freelens** | Desktop (AppImage) | The Lens experience without commercial licensing or login | Open-source (MIT) drop-in alternative to Lens |
| **Headlamp** | Web + desktop (AppImage) | Multi-cluster UI, plugins, RBAC-aware controls | CNCF Sandbox; official successor to the archived Kubernetes Dashboard |
| **stern** | CLI | Tail logs from multiple Pods/containers at once | Used by the `stern-*` targets in the Makefile |

### Docker

| Tool | Interface | What it offers | Why pick it |
| --- | --- | --- | --- |
| **lazydocker** | Terminal | Real-time stats, logs, start/stop/exec for containers, images and volumes | Zero setup; ideal for quick local inspection |
| **Portainer** | Browser (:9000) | Manage containers, images, volumes, networks and stacks; live logs and console | Most popular Docker GUI; also supports Kubernetes |
| **Yacht** | Browser (:8000) | Docker Compose stack management with a simple dashboard | Lightweight alternative for managing existing containers |
| **Dockge** | Browser (:2201) | Docker Compose stack editor and manager | Good if you want to edit and redeploy compose files visually |

The dashboard containers can be installed with `./scripts/install-tools.sh --dashboards`.

### Not installed

| Tool | Reason |
| --- | --- |
| **Aptakube** | Paid commercial product |
| **Kubernetes Dashboard** | Archived on 21 January 2026; use Headlamp instead |
| **cAdvisor + Prometheus + Grafana** | A monitoring stack rather than a single tool; the project exposes metrics but does not deploy Prometheus (see [limitations](../deep-dives/limitations.md#observability-gaps)) |
| **Docker Desktop** | Not available natively on Arch Linux |

## Which one should I use?

| Situation | Tool |
| --- | --- |
| Debugging a Pod from a terminal | `k9s` |
| Reading logs from several Pods at once | `stern` or [Grafana Loki](../monitoring-and-logging.md) |
| Visual overview of the whole cluster | Lens or Freelens |
| Shared browser UI for a team | Headlamp |
| Inspecting the host Docker daemon | `lazydocker` |
| Managing containers from a browser | Portainer, Yacht or Dockge |

For this project most inspection can also be done with plain `kubectl` — see [troubleshooting](../guides/troubleshooting.md) for the exact commands.

## Installation and verification

```bash
./scripts/install-tools.sh --check        # verify what is installed
./scripts/install-tools.sh                # install required tools
./scripts/install-tools.sh --optional     # add inspectors
./scripts/install-tools.sh --dashboards   # add browser dashboards
./scripts/install-tools.sh --help         # full options
```

The script is idempotent: it skips existing tools, reads pinned versions from `.env`, supports Arch/EndeavourOS, Debian/Ubuntu and Fedora, and never deletes a cluster. The AppImage tools (Lens, Freelens, Headlamp) require FUSE.

Environment-specific problems — veth, the registry proxy, and the transparent HTTP proxy — are documented in [runtime notes](../guides/runtime-notes.md).

## Where to read next

- [Prerequisites](../getting-started/prerequisites.md) — setup overview.
- [Technology stack](../technologies/overview.md) — the tools the application itself uses.
- [Repository map](repository.md) — the files behind each tool.
- [Runtime notes](../guides/runtime-notes.md) — environment issues encountered while running the stack.
