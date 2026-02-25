#!/bin/bash
set -e

echo "Creating docker buildx container 'mybuilder'..."
docker buildx create --use --name mybuilder --driver docker-container --driver-opt network=host
echo "Buildx container ready."
