variable "REGISTRY" {
  default = "localhost:5000/"
}

variable "TAG" {
  default = "latest"
}

# Image version variables loaded from .env
variable "ARTEMIS_VERSION" {}
variable "KEYCLOAK_VERSION" {}
variable "NGINX_VERSION" {}
variable "MAVEN_VERSION" {}
variable "JRE_VERSION" {}
variable "DOCKER_DIND_VERSION" {}
variable "HELM_VERSION" {}
variable "HELMFILE_VERSION" {}

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
    "keycloak",
    "dind"
  ]
}

group "default" {
  targets = [
    "nginx-frontend",
    "artemis",
    "inventory-service",
    "purchase-service",
    "keycloak",
    "dind"
  ]
}

target "builder-common" {
  context    = "."
  dockerfile = "services/common/Dockerfile"
  tags       = ["${REGISTRY}builder-common:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    MAVEN_VERSION = "${MAVEN_VERSION}"
  }
}

target "inventory-service" {
  context    = "services/inventory-service"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}inventory-service:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    REGISTRY    = "${REGISTRY}"
    JRE_VERSION = "${JRE_VERSION}"
  }
  inherits   = ["builder-common"]
}

target "purchase-service" {
  context    = "services/purchase-service"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}purchase-service:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    REGISTRY    = "${REGISTRY}"
    JRE_VERSION = "${JRE_VERSION}"
  }
  inherits   = ["builder-common"]
}

target "nginx-frontend" {
  context    = "services/web-client"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}nginx-frontend:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    NGINX_VERSION = "${NGINX_VERSION}"
  }
}

target "artemis" {
  context    = "services/artemis"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}artemis:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    ARTEMIS_VERSION = "${ARTEMIS_VERSION}"
  }
}

target "keycloak" {
  context    = "services/keycloak"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}keycloak:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    KEYCLOAK_VERSION = "${KEYCLOAK_VERSION}"
  }
}

target "dind" {
  context    = "services/dind"
  dockerfile = "Dockerfile"
  tags       = ["${REGISTRY}dind:${TAG}"]
  platforms  = ["linux/amd64"]
  push       = true
  args = {
    DOCKER_DIND_VERSION = "${DOCKER_DIND_VERSION}"
    HELM_VERSION        = "${HELM_VERSION}"
    HELMFILE_VERSION    = "${HELMFILE_VERSION}"
  }
}
