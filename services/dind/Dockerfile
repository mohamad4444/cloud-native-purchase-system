FROM docker:28.4.0-dind

# Install base tools (curl, bash, git, etc.)
RUN apk add --no-cache bash curl git

# Install kubectl (latest stable)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Copy pre-downloaded Helm and Helmfile binaries from local build context
COPY helm /usr/local/bin/helm
COPY helmfile /usr/local/bin/helmfile

# Ensure they are executable
RUN chmod +x /usr/local/bin/helm /usr/local/bin/helmfile