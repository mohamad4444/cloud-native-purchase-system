// config.js
export const KEYCLOAK_CONFIG = {
    url: 'http://localhost:8180/',
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client',
    scope: 'openid profile email offline_access'
};

export const API_ENDPOINTS = {
    purchases: 'http://localhost:8080/purchases',
    inventory: 'http://localhost:8081/inventory'
};
