#!/bin/bash

# Platform-specific CA trust commands
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ../certs/ca.crt
    echo "CA trusted for macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    sudo cp ../certs/ca.crt /usr/local/share/ca-certificates/local-ca.crt
    sudo update-ca-certificates
    echo "CA trusted for Linux"
else
    echo "Unsupported OS. Please manually trust ../certs/ca.crt"
fi