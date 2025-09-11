#!/bin/bash

# Port forward all services with HTTPS
kubectl port-forward svc/ingress-nginx-controller 8443:443 &

# Update hosts file
echo "127.0.0.1 frontend.local.test purchase-service.local.test inventory-service.local.test keycloak.local.test" | sudo tee -a /etc/hosts

echo "Development services available at:"
echo "Frontend: https://frontend.local.test:8443"
echo "Keycloak: https://keycloak.local.test:8443"
echo "Purchase API: https://purchase-service.local.test:8443"
echo "Inventory API: https://inventory-service.local.test:8443"