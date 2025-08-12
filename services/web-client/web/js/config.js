// config.js
export const KEYCLOAK_CONFIG = {
    url: 'http://localhost:8280/',
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client',
    scope: 'openid profile email offline_access'
};

export const API_ENDPOINTS = {
    purchases: 'http://purchase-service:8080/purchases',
    inventory: 'http://inventory-service:8080/inventory'
};
