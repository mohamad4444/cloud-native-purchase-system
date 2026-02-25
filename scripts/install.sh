#!/bin/bash
# Installation script for Purchase System Cloud Native

set -e

echo "Installing Purchase System Cloud Native Dependencies"
echo "=========================================================="
echo ""

# Detect OS
OS_FAMILY="unknown"
if [ -f /etc/arch-release ]; then
    OS_FAMILY="arch"
    echo "[OK] Detected Arch Linux"
elif [ -f /etc/debian_version ] || [ -f /etc/ubuntu-release ]; then
    OS_FAMILY="debian"
    echo "[OK] Detected Debian/Ubuntu Linux"
else
    echo "[ERROR] Unsupported operating system. This script supports Arch Linux and Debian/Ubuntu."
    exit 1
fi

echo "[OK] Loading versions from .env file..."
if [ -f ../.env ]; then
    set -a
    # shellcheck disable=SC1091
    source ../.env
    set +a
elif [ -f .env ]; then
    set -a
    # shellcheck disable=SC1091
    source .env
    set +a
else
    echo "[ERROR] .env file not found. Please run this script from the project root or scripts directory."
    exit 1
fi

# Ensure local bin directory exists
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Function to add LOCAL_BIN to PATH if it isn't already there
add_to_path() {
    local profile_file=$1
    if [ -f "$profile_file" ]; then
        # shellcheck disable=SC2016
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$profile_file"; then
            echo "" >> "$profile_file"
            # shellcheck disable=SC2016
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$profile_file"
            echo "[OK] Added $LOCAL_BIN to $profile_file"
        fi
    fi
}

echo "Configuring PATH for local binaries..."
add_to_path "$HOME/.bashrc"
add_to_path "$HOME/.zshrc"
export PATH="$LOCAL_BIN:$PATH"

echo ""

################################################################################
# Define variables
################################################################################

if [ "$OS_FAMILY" = "arch" ]; then
    OS_PACKAGES=(
        "k9s"
        "make"
        "docker"
        "docker-buildx"
        "jq"
    )
    # No extra tarballs for Arch
    EXTRA_TARBALLS=()
elif [ "$OS_FAMILY" = "debian" ]; then
    OS_PACKAGES=(
        "make"
        "docker.io"
        "docker-buildx-plugin"
        "jq"
        "curl"
    )
    # k9s isn't nicely packaged in all debian repos, so grab it direct
    EXTRA_TARBALLS=(
        "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz|k9s|k9s"
    )
fi

# Format: "URL|binary_name"
DIRECT_BINARIES=(
    "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl|kubectl"
    "https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64|minikube"
)

# Format: "URL|binary_name"
APPIMAGES=(
    "https://api.k8slens.dev/binaries/Lens-${LENS_VERSION}.x86_64.AppImage|lens"
)

# Format: "URL|path_in_tar|binary_name"
TARBALLS=(
    "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz|linux-amd64/helm|helm"
    "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz|helmfile|helmfile"
    "https://github.com/kluctl/kluctl/releases/download/${KLUCTL_VERSION}/kluctl_${KLUCTL_VERSION}_linux_amd64.tar.gz|kluctl|kluctl"
)
# Merge OS-specific tarballs
TARBALLS=("${TARBALLS[@]}" "${EXTRA_TARBALLS[@]}")

################################################################################
# Define installation functions
################################################################################

install_direct_binary() {
    local url=$1
    local name=$2
    if [ ! -x "$LOCAL_BIN/$name" ]; then
        echo "Downloading $name..."
        curl -sSL "$url" -o "$LOCAL_BIN/$name"
        chmod +x "$LOCAL_BIN/$name"
        echo "[OK] $name downloaded successfully"
    else
        echo "[OK] $name already installed"
    fi
}

install_appimage() {
    local url=$1
    local name=$2
    if [ ! -x "$LOCAL_BIN/$name" ]; then
        echo "Downloading $name AppImage..."
        curl -sSL "$url" -o "$LOCAL_BIN/$name"
        chmod +x "$LOCAL_BIN/$name"
        echo "[OK] $name AppImage downloaded successfully"
    else
        echo "[OK] $name already installed"
    fi
}

install_tarball_binary() {
    local url=$1
    local path_in_tar=$2
    local name=$3
    if [ ! -x "$LOCAL_BIN/$name" ]; then
        echo "Downloading $name..."
        local tmp_dir=$(mktemp -d)
        if curl -sSL "$url" | tar xz -C "$tmp_dir"; then
            mv "$tmp_dir/$path_in_tar" "$LOCAL_BIN/$name"
            chmod +x "$LOCAL_BIN/$name"
            echo "[OK] $name extracted successfully"
        else
            echo "[ERROR] Failed to extract $name from $url"
        fi
        rm -rf "$tmp_dir"
    else
        echo "[OK] $name already installed"
    fi
}

