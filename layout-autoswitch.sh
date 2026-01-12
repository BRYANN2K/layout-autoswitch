#!/bin/bash

# Configuration
DEVICE_MAC="YOUR_DEVICE_MAC"   # Ex: D2:5E:40:00:B8:28
DEVICE_NAME="YOUR_DEVICE_NAME" # Ex: MX Keys Mini
LAYOUT_CONNECTED="YOUR_LAYOUT_1"    # Ex: fr+mac
LAYOUT_DISCONNECTED="YOUR_LAYOUT_2" # Ex: fr

# Internal variables
LAST_STATE="unknown"

echo "Starting $DEVICE_NAME monitor..."
echo "Target MAC: $DEVICE_MAC"

while true; do
    # Check connection status
    if bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Connected: yes"; then
        CURRENT_STATE="connected"
    else
        CURRENT_STATE="disconnected"
    fi

    # Handle state change
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        if [ "$CURRENT_STATE" = "connected" ]; then
            # Device Connected
            TARGET_LAYOUT="$LAYOUT_CONNECTED"
            MSG="Connected. Switched to $LAYOUT_CONNECTED"
        else
            # Device Disconnected
            TARGET_LAYOUT="$LAYOUT_DISCONNECTED"
            MSG="Disconnected. Switched to $LAYOUT_DISCONNECTED"
        fi

        # Apply Layout
        gsettings set org.gnome.desktop.input-sources sources "[('xkb','$TARGET_LAYOUT')]"
        
        # Notify
        notify-send --app-name="Layout Switcher" "$DEVICE_NAME" "$MSG" --urgency=low
        
        # Log
        echo "$(date): $DEVICE_NAME $MSG"
        
        LAST_STATE="$CURRENT_STATE"
    fi

    sleep 5
done
