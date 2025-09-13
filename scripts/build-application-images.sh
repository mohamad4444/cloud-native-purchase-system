#!/bin/bash
REGISTRY="${1:-localhost:5000/}" docker buildx bake application-images --push
