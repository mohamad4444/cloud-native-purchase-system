# Local runtime notes and environment errors

Notes from actually running this project on an EndeavourOS (Arch) machine inside a restricted virtual environment. The standard tutorial is [run on local Kubernetes](../tutorials/local-kubernetes.md); this page records what happens when the host kernel cannot provide the networking Docker expects, and every error encountered along the way.

## Can Minikube run under Docker?

**Yes — normally.** The Docker driver is the default and recommended way to run Minikube locally. It starts a container from the `kicbase` image and runs kubelet and the control plane inside it, which is lighter than a full VM. The tutorial uses:

```bash
minikube start --driver=docker --memory=8g --cpus=4
```

For that to work, the host must provide two kernel features:

| Feature | Why Minikube/Docker needs it |
| --- | --- |
| **Overlay filesystem mounts** | Container images are built from stacked layers. Docker mounts them with overlayfs. |
| **veth pairs** | Docker's bridge network gives each container its own network namespace. A **veth pair** is a virtual Ethernet "cable": one end lives in the host bridge (`docker0`), the other inside the container. Without it, a container cannot get a network interface on a bridge. |

### What is a veth module?

`veth` is a Linux kernel module that creates **virtual ethernet devices in pairs**. Traffic written to one end comes out the other. Docker (and Kubernetes CNI plugins) use it to connect a container's network namespace to the host bridge — it is the plumbing behind `docker0` and most pod networking.

You can check whether your kernel offers it:

```bash
lsmod | grep veth
find /lib/modules/$(uname -r) -name 'veth*.ko*'
ip link add veth-test type veth peer name veth-test2 # needs root
```

If the device type is unknown or the module file is missing, the kernel was built without veth support (common in locked-down VMs, containers and some cloud images). If the module exists but is not loaded, `sudo modprobe veth` fixes it.

### Why it did not work here

This machine's kernel (`7.3.4-arch1-2`) has **no veth module at all**, and Docker's default overlayfs snapshotter also failed to mount layers. Result: containers could only run with `--network=none` — a plain `docker run hello-world` failed at bridge setup, while `docker run --network=none hello-world` succeeded. Since Minikube's Docker driver requires bridge networking, it could not start.

The fix was to use Minikube's **QEMU/KVM driver** instead. That runs a full virtual machine with its own kernel and network stack, so all the container networking happens *inside* the VM and no host veth pairs are needed.

```bash
minikube start --driver=qemu2 --memory=8192 --cpus=4
```

On a normal desktop/laptop with a standard kernel, you should keep using `--driver=docker` and skip everything on this page.

## Errors encountered and resolutions

