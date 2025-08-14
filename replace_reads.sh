#!/bin/bash

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
TARGET_FILE="$HOME/Arch-Hyprland/Hyprland-Dots/copy.sh"

if [ ! -f "$TARGET_FILE" ]; then
  echo "❌ $TARGET_FILE not found!"
  exit 1
fi

keyboard_layout="y"
EDITOR_CHOICE="y"
res_choice=1
answer="y"
border_choice="y"
SDDM_WALL="y"
WALL="n"

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
nvim "$TARGET_FILE"
