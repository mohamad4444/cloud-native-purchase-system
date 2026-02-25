#!/bin/bash
set -e

# Fetch the Minikube IP
IP=$(minikube ip)

if [ -z "$IP" ]; then
    echo "Failed to get Minikube IP. Ensure minikube is running ('minikube start')."
    exit 1
fi

DOMAINS="frontend.local keycloak.local"

echo "Using Minikube IP: $IP"
echo "Updating /etc/hosts for: $DOMAINS (requires sudo)"

for DOMAIN in $DOMAINS; do
    # Check if the domain is already in the hosts file
    if grep -qE "[[:space:]]+$DOMAIN" /etc/hosts; then
        # Replace the existing line: match any IP at start of line followed by spaces and the domain name
        sudo sed -i -E "s/^[0-9\.]+[[:space:]]+$DOMAIN\b/$IP $DOMAIN/" /etc/hosts
        echo " ✓ Updated $DOMAIN -> $IP"
    else
        # Append to the end of the file
        echo "$IP $DOMAIN" | sudo tee -a /etc/hosts >/dev/null
        echo " ✓ Added $DOMAIN -> $IP"
    fi
done

echo "Hosts file updated successfully."
