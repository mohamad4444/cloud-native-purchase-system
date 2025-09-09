#!/bin/bash
# restart-frontend.sh - Restart only frontend deployment

echo "🔄 Restarting frontend deployment..."
kubectl rollout restart deployment frontend-frontend-chart -n frontend

echo "✅ Frontend deployment restarted!"