#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🎯 Starting development workflow..."
"$SCRIPT_DIR/kill-localhost.sh"
"$SCRIPT_DIR/restart-all.sh"
echo "⏳ Waiting for pods to be ready..."
sleep 10
"$SCRIPT_DIR/forward-localhost.sh"
echo "✅ Development workflow complete!"
echo "🌐 Your app is available at: http://localhost:3000"