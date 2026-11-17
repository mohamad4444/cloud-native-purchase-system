# Troubleshooting

Start with the failing layer: host connectivity, Kubernetes resources, application startup, authentication, or messaging. Capture the first relevant error and compare it with the expected configuration before restarting everything.

## Check cluster and workload state

```bash
kubectl config current-context
kubectl get nodes
kubectl get pods,svc,pvc -n dev
kubectl get events -n dev --sort-by=.lastTimestamp
kubectl describe deployment inventory -n dev
kubectl logs deployment/inventory -n dev --tail=100
```

For a crashing Pod, use `kubectl logs POD_NAME -n dev --previous` to inspect the previous container. Replace `POD_NAME` with a real Pod from `kubectl get pods`. Inspect Pending PVCs and scheduling events before treating an unavailable database as a Java error.

## Image builds and image pulls

| Symptom | Next check |
| --- | --- |
| Cannot push to `localhost:5000` | Is the registry port forward running? Does `curl http://localhost:5000/v2/` answer? |
| BuildKit expects HTTPS from an HTTP registry | Check the selected builder's registry configuration |
| Common parent or dependency missing in Docker build | Build and push `builder-common:latest` before backend images |
| Push succeeds but Pod reports `ImagePullBackOff` | Inspect Pod events and node access to the image hostname; host access alone is insufficient |
| A code change does not appear | Confirm the built tag matches the chart, then restart the Deployment |
| Direct Bake reports missing version arguments | Export `.env` first or use Make |

The local configuration uses `localhost:5000/`; the GitLab build configuration uses `registry.kube-system.svc.cluster.local:80/`. They are addresses used from different network contexts. The checked-in BuildKit config under `services/dind` covers the latter, not the host's `localhost` endpoint.

## Browser or API access fails

For `dev`, check the four visible port forwards in [local Kubernetes](../tutorials/local-kubernetes.md). Read the browser network panel and verify the mounted frontend `config.js`, rather than assuming the source copy is what Nginx serves.

For staging, check `minikube ip`, `/etc/hosts`, ingress-nginx, and the TLS Secrets. A ready application Pod does not prove the host can route to `frontend.local`.

For HTTP 401, inspect token expiry, issuer matching, and the service's internal JWK URL. For 403, inspect the mapped `USER` role. See [authentication](../concepts/authentication.md). The actuator health endpoint requires authentication under the current security rules; an anonymous 401 is not a health result.

## Purchases remain pending

Inspect Purchase logs, Inventory logs, and Artemis connectivity. Follow one purchase ID through request publication, inventory consumption, result publication, and status update. Reposting the request creates another record; it is not a retry of the same stored purchase.

The API response omits status. Use `GET /purchase-api/purchases?status=PENDING` or another status filter to inspect membership in a state. See [messaging](../concepts/messaging.md) for transaction and duplicate-delivery limitations.

## Grafana shows no logs

Check the time range and Loki data source first, then query `{namespace="dev"}`. Inspect Alloy logs, the mounted ConfigMap, file targets, and Loki write errors. In particular, review the checked-in `__path__` replacement rule and whether the stored lines contain a CRI envelope. See [the Alloy guide](../monitoring-and-logging.md) for both issues and the labels the pipeline actually creates.

Missing metrics dashboards have a different cause: the current Helmfile does not deploy Prometheus or provision its data source.

## Existing helper script limitations

| File | Current behavior to account for |
| --- | --- |
| `scripts/startup.sh` | Deletes Minikube first, builds images directly without loading `.env`, creates namespaces more than once, and syncs both full environments |
| `scripts/setup-certs.sh` | Writes CA files under `scripts/certificate-authority`, while startup reads them from the root certificate directory |
| `scripts/setup-buildx.sh` | Creates a named builder without local HTTP registry settings; rerunning can collide with that name |
| `scripts/update-hosts.sh` | Changes `/etc/hosts` for the two staging domains and assumes the host can reach the Minikube IP |
| `portforwarding/port-forward.sh` | Uses fixed namespaces/ports, backgrounds jobs, and suppresses their errors |

The tutorials use explicit steps around these limitations. The documentation migration does not repair or run these application scripts.

## Unpinned infrastructure and local credentials

Cert-manager, GitLab runner, and Reloader have pinned versions in Helmfile. Loki, Grafana, and Alloy do not. A new chart resolution can therefore differ from the original working environment; inspect the resolved versions and render values before applying upgrades.

The repository also includes local development credentials, local CA material, permissive runner configuration, and verbose authentication logging. Review the relevant files before reusing the environment outside a dedicated local cluster. These concrete characteristics are why the documentation describes a learning deployment.
