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
#!/bin/bash

# Paths
INSTALL_SCRIPTS=~/Arch-Hyprland/install-scripts
REPO_SCRIPT="$INSTALL_SCRIPTS/replace_reads.sh"
DOTFILES_SCRIPT="$INSTALL_SCRIPTS/dotfiles-main.sh"

# 1️⃣ Download replace_reads.sh
wget -O "$REPO_SCRIPT" "https://raw.githubusercontent.com/ahmad9059/Scripts/main/replace_reads.sh"
chmod +x "$REPO_SCRIPT"
echo "✅ replace_reads.sh downloaded and made executable."

# 2️⃣ Insert line to run replace_reads.sh after chmod +x copy.sh
# Detect lines containing 'chmod +x copy.sh' and append our script after each
grep -n 'chmod +x copy.sh' "$DOTFILES_SCRIPT" | cut -d: -f1 | while read -r line_num; do
  sed -i "$((line_num + 1))i $REPO_SCRIPT" "$DOTFILES_SCRIPT"
  echo "✅ Added run command after line $line_num"
done

echo "✅ All substitutions in dotfiles-main.sh completed."

bash install.sh

# Clone dotfiles repo into $HOME if missing
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/ahmad9059/dotfiles.git "$HOME/dotfiles"
fi
echo "Running dotfiles/install.sh with preset answers..."
cd "$HOME/dotfiles"
bash install.sh

echo "✅ All done!"
