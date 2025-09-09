#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🚀 Applying Helmfile changes..."
cd "$SCRIPT_DIR/../environments" && helmfile -e dev apply -l tier=ready

echo "🔄 Restarting all deployments in frontend namespace..."
kubectl rollout restart deployment --all -n frontend
echo "✅ All deployments restarted and Helmfile applied!"