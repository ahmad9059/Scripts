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
RESET="$(tput sgr0)"

# ===========================
# Run Arch-Hyprland installer
# ===========================
LOG_FILE="$HOME/boot_file.log"

# ===========================
# Ask for sudo once, keep it alive
# ===========================
echo "${NOTE} Asking for sudo password...${RESET}"
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
  echo "${NOTE} Folder 'Arch-Hyprland' already exists in HOME, using it...${RESET}"
else
  echo "${NOTE} Cloning Arch-Hyprland repo into HOME...${RESET}"
  if git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland" >>"$LOG_FILE" 2>&1; then
    echo "${OK} Repo cloned successfully.${RESET}"
  else
    echo "${ERROR} Failed to clone Arch-Hyprland repo. Exiting.${RESET}"
    exit 1
  fi
fi

# ===========================
# Run Arch-Hyprland installer
# ===========================
echo "${NOTE} Running Arch-Hyprland/install.sh with preset answers...${RESET}"
cd "$HOME/Arch-Hyprland"

wget -q -O ~/Arch-Hyprland/install-scripts/zsh.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/zsh.sh
sed -i '/^[[:space:]]*read HYP$/c\HYP="n"' ~/Arch-Hyprland/install.sh
wget -q -O /tmp/replace_reads.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/replace_reads.sh
chmod +x /tmp/replace_reads.sh
bash /tmp/replace_reads.sh
chmod +x install.sh
bash install.sh
echo "${OK} Arch-Hyprland script Installed!${RESET}"

# ===========================
# dotfile banner Banner
# ===========================

echo -e "\033[1;31m     _       _    __ _ _             ___           _        _ _           \033[0m"
echo -e "\033[1;32m  __| | ___ | |_ / _(_) | ___  ___  |_ _|_ __  ___| |_ __ _| | | ___ _ __ \033[0m"
echo -e "\033[1;33m / _\` |/ _ \| __| |_| | |/ _ \/ __|  | || '_ \/ __| __/ _\` | | |/ _ \ '__|\033[0m"
echo -e "\033[1;34m| (_| | (_) | |_|  _| | |  __/\__ \  | || | | \__ \ || (_| | | |  __/ |   \033[0m"
echo -e "\033[1;35m \__,_|\___/ \__|_| |_|_|\___||___/ |___|_| |_|___/\__\__,_|_|_|\___|_|   \033[0m"

# ===========================
# Clone dotfiles repo
# ===========================
if [ -d "$HOME/dotfiles" ]; then
  echo "${NOTE} Folder 'dotfiles' already exists in HOME, using it...${RESET}"
else
  echo "${NOTE} Cloning dotfiles repo into ~...${RESET}"
  if git clone --depth=1 https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles" >>"$LOG_FILE" 2>&1; then
    echo "${OK} Repo cloned successfully.${RESET}"
  else
    echo "${ERROR} Failed to clone dotfiles repo. Exiting.${RESET}"
    exit 1
  fi
fi

# ===========================
# Run dotfiles installer
# ===========================
echo "${NOTE} Running dotfiles/install.sh with preset answers...${RESET}"
cd "$HOME/dotfiles"
chmod +x dotfile_installer.sh
bash dotfile_installer.sh

# ===========================
# Check for Reboot
# ===========================

if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  echo "$OK Rebooting..."
  sudo reboot
else
  echo "${OK} You chose NOT to reboot. Please reboot later.${RESET}"
fi
