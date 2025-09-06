#!/bin/bin/node

// Generate a development config file for local development
const fs = require('fs');

const config = {
  environment: "development",
  api: {
    purchase: "https://purchase-service.local.test:8443",
    inventory: "https://inventory-service.local.test:8443",
    keycloak: {
      url: "https://keycloak.local.test:8443",
      realm: "myrealm",
      clientId: "web-client"
    }
  },
  features: {
    enableExperimental: true,
    debugMode: true
  }
};

fs.writeFileSync(
  '../services/web-client/web/config.js',
  `window.APP_CONFIG = ${JSON.stringify(config, null, 2)};`
);

console.log('Development config generated');