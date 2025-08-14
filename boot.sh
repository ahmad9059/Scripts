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
# Clone Arch-Hyprland repo
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
    echo "${ERROR} Failed to clone Arch-Hyprland repo. Check $LOG_FILE for details.${RESET}"
    exit 1
  fi
fi

# ===========================
# Run Arch-Hyprland installer
# ===========================
echo "${NOTE} Running Arch-Hyprland/install.sh with preset answers...${RESET}"
cd "$HOME/Arch-Hyprland"
# Download zsh.sh silently
if wget -q -O install-scripts/zsh.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/zsh.sh >>"$LOG_FILE" 2>&1; then
  echo "${OK} zsh.sh downloaded.${RESET}"
else
  echo "${ERROR} Failed to download zsh.sh. Check $LOG_FILE.${RESET}"
  exit 1
fi
# Modify install.sh preset
if sed -i '/^[[:space:]]*read HYP$/c\HYP="n"' install.sh >>"$LOG_FILE" 2>&1; then
  echo "${OK} Modified install.sh preset for HYP=n.${RESET}"
else
  echo "${ERROR} Failed to modify install.sh. Check $LOG_FILE.${RESET}"
  exit 1
fi
# Download and run replace_reads.sh silently
if wget -q -O /tmp/replace_reads.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/replace_reads.sh >>"$LOG_FILE" 2>&1; then
  chmod +x /tmp/replace_reads.sh
  if bash /tmp/replace_reads.sh >>"$LOG_FILE" 2>&1; then
    echo "${OK} replace_reads.sh executed successfully.${RESET}"
  else
    echo "${ERROR} replace_reads.sh execution failed. Check $LOG_FILE.${RESET}"
    exit 1
  fi
else
  echo "${ERROR} Failed to download replace_reads.sh. Check $LOG_FILE.${RESET}"
  exit 1
fi
# Ensure install.sh is executable and run it silently
chmod +x install.sh
if bash install.sh >>"$LOG_FILE" 2>&1; then
  echo "${OK} Arch-Hyprland installation completed.${RESET}"
else
  echo "${ERROR} Arch-Hyprland installation failed. Check $LOG_FILE.${RESET}"
  exit 1
fi

# ===========================
# Clone dotfiles repo
# ===========================
if [ -d "$HOME/dotfiles" ]; then
  echo "${NOTE} Folder 'dotfiles' already exists in ~, using it...${RESET}" >>"$LOG_FILE" 2>&1
else
  echo "${NOTE} Cloning dotfiles repo into ~...${RESET}" >>"$LOG_FILE" 2>&1
  if git clone --depth=1 https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles" >>"$LOG_FILE" 2>&1; then
    echo "${OK} Repo cloned successfully.${RESET}" >>"$LOG_FILE" 2>&1
  else
    echo "${ERROR} Failed to clone dotfiles repo. Exiting.${RESET}" >>"$LOG_FILE" 2>&1
    exit 1
  fi
fi

# ===========================
# Run dotfiles installer
# ===========================
echo "${NOTE} Running dotfiles/dotfile_installer.sh with preset answers...${RESET}" >>"$LOG_FILE" 2>&1
cd "$HOME/dotfiles" >>"$LOG_FILE" 2>&1
chmod +x dotfile_installer.sh >>"$LOG_FILE" 2>&1
bash dotfile_installer.sh >>"$LOG_FILE" 2>&1

# ===========================
# Check for Reboot
# ===========================

if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  echo "$OK Rebooting..."
  sudo reboot
else
  echo "${OK} You chose NOT to reboot. Please reboot later.${RESET}"
fi
