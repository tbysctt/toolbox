#!/bin/ash

set -eux -o pipefail

# Install dependencies
apk add --no-cache \
  bash ca-certificates curl wget git \
  zsh tmux less ripgrep fd fzf grep \
  jq yq unzip gcc musl-dev python3 \
  nodejs npm kubectl iputils bind-tools net-tools procps \
  strace tcpdump traceroute stow tzdata zsh-vcs shadow fastfetch yazi \
  neovim tree-sitter tree-sitter-cli luarocks go gopls ruff # Needed for Neovim

# yaml-language-server is only in Alpine edge/testing; install via NPM
npm install -g yaml-language-server typescript

# Git identity defaults
git config --global user.name "Debug User"
git config --global user.email "user@host.tld"
git config --global init.defaultBranch main

# Clone dotfiles and stow them
git clone https://github.com/tbysctt/dotfiles ~/dotfiles
cd ~/dotfiles && stow zsh vim neovim tmux lf yazi

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search

# Install Lazygit via Go
GOBIN=/usr/local/bin go install github.com/jesseduffield/lazygit@latest

# Use ZSH as the default shell
chsh -s /bin/zsh root
