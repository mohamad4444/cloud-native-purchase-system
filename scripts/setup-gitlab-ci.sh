#!/usr/bin/env bash
# Attach this local Kubernetes cluster to a GitLab CI/CD pipeline using the GitLab API.
#
# The script uses a Personal Access Token (PAT) with the `api` scope to:
#   1. verify the token and resolve the target project
#   2. create a project runner (runner authentication token, glrt-...)
#   3. install/upgrade the runner Helm chart in the local cluster with that token
#   4. optionally set CI/CD variables and trigger a pipeline
#
# The token is never written to the repository. It lives only in a temporary
# values file with mode 0600, removed on exit.
#
# Usage:
#   GITLAB_TOKEN=glpat-... ./scripts/setup-gitlab-ci.sh
#   GITLAB_TOKEN=glpat-... GITLAB_PROJECT_PATH=mohamad4444/cloud-native-purchase-system \
#       ./scripts/setup-gitlab-ci.sh --trigger
#   ./scripts/setup-gitlab-ci.sh --check     # verify prerequisites only
#   ./scripts/setup-gitlab-ci.sh --help
#
# Environment variables:
#   GITLAB_TOKEN         (required) PAT with `api` scope
#   GITLAB_URL           default: https://gitlab.rlp.net
#   GITLAB_PROJECT_ID    numeric project id (takes precedence over path)
#   GITLAB_PROJECT_PATH  namespace/project, default: the repo's GitLab remote path
#   RUNNER_DESCRIPTION   default: local-minikube-runner
#   RUNNER_TAGS          default: kubernetes
#   CI_REGISTRY_IMAGE    optional: image to override the runner build image

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

info()  { printf '\033[1;34m[%s]\033[0m %s\n' 'INFO' "$*"; }
ok()    { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage: ./scripts/setup-gitlab-ci.sh [options]

Automatically connects the local Minikube cluster to a GitLab project as a
Kubernetes runner, using a Personal Access Token with the `api` scope.

Options:
  --check     Only verify prerequisites (kubectl/helm + cluster access)
  --trigger   Trigger a pipeline after the runner is installed
  --dry-run   Show the API calls and Helm commands without executing them
  --help      Show this help

Environment:
  GITLAB_TOKEN         required PAT with `api` scope (never stored on disk)
  GITLAB_URL           default https://gitlab.rlp.net
  GITLAB_PROJECT_ID    numeric id, preferred when known
  GITLAB_PROJECT_PATH  namespace/project (auto-detected from git remote)
EOF
}

CHECK_ONLY=0
TRIGGER=0
DRY_RUN=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)   CHECK_ONLY=1; shift ;;
        --trigger) TRIGGER=1; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) fail "Unknown option: $1 (try --help)" ;;
    esac
done

# ---------------------------------------------------------------------------
# Prerequisites
# ---------------------------------------------------------------------------
for tool in curl helm kubectl jq git; do
    command -v "$tool" >/dev/null 2>&1 || fail "Missing required tool: ${tool}"
done

GITLAB_URL="${GITLAB_URL:-https://gitlab.rlp.net}"
GITLAB_URL="${GITLAB_URL%/}"
RUNNER_DESCRIPTION="${RUNNER_DESCRIPTION:-local-minikube-runner}"
RUNNER_TAGS="${RUNNER_TAGS:-kubernetes}"

if [[ "$CHECK_ONLY" -eq 1 ]]; then
    info "Checking cluster access..."
    kubectl cluster-info >/dev/null 2>&1 || fail "kubectl cannot reach a cluster"
    ns="$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)"
    ok "Cluster reachable (context namespace: ${ns:-default})"
    helm version --short
    [[ -n "${GITLAB_TOKEN:-}" ]] && ok "GITLAB_TOKEN is set" || warn "GITLAB_TOKEN is not set (required for a real run)"
    exit 0
fi

[[ -n "${GITLAB_TOKEN:-}" ]] || fail "Set GITLAB_TOKEN (PAT with api scope). See --help."

# Resolve project path from the git remote when not provided
if [[ -z "${GITLAB_PROJECT_ID:-}" && -z "${GITLAB_PROJECT_PATH:-}" ]]; then
    remote="$(git -C "$PROJECT_ROOT" remote get-url origin 2>/dev/null || true)"
    if [[ "$remote" =~ [:/]([^/:]+/[^/]+?)(\.git)?$ ]]; then
        GITLAB_PROJECT_PATH="${BASH_REMATCH[1]}"
        info "Auto-detected project path: ${GITLAB_PROJECT_PATH}"
    else
        fail "Could not detect project path. Set GITLAB_PROJECT_ID or GITLAB_PROJECT_PATH."
    fi
fi

api() {
    local method="$1" endpoint="$2"; shift 2
    local url="${GITLAB_URL}/api/v4${endpoint}"
    if [[ "$DRY_RUN" -eq 1 ]]; then
        printf '\033[1;34m[INFO]\033[0m DRY-RUN: %s %s %s\n' "$method" "$url" "$*" >&2
        echo '{}'
        return 0
    fi
    curl -fsS --retry 2 -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        -X "$method" "$url" "$@"
}

# ---------------------------------------------------------------------------
# 1. Validate token
# ---------------------------------------------------------------------------
info "Validating GitLab token at ${GITLAB_URL}..."
user_json="$(api GET /user)"
if [[ "$DRY_RUN" -eq 0 ]]; then
    user_name="$(echo "$user_json" | jq -r '.username // "unknown"')"
    ok "Authenticated as ${user_name}"
