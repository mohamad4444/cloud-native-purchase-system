#!/bin/bash
if [ -f port-forward.pid ]; then
    PID=$(cat port-forward.pid)
    if ps -p $PID > /dev/null; then
        echo "✅ Port-forward is running (PID: $PID)"
    else
        echo "❌ PID file exists but process not running"
        rm -f port-forward.pid
    fi
else
    echo "❌ Port-forward is not running"
fi