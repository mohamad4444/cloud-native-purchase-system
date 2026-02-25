ARG KEYCLOAK_VERSION=latest
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

# Copy your realm JSON into the container
COPY ./realms/purchase-service-realm-realm.json /opt/keycloak/data/import/

