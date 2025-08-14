#!/bin/bash

set -e

# Ask for sudo once, keep it alive
# Ask for sudo password upfront
sudo -v

# Function to keep sudo alive until this script exits
keep_sudo_alive() {
  while true; do
    sudo -n true
    sleep 30
  done
}

# Start keep-alive in background
keep_sudo_alive &
SUDO_KEEP_ALIVE_PID=$!

# Ensure the keep-alive process stops on exit or Ctrl+C
trap 'kill $SUDO_KEEP_ALIVE_PID' EXIT

# Directory where this script (and presets) live
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone Arch-Hyprland repo into $HOME if missing
if [ -d "$HOME/Arch-Hyprland" ]; then
  echo "📂 Folder 'Arch-Hyprland' already exists in ~, using it..."
else
  echo "⬇️ Cloning Arch-Hyprland repo into ~..."
  if git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"; then
    echo "✅ Repo cloned successfully."
  else
    echo "❌ Failed to clone Arch-Hyprland repo. Exiting."
    exit 1
  fi
fi
echo "Running Arch-Hyprland/install.sh with preset answers..."
cd "$HOME/Arch-Hyprland"
wget -O ~/Arch-Hyprland/install-scripts/zsh.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/zsh.sh
sed -i '/^[[:space:]]*read HYP$/c\HYP="n"' ~/Arch-Hyprland/install.sh
sed -i '/^[[:space:]]*git stash && git pull/d' ~/Arch-Hyprland/install-scripts/dotfiles-main.sh
# Using wget
wget -O /tmp/replace_reads.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/replace_reads.sh
chmod +x /tmp/replace_reads.sh
bash /tmp/replace_reads.sh
bash install.sh

# Clone dotfiles repo into $HOME if missing
# Clone dotfiles repo into $HOME if missing
if [ -d "$HOME/dotfiles" ]; then
  echo "📂 Folder 'dotfiles' already exists in ~, using it..."
else
  echo "⬇️ Cloning dotfiles repo into ~..."
  if git clone --depth=1 https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"; then
    echo "✅ Repo cloned successfully."
  else
    echo "❌ Failed to clone dotfiles repo. Exiting."
    exit 1
  fi
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

echo "✅ All done!"
