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
# --------------- #
# =========================
# 1️⃣ Clone the Hyprland-Dots repo
# =========================
echo "Cloning Hyprland-Dots repo into ~/Arch-Hyprland..."
git clone --depth=1 https://github.com/JaKooLit/Hyprland-Dots ~/Arch-Hyprland/Hyprland-Dots
if [ $? -ne 0 ]; then
  echo "❌ Failed to clone repo. Exiting."
  exit 1
fi
echo "✅ Repo cloned successfully."

# =========================
# 2️⃣ Variables to replace in copy.sh
# =========================
TARGET_FILE=~/Arch-Hyprland/Hyprland-Dots/copy.sh

keyboard_layout="y"
EDITOR_CHOICE="y"
res_choice=1
answer="y"
border_choice="y"
SDDM_WALL="y"
WALL="y"

# =========================
# 3️⃣ Perform substitutions
# =========================
sed -i \
  -e "s/^[[:space:]]*read keyboard_layout$/keyboard_layout=\"$keyboard_layout\"/" \
  -e "s/^[[:space:]]*read EDITOR_CHOICE$/EDITOR_CHOICE=\"$EDITOR_CHOICE\"/" \
  -e "s/^[[:space:]]*read res_choice$/res_choice=$res_choice/" \
  -e "s/^[[:space:]]*read answer$/answer=\"$answer\"/" \
  -e "s/^[[:space:]]*read border_choice$/border_choice=\"$border_choice\"/" \
  -e "s/^[[:space:]]*read SDDM_WALL$/SDDM_WALL=\"$SDDM_WALL\"/" \
  -e "s/^[[:space:]]*read WALL$/WALL=\"$WALL\"/" \
  "$TARGET_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Failed to perform substitutions in $TARGET_FILE"
  exit 1
fi

echo "✅ Substitutions completed successfully in $TARGET_FILE"

# ------------------- #

bash install.sh

# Clone dotfiles repo into $HOME if missing
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

echo "✅ All done!"
