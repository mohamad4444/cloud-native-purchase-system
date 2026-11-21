# Problems and fixes

A short record of debugging work taken from the repository's git history. Each entry gives the symptom, the cause, and the fix, with the commit that records it. Commit messages such as `try 3` through `try 6`, `attempt at dind fix`, and `error fixed` mark where a solution was reached by iteration rather than guessed in one step.

## Authentication and routing

### Keycloak redirects used the wrong port

- **Symptom:** Login redirects broke after introducing the Keycloak reverse proxy.
- **Fix:** Changed the redirect target from port 80 to 8280 and corrected the proxy's forwarded headers. Later the same class of problem appeared as an issuer mismatch between the browser URL and the internal token URL.
- **Commits:** `cf76cf8` (redirect to 8280), `a9de277` (redirects and JWT decoder experiments), `290ba59` (HTTP working with API proxy).
- **Lesson:** Authentication fails in more than one place — redirect URI, issuer claim, and JWK URL must each match the address used by the client that consumes them. This is why the [authentication page](concepts/authentication.md) distinguishes the public issuer from the internal JWK endpoint.

### CORS blocked browser calls

- **Symptom:** The browser rejected cross-origin API calls before they reached the services.
- **Fix:** Permitted `OPTIONS` preflight at the security filter chain, tightened the Nginx API proxy headers, and aligned the frontend `config.js` origin with the allowed origins.
- **Commits:** `e64ad63` (CORS problem fixed), `02f9964` (Nginx forwarding), `a9de277`.
- **Lesson:** CORS, proxy routing, and Spring Security each have to agree; fixing one layer alone did not make the call work.

### Inventory endpoint unreachable through the proxy

- **Symptom:** The service worked, but `/inventory-api/inventory` answered incorrectly or not at all.
- **Fix:** Reworked the Nginx location block to match the path and pass the remainder to the service, and corrected the controller mapping.
- **Commits:** `629d2ea` (endpoint problem), `41f15b9` (fixed mapping), `5157242` (inventory fetch in the frontend).
- **Lesson:** A working service behind a broken route still looks broken to the user. Check the proxy path and the controller annotation together.

## Kubernetes and images

### Pods could not pull images from the in-cluster registry

- **Symptom:** Images pushed successfully from the host, but nodes could not pull them (`ImagePullBackOff`).
- **Fix:** Switched the registry address to a cluster-resolvable hostname and removed an in-cluster registry chart in favour of Minikube's registry addon. The build registry prefix and the chart image names had to be changed together.
- **Commits:** `db994e3` ("unable to pull images from it inside the Cluster at Node level"), `3b03395`, `704a65d`.
- **Lesson:** `localhost:5000` means different things on the host and on a node. The [troubleshooting guide](guides/troubleshooting.md#image-builds-and-image-pulls) still calls this out.

### Image versions were scattered across files

- **Symptom:** Changing a base image required editing several Dockerfiles and chart values.
- **Fix:** Moved version pins into `.env` and passed them into Docker Bake as build arguments.
- **Commit:** `bfa94e4`.
- **Lesson:** A single source of truth for versions prevents the build output, Dockerfile `FROM` lines, and chart tags from drifting apart. See [configuration](reference/configuration.md#images-and-application-versions).

### A `latest` push did not update a running Pod

- **Symptom:** A rebuilt image with the same tag was not picked up.
- **Fix:** Restart the workload after pushing; the charts use `Always`, but a running Pod does not re-pull on its own.
- **Where recorded:** [Development workflow](guides/development.md#build-one-backend-without-the-ci-image).

## Helm values and environments

### Values merges overwrote the wrong settings

- **Symptom:** Environment overrides did not take effect in the expected order; some defaults won when they should have lost.
- **Fix:** Reworked `env-magic.gotmpl` several times, settling on the order `globalDefaults < release values < globalOverrides`, with `globalConfig` added as its own map. A later simplification replaced `globalBefore`/`globalAfter` with the current names.
- **Commits:** `fa43609`, `c118dd5`, `8930421` ("Order is defaults < globalBefore < releases < globalAfter"), `82857a2` and its revert `aae63b2`.
- **Lesson:** The template merges at the **top level**, not recursively. This is documented in [Kubernetes, Helm, and Helmfile](concepts/kubernetes-and-helm.md#environment-values-and-merge-behavior).

### A typo in values pointed the frontend at the wrong host

- **Symptom:** Staging API paths used `frotnend.local`.
- **Fix:** Corrected the host in the environment values; the chart's standalone defaults still contain the misspelling, which is why the environment values must be used.
- **Where recorded:** [Configuration reference](reference/configuration.md#browser-addresses).

## CI/CD

### The GitLab Runner could not build or push images

- **Symptom:** Runner jobs failed while starting Docker, building images, or reaching the registry.
- **Fix (iterative):** Registered and fixed the runner, granted its service account the needed cluster permissions, introduced a custom Docker-in-Docker image, and added daemon.json and BuildKit config so Buildx could use the insecure cluster registry. The series `75033a5` through `f350f3b` ("try 6") records the attempts.
- **Commits:** `5009876` (runner fixed, build and push), `2317037` (dind as custom image), `75033a5` (attempt at dind fix), `f350f3b` (try 6).
- **Lesson:** CI in Kubernetes combines a runner, RBAC, Docker-in-Docker and registry trust. Failure could be in any of those layers, so the fixes were applied one at a time. See [design decisions](concepts/design-decisions.md#cicd-external-gitlab-with-an-in-cluster-runner).

### Maven artifacts were not shared between pipeline stages

- **Symptom:** Later stages could not find parent POMs or the common module built earlier.
- **Fix:** Built the POMs and common library first and passed artifacts between stages.
- **Commits:** `20fb19a`, `c35f848`, `9821d31`, `d116cf2`, `95f033c`.
- **Lesson:** The project has no root reactor POM, so build order is explicit. See [development workflow](guides/development.md#build-java-outside-docker).

## Observability

### Loki and Promtail did not collect logs

- **Symptom:** The Compose-era logging stack produced no queryable logs.
- **Fix:** Adjusted Loki and Promtail configuration and the positions file, then removed committed runtime data.
- **Commits:** `a265266`, `cb2942f`.
- **Lesson:** The stack was later migrated to Grafana Alloy. The current [logging guide](monitoring-and-logging.md#known-collection-details-to-verify) documents the relabel and CRI-envelope issues that still need checking.

### Prometheus was never deployed in Kubernetes

- **Symptom:** Metrics endpoints exist, but no server or dashboard is present.
- **Status:** Not fixed — recorded as a scope boundary rather than a bug. See [metrics collection](monitoring-and-logging.md#metrics-are-exposed-but-collection-is-unfinished).

## Project structure

### Keeping Compose and Kubernetes in sync was too much work

- **Symptom:** Two deployment models meant two sets of configuration and duplicated effort.
- **Fix:** Moved entirely to Kubernetes, kept the Compose version as the `Docker-Compsoe-Version` tag, and later consolidated helper scripts into `scripts/` and versions into `.env`.
- **Commits:** `5925cbf` (simplified to a demo project), `9ba7f42` (scripts consolidated), `bfa94e4` (versions centralized).
- **Lesson:** Fewer deployment targets meant fewer places for configuration to drift. See [project history](project-history.md).

## What's next

- [Learning process](learning-process.md) — how the work was approached.
- [Troubleshooting](guides/troubleshooting.md) — current day-to-day checks.
- [Design decisions](concepts/design-decisions.md) — the reasoning behind the resulting setup.
