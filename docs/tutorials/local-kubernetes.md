# Run on local Kubernetes

This tutorial brings up the **core application in the `dev` namespace**, using HTTP and port forwarding. It avoids TLS and the optional GitLab runner and logging stack while you establish that purchases work. Complete the [prerequisites](../getting-started/prerequisites.md) first. Run commands from the repository root.

These steps are derived from the repository configuration. They have not been exercised against a fresh cluster as part of the documentation migration; use the checkpoints to identify failures before proceeding.

## 1. Start the cluster

Use a dedicated Minikube environment and inspect the active context:

```bash
minikube start --driver=docker --memory=8g --cpus=4
kubectl config current-context
kubectl get nodes
minikube addons enable registry
```

Wait for the node to report `Ready`. This workflow uses the default `minikube` profile, as do the existing helper scripts. If you use a named profile, pass that profile consistently to every Minikube command and check your kubectl context.

Do not use `scripts/startup.sh` as an everyday start command: its first command is `minikube delete`. It also attempts to deploy both environments and the full infrastructure stack.

## 2. Expose the image registry

In a second terminal, keep this running:

```bash
kubectl port-forward -n kube-system service/registry 5000:80
```

From your original terminal, check that the registry answers:

```bash
curl --fail http://localhost:5000/v2/
```

An empty JSON object is a normal successful response. The checked-in build and chart configuration use the registry prefix `localhost:5000/`. Image pushes originate on your host; image pulls originate in the Minikube node. They must reach the same registry. If pulls fail after pushes succeed, investigate [registry access](../guides/troubleshooting.md#image-builds-and-image-pulls) rather than assuming that host connectivity proves node connectivity.

## 3. Configure Buildx for the local HTTP registry

The local registry uses HTTP. Create a local BuildKit configuration and a builder that can reach the host port forward:

```bash
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
```

This host networking setup assumes Linux. If that builder already exists, select it with `docker buildx use purchase-docs-builder` instead of recreating it. The repository's `scripts/setup-buildx.sh` creates `mybuilder` without a registry configuration; the CI configuration targets a different, cluster-internal registry hostname.

## 4. Build the application images

Make loads and exports the versions in `.env`. The Java services depend on the `builder-common:latest` image, so build it first:

```bash
make build-and-push
curl --fail http://localhost:5000/v2/_catalog
```

The catalog should include `builder-common`, `inventory-service`, `purchase-service`, `nginx-frontend`, `keycloak`, and `artemis`; the Make target also builds the CI `dind` image. See [development](../guides/development.md) for a narrower build. The Dockerfiles use `-DskipTests`, so a successful image build is not evidence that tests ran.

## 5. Render and deploy the core releases

The release selector below limits the first deployment to frontend, Keycloak, the broker, and the two business services. `--skip-needs` deliberately omits their declared cert-manager dependency because ingress is disabled in `dev`.

```bash
helmfile --file environments/helmfile.yaml -e dev \
 --selector name=frontend --selector name=keycloak \
 --selector name=message-broker --selector name=inventory-service \
 --selector name=purchase-service \
 template --skip-needs > .local/dev-rendered.yaml
```

Inspect `.local/dev-rendered.yaml`: image names should use `localhost:5000/`, resources should use `dev`, and the frontend and Keycloak ingress objects should be absent. Rendered manifests contain development secrets; keep them local.

Then apply that same selection:

```bash
helmfile --file environments/helmfile.yaml -e dev \
 --selector name=frontend --selector name=keycloak \
 --selector name=message-broker --selector name=inventory-service \
 --selector name=purchase-service \
 sync --skip-needs
kubectl get pods,svc,pvc -n dev
kubectl rollout status deployment/inventory -n dev --timeout=300s
kubectl rollout status deployment/purchase -n dev --timeout=300s
kubectl rollout status deployment/keycloak -n dev --timeout=300s
```

Helmfile creates namespaces through its defaults. Services can start before their databases or broker and may need time or a restart to connect. A timeout is a reason to inspect Events and logs; the deployment is not verified until its workloads are ready. See [troubleshooting](../guides/troubleshooting.md).

## 6. Open the frontend

Run each port forward in its own terminal:

```bash
kubectl port-forward -n dev service/frontend-service 4200:80
```

```bash
kubectl port-forward -n dev service/keycloak-service 8080:8080
```

```bash
kubectl port-forward -n dev service/purchase-service 8001:8080
```

```bash
kubectl port-forward -n dev service/inventory-service 8002:8080
```

Open <http://localhost:4200>. The frontend configuration should point to Keycloak at `http://localhost:8080` and to APIs on ports 8001 and 8002. An API request without a token should be rejected; it does not establish whether authenticated access works.

The optional `bash portforwarding/port-forward.sh start` helper starts these and additional monitoring/broker forwards in the background. It assumes those services exist and suppresses errors. Prefer the visible commands above while diagnosing a first run.

Continue with [make your first purchase](first-purchase.md).

## Stop and resume

Stop port forwards with Ctrl+C and stop the cluster with `minikube stop`. Resume with `minikube start`, then restart the port forwards, including the registry forward before rebuilding images. There is no need to delete the cluster for an ordinary restart.

For HTTPS and ingress, follow [certificate management](../certificate-management.md). For Alloy, Loki, and Grafana, follow [logging](../monitoring-and-logging.md). The full staging command `make deploy` includes infrastructure and the original GitLab runner; review its values before using it.
