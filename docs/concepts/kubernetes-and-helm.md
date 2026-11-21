# Kubernetes, Helm, and Helmfile

These tools act at different levels. Kubernetes runs resources. Helm creates those resources from chart templates and values. Helmfile coordinates several Helm releases using one environment selection.

## Follow one value into the application

The development environment contains this configuration in `environments/values/env/dev.yaml`:

```yaml
globalConfig:
 namespace: "dev"
 profile: "dev"
 registry: "localhost:5000/"
 pullPolicy: Always
```

The inventory release in `environments/helmfile.yaml` uses `charts/inventory-service-chart` and the values template `environments/values/env/env-magic.gotmpl`. That template takes values for the release name, adds `globalConfig`, and passes the result to Helm.

The deployment template then constructs an image name:

```yaml
image: "{{ .Values.globalConfig.registry }}{{ .Values.backend.image.name }}:{{ .Values.backend.image.tag }}"
```

With the checked-in development values and chart defaults, this becomes `localhost:5000/inventory-service:latest`. The ConfigMap separately maps `globalConfig.profile` to `SPRING_PROFILES_ACTIVE`, which selects the Java logging profile and application behavior.

This path tells you where to make a change. An environment-specific override belongs in `dev.yaml` or `staging.yaml`; a chart's general default belongs in its `values.yaml`; the Kubernetes resource layout belongs in `templates/`.

## Deployment, Service, and labels

The Inventory Deployment gives Pods these labels:

```yaml
microserviceName: inventory
component: backend
env: dev
```

The `inventory-service` Service selects the same labels and forwards port 8080 to the selected Pods. If a Service has no endpoints, compare its selector with the Pod labels before changing application code. Alloy also uses these labels to describe logs, so they connect deployment, networking, and observability.

## Environment values and merge behavior

`env-magic.gotmpl` applies `globalDefaults`, then the release-specific map, then `globalOverrides`, and finally adds `globalConfig` as its own map. The loops replace **top-level keys**; they are not a recursive merge between those three maps. Helm subsequently merges the resulting values with chart defaults.

Release names matter. For example, the backend override key is `inventory-service`, matching its Helmfile release name, while the frontend key is `frontend`. See the [configuration reference](../reference/configuration.md).

## Namespaces and shared infrastructure

Application releases use `globalConfig.namespace`, normally `dev` or `staging`. Logging uses `monitoring`; cert-manager uses `cert-manager`; runner resources use `gitlab-runner`. Those infrastructure releases are shared by both environment selections.

The `environment` fields under release `labels` are metadata for selection. They do not automatically prevent a release from being installed when you use `-e dev`. Selecting `-e` chooses values; selecting releases requires a selector or an `installed` condition. This is why the first tutorial selects core releases explicitly.

Helmfile `needs` expresses release ordering, but it does not replace application readiness checks. The charts do not comprehensively configure readiness probes or all application dependency relationships.

## Inspect before applying

```bash
helmfile --file environments/helmfile.yaml -e dev \
 --selector name=inventory-service template --skip-needs
kubectl get pods -n dev --show-labels
kubectl get endpoints -n dev inventory-service
```

Rendering does not install resources. It may fetch charts or need locally available dependencies, and its output can contain Secret values. Applying uses `sync`, which changes the selected cluster. Read the [upstream Helmfile documentation](https://helmfile.readthedocs.io/en/latest/) for selector and dependency behavior beyond this project's examples.
