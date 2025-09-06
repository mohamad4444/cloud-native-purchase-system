# Default recipe
default: help

# Detect docker compose command (prefers `docker compose`, falls back to `docker-compose`)
DOCKER_COMPOSE := `if command -v "docker" >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then echo "docker compose"; elif command -v "docker-compose" >/dev/null 2>&1; then echo "docker-compose"; else echo "docker compose"; fi`


# Build Artemis image
build-artemis:
    docker build -t purchasesystem/artemis:latest ./docker/artemis

# Build shared Java dependencies
build-java-deps:
    @echo "Building shared Java dependencies..."
    cd services/swtp-base-pom && mvn clean install -DskipTests
    cd services/common && mvn clean install -DskipTests
    cd services/swtp-parent-pom && mvn clean install -DskipTests

# Build inventory service (depends on build-java-deps)
build-inventory-service: build-java-deps
    @echo "Building inventory-service..."
    cd services/inventory-service && mvn clean package -DskipTests

# Build purchase service (depends on build-java-deps)
build-purchase-service: build-java-deps
    @echo "Building purchase-service..."
    cd services/purchase-service && mvn clean package -DskipTests

# Build all: artemis + inventory + purchase
build: build-artemis build-inventory-service build-purchase-service
# Rebuild both inventory and purchase service + dependencies (build-java-deps runs only once)
rebuild: build-java-deps
    @echo "Building inventory-service..."
    cd services/inventory-service && mvn clean package -DskipTests
    @echo "Building purchase-service..."
    cd services/purchase-service && mvn clean package -DskipTests

# Start development environment (depends on build)
dev: build
    {{DOCKER_COMPOSE}} --env-file .env up -d

# Start production environment (depends on build)
prod: build
    {{DOCKER_COMPOSE}} --env-file .env.prod -f docker-compose.yml -f docker-compose.prod.yml up -d --build

# Stop containers
stop:
    {{DOCKER_COMPOSE}} down

# Clean containers and volumes
clean:
    {{DOCKER_COMPOSE}} down --volumes --remove-orphans

# Tail logs from all containers
logs:
    {{DOCKER_COMPOSE}} logs -f
# Restart only keycloak and api services
restart-keycloak-api:
    {{DOCKER_COMPOSE}} stop keycloak api-proxy
    {{DOCKER_COMPOSE}} rm -f keycloak api-proxy
    {{DOCKER_COMPOSE}} up -d keycloak api-proxy

# Help text
help:
    @echo "Usage:"
    @echo "  just build-java-deps         - Build shared Java dependencies"
    @echo "  just build-inventory-service - Build inventory-service (depends on shared deps)"
    @echo "  just build-purchase-service  - Build purchase-service (depends on shared deps)"
    @echo "  just build                  - Build everything (artemis + all Java)"
    @echo "  just dev                    - Start development environment"
    @echo "  just prod                   - Start production environment"
    @echo "  just stop                   - Stop and remove containers"
    @echo "  just clean                  - Clean containers and volumes"
    @echo "  just logs                   - Tail logs from all containers"
