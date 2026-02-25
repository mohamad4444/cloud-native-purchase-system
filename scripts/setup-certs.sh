#!/bin/bash
set -e

# Change to the script's directory and then to certificate-authority
cd "$(dirname "$0")"
mkdir -p certificate-authority
cd certificate-authority

echo "Generating CA private key..."
openssl genrsa -out ca7.key 4096

echo "Creating CA certificate (valid for 10 years)..."
openssl req -x509 -new -nodes -key ca7.key -sha256 -days 3650 \
  -out ca7.crt \
  -subj "/CN=My Local Root CA 7"

echo "Verifying certificate..."
openssl x509 -in ca7.crt -noout -subject -issuer -dates

echo "Making CA trusted on your system (Linux)..."
# We first try update-ca-trust (Arch/RHEL), then fallback or alert user
if command -v update-ca-trust >/dev/null 2>&1; then
    sudo cp ca7.crt /etc/ca-certificates/trust-source/anchors/
    sudo update-ca-trust
    trust list | grep -i "My Local Root CA 7" || echo "update-ca-trust ran successfully."
elif command -v update-ca-certificates >/dev/null 2>&1; then
    sudo cp ca7.crt /usr/local/share/ca-certificates/ca7.crt
    sudo update-ca-certificates
else
    echo "Could not find update-ca-trust. Please add ca7.crt to your system's trust store manually."
fi

echo "Done! The Kubernetes secret will be created by startup.sh"
