FROM quay.io/keycloak/keycloak:26.2.5

# Copy your realm JSON into the container
COPY purchase-service-realm-realm.json /opt/keycloak/data/import/

# Optional: copy entrypoint script
COPY docker-entrypoint.sh /opt/keycloak/docker-entrypoint.sh

# Use your entrypoint
ENTRYPOINT ["/opt/keycloak/docker-entrypoint.sh"]
