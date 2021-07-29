#!/bin/bash

set -euo pipefail

apt-get update
apt-get install \
    apt-file \
    curl \
    git \
    libcap2-bin \
    libfuse2 \
    man-db \
    npm \
    nmap \
    postgresql-client-common \
    python3-pip \
    rtorrent \
    screen \
    tmux \
    vim \
    wget \
    zsh \
    -y

# nice to have, not critical
apt-get install \
    cargo \
    strace \
    pv \
    jq \
    -y

#wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O /usr/local/bin/nvim
#chmod +x /usr/local/bin/nvim

wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz -O- | tar zxvf - -C /usr/local --strip=1

apt-file update

# maybe not necessarily a great idea?
setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap

curl https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz | tar zxf - -C /usr/local

npm install -g dockerfile-language-server-nodejs
