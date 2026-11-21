#!/usr/bin/env bash
# Install and verify every tool needed to build and run the Cloud Native Purchase System.
#
# Usage:
#   ./scripts/install-tools.sh --check     # only verify what is installed
#   ./scripts/install-tools.sh             # install missing tools
#   ./scripts/install-tools.sh --optional  # also install k9s and stern
#   ./scripts/install-tools.sh --help
#
# Safe to re-run: existing tools are detected and skipped, and it never deletes a cluster.
# Supported: Arch Linux / EndeavourOS, Debian / Ubuntu, Fedora.

set -euo pipefail

CHECK_ONLY=0
INSTALL_OPTIONAL=0
LOCAL_BIN="${HOME}/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------
info()  { printf '\033[1;34m[%s]\033[0m %s\n' 'INFO' "$*"; }
ok()    { printf '\033[1;32m[ OK ]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
fail()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage: ./scripts/install-tools.sh [options]

Options:
  --check      Only verify installed tools; do not install anything
  --optional   Also install optional tools (k9s, stern)
  --help       Show this help

By default the script installs missing required tools and prints a summary.
It reads pinned tool versions from the repository .env file when available.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)    CHECK_ONLY=1; shift ;;
        --optional) INSTALL_OPTIONAL=1; shift ;;
        -h|--help)  usage; exit 0 ;;
        *)          fail "Unknown option: $1 (try --help)" ;;
    esac
done

# ---------------------------------------------------------------------------
# OS detection and version pins
# ---------------------------------------------------------------------------
OS_FAMILY="unknown"
if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    case "${ID_LIKE:-${ID}}" in
        *arch*)   OS_FAMILY="arch" ;;
        *debian*|debian|ubuntu) OS_FAMILY="debian" ;;
        *fedora*|rhel|centos)   OS_FAMILY="fedora" ;;
    esac
fi

if [[ -f "${PROJECT_ROOT}/.env" ]]; then
    set -a
    # shellcheck disable=SC1091
    . "${PROJECT_ROOT}/.env"
    set +a
fi

HELM_VERSION="${HELM_VERSION:-v4.1.1}"
HELMFILE_VERSION="${HELMFILE_VERSION:-v1.3.1}"
MINIKUBE_VERSION="${MINIKUBE_VERSION:-v1.36.0}"
STERN_VERSION="${STERN_VERSION:-v1.35.0}"
KUBECTL_VERSION="${KUBECTL_VERSION:-}"
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64)  ARCH_SUFFIX="amd64" ;;
    aarch64|arm64) ARCH_SUFFIX="arm64" ;;
    *) fail "Unsupported architecture: $ARCH" ;;
esac

info "Project root: ${PROJECT_ROOT}"
info "OS family: ${OS_FAMILY}"
info "Architecture: ${ARCH_SUFFIX}"

# ---------------------------------------------------------------------------
# Verification helpers
# ---------------------------------------------------------------------------
REQUIRED_TOOLS=(docker minikube kubectl helm helmfile make openssl curl java)
OPTIONAL_TOOLS=(jq stern k9s)
MISSING=()

have() { command -v "$1" >/dev/null 2>&1; }

version_of() {
    local tool="$1"
    case "$tool" in
        docker)   docker --version 2>/dev/null | head -1 ;;
        minikube) minikube version --short 2>/dev/null | head -1 ;;
        kubectl)  kubectl version --client --short 2>/dev/null | head -1 || kubectl version --client 2>/dev/null | head -1 ;;
        helm)     helm version --short 2>/dev/null | head -1 ;;
        helmfile) helmfile --version 2>/dev/null | head -1 ;;
        make)     make --version 2>/dev/null | head -1 ;;
        openssl)  openssl version 2>/dev/null | head -1 ;;
        curl)     curl --version 2>/dev/null | head -1 ;;
        java)     java -version 2>&1 | head -1 ;;
        jq)       jq --version 2>/dev/null | head -1 ;;
        stern)    stern --version 2>/dev/null | head -1 || echo "installed" ;;
        k9s)      k9s version --short 2>/dev/null | head -1 || echo "installed" ;;
        *)        echo "unknown" ;;
    esac
}

