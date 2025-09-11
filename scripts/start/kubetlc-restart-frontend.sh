#!/bin/bash
echo "🔄 Restarting frontend deployment..."
kubectl rollout restart deployment frontend-frontend-chart -n frontend
echo "✅ Frontend deployment restarted!"