#!/bin/bash

# Super simple version - just updates hosts file
echo "Updating minikube IP in hosts file..."

IP=$(minikube ip 2>/dev/null) || { echo "Minikube not running"; exit 1; }

echo "Minikube IP: $IP"

# Remove old .test entries and add new ones
sudo sed -i '/\.test$/d' /etc/hosts
echo "$IP registry.test" | sudo tee -a /etc/hosts >/dev/null
echo "$IP app1.test" | sudo tee -a /etc/hosts >/dev/null
echo "$IP app2.test" | sudo tee -a /etc/hosts >/dev/null

echo "Updated hosts file:"
grep "\.test$" /etc/hosts
echo "Done! You can now use registry.test, app1.test, etc."
