  package_name="keymapper-4.8.2-Linux.deb"
  curl -LO "https://github.com/houmain/keymapper/releases/download/4.8.2/$package_name"
  sudo dpkg -i "$package_name"
  sudo systemctl enable keymapperd
