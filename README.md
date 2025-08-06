# Debugging Toolbox

A comprehensive debugging and development container image packed with essential tools for troubleshooting, development, and system administration tasks.

- **Base Image**: Debian 12.11 Slim
- **Architecture**: linux/amd64
- **Shell**: Zsh (with Oh My Zsh)
- **Working Directory**: `/root`
- **Entrypoint**: `zsh`

## Quick Start

```sh
# Pull the latest image
docker pull ghcr.io/tobyscott25/toolbox:latest

# Run interactively
docker run --rm -it ghcr.io/tobyscott25/toolbox:latest

# Run with host network access (useful for network debugging)
docker run --rm -it --network host ghcr.io/tobyscott25/toolbox:latest

# Mount current directory for file operations
docker run --rm -it -v $(pwd):/workspace -w /workspace ghcr.io/tobyscott25/toolbox:latest
```

## Included Tools

### Development & Editors
- **nvim** - Neovim (LazyVim distribution)
- **git** - Git VCS
- **lazygit** - Terminal UI for git commands
- **gcc** - GNU C/C++ Compiler
- **python** - Python 3

### Kubernetes & Container Tools
- **kubectl** - Kubernetes command-line tool

### Network & System Debugging
- **curl/wget** - HTTP clients
- **ping** - Network connectivity testing
- **traceroute** - Network path tracing
- **tcpdump** - Network packet analyzer
- **netstat** - Network statistics (via net-tools)
- **dig/nslookup** - DNS lookup tools (via dnsutils)
- **strace** - System call tracer

### File & Text Processing
- **rg** - Ripgrep, fast text search
- **fzf** - Fuzzy finder
- **fd** - Fast file finder
- **jq** - JSON processor
- **yq** - YAML processor
- **grep/less** - Text processing utilities

### Shell & Terminal
- **zsh** ZSH (with Oh My Zsh including auto-suggestions and syntax highlighting plugins)
- **tmux** - Terminal multiplexer

### System Utilities
- **ps/top** - Process utilities (via procps)
- **unzip** - Archive extraction

## Built-in Aliases

- `k` → `kubectl`
- `vim` → `nvim`

## Common Use Cases

### Kubernetes Debugging
```sh
# Connect to a cluster and debug
docker run --rm -it -v ~/.kube:/root/.kube ghcr.io/tobyscott25/toolbox:latest
k get pods  # kubectl is aliased to 'k'
```

### Network Troubleshooting
```sh
# Run with host network for network debugging
docker run --rm -it --network host ghcr.io/tobyscott25/toolbox:latest
ping google.com
traceroute 8.8.8.8
tcpdump -i eth0
```

### File Analysis & Processing
```sh
# Mount directory and analyze files
docker run --rm -it -v /path/to/files:/data ghcr.io/tobyscott25/toolbox:latest
cd /data
rg "pattern" .          # Search with ripgrep
fd "*.json" . | head    # Find JSON files
cat file.json | jq '.'  # Pretty print JSON
```

### Development Environment
```sh
# Use as a development container
docker run --rm -it -v $(pwd):/workspace -w /workspace ghcr.io/tobyscott25/toolbox:latest
nvim file.py
git status
lazygit
```

## Advanced Usage

### With Docker Socket Access
```sh
# For Docker-in-Docker scenarios
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/tobyscott25/toolbox:latest
dive image:tag  # Analyze Docker images
```

### Persistent Configuration
```sh
# Mount your dotfiles for persistent configuration
docker run --rm -it \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.kube:/root/.kube:ro \
  ghcr.io/tobyscott25/toolbox:latest
```

### As a Sidecar Container
```yaml
# In Kubernetes
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: debug-toolbox
    image: ghcr.io/tobyscott25/toolbox:latest
    command: ["sleep", "infinity"]
    # Then: kubectl exec -it pod-name -c debug-toolbox -- zsh
```

## Image Development

To build, run and test locally:

```sh
git clone https://github.com/tobyscott25/toolbox.git
cd toolbox
docker build -t tobystoolbox:latest --platform=linux/amd64 .
docker run --rm -it tobystoolbox:latest
```
