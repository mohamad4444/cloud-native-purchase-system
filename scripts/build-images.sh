#!/bin/bash

# Script to build and push Docker images to local Minikube registry
set -e

REGISTRY="localhost:5000"
PROJECT_ROOT=$(dirname "$(dirname "$0")")  # Fixed path calculation

# Array of services with their paths and image names
declare -A SERVICES=(
    # ["inventory-service"]="services/inventory-service"
    # ["purchase-service"]="services/purchase-service" 
    # ["web-client"]="services/web-client"
    ["artemis"]="docker/services/artemis"
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

# Function to build and push a Docker image
build_and_push() {
    local service_name=$1
    local service_path=$2
    local image_name="$REGISTRY/$service_name:latest"
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    local build_context="$PROJECT_ROOT"
    
    echo "=== Building $service_name ==="
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

# Function to build builder-common image
build_builder_common() {
    local image_name="$REGISTRY/builder-common:latest"
    local dockerfile_path="$PROJECT_ROOT/docker/base-images/builder-common/Dockerfile"
    local build_context="$PROJECT_ROOT"
    
    echo "=== Building builder-common ==="
    echo "Dockerfile: $dockerfile_path"
    echo "Context: $build_context"
    
    if [ ! -f "$dockerfile_path" ]; then
        echo "Warning: builder-common Dockerfile not found at $dockerfile_path, skipping..."
        return 1
    fi
    
    echo "Building image: $image_name"
    docker build -t "$image_name" -f "$dockerfile_path" "$build_context"
    
    echo "Pushing $image_name to registry..."
    docker push "$image_name"
    
    echo "✓ Successfully built and pushed builder-common image"
    echo ""
}

# Main execution
echo "=============================================="
echo "Building Docker images for Minikube registry: $REGISTRY"
echo "=============================================="

# Check registry accessibility
check_registry

# Build builder-common first (required for other services)
build_builder_common

# Build and push each service
for service in "${!SERVICES[@]}"; do
    build_and_push "$service" "${SERVICES[$service]}"
done

echo "=============================================="
echo "All images built and pushed successfully!"
echo "Registry contents:"

# Check if jq is available, if not use alternative output
if command -v jq >/dev/null 2>&1; then
    curl -s http://localhost:5000/v2/_catalog | jq .
else
    curl -s http://localhost:5000/v2/_catalog
fi

echo "=============================================="