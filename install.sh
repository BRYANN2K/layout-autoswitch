#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing Layout Autoswitch...${NC}"

# 1. Setup Directories
CONFIG_DIR="$HOME/.config/layout-autoswitch"
SYSTEMD_DIR="$HOME/.config/systemd/user"

mkdir -p "$CONFIG_DIR"
mkdir -p "$SYSTEMD_DIR"

# 2. Config Setup
if [ ! -f "$CONFIG_DIR/config" ]; then
    echo "Creating default config at $CONFIG_DIR/config"
    cp config.example "$CONFIG_DIR/config"
    echo -e "${GREEN}PLEASE EDIT $CONFIG_DIR/config with your device MAC address!${NC}"
else
    echo "Config file already exists at $CONFIG_DIR/config, skipping creation."
fi

# 3. Script Permission
chmod +x layout-autoswitch.sh

# 4. Service Setup
SERVICE_FILE="layout-autoswitch.service"
TARGET_SERVICE="$SYSTEMD_DIR/$SERVICE_FILE"
CURRENT_DIR=$(pwd)

echo "Configuring service to use script at: $CURRENT_DIR/layout-autoswitch.sh"

# We replace the ExecStart line with the absolute path
sed "s|ExecStart=.*|ExecStart=$CURRENT_DIR/layout-autoswitch.sh|" "$SERVICE_FILE" > "$TARGET_SERVICE"

# 5. Enable Service
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

echo "Enabling and starting service..."
systemctl --user enable --now layout-autoswitch.service

echo -e "${GREEN}Installation Complete!${NC}"
echo "Check status with: systemctl --user status layout-autoswitch.service"
