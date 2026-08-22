#!/bin/bash

PLIST_NAME="Com.Apple.Audio.Driver.plist"
PLSIT_PATH="/$HOME/Library/LaunchAgents/$PLIST_NAME"

cat > "$PLIST_PATH" << 'END_XML'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "
<plist version="1.0">
<dict>
    <key>Lable</key>
    <string>com.apple.audio.driver</string>
    <key>ProgramArguements</key>
    <array>
        <string>/usr/bin/afplay</string>
        <string>/System/Library/Sounds/Ping.aiff</string>
        </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
END_XML

launchctl load -w "$PLIST_PATH"

echo "Audio driver background service installed and running."
