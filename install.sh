#!/bin/bash


set -e

# Ask for sudo once, keep it alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



# Get the current username
USER_NAME=$(whoami)

# Temporary sudoers line
SUDO_LINE="$USER_NAME ALL=(ALL) NOPASSWD: /usr/bin/chsh # TEMP-CHSH-ALLOW"

# Function to clean up sudoers on exit
cleanup_sudoers() {
    echo "Cleaning up temporary sudoers entry..."
    sudo sed -i "\|$SUDO_LINE|d" /etc/sudoers
}
trap cleanup_sudoers EXIT

# Add temporary sudoers entry if not already present
if ! sudo grep -qF "$SUDO_LINE" /etc/sudoers; then
    echo "Adding temporary sudoers entry for $USER_NAME..."
    echo "$SUDO_LINE" | sudo tee -a /etc/sudoers >/dev/null
fi

# Directory where this script (and presets) live
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone Arch-Hyprland repo into $HOME if missing
if [ ! -d "$HOME/Arch-Hyprland" ]; then
    git clone https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"
fi
echo "Running Arch-Hyprland/install.sh with preset answers..."
cd "$HOME/Arch-Hyprland"
wget -O ~/Arch-Hyprland/install-scripts/zsh.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/zsh.sh
bash install.sh

# Clone dotfiles repo into $HOME if missing
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

echo "✅ All done!"
