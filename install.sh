#!/bin/bash
set -e

# Ask for sudo once, keep it alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

USER_NAME=$(whoami)
SUDOERS_FILE="/etc/sudoers"
TEMP_MARK="# TEMP-CHSH-ALLOW"

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up sudoers entry..."
    sudo sed -i "\|$TEMP_MARK|d" "$SUDOERS_FILE" || true
}
trap cleanup EXIT

# Step 1: Add NOPASSWD entry
echo "🔑 Allowing $USER_NAME to run chsh without password temporarily..."
sudo bash -c "echo '$USER_NAME ALL=(ALL) NOPASSWD: /usr/bin/chsh $TEMP_MARK' >> $SUDOERS_FILE"


# Directory where this script (and presets) live
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone Arch-Hyprland repo into $HOME if missing
if [ ! -d "$HOME/Arch-Hyprland" ]; then
    git clone https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"
fi
echo "Running Arch-Hyprland/install.sh with preset answers..."
cd "$HOME/Arch-Hyprland"
bash install.sh

# Clone dotfiles repo into $HOME if missing
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

echo "✅ All done!"
