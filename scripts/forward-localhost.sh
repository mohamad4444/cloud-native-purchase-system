#!/bin/bash
# start-port-forward.sh
#  Port-forward both frontend and Keycloak

echo " Starting port-forwards..."

# Frontend port-forward
nohup kubectl port-forward -n frontend deployment/frontend-frontend-chart 3000:80 > frontend-port-forward.log 2>&1 &
echo $! > frontend-port-forward.pid
echo " Frontend port-forward started (PID: $(cat frontend-port-forward.pid))"
echo " Frontend logs: frontend-port-forward.log"
echo " Access frontend: http://localhost:3000"

# Keycloak port-forward
nohup kubectl port-forward -n auth deployment/keycloak 8080:8080 > keycloak-port-forward.log 2>&1 &
echo $! > keycloak-port-forward.pid
echo "Keycloak port-forward started (PID: $(cat keycloak-port-forward.pid))"
echo "Keycloak logs: keycloak-port-forward.log"
echo "Access Keycloak: http://localhost:8080/auth"

echo "To stop: ./stop-port-forward.sh"