################################################################################
# Installation Steps
################################################################################

echo "Installing System Dependencies (${OS_PACKAGES[*]})..."
if [ "$OS_FAMILY" = "arch" ]; then
    if command -v yay &> /dev/null; then
        echo "Using yay (AUR helper)..."
        yay -S --needed "${OS_PACKAGES[@]}"
    else
        echo "yay not found. Installing from official repos..."
        sudo pacman -S --needed "${OS_PACKAGES[@]}"
    fi
elif [ "$OS_FAMILY" = "debian" ]; then
    echo "Using apt-get..."
    sudo apt-get update
    sudo apt-get install -y "${OS_PACKAGES[@]}"
fi

echo ""
echo "Downloading Tooling Static Binaries to $LOCAL_BIN..."

# Install Direct Binaries
for entry in "${DIRECT_BINARIES[@]}"; do
    url="${entry%%|*}"
    name="${entry##*|}"
    install_direct_binary "$url" "$name"
done

# Install AppImages
for entry in "${APPIMAGES[@]}"; do
    url="${entry%%|*}"
    name="${entry##*|}"
    install_appimage "$url" "$name"
done

# Install Tarballs
for entry in "${TARBALLS[@]}"; do
    url="${entry%%|*}"
    remaining="${entry#*|}"
    path_in_tar="${remaining%%|*}"
    name="${remaining##*|}"
    install_tarball_binary "$url" "$path_in_tar" "$name"
done

echo ""
echo "Configuring Docker..."

# Ensure Docker service is running
sudo systemctl enable docker || true
sudo systemctl start docker || true

# Add user to docker group if not already
if ! groups "$USER" | grep -q docker; then
    echo "Adding $USER to docker group..."
    sudo usermod -aG docker "$USER"
    echo "[WARNING] You'll need to log out and back in for docker group changes to take effect"
    echo "          Or run: newgrp docker"
fi

echo ""
echo "Setting up Docker Buildx..."
if ! docker buildx ls 2>/dev/null | grep -q mybuilder; then
    docker buildx create --use --name mybuilder --driver docker-container --driver-opt network=host || echo "[WARNING] Buildx creation might require docker privileges."
    echo "[OK] Docker buildx builder 'mybuilder' setup attempted."
else
    echo "[OK] Docker buildx builder 'mybuilder' already exists"
fi

echo ""
echo "Starting Minikube..."
if minikube status &> /dev/null; then
    echo "[OK] Minikube is already running"
else
    # Minikube needs docker perm, let's run without explicitly failing the whole script
    if groups "$USER" | grep -q docker || [ "$EUID" -eq 0 ]; then
        minikube start --driver=docker --memory=4096 --cpus=2 || echo "[WARNING] Minikube start failed. Try running 'newgrp docker' first."
        minikube addons enable registry || true
        echo "[OK] Minikube startup attempted"
    else
        echo "[WARNING] Cannot start minikube automatically until you join the docker group."
    fi
fi

echo ""
echo "Verification:"
echo "----------------"
echo "Docker:    $(docker --version 2>/dev/null || echo 'Docker not working without sudo yet')"
echo "Minikube:  $(minikube version --short 2>/dev/null || echo 'Minikube not installed')"
echo "Helm:      $("$LOCAL_BIN/helm" version --short 2>/dev/null || echo 'Helm not installed')"
echo "Helmfile:  $("$LOCAL_BIN/helmfile" --version 2>/dev/null || echo 'Helmfile not installed')"
echo "Kluctl:    $("$LOCAL_BIN/kluctl" version 2>/dev/null || echo 'Kluctl not installed')"
echo "kubectl:   $(kubectl version --client --short 2>/dev/null || echo 'kubectl not installed')"
echo "K9s:       $(k9s version -s | head -n1 2>/dev/null || echo 'K9s not installed')"
echo "Make:      $(make --version | head -n1 2>/dev/null || echo 'Make not installed')"
echo "Lens:      $(command -v lens || echo 'Lens not installed')"

echo ""
echo "[OK] Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run this to refresh your PATH: source ~/.bashrc (or ~/.zshrc)"
echo "2. If docker group was just added, run: newgrp docker"
echo "3. For staging deployment, setup certificates in certificate-authority/"
echo "4. Run: ./scripts/startup.sh"
echo "5. Run: make release"
