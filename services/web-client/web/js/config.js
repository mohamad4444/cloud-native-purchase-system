// config.js
export const KEYCLOAK_CONFIG = {
    url: 'http://localhost:8180/',
    realm: 'purchase-service-realm',
    clientId: 'web-frontend-client',
    scope: 'openid profile email offline_access'
};

export const API_ENDPOINTS = {
    helloUser: 'http://localhost:8080/helloUser',
    helloAdmin: 'http://localhost:8080/helloAdmin',
    purchase: 'http://localhost:8080/api/purchase',
    purchases: 'http://localhost:8080/api/purchases',
    inventory: 'http://localhost:8081/inventory'
};
