#!/usr/bin/env bash

set -e

echo "Fixing public-test files..."

mkdir -p data engine backups

cat > README.md <<'READMEEOF'
# CyberShell Academy

CyberShell Academy is a terminal-based cyber training RPG that teaches Windows and Linux command-line fundamentals through missions, XP, ranks, daily challenges, boss trials, badges, and anonymous operator profiles.

## Features

- Anonymous local operator profiles
- Saved progress
- Windows Light Path
- Linux Shadow Path
- XP and rank progression
- Locked missions
- Real answer checking
- Placement test
- Boss trials
- Badges
- Daily challenge
- Local leaderboard
- Terminal cyber-style UI

## Install on Ubuntu or Linux

Run these commands:

    git clone https://github.com/m4ckDev/cyber-games-powershell.git
    cd cyber-games-powershell
    chmod +x install.sh
    ./install.sh

Then run the game:

    cybergame

## Manual Run

    pwsh -NoProfile -ExecutionPolicy Bypass -File ./Start-CyberShell.ps1

## Local Save Data

Player data is stored locally and ignored by Git:

    data/profiles.json
    data/leaderboard.json
    data/daily-state.json

## Purpose

This project is designed for safe, beginner-friendly command-line training. It focuses on system administration, Linux fundamentals, Windows fundamentals, and defensive cyber awareness.
READMEEOF

cat > .gitignore <<'GITIGNOREEOF'
# Local player data
data/profiles.json
data/leaderboard.json
data/daily-state.json

# Backups
backups/

# OS junk
.DS_Store
Thumbs.db

# Editor junk
.vscode/
.idea/
GITIGNOREEOF

cat > install.sh <<'INSTALLEOF'
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
INSTALLEOF

chmod +x install.sh
touch data/.gitkeep

echo "Repair complete."
