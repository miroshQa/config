function prepare_before_installation() {
  # Cd to directory when needed packages will be storred
  installation_dir="~/installation"
  if [ ! -d "$installation_dir" ]; then
    mkdir "$installation_dir"
  fi
  cd "$installation_dir"
}

# Some utiliti functions
function append_if_no_exists() {
  local string="$1"
  grep -qxF "$string" '~/.bashrc' || echo "$string" >> "~/.bashrc"
}

function install_neovim() {
  NVIM_DIR="/opt/nvim-linux64"
  echo "Starting installing neovim..."
  curl -# -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
  sudo rm -rf "$NVIM_DIR"
  sudo tar -C /opt -xzf "nvim-linux64.tar.gz"
  sudo apt install -y xclip
  append_if_no_exists 'export PATH="$PATH:/opt/nvim-linux64/bin"'
  append_if_no_exists  'export MANPAGER="nvim +Man!"'
}

function install_keymapper() {
  package_name="keymapper-4.8.2-Linux.deb"
  curl -LO "https://github.com/houmain/keymapper/releases/download/4.8.2/$package_name"
  sudo dpkg -i "$package_name"
  sudo systemctl enable keymapperd
}

function install_ripgrep() {
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
  sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
}

function install_zoxide() {
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  append_if_no_exists 'eval "$(zoxide init bash)"' 
  append_if_no_exists '/home/miron/.local/bin' ~/.bashrc
}

install_counter=0
function install_if_missing() {
  ((install_counter++))
  local command_name="$1"
  local install_function="${commands[$command_name]}"
  echo "$install_counter. Starting to install $command_name"
  if ! command -v "$command_name" &> /dev/null; then
    "$install_function"
    echo "$command_name"
  else
    echo "$command_name is installed. Skip"
  fi
  printf "\n"
}

function main() {
  ## Main block
  echo "Starting to install essential programms and utilites..."
  prepare_before_installation

  declare -A commands=(
  [nvim]="install_neovim"
  [zoxide]="install_zoxide"
  [keymapper]="install_keymapper"
  [rg]="install_ripgrep"
  )


  # Check and install if missing
  for cmd in "${!commands[@]}"; do
    install_if_missing "$cmd"
  done

}

main
