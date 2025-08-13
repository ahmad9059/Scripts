#!/bin/bash
set -e

# Ask for sudo once, keep it alive
sudo -v

# Keep sudo alive for 2 hours (refresh every 60 seconds)
# This loop will end automatically when the script finishes
(
    end=$((SECONDS + 7200)) # 7200 seconds = 2 hours
    while [ $SECONDS -lt $end ]; do
        sudo -n true
        sleep 60
    done
) 2>/dev/null &


# Directory where this script (and presets) live
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone Arch-Hyprland repo into $HOME if missing
if [ ! -d "$HOME/Arch-Hyprland" ]; then
    git clone https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"
fi
echo "Running Arch-Hyprland/install.sh with preset answers..."
cd "$HOME/Arch-Hyprland"
cat "$SCRIPT_DIR/preset_config.sh" | bash install.sh

# Clone dotfiles repo into $HOME if missing
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
cat "$SCRIPT_DIR/preset_dotfile.sh" | bash install.sh

echo "✅ All done!"
