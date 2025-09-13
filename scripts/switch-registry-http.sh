#!/bin/bash
# Switch back to HTTP registry
sed -i.bak 's/REGISTRY_URL := "localhost:5443\/"/REGISTRY_URL := "localhost:5000\/"/' Justfile
echo "Registry updated to HTTP: localhost:5000"
