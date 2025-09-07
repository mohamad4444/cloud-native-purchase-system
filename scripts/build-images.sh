#!/bin/bash

# Script to build and push Docker images to local Minikube registry
set -e

REGISTRY="localhost:5000"
PROJECT_ROOT=$(dirname "$0")/..

# Array of services with their paths and image names
declare -A SERVICES=(
    ["inventory-service"]="services/inventory-service"
    ["purchase-service"]="services/purchase-service" 
    ["web-client"]="services/web-client"
    # Add more services here if needed
)

# Function to build and push a Docker image
build_and_push() {
    local service_name=$1
    local service_path=$2
    local image_name="$REGISTRY/$service_name:latest"
    
    echo "Building $service_name..."
    docker build -t "$image_name" -f "$PROJECT_ROOT/$service_path/Dockerfile" "$PROJECT_ROOT/$service_path"
    
    echo "Pushing $image_name to registry..."
    docker push "$image_name"
    
    echo "Successfully built and pushed $image_name"
}

# Main execution
echo "Building and pushing Docker images to $REGISTRY"

# Build and push each service
for service in "${!SERVICES[@]}"; do
    build_and_push "$service" "${SERVICES[$service]}"
done

echo "All images built and pushed successfully!"