# Development workflow

Run commands from the repository root and confirm your Kubernetes context before deployment. The Makefile loads `.env` and exports its version variables to Docker Bake. `make` with no target runs `release`, which builds images and deploys **staging**.

## Choose the right operation

| Change | Operation | Reason |
| --- | --- | --- |
| Java or static frontend code | Build/push the affected image, then restart its workload | The code is inside the image |
| Shared Java module or parent POM | Build `builder-common` first, then dependent service images | Services build from the common builder image |
| Chart template or values | Render, then sync the selected release/environment | Kubernetes resources must be updated |
| Documentation | `zensical serve` or `zensical build --strict` | Documentation is a separate static site |

## Existing Make targets

```bash
make build-and-push              # Build common image, then all application images
make deploy                      # Sync the entire staging Helmfile
make release                     # Build/push, then staging sync
make rollout-restart-inventory   # Restart inventory in staging
make rollout-restart-purchase    # Restart purchase in staging
```

`make rollout-restart` restarts all deployments in staging. `stern-inventory` and related targets tail staging inventory logs, with optional JSON filtering and formatting through jq. These targets do not select `dev` automatically.

The registry port forward must remain active for local pushes. The [Kubernetes tutorial](../tutorials/local-kubernetes.md) explains registry and Buildx setup.

## Build one backend without the CI image

Load `.env` for direct Bake commands, because the HCL version variables have no defaults:

```bash
set -a
source .env
set +a
docker buildx bake builder-common --push
docker buildx bake inventory-service --push
kubectl rollout restart deployment/inventory -n dev
kubectl rollout status deployment/inventory -n dev --timeout=300s
```

Use `purchase-service` and `deployment/purchase` for Purchase. Rebuild the common image after changing shared code or Maven parents. The backend Dockerfiles reference `builder-common:latest` directly; changing the Bake `TAG` alone does not update that `FROM` or the chart image tags.

The charts use `Always` in the environment values, but pushing another image with the same `latest` tag does not itself trigger a rollout. Restart the workload to make a running Pod pick it up. There is no configured Java file synchronization or Kubernetes live reload in this version.

## Inspect a chart change

```bash
helmfile --file environments/helmfile.yaml -e dev \
  --selector name=inventory-service template --skip-needs
helmfile --file environments/helmfile.yaml -e dev \
  --selector name=inventory-service sync --skip-needs
```

Check images, namespaces, selectors, and environment variables in the rendered resources. ConfigMap changes to the backends and Keycloak can be handled by Stakater Reloader when it is installed; without it, restart those workloads after updating environment-based configuration.

## Build Java outside Docker

There is no root Maven reactor POM. Install parent POMs and the common module in order using Java 21 and Maven:

```bash
mvn -f services/poms/swtp-base-pom/pom.xml install
mvn -f services/common/pom.xml install
mvn -f services/poms/swtp-parent-pom/pom.xml install
mvn -f services/inventory-service/pom.xml verify
mvn -f services/purchase-service/pom.xml verify
```

Do not infer test coverage from these commands: inspect which tests exist and what Maven actually runs. The container builds explicitly skip tests. To run a backend outside the cluster, configure its database, broker, issuer, and JWK URL first; the fallback URLs in `application-common.properties` are not a complete environment.

## Preserve useful versions

The local annotated `pre-zensical` tag identifies the committed baseline before the Zensical migration. Inspect it with `git show --no-patch pre-zensical`; use a separate worktree if you want to compare that version without disturbing uncommitted work. The historical Compose tag remains available as well. See [project history](../project-history.md).
