#!/bin/bash

# === Start all port-forwards ===
start() {
  echo "Starting port-forwards..."

  # Inventory Service
  kubectl port-forward -n dev svc/inventory-service 8002:8080 >/dev/null 2>&1 &
  echo $! > .pf-inventory.pid

  # Purchase Service
  kubectl port-forward -n dev svc/purchase-service 8001:8080 >/dev/null 2>&1 &
  echo $! > .pf-purchase.pid

  # Keycloak Service
  kubectl port-forward -n dev svc/keycloak-service 8080:8080 >/dev/null 2>&1 &
  echo $! > .pf-keycloak.pid

  # Frontend Service
  kubectl port-forward -n dev svc/frontend-service 4200:80 >/dev/null 2>&1 &
  echo $! > .pf-frontend.pid

  # Artemis Service
  kubectl port-forward -n dev svc/artemis-service 8161:8161 >/dev/null 2>&1 &
  echo $! > .pf-artemis.pid

  # Grafana
  kubectl port-forward -n monitoring svc/grafana 3000:80 >/dev/null 2>&1 &
  echo $! > .pf-grafana.pid

  # Loki
  kubectl port-forward -n monitoring svc/loki 3100:3100 >/dev/null 2>&1 &
  echo $! > .pf-loki.pid

  echo "✅ All port-forwards started."
}

# === Stop all port-forwards ===
stop() {
  echo "Stopping port-forwards..."

  for pidfile in .pf-*.pid; do
    if [ -f "$pidfile" ]; then
      kill "$(cat "$pidfile")" 2>/dev/null
      rm -f "$pidfile"
      echo "Stopped $(basename "$pidfile" .pid)"
    fi
  done

  echo "✅ All port-forwards stopped."
}

case "$1" in
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  *) echo "Usage: $0 {start|stop|restart}" ;;
esac
