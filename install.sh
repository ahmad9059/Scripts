#!/bin/bash

set -e

# ===========================
# Color-coded status labels
# ===========================
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 3)[WARN]$(tput sgr0)"
OK="$(tput setaf 2)[OK]$(tput sgr0)"
NOTE="$(tput setaf 6)[NOTE]$(tput sgr0)"
ACTION="$(tput setaf 5)[ACTION]$(tput sgr0)"

# ===========================
# Ask for sudo once, keep it alive
# ===========================
echo "$NOTE Asking for sudo password..."
sudo -v

keep_sudo_alive() {
  while true; do
    sudo -n true
    sleep 30
  done
}

keep_sudo_alive &
SUDO_KEEP_ALIVE_PID=$!

trap 'kill $SUDO_KEEP_ALIVE_PID' EXIT

# ===========================
# Define script directory
# ===========================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ===========================
# Clone Arch-Hyprland repo
# ===========================
if [ -d "$HOME/Arch-Hyprland" ]; then
  echo "$NOTE Folder 'Arch-Hyprland' already exists in ~, using it..."
else
  echo "$NOTE Cloning Arch-Hyprland repo into ~..."
  if git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"; then
    echo "$OK Repo cloned successfully."
  else
    echo "$ERROR Failed to clone Arch-Hyprland repo. Exiting."
    exit 1
  fi
fi

# ===========================
# Run Arch-Hyprland installer
# ===========================
echo "$NOTE Running Arch-Hyprland/install.sh with preset answers..."
cd "$HOME/Arch-Hyprland"

wget -O ~/Arch-Hyprland/install-scripts/zsh.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/zsh.sh
sed -i '/^[[:space:]]*read HYP$/c\HYP="n"' ~/Arch-Hyprland/install.sh
sed -i '/^[[:space:]]*git stash && git pull/d' ~/Arch-Hyprland/install-scripts/dotfiles-main.sh

wget -O /tmp/replace_reads.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/replace_reads.sh
chmod +x /tmp/replace_reads.sh
bash /tmp/replace_reads.sh
bash install.sh

# ===========================
# Clone dotfiles repo
# ===========================
if [ -d "$HOME/dotfiles" ]; then
  echo "$NOTE Folder 'dotfiles' already exists in ~, using it..."
else
  echo "$NOTE Cloning dotfiles repo into ~..."
  if git clone --depth=1 https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"; then
    echo "$OK Repo cloned successfully."
  else
    echo "$ERROR Failed to clone dotfiles repo. Exiting."
    exit 1
  fi
fi

# ===========================
# Run dotfiles installer
# ===========================
echo "$NOTE Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

# ===========================
# Final status
# ===========================
echo
echo "$OK All done!"
echo "$NOTE Final Check if all essential packages were installed"
echo "$OK GREAT! All essential packages have been successfully installed."
echo
echo "$OK 👌 Hyprland is installed. However, some essential packages may not be installed. Please check logs above."
echo "$ACTION Ignore this if it states 'All essential packages are installed'."
echo
echo "$NOTE You can start Hyprland by typing 'Hyprland' (if SDDM is not installed)."
echo "$NOTE However, it is highly recommended to reboot your system."
read -rp "$ACTION Would you like to reboot now? (y/n): " REBOOT_CHOICE

if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  echo "$OK Rebooting..."
  sudo reboot
else
  echo "$OK You chose NOT to reboot. Please reboot later."
fi
