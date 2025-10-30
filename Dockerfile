FROM debian:12.11-slim

SHELL ["/bin/bash", "-c"]

RUN <<EOF
set -eux -o pipefail
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    stow \
    zsh \
    curl wget \
    fzf grep ripgrep fd-find luarocks \
    iputils-ping \
    jq yq unzip tmux \
    gcc python3 \
    less \
    net-tools \
    procps \
    strace \
    tcpdump \
    traceroute \
    dnsutils
apt clean && rm -rf /var/lib/apt/lists/*

git clone https://github.com/tbysctt/dotfiles ~/dotfiles
stow zsh vim lazyvim tmux lf

git config --global user.name "Debug User"
git config --global user.email "user@host.tld"
git config --global init.defaultBranch main

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
chmod +x kubectl
mv kubectl /usr/local/bin/
rm kubectl.sha256

NEOVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -LO "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz"
tar -xzf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 /opt/nvim
ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz
nvim --headless "+Lazy! sync" +qa

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit -D -t /usr/local/bin/
rm -rf lazygit.tar.gz lazygit

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

EOF

WORKDIR /root

ENTRYPOINT ["zsh"]
