#!/bin/bash
# stop-port-forward.sh

echo "Stopping port-forwards..."

# Array of PID files and corresponding ports
declare -A forwards=(
    ["frontend-port-forward.pid"]=3000
    ["keycloak-port-forward.pid"]=8080
)

for pidfile in "${!forwards[@]}"; do
    port=${forwards[$pidfile]}
    if [ -f "$pidfile" ]; then
        PID=$(cat "$pidfile")
        kill $PID 2>/dev/null
        rm -f "$pidfile"
        echo "Stopped port-forward for port $port (PID: $PID)"
    else
        echo "No PID file for port $port. Killing any process on port $port..."
    fi
    # Force kill as fallback
    pkill -f "port-forward.*$port" 2>/dev/null
done

echo "✅ Cleanup complete"
