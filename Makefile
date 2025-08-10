# Use env var if set, else default to 'docker compose'
DOCKER_COMPOSE ?= docker compose

.DEFAULT_GOAL := help

build-artemis:
	docker build -t purchasesystem/artemis:latest ./docker/artemis

build-java-deps:
	@echo "Building shared Java dependencies..."
	cd services/swtp-base-pom && mvn clean install -DskipTests
	cd services/common && mvn clean install -DskipTests
	cd services/swtp-parent-pom && mvn clean install -DskipTests

build-inventory-service: build-java-deps
	@echo "Building inventory-service..."
	cd services/inventory-service && mvn clean package -DskipTests

build-purchase-service: build-java-deps
	@echo "Building purchase-service..."
	cd services/purchase-service && mvn clean package -DskipTests

build: build-artemis build-inventory-service build-purchase-service

help:
	@echo "Usage:"
	@echo "  make build-java-deps         - Build shared Java dependencies"
	@echo "  make build-inventory-service - Build inventory-service (depends on shared deps)"
	@echo "  make build-purchase-service  - Build purchase-service (depends on shared deps)"
	@echo "  make build                  - Build everything (artemis + all Java)"
	@echo "  make dev                    - Start development environment"
	@echo "  make prod                   - Start production environment"
	@echo "  make stop                   - Stop and remove containers"
	@echo "  make logs                   - Tail logs from all containers"

dev: build
	$(DOCKER_COMPOSE) --env-file .env up -d

prod: build
	$(DOCKER_COMPOSE) --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build

stop:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f
