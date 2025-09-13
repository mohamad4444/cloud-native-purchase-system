#!/bin/bash
# Start HTTPS registry
docker-compose -f docker-compose.yml up -d registry-https

# Update Justfile with HTTPS registry
sed -i.bak 's/REGISTRY_URL := "localhost:5000\/"/REGISTRY_URL := "localhost:5443\/"/' Justfile
echo "Registry updated to HTTPS: localhost:5443"
