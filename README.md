# Purchase System

A microservices-based purchase management platform with authentication, messaging, monitoring, and logging. Supports **local development with Docker Compose and Make** and **cloud-native deployment with Kubernetes, Helm, and Helmfile**.

> **Note**: This project was developed on Archlinux (EndeavourOS)

## Overview

The system includes the following components:

### Core Services

- **Frontend** – Static UI served via Nginx
- **Microservices** – Purchase Service & Inventory Service (Spring Boot)
- **Authentication** – Keycloak
- **Databases** – PostgreSQL (one per service + Keycloak)
- **Messaging** – ActiveMQ Artemis

### Infrastructure

- **API Gateway** – Ingress-nginx
- **Monitoring & Logging** – Prometheus, Grafana, Loki, Promtail, Alloy
- **Certificate Management** – Cert-manager with custom CA
- **Deployment** – Helm charts packaged for Kubernetes
- **Development** – Make (Makefile) for simplified workflows

### Legacy Note
A Docker Compose version exists under a separate tag but is no longer maintained.

---

## Prerequisites

### Required Tools

- **minikube** - [Installation guide](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
- **helm** - [Installation guide](https://helm.sh/docs/intro/install/)
- **helmfile** - [Installation guide](https://helmfile.readthedocs.io/en/latest/#installation)
- **docker** - [Installation guide](https://docs.docker.com/engine/install/)
- **OpenSSL** - Available on Linux by default. On Windows, use WSL: `sudo apt install openssl`
- **Docker buildx**

### Optional Tools

- **make** - Command runner
- **Visual Studio Code** - Code editor
- **IntelliJ IDEA** - Java IDE
- **Lens** - GUI for Kubernetes
- **SmartGit** - Git GUI client


---

## Quick Start

### Step 1: Free Conflicting Ports

Before starting the environment, make sure essential ports (`80`, `443`, `5000`, `8080`, `etc.`) are clear of any other Docker containers or local processes. You can use the provided script to automatically stop conflicting processes:

```bash
./free-ports.sh
```

### Step 2: Certificate Setup (Required for Staging, Optional for Development)

**For staging environment**, you must first set up certificate authorities and cert-manager. We have extracted these commands into a script for your convenience:

```bash
./setup-certs.sh
```

**For local development** using `localhost` domains, you can skip the certificate setup as the system uses HTTP.

### Step 3: Create Docker Buildx container

Initialize the Docker buildx container needed for building images:

```bash
./setup-buildx.sh
```

### Step 4: Initialize the Environment

Run the startup script to initialize minikube and deploy initial pods:
```bash
./startup.sh
```

### Step 5: Deploy Applications

Build and deploy using Make:

```bash
make release
```

Or manually build and deploy:

```bash
# Build and push Docker images (if you made code changes)
make build-and-push

# Deploy with Helmfile (if you made chart changes)
make deploy
```

### Step 6: Update Local Hosts File

To access the applications via clean URLs (`frontend.local` and `keycloak.local`), map the Minikube IP in your `/etc/hosts` file:

```bash
./update-hosts.sh
```

---

## Documentation

- **[Certificate Management Details](docs/certificate-management.md)**: Explains how cert-manager and our custom Certificate Authority are set up.
- **[Monitoring and Logging](docs/monitoring-and-logging.md)**: Contains Grafana Loki queries and other monitoring-related details.

---

## Development Notes

- This system was developed on Archlinux
- The system is designed to work with both HTTPS (production) and HTTP (development)
- Certificate setup is mandatory for production/staging environments
- Local development can use `localhost` domains without certificates
- All infrastructure is managed through Kubernetes manifests and Helm charts
- Use `make` commands for simplified development workflows

For issues or questions, please refer to the individual service documentation or check the monitoring dashboards for system status.
