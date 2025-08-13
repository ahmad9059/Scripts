#!/bin/bash

# =========================
# Variables to replace
# =========================
TARGET_FILE=~/Arch-Hyprland/Hyprland-Dots/copy.sh

keyboard_layout="y"
EDITOR_CHOICE="y"
res_choice=1
answer="y"
border_choice="y"
SDDM_WALL="y"
WALL="n"

# =========================
# Perform substitutions
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

echo "✅ Substitutions completed in $TARGET_FILE"
