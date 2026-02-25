ARG DOCKER_DIND_VERSION=latest
FROM docker:${DOCKER_DIND_VERSION}

# Install base tools (curl, bash, git, etc.)
RUN apk add --no-cache bash curl git

# Install kubectl (latest stable)
RUN curl -sSL "https://dl.k8s.io/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Conditionally copy Helm and Helmfile if they exist locally
# We include daemon.json so the COPY command doesn't fail if helm/helmfile are missing
COPY daemon.json helm* helmfile* /tmp/

# Install Helm and Helmfile (use local copies if available, otherwise download)
ARG HELM_VERSION
ARG HELMFILE_VERSION
RUN if [ -f /tmp/helm ]; then \
    mv /tmp/helm /usr/local/bin/helm; \
    else \
    echo "Downloading Helm ${HELM_VERSION}..." && \
    curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm; \
    fi && \
    if [ -f /tmp/helmfile ]; then \
    mv /tmp/helmfile /usr/local/bin/helmfile; \
    else \
    echo "Downloading Helmfile ${HELMFILE_VERSION}..." && \
    curl -sSL "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/helmfile /usr/local/bin/helmfile; \
    fi && \
    chmod +x /usr/local/bin/helm /usr/local/bin/helmfile && \
    rm -rf /tmp/*

# Add Docker daemon config (insecure registry, experimental features)
COPY daemon.json /etc/docker/daemon.json

# Add BuildKit config (force http + insecure registry for buildx)
COPY buildkitd.toml /etc/buildkitd.toml

# Set environment defaults for buildx
ENV DOCKER_BUILDKIT=1 \
    DOCKER_CLI_EXPERIMENTAL=enabled \
    REGISTRY=registry.kube-system.svc.cluster.local:80/
RUN unset DOCKER_HOST

# Optional: pre-create a default buildx builder with our config
# (will be reused inside the container)
RUN docker buildx create --name mybuilder \
    --driver docker-container \
    --driver-opt network=host \
    --use \
    --buildkitd-config /etc/buildkitd.toml || true

