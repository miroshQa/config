#!/bin/bash
set -e

git clone https://github.com/miroshQa/nvim.git
ln -s "$(pwd)/nvim" "~/.config/"
curl -# -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
sudo tar -C /opt -xzf "nvim-linux64.tar.gz"
sudo apt install -y xclip
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> "~/.bashrc"
echo 'export MANPAGER="nvim +Man!"' >> "~/.bashrc"
