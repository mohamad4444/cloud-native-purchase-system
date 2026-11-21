# Quick guide: run and access the project

The shortest path from a fresh clone to a working app. Full explanations are in the [tutorial](../tutorials/local-kubernetes.md) and the [tools reference](../reference/tools.md).

## 1. Install tools

```bash
./scripts/install-tools.sh            # required tools
./scripts/install-tools.sh --optional # k9s, Lens, Freelens, Headlamp, lazydocker
./scripts/install-tools.sh --check    # verify
```

Log out and back in once if you were just added to the `docker` group.

## 2. Start the cluster

```bash
minikube start --driver=docker --memory=8g --cpus=4
minikube addons enable ingress
```

Check: `kubectl get nodes` should show `minikube` as `Ready`.

## 3. Build and load images

```bash
set -a; . ./.env; set +a
mkdir -p .local
cat > .local/buildkitd.toml <<'EOF'
[registry."localhost:5000"]
  http = true
  insecure = true
EOF
docker buildx create --name purchase-docs-builder --use \
  --driver docker-container --driver-opt network=host \
  --buildkitd-config .local/buildkitd.toml
docker buildx inspect --bootstrap
make build-and-push

for i in builder-common artemis keycloak nginx-frontend inventory-service purchase-service dind; do
  minikube image load localhost:5000/$i:latest
done
```

On a normal network you can push to the in-cluster registry and let Pods pull from it instead — see [runtime notes](../guides/runtime-notes.md) for why `image load` is used here.

## 4. Deploy

```bash
helmfile -f environments/helmfile.yaml -e dev --selector name=cert-manager sync --skip-needs
# set globalConfig.pullPolicy: IfNotPresent in environments/values/env/dev.yaml when using image load
helmfile -f environments/helmfile.yaml -e dev \
  --selector name=frontend --selector name=keycloak \
  --selector name=message-broker --selector name=inventory-service \
  --selector name=purchase-service sync --skip-needs
```

Verify: `kubectl get pods -n dev` — eight Pods should be `Running`.

## 5. Expose the app

```bash
kubectl port-forward -n dev service/frontend-service 4200:80
kubectl port-forward -n dev service/keycloak-service 8080:8080
kubectl port-forward -n dev service/purchase-service 8001:8080
kubectl port-forward -n dev service/inventory-service 8002:8080
```

## Access points

| What | URL / command |
| --- | --- |
| Frontend UI | <http://localhost:4200> |
| Keycloak realm | <http://localhost:8080/realms/purchase-service-realm> |
| Inventory API | <http://localhost:8002/inventory-api/inventory> |
| Purchase API | <http://localhost:8001/purchase-api/purchases> |
| Metrics (no dashboard) | <http://localhost:8002/actuator/prometheus> |

APIs return **401** without a token — that is correct. Sign in through the UI; see [first purchase](../tutorials/first-purchase.md).

### Demo login

| Field | Value |
| --- | --- |
| User | `demo001` |
| Password | `demo001` |
| Realm | `purchase-service-realm` |
| Client | `web-frontend-client` |

## Useful checks

```bash
kubectl get pods -A                       # all workloads
kubectl logs -n dev deployment/inventory --tail=100
kubectl get events -n dev --sort-by=.lastTimestamp
k9s                                       # terminal UI
lazydocker                                # Docker containers
```

In Lens, select the **`dev`** namespace (or **All namespaces**) in the Pods view — pods are not in `default`.

## Optional browser dashboards

```bash
./scripts/install-tools.sh --dashboards
```

| Dashboard | URL |
| --- | --- |
| Portainer | <http://localhost:9000> |
| Yacht | <http://localhost:8000> |
| Dockge | <http://localhost:2201> |

## Clean up

```bash
kubectl port-forward processes: Ctrl+C
minikube stop        # pause the cluster
minikube delete      # remove it entirely
```

## Troubleshooting

- Pods in `ImagePullBackOff` → images were not loaded; repeat step 3, or check the [runtime notes](../guides/runtime-notes.md).
- 401 from the API → expected without a token; sign in first.
- 500 "Access Denied" → the token lacks the `ROLE_USER` authority; see [authentication](../concepts/authentication.md).
- Lens shows no pods → select the `dev` namespace or **All namespaces**.
- Certificate not ready → harmless in dev; TLS is only used in staging.
