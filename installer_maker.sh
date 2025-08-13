#!/bin/bash
set -e

cd "$HOME"
echo "📂 Working directory: $PWD"

if [ -f install.sh ]; then
    echo "✅ install.sh found, running..."
    ./install.sh
else
    echo "⬇️ Downloading install.sh..."
    curl -fsSL https://raw.githubusercontent.com/ahmad9059/Scripts/main/install.sh -o install.sh
    chmod +x install.sh
    ./install.sh
fi