verify() {
    local title="$1"; shift
    echo ""
    info "${title}"
    local tool
    for tool in "$@"; do
        if have "$tool"; then
            printf '  %-12s %s\n' "$tool" "$(version_of "$tool")"
        else
            printf '  %-12s \033[1;31mMISSING\033[0m\n' "$tool"
            MISSING+=("$tool")
        fi
    done
}

# ---------------------------------------------------------------------------
# Check-only mode
# ---------------------------------------------------------------------------
if [[ "$CHECK_ONLY" -eq 1 ]]; then
    verify "Required tools" "${REQUIRED_TOOLS[@]}"
    verify "Optional tools" "${OPTIONAL_TOOLS[@]}"
    echo ""
    if [[ ${#MISSING[@]} -eq 0 ]]; then
        ok "All required tools are present"
    else
        warn "Missing tools: ${MISSING[*]}"
        warn "Run ./scripts/install-tools.sh to install them"
    fi
    exit 0
fi

# ---------------------------------------------------------------------------
# Installation
# ---------------------------------------------------------------------------
mkdir -p "$LOCAL_BIN"
case ":$PATH:" in
    *":${LOCAL_BIN}:"*) ;;
    *) export PATH="${LOCAL_BIN}:${PATH}" ;;
esac

add_to_path() {
    local profile="$1"
    [[ -f "$profile" ]] || return 0
    if ! grep -q '\.local/bin' "$profile"; then
        printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$profile"
        info "Added ~/.local/bin to PATH in ${profile}"
    fi
}
add_to_path "${HOME}/.bashrc"
add_to_path "${HOME}/.zshrc"

SUDO=""
if [[ $EUID -ne 0 ]]; then
    command -v sudo >/dev/null 2>&1 || fail "sudo is required to install system packages"
    SUDO="sudo"
fi

package_installed() {
    case "$OS_FAMILY" in
        arch)   pacman -Qi "$1" >/dev/null 2>&1 ;;
        debian) dpkg -s "$1" >/dev/null 2>&1 ;;
        fedora) rpm -q "$1" >/dev/null 2>&1 ;;
        *)      return 1 ;;
    esac
}

install_packages() {
    local needed=() pkg
    for pkg in "$@"; do
        if package_installed "$pkg"; then
            ok "${pkg} already installed"
        else
            needed+=("$pkg")
        fi
    done
    [[ ${#needed[@]} -eq 0 ]] && return 0

    info "Installing system packages: ${needed[*]}"
    case "$OS_FAMILY" in
        arch)   $SUDO pacman -S --needed --noconfirm "${needed[@]}" ;;
        debian) $SUDO apt-get update -qq && $SUDO apt-get install -y "${needed[@]}" ;;
        fedora) $SUDO dnf install -y "${needed[@]}" ;;
        *)      fail "Unsupported OS. Install these packages manually: ${needed[*]}" ;;
    esac
}

install_binary() {
    local name="$1" url="$2"
    if have "$name"; then
        ok "${name} already installed ($(version_of "$name"))"
        return 0
    fi
    info "Downloading ${name} from ${url}"
    local tmp
    tmp="$(mktemp)"
    curl -fsSL "$url" -o "$tmp" || { rm -f "$tmp"; warn "Could not download ${name}"; return 1; }
    install -m 0755 "$tmp" "${LOCAL_BIN}/${name}"
    rm -f "$tmp"
    ok "${name} installed to ${LOCAL_BIN}/${name}"
}

