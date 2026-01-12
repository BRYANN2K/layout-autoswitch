# Bluetooth Keyboard Layout Autoswitch

A robust, user-level script to automatically switch your GNOME keyboard layout when specific Bluetooth keyboards connect or disconnect.

## Features

- **Multi-Device Support**: Configure multiple devices with different layouts (e.g., Mac layout for MX Keys, generic for others).
- **Priority System**: If multiple devices are configured, the first one found connected takes priority.
- **Config Separation**: User configuration is stored in `~/.config/layout-autoswitch/config` – safe from script updates.
- **User-Level Service**: Runs entirely as your user—no root/sudo required.
- **Desktop Notifications**: Get a notification whenever the layout changes.

## Prerequisites

- **GNOME Desktop Environment** (uses `gsettings`).
- **BlueZ** (provides `bluetoothctl`).
- **libnotify-bin** (provides `notify-send` for strong descriptors).

## Installation

### 1. Automatic Install (Recommended)

Run the provided installer to set up the directories and systemd service automatically:

```bash
chmod +x install.sh
./install.sh
```

### 2. Configuration

1. Edit the configuration file created at `~/.config/layout-autoswitch/config`.
2. Find your device MAC address using `bluetoothctl devices`.
3. Add your devices to the `DEVICES` array.

**Example `~/.config/layout-autoswitch/config`:**

```bash
# Format: "MAC_ADDRESS:DEVICE_NAME:LAYOUT_ID"
DEVICES=(
    "D2:5E:40:00:B8:28:MX Keys Mini:fr+mac"
    "AA:BB:CC:DD:EE:FF:Generic Keyboard:us"
)

# Fallback layout when no known devices are connected
DEFAULT_LAYOUT="fr"
```

### 3. Verification

Check the service status:
```bash
systemctl --user status layout-autoswitch.service
```

Read real-time logs:
```bash
journalctl --user -u layout-autoswitch -f
```

## How It Works

The script runs in the background and checks (polls) for connected devices every 5 seconds.
1. It loops through your `DEVICES` list in order.
2. If it finds a connected device, it switches to that device's specified layout.
3. If no listed devices are connected, it switches to `DEFAULT_LAYOUT`.
4. It only applies changes (and notifies you) if the state actually changes.

## Uninstall

```bash
systemctl --user disable --now layout-autoswitch.service
rm ~/.config/systemd/user/layout-autoswitch.service
rm -rf ~/.config/layout-autoswitch
```
