# Configuration reference

These tables describe the repository's current values, not upstream defaults for every supported tool version. Inspect rendered resources before changing a cluster.

## Where configuration lives

| File | Controls |
| --- | --- |
| `.env` | Base image versions and versions passed into the CI tooling image |
| `docker-bake.hcl` | Image targets, build contexts, registry prefix, output tags |
| `environments/helmfile.yaml` | Releases, chart paths/versions, dependencies, shared Helm defaults |
| `environments/values/env/dev.yaml` | HTTP development environment and local browser URLs |
| `environments/values/env/staging.yaml` | HTTPS staging environment and ingress |
| `environments/values/env/env-magic.gotmpl` | Release value selection and global value composition |
| `charts/*/values.yaml` | Defaults for each local chart |
| `environments/values/charts/*` | Upstream logging and GitLab runner chart configuration |

## Global environment values

| Key | Development | Staging | Meaning |
| --- | --- | --- | --- |
| `globalConfig.namespace` | `dev` | `staging` | Application namespace |
| `globalConfig.env` | `dev` | `staging` | Pod and Service environment label |
| `globalConfig.profile` | `dev` | `staging` | Spring active profile |
| `globalConfig.registry` | `localhost:5000/` | `localhost:5000/` | Prefix concatenated directly with image names; keep the trailing slash |
| `globalConfig.pullPolicy` | `Always` | `Always` | Overrides the chart-specific image pull policy |

The release keys for overrides are `frontend`, `keycloak`, `inventory-service`, `purchase-service`, and so on, matching Helmfile release names. `globalDefaults` and `globalOverrides` are supported by the values template but are not populated in the current environment files. See [merge behavior](../concepts/kubernetes-and-helm.md#environment-values-and-merge-behavior).

## Browser addresses

| Component | Development | Staging |
| --- | --- | --- |
| Frontend | `http://localhost:4200` | `https://frontend.local` |
| Keycloak | `http://localhost:8088` | `https://keycloak.local` |
| Purchase API | `http://localhost:8001/purchase-api/purchases` | `https://frontend.local/purchase-api/purchases` |
| Inventory API | `http://localhost:8002/inventory-api/inventory` | `https://frontend.local/inventory-api/inventory` |
| Grafana | `http://localhost:3000` via port forward when installed | Same monitoring Service; no Grafana ingress is supplied |

Staging sets relative frontend API paths, resolved against the frontend origin. The frontend chart's standalone defaults contain a misspelled `frotnend.local` address; use the Helmfile environment values rather than deploying that chart's defaults unchanged.

## Backend runtime environment

Both backend ConfigMaps and Secrets provide the following variables to the shared Spring configuration:

| Variable | Purpose | Example from development |
| --- | --- | --- |
| `APP_NAME` | Application and logging name | `inventory` or `purchase` |
| `SERVER_PORT` | Container HTTP port | `8080` |
| `SPRING_PROFILES_ACTIVE` | Spring profile | `dev` |
| `DATASOURCE_URL` | Service-specific JDBC URL | `jdbc:postgresql://inventory-db-service:5432/inventorydb` |
| `DATASOURCE_USERNAME` | Database login name | Set by the chart's `database.user` |
| `DATASOURCE_PASSWORD` | Database password | Injected through a Kubernetes Secret |
| `ARTEMIS_BROKER_URL` | Broker connection | `tcp://artemis-service:61616` |
| `ARTEMIS_USER`, `ARTEMIS_PASSWORD` | Broker credentials | Set by chart values; password injected through a Secret |
| `KEYCLOAK_ISSUER_URI` | Expected token issuer | `http://localhost:8088/realms/purchase-service-realm` |
| `KEYCLOAK_JWK_SET_URI` | Internal signing-key endpoint | `http://keycloak-service:8080/realms/purchase-service-realm/protocol/openid-connect/certs` |

Secret templates base64-encode the values already present in chart YAML. This is Kubernetes Secret serialization, not encryption of the repository values.

## Images and application versions

The Java base POM selects Java 21 and Spring Boot 3.5.3. `.env` pins infrastructure/base image versions such as Artemis, Keycloak, Nginx, Maven, and the JRE. Docker Bake defaults to `REGISTRY=localhost:5000/` and `TAG=latest`.

Changing `.env` affects builds, not every Helm value. Application chart tags are configured separately, and the backend Dockerfiles explicitly consume `builder-common:latest`. Keep build output tags, Dockerfile base references, and chart tags aligned when introducing versioned images.

## Shared infrastructure

| Release | Namespace | Version/configuration behavior |
| --- | --- | --- |
| `cert-manager` | `cert-manager` | Chart `v1.18.2`, CRDs enabled, chart verification enabled |
| `ca-issuer` | `cert-manager` | Local ClusterIssuer chart, secret `my-ca-secret` |
| `gitlab-runner-sa`, `gitlab-runner` | `gitlab-runner` | Original CI setup; runner chart `0.80.1` |
| `monitoring-stack` | `monitoring` | Local chart supplying `alloy-config` |
| `loki` | `monitoring` | Unpinned chart, SingleBinary, MinIO enabled, replication factor 1 |
| `grafana` | `monitoring` | Unpinned chart, persistence enabled, Loki data source provisioned |
| `alloy-logs` | `monitoring` | Unpinned chart, existing ConfigMap and host log mounts |
| `reloader` | `kube-system` | Chart `1.0.59`, restarts annotated workloads for config changes |

There is no Prometheus release. Shared resources are not isolated by the `dev`/`staging` application namespace selection. In particular, syncing a full environment also processes the runner and logging releases.
