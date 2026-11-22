# Quick guide: run and access the project

The shortest path from a fresh clone to a working app, using the repository's own scripts and Makefile. Full explanations are in the [tutorial](../tutorials/local-kubernetes.md) and [tools reference](../reference/tools.md).

## 1. Install tools

```bash
./scripts/install-tools.sh # required tools (Arch / Debian / Fedora)
./scripts/install-tools.sh --check # verify
```

Log out and back in once if you were just added to the `docker` group. Optional inspectors (k9s, Lens, Headlamp, lazydocker) and browser dashboards are covered in the [tools reference](../reference/tools.md).

## 2. Prepare the cluster

The provided scripts do the setup in order:

```bash
./scripts/setup-buildx.sh # create the Buildx builder
./scripts/startup.sh # start Minikube, addons, registry port-forward, build & deploy
```

!!! warning "Read `startup.sh` first"
 `startup.sh` begins with `minikube delete` and deploys both `dev` and `staging`. On an existing cluster, skip it and run the explicit steps below instead. The [tutorial](../tutorials/local-kubernetes.md#1-start-the-cluster) walks through them.

Manual equivalent for a first run:

```bash
minikube start --driver=docker --memory=8g --cpus=4
minikube addons enable ingress
minikube addons enable metrics-server   # required for CPU/memory graphs in Lens
kubectl port-forward -n kube-system service/registry 5000:80 # keep running
./scripts/setup-buildx.sh
```

!!! note "No CPU/memory numbers in Lens?"
    Lens reads live resource usage from the Kubernetes Metrics API, which is provided by the `metrics-server` addon. Without it, `kubectl top` fails and Pod/Node views show no graphs. Enable it with `minikube addons enable metrics-server` and wait ~30 seconds for the first samples. Verify with `kubectl top nodes`. Lens's own Prometheus stack (namespace `lens-metrics`) provides historical charts but does not replace metrics-server.

## 3. Build and deploy with Make

The [Makefile](https://github.com/mohamad4444/cloud-native-purchase-system/blob/develop/Makefile) loads `.env` automatically and wraps the long commands:

```bash
make build-and-push # docker buildx bake base-images + application-images
make deploy # helmfile -e staging sync
make release # both of the above (also the default `make` target)
```

`deploy` and `release` target **staging**. For the `dev` environment used in this guide, run Helmfile directly:

```bash
helmfile -f environments/helmfile.yaml -e dev --selector name=cert-manager sync --skip-needs
helmfile -f environments/helmfile.yaml -e dev \
 --selector name=frontend --selector name=keycloak \
 --selector name=message-broker --selector name=inventory-service \
 --selector name=purchase-service sync --skip-needs
```

If images were loaded with `minikube image load` instead of pushed to a registry, set `globalConfig.pullPolicy: IfNotPresent` in `environments/values/env/dev.yaml` first — see [runtime notes](../guides/runtime-notes.md).

!!! note "A rebuilt `latest` image does not restart Pods"
 After rebuilding an image with the same tag, run `make rollout-restart-inventory` / `make rollout-restart-purchase` (targets staging), or `kubectl rollout restart deployment/<name> -n dev`.

## 4. Expose the app

Use the helper script for all port-forwards at once:

```bash
bash portforwarding/port-forward.sh start
```

It forwards frontend (4200), Keycloak (8088), purchase (8001), inventory (8002), Artemis (8161), Grafana (3000) and Loki (3100) in the background. Check with `bash portforwarding/port-forward.sh status`; stop with `bash portforwarding/port-forward.sh stop`. Its limitations are listed in [troubleshooting]](../guides/troubleshooting.md#existing-helper-script-limitations).

For visibility while learning, start the four core forwards manually instead:

```bash
kubectl port-forward -n dev service/frontend-service 4200:80
kubectl port-forward -n dev service/keycloak-service 8088:8080
kubectl port-forward -n dev service/purchase-service 8001:8080
kubectl port-forward -n dev service/inventory-service 8002:8080
```

## Access points

| What | URL / command |
| --- | --- |
| Frontend UI | <http://localhost:4200> |
| Keycloak realm | <http://localhost:8088/realms/purchase-service-realm> |
| Inventory API | <http://localhost:8002/inventory-api/inventory> |
| Purchase API | <http://localhost:8001/purchase-api/purchases> |
| Metrics endpoint | <http://localhost:8002/actuator/prometheus> |

APIs return **401** without a token — that is correct. Sign in through the UI; see [first purchase](../tutorials/first-purchase.md).

### Demo login

| Field | Value |
| --- | --- |
| User | `demo001` |
| Password | `demo001` |
| Realm | `purchase-service-realm` |
| Client | `web-frontend-client` |

## Check ports before starting

Port-forwards fail silently if a port is already taken by another app (for example Open WebUI on 8080). Run the check script first — it lists each occupied port and the process or container that owns it:

```bash
./scripts/check-ports.sh # all project ports
./scripts/check-ports.sh 4200 8088 8001 # specific ports
```

It exits `0` when every checked port is free and `1` otherwise. The full mode also prints which service normally uses each port. If a port is busy, stop the owning process, or use `bash portforwarding/port-forward.sh restart`.

## Useful checks

```bash
kubectl get pods -A # all workloads
kubectl logs -n dev deployment/inventory --tail=100
kubectl get events -n dev --sort-by=.lastTimestamp
make stern-inventory # tail inventory logs (staging)
k9s # terminal UI
lazydocker # Docker containers
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

## Clean up / destroy

Nothing runs in the background forever unless you leave it there. Use the matching level of cleanup:

```bash
# 1. Stop port-forwards (the most common leftover)
bash portforwarding/port-forward.sh stop
# If you started kubectl port-forward manually, press Ctrl+C in each terminal.
# Verify with: ./scripts/check-ports.sh

# 2. Pause the cluster but keep all images and state (quickest to resume)
minikube stop

# 3. Destroy the cluster and everything in it (images, databases, deployments)
minikube delete

# 4. Stop the optional browser dashboards (if you installed them)
docker stop portainer yacht dockge 2>/dev/null || true
# To remove them completely (also deletes their data volumes):
# docker rm -f portainer yacht dockge
# docker volume rm portainer_data yacht 2>/dev/null || true

# 5. Stop the local Buildx builder container (optional)
docker buildx stop purchase-docs-builder 2>/dev/null || true
```

!!! note "Cleanup order"
 Stop port-forwards **before** `minikube stop`/`delete` — otherwise `kubectl` processes keep trying to reach a cluster that no longer exists. `minikube delete` removes the cluster permanently; `minikube stop` only pauses it.

Check that everything is down with:

```bash
./scripts/check-ports.sh # should report all ports free
minikube status # should say Stopped / Not found
docker ps --format '{{.Names}}' | grep -E 'minikube|portainer|yacht|dockge' || echo 'no project containers'
```

## Troubleshooting

- Pods in `ImagePullBackOff` → images were not loaded; rebuild with `make build-and-push` or see [runtime notes](../guides/runtime-notes.md).
- Login button does nothing → reload the page; the button is bound before the silent-SSO check. Check the browser console for `"[auth]"` messages.
- Login page shows another app (e.g. Open WebUI) → port 8080 is occupied. This setup uses **8088** for Keycloak; keep the `8088` port-forward running.
- 401 from the API → expected without a token; sign in first.
- 500 "Access Denied" → the token lacks `ROLE_USER`; see [authentication](../concepts/authentication.md).
- Lens shows no pods → select `dev` or **All namespaces**.
- Certificate not ready → harmless in dev; TLS is only used in staging.
