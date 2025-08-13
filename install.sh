#!/bin/bash

set -e

# Ask for sudo once, keep it alive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Directory where this script (and presets) live
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone Arch-Hyprland repo into $HOME if missing
if [ ! -d "$HOME/Arch-Hyprland" ]; then
  git clone https://github.com/JaKooLit/Arch-Hyprland.git "$HOME/Arch-Hyprland"
fi
echo "Running Arch-Hyprland/install.sh with preset answers..."
cd "$HOME/Arch-Hyprland"
wget -O ~/Arch-Hyprland/install-scripts/zsh.sh https://raw.githubusercontent.com/ahmad9059/Scripts/main/zsh.sh
sed -i '/^[[:space:]]*read HYP$/c\HYP="n"' ~/Arch-Hyprland/install.sh
# Download replace_reads.sh
wget -O /home/ahmad/Arch-Hyprland/install-scripts/replace_reads.sh "https://raw.githubusercontent.com/ahmad9059/Scripts/main/replace_reads.sh"
chmod +x /home/ahmad/Arch-Hyprland/install-scripts/replace_reads.sh
echo "✅ replace_reads.sh downloaded and made executable."

# Insert command to run replace_reads.sh after line 27
sed -i '27a /home/ahmad/Arch-Hyprland/install-scripts/replace_reads.sh' /home/ahmad/Arch-Hyprland/install-scripts/dotfiles-main.sh

# Insert command to run replace_reads.sh after line 32
sed -i '32a /home/ahmad/Arch-Hyprland/install-scripts/replace_reads.sh' /home/ahmad/Arch-Hyprland/install-scripts/dotfiles-main.sh

echo "✅ replace_reads.sh run commands added in dotfiles-main.sh"
bash install.sh

# Clone dotfiles repo into $HOME if missing
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

echo "✅ All done!"
