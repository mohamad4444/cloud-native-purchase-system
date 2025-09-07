#!/bin/bash

# Script to build and push Docker images to local Minikube registry with smart caching
set -e

REGISTRY="localhost:5000"
PROJECT_ROOT=$(dirname "$(dirname "$0")")
export DOCKER_BUILDKIT=1

# Define two distinct types of services
declare -A ROOT_LEVEL_SERVICES=(
    ["builder-common"]="docker/base-images/builder-common"
    ["artemis"]="docker/services/artemis"
)

declare -A SERVICE_LEVEL_SERVICES=(
    ["inventory-service"]="services/inventory-service"
    ["purchase-service"]="services/purchase-service" 
    ["web-client"]="services/web-client"
    
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

# Function to check if image exists in registry
image_exists_in_registry() {
    local service_name=$1
    local response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:5000/v2/$service_name/tags/list")
    if [ "$response" = "200" ]; then
        # Now check if latest tag exists
        if curl -s "http://localhost:5000/v2/$service_name/tags/list" | grep -q '"latest"'; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# Function to check if rebuild is needed
needs_rebuild() {
    local service_path=$1
    local service_name=$2
    local build_context=$3
    local image_name="$REGISTRY/$service_name:latest"
    
    echo "DEBUG: Checking if $service_name needs rebuild..."
    
    # If image doesn't exist locally, rebuild needed
    if ! docker image inspect "$image_name" >/dev/null 2>&1; then
        echo "ℹ️  $service_name: Image doesn't exist locally, will build"
        return 0
    fi
    
    # Get image creation time
    local image_created=$(docker image inspect "$image_name" | \
        grep -o '"Created": *"[^"]*"' | head -1 | cut -d'"' -f4)
    local image_timestamp=$(date -d "$image_created" +%s 2>/dev/null || echo 0)
    
    # Check Dockerfile modification
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    if [ -f "$dockerfile_path" ]; then
        local dockerfile_mtime=$(stat -c %Y "$dockerfile_path")
        if [ "$dockerfile_mtime" -gt "$image_timestamp" ]; then
            echo "ℹ️  $service_name: Dockerfile modified, will rebuild"
            return 0
        fi
    fi
    
    # Check key source files modification (limited to 20 files for performance)
    local key_files=$(find "$build_context" \
        -name "*.java" -o -name "pom.xml" -o -name "*.js" -o -name "*.ts" \
        -o -name "*.gradle" -o -name "*.xml" -o -name "Dockerfile" \
        -o -name "package.json" -o -name "*.py" -o -name "*.go" \
        -o -name "*.rb" -o -name "*.php" 2>/dev/null | head -20)
    
    for file in $key_files; do
        if [ -f "$file" ]; then
            local file_mtime=$(stat -c %Y "$file" 2>/dev/null || echo 0)
            if [ "$file_mtime" -gt "$image_timestamp" ]; then
                echo "ℹ️  $service_name: Source files modified, will rebuild"
                return 0
            fi
        fi
    done
    
    # Check if image exists in registry using the new function
    if ! image_exists_in_registry "$service_name"; then
        echo "ℹ️  $service_name: Not in registry, will push"
        if docker push "$image_name" >/dev/null 2>&1; then
            echo "✓ Pushed $image_name to registry"
            return 1  # Already pushed, no rebuild needed
        else
            echo "⚠️  Failed to push, will rebuild"
            return 0  # Push failed, rebuild needed
        fi
    fi
    
    echo "✓ $service_name: No changes detected, skipping rebuild"
    return 1
}

# Function to build and push a root-level service
build_root_level_service() {
    local service_name=$1
    local service_path=$2
    local image_name="$REGISTRY/$service_name:latest"
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    local build_context="$PROJECT_ROOT"
    
    echo "DEBUG: Processing root-level service: $service_name"
    
    if needs_rebuild "$service_path" "$service_name" "$build_context"; then
        echo "=== Building root-level service: $service_name ==="
        echo "Dockerfile: $dockerfile_path"
        echo "Context: $build_context"
        
        if [ ! -f "$dockerfile_path" ]; then
            echo "⚠️  Warning: Dockerfile not found at $dockerfile_path, skipping..."
            return 1
        fi
        
        echo "Building image: $image_name"
        if docker build -t "$image_name" -f "$dockerfile_path" "$build_context"; then
            echo "Pushing $image_name to registry..."
            if docker push "$image_name"; then
                echo "✓ Successfully built and pushed $image_name"
            else
                echo "❌ Failed to push $image_name"
                return 1
            fi
        else
            echo "❌ Failed to build $image_name"
            return 1
        fi
        
        echo ""
        return 0
    else
        echo "DEBUG: Skipping rebuild for $service_name"
        return 1
    fi
}

# Function to build and push a service-level service
build_service_level_service() {
    local service_name=$1
    local service_path=$2
    local image_name="$REGISTRY/$service_name:latest"
    local dockerfile_path="$PROJECT_ROOT/$service_path/Dockerfile"
    local build_context="$PROJECT_ROOT/$service_path"
    
    echo "DEBUG: Processing service-level service: $service_name"
    
    if needs_rebuild "$service_path" "$service_name" "$build_context"; then
        echo "=== Building service-level service: $service_name ==="
        echo "Dockerfile: $dockerfile_path"
        echo "Context: $build_context"
        
        if [ ! -f "$dockerfile_path" ]; then
            echo "⚠️  Warning: Dockerfile not found at $dockerfile_path, skipping..."
            return 1
        fi
        
        echo "Building image: $image_name"
        if docker build -t "$image_name" -f "$dockerfile_path" "$build_context"; then
            echo "Pushing $image_name to registry..."
            if docker push "$image_name"; then
                echo "✓ Successfully built and pushed $image_name"
            else
                echo "❌ Failed to push $image_name"
                return 1
            fi
        else
            echo "❌ Failed to build $image_name"
            return 1
        fi
        
        echo ""
        return 0
    else
        echo "DEBUG: Skipping rebuild for $service_name"
        return 1
    fi
}

# Main execution
echo "=============================================="
echo "Building Docker images for Minikube registry: $REGISTRY"
echo "BuildKit enabled: $DOCKER_BUILDKIT"
echo "=============================================="

# Check registry accessibility
check_registry

echo ""
echo "Building root-level services (from project root context)..."
echo "----------------------------------------------------------"

# Build root-level services first
root_build_count=0
for service in "${!ROOT_LEVEL_SERVICES[@]}"; do
    service_path="${ROOT_LEVEL_SERVICES[$service]}"
    echo "Processing root service: $service"
    if build_root_level_service "$service" "$service_path"; then
        ((root_build_count++))
    fi
done

echo ""
echo "Building service-level services (from their own directories)..."
echo "---------------------------------------------------------------"

# Build service-level services
service_build_count=0
for service in "${!SERVICE_LEVEL_SERVICES[@]}"; do
    service_path="${SERVICE_LEVEL_SERVICES[$service]}"
    echo "Processing service-level service: $service"
    if build_service_level_service "$service" "$service_path"; then
        ((service_build_count++))
    fi
done

echo "=============================================="
echo "Build completed!"
echo "Root-level services built: $root_build_count"
echo "Service-level services built: $service_build_count"
echo "Total services processed: $((${#ROOT_LEVEL_SERVICES[@]} + ${#SERVICE_LEVEL_SERVICES[@]}))"

# Show registry contents
echo ""
echo "Registry contents:"
if command -v jq >/dev/null 2>&1; then
    curl -s http://localhost:5000/v2/_catalog | jq .
else
    curl -s http://localhost:5000/v2/_catalog
fi

echo "=============================================="