#!/bin/bash

# Configuration Loading
CONFIG_FILE="$HOME/.config/layout-autoswitch/config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Config file not found at $CONFIG_FILE"
    echo "Please copy config.example to $CONFIG_FILE and configure it."
    exit 1
fi

# Internal variables
LAST_STATE="unknown"

echo "Starting Layout Autoswitch Monitor..."
echo "Loaded ${#DEVICES[@]} devices from config."

while true; do
    ACTIVE_DEVICE_NAME=""
    TARGET_LAYOUT="$DEFAULT_LAYOUT"
    CONNECTED_MSG=""

    # Iterate through devices in priority order
    for DEVICE_ENTRY in "${DEVICES[@]}"; do
        # Parse entry: MAC:NAME:LAYOUT
        # We use cut to split by colon
        DEV_MAC=$(echo "$DEVICE_ENTRY" | cut -d':' -f1)
        DEV_NAME=$(echo "$DEVICE_ENTRY" | cut -d':' -f2)
        DEV_LAYOUT=$(echo "$DEVICE_ENTRY" | cut -d':' -f3)

        # Check connection
        if bluetoothctl info "$DEV_MAC" 2>/dev/null | grep -q "Connected: yes"; then
            ACTIVE_DEVICE_NAME="$DEV_NAME"
            TARGET_LAYOUT="$DEV_LAYOUT"
            CONNECTED_MSG="Connected to optimized device: $DEV_NAME"
            break # Stop at first connected device (Priority)
        fi
    done

    # If no device connected, we stay with DEFAULT_LAYOUT (set above)
    if [ -z "$ACTIVE_DEVICE_NAME" ]; then
        CURRENT_STATE="default"
    else
        CURRENT_STATE="connected:$ACTIVE_DEVICE_NAME"
    fi

    # Handle state change
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        
        # Apply Layout
        gsettings set org.gnome.desktop.input-sources sources "[('xkb','$TARGET_LAYOUT')]"
        
        # Determine notification message
        if [ -n "$ACTIVE_DEVICE_NAME" ]; then
            MSG="$CONNECTED_MSG. Switched to $TARGET_LAYOUT"
            TITLE="$ACTIVE_DEVICE_NAME Connected"
        else
            MSG="Devices disconnected. Reverted to $TARGET_LAYOUT"
            TITLE="Layout Autoswitch"
        fi

        # Notify
        notify-send --app-name="Layout Switcher" "$TITLE" "$MSG" --urgency=low
        
        # Log
        echo "$(date): $MSG"
        
        LAST_STATE="$CURRENT_STATE"
    fi

    sleep 5
done
