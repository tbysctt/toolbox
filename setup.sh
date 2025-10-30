#!/bin/ash
set -eux -o pipefail

# Install dependencies
apk add --no-cache \
    bash ca-certificates curl wget git \
    zsh tmux less ripgrep fd fzf grep \
    jq yq unzip gcc musl-dev python3 \
    iputils bind-tools net-tools procps \
    strace tcpdump traceroute luarocks stow tzdata

# Git identity defaults
git config --global user.name "Debug User"
git config --global user.email "user@host.tld"
git config --global init.defaultBranch main

# Clone dotfiles and stow them
git clone https://github.com/tbysctt/dotfiles ~/dotfiles
cd ~/dotfiles && stow zsh vim lazyvim tmux lf

# Install OhMyZsh and plugins
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install Neovim
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
tar -xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 /opt/nvim
ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz
nvim --headless "+Lazy! sync" +qa || true

# Install kubectl
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c -
install -m755 kubectl /usr/local/bin/
rm kubectl kubectl.sha256

# Install Lazygit
LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install -Dm755 lazygit /usr/local/bin/lazygit
rm lazygit.tar.gz lazygit

