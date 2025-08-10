# Use env var if set, else default to 'docker compose'
DOCKER_COMPOSE ?= docker compose

.DEFAULT_GOAL := help

build-artemis:
	docker build -t purchasesystem/artemis:latest ./docker/artemis

build: build-artemis
	# More builds here
help:
	@echo "Usage:"
	@echo "  make dev       - Start development environment"
	@echo "  make prod      - Start production environment"
	@echo "  make stop      - Stop and remove containers"
	@echo "  make logs      - Tail logs from all containers"

dev:
	$(DOCKER_COMPOSE) --env-file .env up -d --build

prod:
	$(DOCKER_COMPOSE) --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build

stop:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f
