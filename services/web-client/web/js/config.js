// config.js

export const KEYCLOAK_CONFIG = {
    // Use the /auth path because NGINX maps that to Keycloak
    url: 'http://localhost:8080',
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client',
    scope: 'openid profile email offline_access'
};

export const API_ENDPOINTS = {
    purchases: 'http://purchase-service:8080/purchases',
    inventory: 'http://inventory-service:8080/inventory'
};
