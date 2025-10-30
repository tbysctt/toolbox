# Debugging Toolbox

A comprehensive debugging and development container image packed with essential tools for troubleshooting, development, and system administration tasks.

This image is based on Alpine to keep the size small and includes [my dotfiles](https://github.com/tbysctt/dotfiles) to configure the built-in tools.

> Note: It only supports x86 for now. ARM support will come later :)

## Quick Start

```sh
# Pull the latest image
docker pull ghcr.io/tbysctt/toolbox:latest

# Run interactively
docker run --rm -it ghcr.io/tbysctt/toolbox:latest

# Run with host network access (useful for network debugging)
docker run --rm -it --network host ghcr.io/tbysctt/toolbox:latest

# Mount current directory for file operations
docker run --rm -it -v $(pwd):/workspace -w /workspace ghcr.io/tbysctt/toolbox:latest
```

## Common Use Cases

### Kubernetes Debugging
```sh
# Connect to a cluster and debug
docker run --rm -it -v ~/.kube:/root/.kube ghcr.io/tbysctt/toolbox:latest
k get pods  # kubectl is aliased to 'k'
```

### Network Troubleshooting
```sh
# Run with host network for network debugging
docker run --rm -it --network host ghcr.io/tbysctt/toolbox:latest
ping google.com
traceroute 8.8.8.8
tcpdump -i eth0
```

### File Analysis & Processing
```sh
# Mount directory and analyze files
docker run --rm -it -v /path/to/files:/data ghcr.io/tbysctt/toolbox:latest
cd /data
rg "pattern" .          # Search with ripgrep
fd "*.json" . | head    # Find JSON files
cat file.json | jq '.'  # Pretty print JSON
```

### Development Environment
```sh
# Use as a development container
docker run --rm -it -v $(pwd):/workspace -w /workspace ghcr.io/tbysctt/toolbox:latest
nvim file.py
git status
lazygit
```

## Advanced Usage

### With Docker Socket Access
```sh
# For Docker-in-Docker scenarios
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/tbysctt/toolbox:latest
dive image:tag  # Analyze Docker images
```

### Persistent Configuration
```sh
# Mount your dotfiles for persistent configuration
docker run --rm -it \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.kube:/root/.kube:ro \
  ghcr.io/tbysctt/toolbox:latest
```

### As a Sidecar Container
```yaml
# In Kubernetes
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: debug-toolbox
    image: ghcr.io/tbysctt/toolbox:latest
    command: ["sleep", "infinity"]
    # Then: kubectl exec -it pod-name -c debug-toolbox -- zsh
```

## Image Development

To build, run and test locally:

```sh
git clone https://github.com/tbysctt/toolbox.git
cd toolbox
docker build -t tobystoolbox:latest --platform=linux/amd64 .
docker run --rm -it tobystoolbox:latest
```
