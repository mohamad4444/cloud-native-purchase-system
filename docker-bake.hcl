variable "REGISTRY" {
  default = "localhost:5000/"
}

variable "TAG" {
  default = "latest"
}
group "base-images" {
  targets = [
    "builder-common"
  ]
}
group "application-images" {
  targets = [
    "nginx-frontend",
    "artemis",
    "inventory-service",
    "purchase-service",
    "keycloak"
  ]
}

group "default" {
  targets = [
    "nginx-frontend",
    "artemis",
    "inventory-service",
    "purchase-service",
    "keycloak"
  ]
}

target "builder-common" {
  context    = "."
  dockerfile = "services/common/Dockerfile"
  tags       = ["${REGISTRY}builder-common:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true

}

target "inventory-service" {
  context    = "services/inventory-service"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}inventory-service:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true

  inherits   = ["builder-common"]
}

target "purchase-service" {
  context    = "services/purchase-service"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}purchase-service:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true

  inherits   = ["builder-common"]
}

target "nginx-frontend" {
  context    = "services/web-client"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}nginx-frontend:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
}

target "artemis" {
  context    = "services/artemis"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}artemis:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
}

target "keycloak" {
  context    = "services/keycloak"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}keycloak:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
}
