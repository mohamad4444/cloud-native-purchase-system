#!/bin/bash
# Installation script for Purchase System Cloud Native on Arch Linux

set -e

echo "Installing Purchase System Cloud Native Dependencies"
echo "=========================================================="
echo ""

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo "[ERROR] This script is designed for Arch Linux"
    exit 1
fi

echo "[OK] Already installed: Docker, Java, Maven, OpenSSL"
echo ""

# Install required packages
echo "Installing Kubernetes and build tools..."
if command -v yay &> /dev/null; then
    echo "Using yay (AUR helper)..."
    yay -S --needed minikube helm kubectl just helmfile
else
    echo "yay not found. Installing from official repos (helmfile may be missing)..."
    sudo pacman -S --needed minikube helm kubectl just
    echo "[WARNING] Note: helmfile might need to be installed from AUR"
fi

echo ""
echo "Configuring Docker..."

# Ensure Docker service is running
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group if not already
if ! groups $USER | grep -q docker; then
    echo "Adding $USER to docker group..."
    sudo usermod -aG docker $USER
    echo "[WARNING] You'll need to log out and back in for docker group changes to take effect"
    echo "          Or run: newgrp docker"
fi

echo ""
echo "Setting up Docker Buildx..."
if ! docker buildx ls | grep -q mybuilder; then
    docker buildx create --use --name mybuilder --driver docker-container --driver-opt network=host
    echo "[OK] Docker buildx builder 'mybuilder' created"
else
    echo "[OK] Docker buildx builder 'mybuilder' already exists"
fi

echo ""
echo "Starting Minikube..."
if minikube status &> /dev/null; then
    echo "[OK] Minikube is already running"
else
    minikube start --driver=docker --memory=4096 --cpus=2
    minikube addons enable registry
    echo "[OK] Minikube started with registry addon"
fi

echo ""
echo "Verification:"
echo "----------------"
echo "Docker:    $(docker --version)"
echo "Minikube:  $(minikube version --short)"
echo "Helm:      $(helm version --short)"
echo "kubectl:   $(kubectl version --client --short 2>/dev/null || echo 'kubectl installed')"
echo "Just:      $(just --version)"
echo "Maven:     $(mvn --version | head -n1)"
echo "Java:      $(javac -version 2>&1)"

echo ""
echo "[OK] Installation complete!"
echo ""
echo "Next steps:"
echo "1. If docker group was just added, run: newgrp docker"
echo "2. For staging deployment, setup certificates in certificate-authority/"
echo "3. Run: ./startup.sh"
echo "4. Run: just release"