else
    user_name="dry-run"
fi

# ---------------------------------------------------------------------------
# 2. Resolve project
# ---------------------------------------------------------------------------
if [[ -n "${GITLAB_PROJECT_ID:-}" ]]; then
    project_id="${GITLAB_PROJECT_ID}"
    info "Using project id ${project_id}"
else
    encoded="$(printf '%s' "$GITLAB_PROJECT_PATH" | jq -sRr @uri)"
    project_json="$(api GET "/projects/${encoded}")"
    project_id="$(echo "$project_json" | jq -r '.id')"
    [[ "$project_id" != "null" && -n "$project_id" ]] || fail "Project not found: ${GITLAB_PROJECT_PATH}"
    ok "Project ${GITLAB_PROJECT_PATH} → id ${project_id}"
fi

# ---------------------------------------------------------------------------
# 3. Create runner via API (runner authentication token)
# ---------------------------------------------------------------------------
info "Creating project runner '${RUNNER_DESCRIPTION}'..."
runner_json="$(api POST "/projects/${project_id}/runners" \
    -H 'Content-Type: application/json' \
    --data "$(jq -nc \
        --arg desc "$RUNNER_DESCRIPTION" \
        --arg tags "$RUNNER_TAGS" \
        '{description:$desc, runner_type:"project_type", tag_list:($tags|split(",")), run_untagged:false, locked:true, access_level:"ref_protected"}')")"

runner_token="$(echo "$runner_json" | jq -r '.token // empty')"
if [[ "$DRY_RUN" -eq 1 ]]; then
    runner_token="glrt-DRYRUN-TOKEN"
elif [[ -z "$runner_token" ]]; then
    fail "GitLab did not return a runner token. Response: ${runner_json}"
else
    ok "Runner created (id $(echo "$runner_json" | jq -r '.id'))"
fi

# ---------------------------------------------------------------------------
# 4. Install the runner into the cluster with a temporary values file
# ---------------------------------------------------------------------------
tmp_values="$(mktemp)"
chmod 600 "$tmp_values"
cleanup() { rm -f "$tmp_values"; }
trap cleanup EXIT

cat > "$tmp_values" <<EOF
gitlabUrl: "${GITLAB_URL}/"
runnerToken: "${runner_token}"
runners:
  name: "${RUNNER_DESCRIPTION}"
  tags: ["${RUNNER_TAGS}"]
  privileged: true
  kubernetes:
    hostNetwork: true
    namespace: gitlab-runner
    serviceAccount: gitlab-runner
    image: "registry.kube-system.svc.cluster.local:80/dind:latest"
EOF

info "Ensuring gitlab-runner namespace and service account exist..."
if [[ "$DRY_RUN" -eq 1 ]]; then
    info "DRY-RUN: helm upgrade --install gitlab-runner-sa ./charts/gitlab-runner-sa -n gitlab-runner --create-namespace"
else
    helm upgrade --install gitlab-runner-sa "${PROJECT_ROOT}/charts/gitlab-runner-sa" \
        --namespace gitlab-runner --create-namespace --wait >/dev/null
    ok "Service account chart installed"
fi

info "Installing/upgrading the GitLab Runner chart..."
if [[ "$DRY_RUN" -eq 1 ]]; then
    info "DRY-RUN: helm upgrade --install gitlab-runner gitlab/gitlab-runner --version 0.80.1 -n gitlab-runner -f ${PROJECT_ROOT}/environments/values/charts/runner.yaml -f ${tmp_values}"
else
    helm repo add gitlab https://charts.gitlab.io >/dev/null 2>&1 || true
    helm repo update gitlab >/dev/null 2>&1 || true
    helm upgrade --install gitlab-runner gitlab/gitlab-runner \
        --version 0.80.1 \
        --namespace gitlab-runner \
        -f "${PROJECT_ROOT}/environments/values/charts/runner.yaml" \
        -f "$tmp_values" \
        --wait >/dev/null
    ok "GitLab Runner installed in namespace gitlab-runner"
fi

# ---------------------------------------------------------------------------
# 5. Optional: set CI/CD variables and trigger a pipeline
# ---------------------------------------------------------------------------
if [[ -n "${CI_REGISTRY_IMAGE:-}" ]]; then
    info "Setting CI variable CI_REGISTRY_IMAGE..."
    api POST "/projects/${project_id}/variables" \
        -H 'Content-Type: application/json' \
        --data "$(jq -nc --arg v "$CI_REGISTRY_IMAGE" '{key:"CI_REGISTRY_IMAGE",value:$v,protected:false,masked:false,variable_type:"env_var"}')" >/dev/null
    ok "CI variable set"
fi

if [[ "$TRIGGER" -eq 1 ]]; then
    info "Triggering a pipeline on ${GITLAB_URL}..."
    pipeline_json="$(api POST "/projects/${project_id}/pipeline" -H 'Content-Type: application/json' --data '{"ref":"develop"}')"
    pid="$(echo "$pipeline_json" | jq -r '.id // "unknown"')"
    ok "Pipeline ${pid} triggered (ref develop)"
    echo "  ${GITLAB_URL}/${GITLAB_PROJECT_PATH:-projects/${project_id}}/-/pipelines/${pid}"
fi

echo ""
ok "CI/CD attachment complete"
info "The runner uses tag '${RUNNER_TAGS}' — jobs in .gitlab-ci.yml must match it (they already do)."
info "Runner token stored only in a temporary file that has now been removed."
