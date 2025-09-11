#!/bin/bash

# Create certs directory if it doesn't exist
mkdir -p ../certs

# Generate root CA
openssl genrsa -out ../certs/ca.key 2048
openssl req -new -x509 -days 3650 -key ../certs/ca.key -out ../certs/ca.crt \
  -subj "/CN=Local Development CA"

# Generate wildcard certificate for *.local.test
openssl genrsa -out ../certs/wildcard.local.test.key 2048
openssl req -new -key ../certs/wildcard.local.test.key -out ../certs/wildcard.local.test.csr \
  -subj "/CN=*.local.test"

openssl x509 -req -days 365 -in ../certs/wildcard.local.test.csr \
  -CA ../certs/ca.crt -CAkey ../certs/ca.key -CAcreateserial \
  -out ../certs/wildcard.local.test.crt

# Create Kubernetes TLS secret
kubectl create secret tls wildcard-tls-secret \
  --cert=../certs/wildcard.local.test.crt \
  --key=../certs/wildcard.local.test.key \
  --dry-run=client -o yaml > ../charts/tls-chart/templates/wildcard-secret.yaml

echo "Local HTTPS setup complete!"
echo "Run './scripts/trust-local-ca.sh' to trust the CA in your browser"