// config.js

export const KEYCLOAK_CONFIG = {
    // Use the /auth path because NGINX maps that to Keycloak
    url: 'http://localhost:8080',// <— this should match what your browser accesses
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client',
    scope: 'openid profile email offline_access'
};

export const API_ENDPOINTS = {
    inventory: 'http://localhost:8081/inventory-api/inventory',
    purchases: 'http://localhost:8082/purchase-api/purchases'
};
