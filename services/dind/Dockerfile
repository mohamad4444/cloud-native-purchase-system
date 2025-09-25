FROM docker:28.4.0-dind

# Install base tools (curl, bash, git, etc.)
RUN apk add --no-cache bash curl git

# Install kubectl (latest stable)
RUN curl -sSL "https://dl.k8s.io/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

# Copy pre-downloaded Helm and Helmfile binaries from local build context
COPY helm /usr/local/bin/helm
COPY helmfile /usr/local/bin/helmfile

# Ensure they are executable
RUN chmod +x /usr/local/bin/helm /usr/local/bin/helmfile

# Add Docker daemon config (insecure registry, experimental features)
COPY daemon.json /etc/docker/daemon.json

# Add BuildKit config (force http + insecure registry for buildx)
COPY buildkitd.toml /etc/buildkitd.toml

# Set environment defaults for buildx
ENV DOCKER_BUILDKIT=1 \
    DOCKER_CLI_EXPERIMENTAL=enabled \
    REGISTRY=registry.kube-system.svc.cluster.local:80/ \
    DOCKER_HOST=unix:///var/run/docker.sock

# Optional: pre-create a default buildx builder with our config
# (will be reused inside the container)
RUN docker buildx create --name mybuilder \
    --driver docker-container \
    --driver-opt network=host \
    --use \
    --buildkitd-config /etc/buildkitd.toml || true


ENTRYPOINT ["sh", "-c", "dockerd --host=unix:///var/run/docker.sock & sleep 3; exec bash"]
CMD []
