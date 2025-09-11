#!/bin/bash
# forward-dbs.sh

echo "Forwarding purchase-db (localhost:5432) and inventory-db (localhost:5433)..."
echo "Press Ctrl+C to stop"

# Run both port-forwards in the background
kubectl port-forward service/purchase-db 5432:5432 &
kubectl port-forward service/inventory-db 5433:5432 &

# Wait for user to press Ctrl+C
trap 'kill $(jobs -p); exit' INT
wait