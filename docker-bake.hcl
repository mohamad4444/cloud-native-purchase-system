variable "REGISTRY" {
  default = "localhost:5000/"
}

variable "TAG" {
  default = "latest"
}

variable "CACHE_REGISTRY" {
  default = "localhost:5000/"
}

// Common build arguments for cache optimization
variable "COMMON_ARGS" {
  default = {
    BUILDKIT_INLINE_CACHE = "1"  // Enables inline cache metadata in images
  }
}

// GROUP APPROACH: For building in sequence when using groups
group "base-images" {
  targets = ["builder-common"]
}

group "application-images" {
  targets = ["nginx-frontend", "artemis", "inventory-service", "purchase-service"]
}

// Sequential group for ordered building - base first, then applications
group "all-ordered" {
  targets = [
    "base-images",        // Base images build first
    "application-images"  // Applications build after base is complete
  ]
}

// Default group now uses the ordered approach
group "default" {
  targets = ["all-ordered"]
}

// Original all group still available for parallel building
group "all" {
  targets = ["base-images", "application-images"]
}

// Common target configuration for maximum build speed
target "common" {
  platforms = ["linux/amd64"]
  output    = ["type=registry"]  // Better performance than push=true
  args      = COMMON_ARGS
  
  // CACHE CONFIGURATION - KEY FOR MAXIMUM BUILD SPEED
  cache-from = [
    "type=registry,ref=${CACHE_REGISTRY}cache-${target}:latest",  // Dedicated cache image
    "type=registry,ref=${REGISTRY}${target}:latest"               // Fallback to main image
  ]
  cache-to = [
    "type=registry,ref=${CACHE_REGISTRY}cache-${target}:latest,mode=max"  // Export full cache
  ]
}

// BASE IMAGE - built first in ordered groups
target "builder-common" {
  inherits   = ["common"]
  context    = "."
  dockerfile = "libraries/common/Dockerfile"
  tags       = ["${REGISTRY}builder-common:${TAG}"]
}

// APPLICATION TARGETS with DEPENDENCY APPROACH
// Explicit dependencies ensure correct build order even when building individual targets

target "nginx-frontend" {
  inherits   = ["common"]
  context    = "services/web-client"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}nginx-frontend:${TAG}"]
  // depends_on = ["builder-common"]  // Uncomment if this service also needs builder-common
}

target "artemis" {
  inherits   = ["common"]
  context    = "."
  dockerfile = "docker/services/artemis/Dockerfile"
  tags       = ["${REGISTRY}artemis:${TAG}"]
  // depends_on = ["builder-common"]  // Uncomment if this service also needs builder-common
}

// DEPENDENCY APPROACH: These services explicitly depend on builder-common
// This ensures they build AFTER builder-common, regardless of how they're built
target "inventory-service" {
  inherits   = ["common"]
  context    = "services/inventory-service"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}inventory-service:${TAG}"]
  depends_on = ["builder-common"]  // Explicit dependency - builds after builder-common
}

target "purchase-service" {
  inherits   = ["common"]
  context    = "services/purchase-service"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}purchase-service:${TAG}"]
  depends_on = ["builder-common"]  // Explicit dependency - builds after builder-common
}