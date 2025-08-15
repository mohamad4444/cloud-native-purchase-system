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
