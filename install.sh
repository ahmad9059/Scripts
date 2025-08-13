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
REPO_DIR="$HOME/Arch-Hyprland/Hyprland-Dots"

if [ -d "$REPO_DIR/.git" ]; then
  echo "📂 Repo already exists at $REPO_DIR, updating..."
  cd "$REPO_DIR" || exit 1
  git pull --ff-only || {
    echo "❌ Failed to update repo."
    exit 1
  }
else
  echo "⬇️ Cloning Hyprland-Dots repo into $REPO_DIR..."
  git clone --depth=1 https://github.com/JaKooLit/Hyprland-Dots "$REPO_DIR" || {
    echo "❌ Failed to clone repo. Exiting."
    exit 1
  }
fi

echo "✅ Repo ready."
# =========================
# 2️⃣ Variables to replace in copy.sh
# =========================
TARGET_FILE="$HOME/Arch-Hyprland/Hyprland-Dots/copy.sh"

if [ ! -f "$TARGET_FILE" ]; then
  echo "❌ $TARGET_FILE not found!"
  exit 1
fi

chmod +w "$TARGET_FILE"

keyboard_layout="y"
EDITOR_CHOICE="y"
res_choice=1
answer="y"
border_choice="y"
SDDM_WALL="y"
WALL="y"

sed -i \
  -e "s/^[[:space:]]*read keyboard_layout.*/keyboard_layout=\"$keyboard_layout\"/" \
  -e "s/^[[:space:]]*read EDITOR_CHOICE.*/EDITOR_CHOICE=\"$EDITOR_CHOICE\"/" \
  -e "s/^[[:space:]]*read res_choice.*/res_choice=$res_choice/" \
  -e "s/^[[:space:]]*read answer.*/answer=\"$answer\"/" \
  -e "s/^[[:space:]]*read border_choice.*/border_choice=\"$border_choice\"/" \
  -e "s/^[[:space:]]*read SDDM_WALL.*/SDDM_WALL=\"$SDDM_WALL\"/" \
  -e "s/^[[:space:]]*read WALL.*/WALL=\"$WALL\"/" \
  "$TARGET_FILE"

echo "✅ Substitutions completed successfully in $TARGET_FILE"
cat "$TARGET_FILE"
echo "Press any key to continue..."
read -n1 -s key
echo "You pressed: $key"

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
