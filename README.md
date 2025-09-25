# Purchase System

A microservices-based purchase management platform with authentication, messaging, monitoring, and logging. Supports **local development with Docker Compose and Just** and **cloud-native deployment with Kubernetes, Helm, and Helmfile**.

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
- **Development** – Just command runner for simplified workflows

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
- **just** - Command runner [Installation guide](https://github.com/casey/just)
- **Visual Studio Code** - Code editor
- **IntelliJ IDEA** - Java IDE
- **Lens** - GUI for Kubernetes
- **SmartGit** - Git GUI client

---

## Quick Start

### Step 1: Certificate Setup (Required for Staging, Optional for Development)

**For staging environment**, you must first set up certificate authorities and cert-manager:

```bash
cd certificate-authority

# Generate CA private key
openssl genrsa -out ca7.key 4096

# Create CA certificate (valid for 10 years)
openssl req -x509 -new -nodes -key ca7.key -sha256 -days 3650 \
  -out ca7.crt \
  -subj "/CN=My Local Root CA 7"

# Verify certificate
openssl x509 -in ca7.crt -noout -subject -issuer -dates

# Make CA trusted on your system (Linux)
sudo cp ca7.crt /etc/ca-certificates/trust-source/anchors/
sudo update-ca-trust
trust list | grep -i "My Local Root CA 7"

# Create Kubernetes secret for cert-manager
kubectl create namespace cert-manager
kubectl create secret tls my-ca-secret \
  --cert=ca7.crt \
  --key=ca7.key \
  -n cert-manager
```

**For local development** using `localhost` domains, you can skip the certificate setup as the system uses HTTP.

### Step 2 create buildx container
docker buildx create --use --name mybuilder --driver docker-container --driver-opt network=host

### Step 2: Initialize the Environment

Run the startup script to initialize minikube and deploy initial pods:
```bash
./startup.sh
```

### Step 3: Deploy Applications

Build and deploy using Just:
```bash
just release
```

Or manually build and deploy:
```bash
# Build and push Docker images (if you made code changes)
docker buildx bake base-images --push
docker buildx bake application-images --push

# Deploy with Helmfile (if you made chart changes)
helmfile --file ./environments sync
```

---

## Certificate Management Details

The system uses cert-manager with a custom Certificate Authority. Here's the complete setup:

### 1. Install Cert-Manager
```yaml
- name: cert-manager
  namespace: cert-manager
  createNamespace: true
  version: v1.18.2
  chart: oci://quay.io/jetstack/charts/cert-manager
  verify: true
  keyring: ./cert-manager-keyring-2021-09-20-1020CF3C033D4F35BAE1C19E1226061C665DF13E.gpg
  values:
  - crds:
      enabled: true
```

### 2. Create ClusterIssuer
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: my-ca-issuer
spec:
  ca:
    secretName: my-ca-secret
    secretNamespace: cert-manager
```

### 3. Create Certificate for Each Application
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: hello-tls
  namespace: default
spec:
  commonName: hello.local
  secretName: hello-local-tls-secret
  dnsNames:
    - www.hello.local
  issuerRef:
    name: my-ca-issuer
    kind: ClusterIssuer
```

### 4. Configure Ingress with TLS
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-nginx
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: my-ca-issuer
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
    - hosts:
        - hello.local
      secretName: hello-local-tls-secret
  rules:
    - host: hello.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-nginx
                port:
                  number: 80
```

---

## Monitoring and Logging

### Grafana Loki Queries

**Simple query for standard logs:**
```
{service="$service", stream="stdout"} |= "INFO"
```

**Query for JSON-formatted logs:**
```
{service="$service", stream="stdout"}
| json
| level="INFO"
| app="purchase-system"
| line_format "{{.timestamp}} {{.level}} {{.app}} {{.message}}"
```

---

## Development Notes
- This system was developed on Archlinux
- The system is designed to work with both HTTPS (production) and HTTP (development)
- Certificate setup is mandatory for production/staging environments
- Local development can use `localhost` domains without certificates
- All infrastructure is managed through Kubernetes manifests and Helm charts
- Use `just` commands for simplified development workflows

For issues or questions, please refer to the individual service documentation or check the monitoring dashboards for system status.
