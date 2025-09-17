# Purchase System

A microservices-based purchase management platform with authentication, messaging, monitoring, and logging.  
Supports **local development with Docker Compose and Just** and **cloud-native deployment with Kubernetes, Helm, Istio **.

---

## Overview

The system includes:
- **Frontend** – Static UI served via Nginx
- **Microservices** – Purchase Service & Inventory Service (Spring Boot)
- **Authentication** – Keycloak
- **Databases** – PostgreSQL (one per service + Keycloak)
- **Messaging** – ActiveMQ Artemis
- **API Gateway** – Nginx (local) / Istio Ingress (K8s)
- **Monitoring & Logging** – Prometheus, Grafana, Loki, Promtail
- **Service Mesh** – Istio (in K8s)
- **Helm** – Deployment packaging for Kubernetes
- **Just** – Command runner to simplify workflows

### Technologies Used

#### Core
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/spring/spring-original.svg" alt="Spring Boot" height="40"/> **Spring Boot** – Java microservices  
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original.svg" alt="PostgreSQL" height="40"/> **PostgreSQL** – Relational database  
<img src="https://www.keycloak.org/resources/images/keycloak_icon_512px.png" alt="Keycloak" height="40"/> **Keycloak** – Identity and access management  
<img src="https://activemq.apache.org/assets/img/activemq-logo.png" alt="ActiveMQ Artemis" height="40"/> **ActiveMQ Artemis** – Messaging broker  

#### Infrastructure & Deployment
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original.svg" alt="Docker" height="40"/> **Docker Compose** – Local development  
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/kubernetes/kubernetes-plain.svg" alt="Kubernetes" height="40"/> **Kubernetes** – Container orchestration  
<img src="https://helm.sh/img/helm.svg" alt="Helm" height="40"/> **Helm** – Kubernetes application packaging  
<img src="https://istio.io/latest/favicons/android-192x192.png" alt="Istio" height="40"/> **Istio** – Service mesh for routing, security, observability  
<img src="https://just.systems/images/logo.png" alt="Just" height="40"/> **Just** – Command runner  

#### Monitoring & Logging
<img src="https://raw.githubusercontent.com/prometheus/prometheus/main/documentation/images/prometheus-logo.png" alt="Prometheus" height="40"/> **Prometheus** – Metrics collection  
<img src="https://grafana.com/static/assets/img/fav32.png" alt="Grafana" height="40"/> **Grafana** – Visualization  
<img src="https://grafana.com/static/assets/img/logos/logo-loki.svg" alt="Loki" height="40"/> **Loki** – Log aggregation  
<img src="https://grafana.com/static/assets/img/logos/icon-promtail.svg" alt="Promtail" height="40"/> **Promtail** – Log shipping


# commands
dev:
	docker compose --env-file .env up -d --build

prod:
	docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build

stop:
	docker compose down


	
docker build -f Dockerfile -t purchase-service-image ..


Grafana
{service="$service", stream="stdout"} |= "INFO"


{service="$service", stream="stdout"}
| json
| level="INFO"
| app="purchase-system"
| line_format "{{.timestamp}} {{.level}} {{.app}} {{.message}}"



kubectl create configmap prometheus-config --from-file=./docker/configs/prometheus/prometheus.yml
kubectl create configmap loki-config --from-file=./docker/configs/loki/loki-config.yaml
kubectl create configmap promtail-config --from-file=./docker/configs/promtail/promtail-config.yaml





# Creating Certificate Authority and Cert-Manager

First You need to create Certificate Authorities Keys (Private and Public key)

```bash
cd certificate-authority
openssl genrsa -out ca7.key 4096
#Certificate for 10 years
openssl req -x509 -new -nodes -key ca7.key -sha256 -days 3650 \
  -out ca7.crt \
  -subj "/CN=My Local Root CA 7"
#Verify
openssl x509 -in ca7.crt -noout -subject -issuer -dates
```

make the ca trusted on your operation system and in browsers, for firefox this needs to be done manually, chrome automatically takes certificate authorities from system

```bash
# Copy your CA certificate to the trust source directory
sudo cp ca7.crt /etc/ca-certificates/trust-source/anchors/

# Update the trust store
sudo update-ca-trust
#verify with ca common name
trust list | grep -i "My Local Root CA 7"

```

now create secret that issuer will user of our CA files
```bash
# namespace can be anything since it is a clusterissuer but need to be specified in clusterissuer
kubectl create my-issuer
kubectl create secret tls my-ca-secret \
  --cert=ca.crt \
  --key=ca.key \
  -n my-issuer

```

now we need to install cert-manager 
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

# Your CA setup resources
- name: ca-issuer
  namespace: cert-manager #probably extra as it is a cluster issuer
  chart: ./charts/ca-issuer
  needs:
  - cert-manager/cert-manager
  ```

then you need to save it as a secret in helm under any namespace , but issuers can only access secrets in their own namespace and clusterissuers can access any name space but the secret namespace needs to be specified
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: my-ca-issuer
spec:
  ca:
    secretName: my-ca-secret
    secretNamespace: my-issuer
```

now you make make for each application that uses ingress a certificate file

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: hello-tls #certificate resouce name
  namespace: default     # <- same namespace as ingress
spec:
  commonName: hello.local #must be added for certificate to work
  secretName: hello-local-tls-secret # <- must match ingress.spec.tls.secretName
  dnsNames: #extra names beside common
    - www.hello.local
  issuerRef:
    name: my-ca-issuer #must match IssuerName
    kind: ClusterIssuer
```

now we must add these in our ingress.yaml
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-nginx
  labels:
    app: hello-nginx
  annotations:
  #.class # Tells Kubernetes to use the "nginx" ingress controller 
    # (must match the controller deployed in your cluster)
    kubernetes.io/ingress.class: nginx 
    cert-manager.io/cluster-issuer: my-ca-issuer #must match issuer name
    nginx.ingress.kubernetes.io/ssl-redirect: "true" #redirect http to https
spec:
  tls:
    - hosts:
        - hello.local
      secretName: hello-local-tls-secret #this must match what is in certificate
  rules:
    - host: hello.local #url expected 
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-nginx #service name must match service
                port:
                  number: 80

```