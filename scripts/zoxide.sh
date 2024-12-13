#!/bin/bash
set -e

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init bash)"' >> "~/.bashrc"
echo '/home/miron/.local/bin' >> "~/.basrc"
