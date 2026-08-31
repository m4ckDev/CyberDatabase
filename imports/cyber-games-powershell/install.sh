#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/m4ckDev/cyber-games-powershell.git"
GAME_DIR="$HOME/cyber-games-powershell"

echo "===================================="
echo " CYBERSHELL INSTALLER"
echo "===================================="

if ! command -v git >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y git
fi

if ! command -v pwsh >/dev/null 2>&1; then
    sudo snap install powershell --classic
fi

if [ ! -d "$GAME_DIR" ]; then
    git clone "$REPO_URL" "$GAME_DIR"
else
    cd "$GAME_DIR"
    git pull
fi

sudo tee /usr/local/bin/cybergame > /dev/null <<'CMDEOF'
#!/usr/bin/env bash

set -e

GAME_DIR="$HOME/cyber-games-powershell"
REPO_URL="https://github.com/m4ckDev/cyber-games-powershell.git"
GAME_FILE="./Start-CyberShell.ps1"

if ! command -v git >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y git
fi

if ! command -v pwsh >/dev/null 2>&1; then
    sudo snap install powershell --classic
fi

if [ ! -d "$GAME_DIR" ]; then
    git clone "$REPO_URL" "$GAME_DIR"
else
    cd "$GAME_DIR"
    git pull
fi

cd "$GAME_DIR"

if [ ! -f "$GAME_FILE" ]; then
    echo "ERROR: Could not find $GAME_FILE"
    exit 1
fi

pwsh -NoProfile -ExecutionPolicy Bypass -File "$GAME_FILE"
CMDEOF

sudo chmod +x /usr/local/bin/cybergame

echo "Install complete."
echo "Run the game with: cybergame"
