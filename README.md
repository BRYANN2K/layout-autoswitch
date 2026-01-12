<<<<<<< HEAD
# layout-autoswitch
=======
# Bluetooth Keyboard Layout Autoswitch

A simple, lightweight script to automatically switch your GNOME keyboard layout when a specific Bluetooth keyboard (e.g., Logitech MX Keys) connects or disconnects.

## Features

- **Automatic Layout Switching**: Sets a specific layout (e.g., `fr+mac`) when your device connects, and reverts to a default layout (e.g., `fr`) when it disconnects.
- **User-Level Service**: Runs entirely as your user—no root/sudo required.
- **Desktop Notifications**: Get a subtle notification whenever the layout changes.

## Prerequisites

- **GNOME Desktop Environment** (uses `gsettings`).
- **BlueZ** (provides `bluetoothctl`).
- **libnotify-bin** (provides `notify-send` for notifications, usually installed by default on many distros).

## Installation

### 1. Setup the Script

1. Copy `layout-autoswitch.sh` to a permanent location, for example:
   ```bash
   mkdir -p ~/Documents/Scripts/layout-autoswitch
   cp layout-autoswitch.sh ~/Documents/Scripts/layout-autoswitch/
   chmod +x ~/Documents/Scripts/layout-autoswitch/layout-autoswitch.sh
   ```

2. **Edit the script** to configure your device and layouts:
   Open `layout-autoswitch.sh` and update the top variables:
   ```bash
   DEVICE_MAC="D2:5E:40:00:B8:28"   # Get this via 'bluetoothctl devices'
   DEVICE_NAME="MX Keys Mini"       # Friendly name for notifications
   LAYOUT_CONNECTED="fr+mac"        # Layout ID when connected
   LAYOUT_DISCONNECTED="fr"         # Layout ID when disconnected
   ```

   > **Tip:** To find your device's MAC address, run `bluetoothctl devices` in a terminal.

### 2. Setup the Service

1. Copy `layout-autoswitch.service` to the systemd user directory:
   ```bash
   mkdir -p ~/.config/systemd/user/
   cp layout-autoswitch.service ~/.config/systemd/user/
   ```

2. **Edit the service file** to point to your script:
   Open `~/.config/systemd/user/layout-autoswitch.service` and ensure the `ExecStart` path is correct.
   *(Note: The provided file uses `%h` which automatically resolves to your home directory, assuming you followed the path in step 1).*

3. Reload systemd and enable the service:
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable --now layout-autoswitch.service
   ```

## Usage

Once enabled, the service runs in the background. 
- Turn on your keyboard -> Notification: "Connected", Layout switches.
- Turn off your keyboard -> Notification: "Disconnected", Layout reverts.

You can check the logs anytime with:
```bash
journalctl --user -u layout-autoswitch -f
```

## Uninstallation

To remove the service:
```bash
systemctl --user disable --now layout-autoswitch.service
rm ~/.config/systemd/user/layout-autoswitch.service
```
>>>>>>> 1647a53 (Premier commit)
