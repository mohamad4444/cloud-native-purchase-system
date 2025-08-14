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
![Spring Boot](https://raw.githubusercontent.com/devicons/devicon/master/icons/spring/spring-original-wordmark.svg) **Spring Boot** – Java microservices  
![PostgreSQL](https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg) **PostgreSQL** – Relational database  
![Keycloak](https://www.keycloak.org/resources/images/keycloak_icon_512px.png) **Keycloak** – Identity and access management  
![ActiveMQ Artemis](https://activemq.apache.org/assets/img/activemq-logo.png) **ActiveMQ Artemis** – Messaging broker  

#### Infrastructure & Deployment
![Docker](https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg) **Docker Compose** – Local development  
![Kubernetes](https://raw.githubusercontent.com/devicons/devicon/master/icons/kubernetes/kubernetes-plain-wordmark.svg) **Kubernetes** – Container orchestration  
![Helm](https://helm.sh/img/helm.svg) **Helm** – Kubernetes application packaging  
![Istio](https://istio.io/latest/favicons/android-192x192.png) **Istio** – Service mesh for routing, security, observability  
![Just](https://just.systems/images/logo.png) **Just** – Command runner  

#### Monitoring & Logging
![Prometheus](https://raw.githubusercontent.com/prometheus/prometheus/main/documentation/images/prometheus-logo.png) **Prometheus** – Metrics collection  
![Grafana](https://grafana.com/static/img/grafana_logo_transparent_400x.png) **Grafana** – Visualization  
![Loki](https://grafana.com/static/img/logos/logo-loki.svg) **Loki** – Log aggregation  
![Promtail](https://grafana.com/static/img/logos/icon-promtail.svg) **Promtail** – Log shipping



# commands
dev:
	docker compose --env-file .env up -d --build

prod:
	docker compose --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build

stop:
	docker compose down


	
docker build -f Dockerfile -t purchase-service-image ..
