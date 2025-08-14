#!/bin/bash

# =========================
# 1️⃣ Clone the Hyprland-Dots repo
# =========================
REPO_DIR="$HOME/Arch-Hyprland/Hyprland-Dots"

if [ -d "$REPO_DIR/.git" ]; then
  echo "📂 Repo already exists at $REPO_DIR, using existing copy..."
  cd "$REPO_DIR" || {
    echo "❌ Failed to access $REPO_DIR."
    exit 1
  }
  git pull --ff-only || {
    echo "❌ Failed to update repo."
    exit 1
  }
else
  echo "⬇️ Cloning Hyprland-Dots repo into $REPO_DIR..."
  if git clone --depth=1 https://github.com/JaKooLit/Hyprland-Dots "$REPO_DIR"; then
    echo "✅ Repo cloned successfully."
  else
    echo "❌ Failed to clone repo. Exiting."
    exit 1
  fi
fi
# =========================
# 2️⃣ Variables to replace in copy.sh
# =========================
TARGET_FILE="$HOME/$REPO_DIR/copy.sh"

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
