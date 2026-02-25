#!/bin/bash
set -e

# Define ports that the system uses (add or remove as necessary)
PORTS=(80 443 5000 5432 61616 8080 8280 4200)

echo "Checking for Docker containers using essential ports..."

for port in "${PORTS[@]}"; do
    # Find any running containers bound to this port
    CONTAINERS=$(docker ps -q --filter "publish=$port")
    
    if [ -n "$CONTAINERS" ]; then
        echo "Port $port is in use by container(s): $CONTAINERS. Stopping them..."
        docker stop $CONTAINERS
    fi
done

echo "Checking for local processes bound to essential ports..."

for port in "${PORTS[@]}"; do
    # Using lsof to find PIDs listening on the specific port
    if command -v lsof >/dev/null 2>&1; then
        PIDS=$(lsof -ti tcp:$port || true)
        if [ -n "$PIDS" ]; then
            echo "Port $port is in use by local PID(s): $PIDS. Killing them..."
            # Try to kill gracefully first
            kill $PIDS 2>/dev/null || true
            sleep 1
            # Force kill if still lingering
            kill -9 $PIDS 2>/dev/null || true
        fi
    else
        # Fallback to fuser if lsof isn't available
        if command -v fuser >/dev/null 2>&1; then
            if fuser -n tcp $port >/dev/null 2>&1; then
                echo "Port $port is in use by local process. Killing..."
                fuser -k -n tcp $port >/dev/null 2>&1 || true
            fi
        else
            echo "Warning: Both 'lsof' and 'fuser' commands are missing. Can't check local processes for port $port."
            break # No point looping if both are missing
        fi
    fi
done

echo "Ports ${PORTS[@]} are now free!"
