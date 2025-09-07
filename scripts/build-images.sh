#!/bin/bash

# Script to build and push Docker images to local Minikube registry
set -e

REGISTRY="localhost:5000"
PROJECT_ROOT=$(dirname "$(dirname "$0")")  # Fixed path calculation

# Define two distinct types of services
declare -A ROOT_LEVEL_SERVICES=(
    # Base images that need to be built from project root
    ["builder-common"]="docker/base-images/builder-common"
    ["artemis"]="docker/services/artemis"
    # Add other root-level services here:
    # ["another-base-image"]="docker/base-images/another"
)

declare -A SERVICE_LEVEL_SERVICES=(
    # Regular services that are built from their own directory
    ["inventory-service"]="services/inventory-service"
    ["purchase-service"]="services/purchase-service" 
    ["web-client"]="services/web-client"
    # Add other service-level services here
)

# Function to check if registry is accessible
check_registry() {
    if ! curl -s http://localhost:5000/v2/_catalog > /dev/null 2>&1; then
        echo "Error: Registry at localhost:5000 is not accessible"
        echo "Make sure to run: minikube addons enable registry"
        echo "And: kubectl port-forward -n kube-system service/registry 5000:80 &"
        exit 1
    fi
    echo "✓ Registry is accessible"
}

# Function to build and push a root-level service (build from project root)
build_root_level_service() {
    local service_name=$1
    local service_path=$2
    local image_name="$REGISTRY/$service_name:latest"
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    local build_context="$PROJECT_ROOT"
    
    echo "=== Building root-level service: $service_name ==="
    echo "Dockerfile: $dockerfile_path"
    echo "Context: $build_context"
    
    if [ ! -f "$dockerfile_path" ]; then
        echo "Warning: Dockerfile not found for $service_name at $dockerfile_path, skipping..."
        return 1
    fi
    
    echo "Building image: $image_name"
    docker build -t "$image_name" -f "$dockerfile_path" "$build_context"
    
    echo "Pushing $image_name to registry..."
    docker push "$image_name"
    
    echo "✓ Successfully built and pushed $image_name"
    echo ""
}

# Function to build and push a service-level service (build from service directory)
build_service_level_service() {
    local service_name=$1
    local service_path=$2
    local image_name="$REGISTRY/$service_name:latest"
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    local build_context="$PROJECT_ROOT/$service_path"
    
    echo "=== Building service-level service: $service_name ==="
    echo "Dockerfile: $dockerfile_path"
    echo "Context: $build_context"
    
    if [ ! -f "$dockerfile_path" ]; then
        echo "Warning: Dockerfile not found for $service_name at $dockerfile_path, skipping..."
        return 1
    fi
    
    echo "Building image: $image_name"
    docker build -t "$image_name" -f "$dockerfile_path" "$build_context"
    
    echo "Pushing $image_name to registry..."
    docker push "$image_name"
    
    echo "✓ Successfully built and pushed $image_name"
    echo ""
}

# Function to check if a service exists and should be built
should_build_service() {
    local service_path=$1
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    
    if [ ! -f "$dockerfile_path" ]; then
        echo "Warning: Dockerfile not found at $dockerfile_path, skipping..."
        return 1
    fi
    return 0
}

# Main execution
echo "=============================================="
echo "Building Docker images for Minikube registry: $REGISTRY"
echo "=============================================="

# Check registry accessibility
check_registry

echo ""
echo "Building root-level services (from project root context)..."
echo "----------------------------------------------------------"

# Build root-level services first (base images, builders)
for service in "${!ROOT_LEVEL_SERVICES[@]}"; do
    service_path="${ROOT_LEVEL_SERVICES[$service]}"
    if should_build_service "$service_path"; then
        build_root_level_service "$service" "$service_path"
    fi
done

echo ""
echo "Building service-level services (from their own directories)..."
echo "---------------------------------------------------------------"

# Build service-level services (regular services)
for service in "${!SERVICE_LEVEL_SERVICES[@]}"; do
    service_path="${SERVICE_LEVEL_SERVICES[$service]}"
    if should_build_service "$service_path"; then
        build_service_level_service "$service" "$service_path"
    fi
done

echo "=============================================="
echo "All images built and pushed successfully!"
echo ""

# Show registry contents
echo "Registry contents:"
if command -v jq >/dev/null 2>&1; then
    curl -s http://localhost:5000/v2/_catalog | jq .
else
    curl -s http://localhost:5000/v2/_catalog
fi

echo "=============================================="
echo "Build summary:"
echo "- Root-level services built: ${#ROOT_LEVEL_SERVICES[@]}"
echo "- Service-level services built: ${#SERVICE_LEVEL_SERVICES[@]}"
echo "=============================================="