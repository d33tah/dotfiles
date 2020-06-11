#!/bin/bash

set -euo pipefail

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

mkdir -pv ~/.config/nvim
ln -sv  ~/.vim/autoload ~/.config/nvim/autoload
ln -sv  ~/.vimrc ~/.config/nvim/init.vim

pip3 install \
    flake8 \
    python-language-server \
    pyls-mypy \
    --user

cargo install fd-find
cargo install ripgrep
