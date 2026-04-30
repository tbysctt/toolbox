#!/bin/ash

set -eux -o pipefail

TARGETARCH="${TARGETARCH:-}"
if [ -z "$TARGETARCH" ]; then
  case "$(uname -m)" in
    x86_64) TARGETARCH=amd64 ;;
    aarch64) TARGETARCH=arm64 ;;
    *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
  esac
fi
case "$TARGETARCH" in
  amd64|arm64) ;;
  *) echo "unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;;
esac

# Install dependencies
apk add --no-cache \
  bash ca-certificates curl wget git \
  zsh tmux less ripgrep fd fzf grep \
  jq yq unzip gcc musl-dev python3 \
  iputils bind-tools net-tools procps \
  strace tcpdump traceroute luarocks stow tzdata zsh-vcs neovim shadow fastfetch

# Git identity defaults
git config --global user.name "Debug User"
git config --global user.email "user@host.tld"
git config --global init.defaultBranch main

# Clone dotfiles and stow them
git clone https://github.com/tbysctt/dotfiles ~/dotfiles
cd ~/dotfiles && stow zsh vim lazyvim tmux lf

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search

# Install Neovim
# curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
# tar -xzf nvim-linux-x86_64.tar.gz
# mv nvim-linux-x86_64 /opt/nvim
# ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
# rm nvim-linux-x86_64.tar.gz

# Install kubectl
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c -
install -m755 kubectl /usr/local/bin/
rm kubectl kubectl.sha256

# Install Lazygit
LAZYGIT_ARCHIVE=
case "${TARGETARCH}" in
  amd64) LAZYGIT_ARCHIVE=Linux_x86_64 ;;
  arm64) LAZYGIT_ARCHIVE=Linux_arm64 ;;
esac
LAZYGIT_JSON=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest)
LAZYGIT_TAG=$(printf '%s\n' "${LAZYGIT_JSON}" | jq -r '.tag_name')
LAZYGIT_VERSION="${LAZYGIT_TAG#v}"
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_TAG}/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCHIVE}.tar.gz"
tar xf lazygit.tar.gz lazygit
install -Dm755 lazygit /usr/local/bin/lazygit
rm lazygit.tar.gz lazygit

# Headlessly sync all lazy.nvim plugins
nvim --headless "+Lazy! sync" +qa || true

# Use ZSH as the default shell
chsh -s /bin/zsh root