install_tarball() {
    local name="$1" url="$2" path_in_tar="$3"
    if have "$name"; then
        ok "${name} already installed ($(version_of "$name"))"
        return 0
    fi
    info "Downloading ${name} ${url}"
    local tmpdir
    tmpdir="$(mktemp -d)"
    if curl -fsSL "$url" | tar -xz -C "$tmpdir" 2>/dev/null; then
        install -m 0755 "${tmpdir}/${path_in_tar}" "${LOCAL_BIN}/${name}"
        ok "${name} installed"
    else
        warn "Could not install ${name}"
    fi
    rm -rf "$tmpdir"
}

# 1. System packages --------------------------------------------------------
case "$OS_FAMILY" in
    arch)
        install_packages curl openssl make docker docker-buildx jq
        have java || install_packages jdk21-openjdk
        ;;
    debian)
        install_packages curl openssl make ca-certificates
        have docker || install_packages docker.io docker-buildx-plugin
        have java || install_packages openjdk-21-jdk || warn "openjdk-21-jdk unavailable; install Java 21 manually"
        have jq || install_packages jq
        ;;
    fedora)
        install_packages curl openssl make docker docker-buildx jq
        have java || install_packages java-21-openjdk
        ;;
esac

# 2. Static binaries (pinned versions from .env) ----------------------------
KUBECTL_URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH_SUFFIX}/kubectl"
[[ -n "$KUBECTL_VERSION" ]] || KUBECTL_URL="https://dl.k8s.io/release/stable.txt"
if [[ -z "$KUBECTL_VERSION" ]]; then
    KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
    KUBECTL_URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH_SUFFIX}/kubectl"
fi
install_binary kubectl "$KUBECTL_URL"

MINIKUBE_URL="https://github.com/kubernetes/minikube/releases/download/${MINIKUBE_VERSION}/minikube-linux-${ARCH_SUFFIX}"
install_binary minikube "$MINIKUBE_URL"

install_tarball helm \
    "https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH_SUFFIX}.tar.gz" \
    "linux-${ARCH_SUFFIX}/helm"

install_tarball helmfile \
    "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_${ARCH_SUFFIX}.tar.gz" \
    "helmfile"

# 3. Optional tools ---------------------------------------------------------
if [[ "$INSTALL_OPTIONAL" -eq 1 ]]; then
    if ! have stern; then
        install_tarball stern \
            "https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_${ARCH_SUFFIX}.tar.gz" \
            "stern"
    fi
    if ! have k9s; then
        install_tarball k9s \
            "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${ARCH_SUFFIX}.tar.gz" \
            "k9s"
    fi
fi

# 4. Docker service and group ----------------------------------------------
if have docker; then
    if command -v systemctl >/dev/null 2>&1; then
        $SUDO systemctl enable --now docker >/dev/null 2>&1 || warn "Could not enable the Docker service"
    fi
    if [[ $EUID -ne 0 ]] && ! id -nG "$USER" | grep -qw docker; then
        info "Adding ${USER} to the docker group"
        $SUDO usermod -aG docker "$USER" || warn "Could not add user to docker group"
        warn "Log out and back in (or run 'newgrp docker') before using Docker without sudo"
    fi
fi

# ---------------------------------------------------------------------------
# Final verification
# ---------------------------------------------------------------------------
verify "Required tools" "${REQUIRED_TOOLS[@]}"
verify "Optional tools" "${OPTIONAL_TOOLS[@]}"

echo ""
CORE_MISSING=()
for t in "${REQUIRED_TOOLS[@]}"; do
    have "$t" || CORE_MISSING+=("$t")
done
if [[ ${#CORE_MISSING[@]} -eq 0 ]]; then
    ok "All required tools are installed"
    echo ""
    info "Next steps:"
    echo "  1. Log out/in if you were just added to the docker group"
    echo "  2. Follow docs/tutorials/local-kubernetes.md to start Minikube"
    echo "  3. Run 'zensical serve' in the docs venv to preview documentation"
else
    warn "Still missing: ${CORE_MISSING[*]}"
    warn "Install them manually, then re-run this script with --check"
fi
