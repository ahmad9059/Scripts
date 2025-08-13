#!/bin/bash

set -e

cd "$HOME"

if [ -f install.sh ]; then
    echo "✅ install.sh found, running..."
else
    echo "⬇️ Downloading install.sh..."
    curl -fsSL https://raw.githubusercontent.com/ahmad9059/Scripts/main/install.sh -o install.sh
    chmod +x install.sh
fi