| # | Error | Cause | Resolution |
| --- | --- | --- | --- |
| 1 | `failed to mount /tmp/containerd-mount... fstype=overlay ... err: no such device` while creating `minikube-preload-sidecar` | Host Docker's overlayfs snapshotter cannot mount layered filesystems in this environment | Temporarily set Docker to the `vfs` storage driver (`/etc/docker/daemon.json`) — portable but slower. Restored to the original config afterwards. |
| 2 | `failed to set up container networking: failed to add the host (veth...) <=> sandbox (veth...) pair interfaces: operation not supported` | No veth pairs in this kernel | Switched from `--driver=docker` to `--driver=qemu2`. |
| 3 | `ip link add ... type veth` → `Error: Unknown device type`; `modprobe veth` → `Module veth not found` | Kernel built without veth support | Cannot be fixed at runtime here; confirms the need for the QEMU driver. |
| 4 | `PROVIDER_QEMU2_NOT_FOUND: stat /usr/share/OVMF/OVMF_CODE.fd: no such file or directory` | Minikube expects OVMF firmware at `/usr/share/OVMF`; Arch installs it under `/usr/share/edk2/x64/` | Symlinked `OVMF_CODE.fd` and `OVMF_VARS.fd` into `/usr/share/OVMF/`. |
| 5 | `GUEST_DRIVER_MISMATCH: existing cluster was created using the docker driver` | A stale, never-started Minikube machine from the failed Docker attempt | `minikube delete` before starting with a different driver. |
| 6 | `ImagePullBackOff` for `localhost:5000/artemis:latest` in Pods | Images were pushed to the registry via a host port-forward, but Pods resolve `localhost` to themselves; the registry-proxy addon that normally fixes this is broken | Loaded images directly into the cluster runtime with `minikube image load` and temporarily set `pullPolicy: IfNotPresent`. |
| 7 | `registry-proxy` pod in `ImagePullBackOff`: `manifest for gcr.io/k8s-minikube/kube-registry-proxy@sha256:... not found` | Minikube pins a digest whose manifest was removed upstream | Unrelated to this project's code; the port-forward approach still works for pushes, and `minikube image load` avoids pulls entirely. |
| 8 | `Get "https://registry.kube-system.svc.cluster.local:80/v2/"` and `lookup registry.kube-system.svc.cluster.local on 10.0.2.3:53: no such host` | The VM's Docker daemon tried TLS and used QEMU's DNS, which cannot resolve cluster service names | Tried the Service ClusterIP instead; the VM also had no route to it (`connect: no route to host`), so the registry path was abandoned in favour of `minikube image load`. |
| 9 | `Job for docker.service failed ... Start request repeated too quickly` (inside the VM) | Editing `/etc/docker/daemon.json` conflicted with Minikube's `--insecure-registries=10.96.0.0/12` flag, then systemd rate-limited restarts | Removed the conflicting file and ran `sudo systemctl reset-failed docker && sudo systemctl start docker`. Note: restarting Docker inside the VM also stopped the control plane; `minikube start` restored it. |
| 10 | `failed to resolve source metadata for localhost:5000/builder-common:latest: not found` during `bake application-images --load` | Buildx's `docker-container` builder has its own image store and cannot see images in the host Docker daemon | Pushed `builder-common` to the registry first so Buildx could pull it as the base layer. |
| 11 | `docker buildx bake ... --load` conflicted with `push = true` in `docker-bake.hcl` | The bake targets default to pushing | Used `--set '*.push=false' --load` to build into the local daemon instead. |
| 12 | `no matches for kind "Certificate" in version "cert-manager.io/v1" — ensure CRDs are installed first` | The frontend/charts create Certificate resources, but cert-manager was not installed | Installed the cert-manager release first: `helmfile -e dev --selector name=cert-manager sync`. |
| 13 | `resource Certificate/dev/frontend-dev-cert not ready ... Issuing certificate as Secret does not exist` | No CA Secret/ClusterIssuer was created in this dev run | Harmless for HTTP dev mode — ingress is disabled. The frontend Pod still runs. The full CA setup is in [certificate management](../certificate-management.md). |
| 14 | API returned `500 {"error":"Access Denied"}` for a token from `admin-cli` | That client issues a lightweight token with no `sub` and no roles | Used `web-frontend-client` (temporarily enabling its password grant through the Admin API to avoid simulating a browser PKCE flow with curl), then reverted it. The real UI uses PKCE — see [Keycloak and OIDC](../deep-dives/keycloak.md#the-authorization-code-flow-with-pkce). |
| 15 | `invalid_grant` when getting an admin token in `purchase-service-realm` | The admin user lives in the `master` realm, not the imported application realm | Requested the token from `/realms/master/...` instead. |
| 16 | `kubectl is version 1.37.2, which may have incompatibilities with Kubernetes 1.33.1` | Standalone kubectl is newer than the cluster | Warning only; all commands worked. `minikube kubectl -- ...` would match exactly. |

## Working setup on this machine

For reference, these were the steps that finally produced a healthy system — useful if you repeat the test in a similarly restricted environment:

```bash
# 1. Start Minikube as a VM (Docker driver is impossible without veth)
minikube start --driver=qemu2 --memory=8192 --cpus=4
minikube addons enable ingress

# 2. Build images into local Docker, then load them into the cluster
set -a; . ./.env; set +a
docker buildx bake base-images --set '*.push=false' --load
docker push localhost:5000/builder-common:latest # so Buildx can use it as a base
docker buildx bake application-images --set '*.push=false' --load
for i in builder-common artemis keycloak nginx-frontend inventory-service purchase-service dind; do
 minikube image load localhost:5000/$i:latest
done

# 3. Install cert-manager CRDs, then deploy with IfNotPresent
helmfile -f environments/helmfile.yaml -e dev --selector name=cert-manager sync
# (temporarily set globalConfig.pullPolicy: IfNotPresent in dev.yaml)
helmfile -f environments/helmfile.yaml -e dev \
 --selector name=frontend --selector name=keycloak \
 --selector name=message-broker --selector name=inventory-service \
 --selector name=purchase-service sync --skip-needs

# 4. Expose the app
kubectl port-forward -n dev service/frontend-service 4200:80
kubectl port-forward -n dev service/keycloak-service 8080:8080
kubectl port-forward -n dev service/purchase-service 8001:8080
kubectl port-forward -n dev service/inventory-service 8002:8080
```

Result: eight healthy Pods in `dev`, a working browser UI, a Keycloak realm, and a purchase that travels through Artemis and reduces inventory stock. See [make your first purchase](../tutorials/first-purchase.md).

## Where to read next

- [Troubleshooting](troubleshooting.md) — checks for day-to-day problems.
- [Problems and fixes](../problems-and-fixes.md) — issues found in the project itself during development.
- [Tool installer](../../scripts/install-tools.sh) — installs the required tooling on a normal host.
