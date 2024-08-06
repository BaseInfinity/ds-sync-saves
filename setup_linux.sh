#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Define variables
SERVICE_NAME="ds_sync_save"
SCRIPT_DIR="/home/$SUDO_USER/ds-sync-save"
SCRIPT_PATH="$SCRIPT_DIR/ds_sync_save.py"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME.service"
CONFIG_PATH="$SCRIPT_DIR/config.json"

# Check if Python script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH does not exist."
    exit 1
fi

# Check if config file exists, create if it doesn't
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config file not found. Creating a sample config file."
    cat > "$CONFIG_PATH" << EOL
{
    "watched_folders": [
        "/path/to/drastic/saves",
        "/path/to/retroarch/saves"
    ]
}
EOL
    chown $SUDO_USER:$SUDO_USER "$CONFIG_PATH"
    echo "Please edit $CONFIG_PATH with your desired watch folders."
fi

# Install required Python packages
sudo -u $SUDO_USER pip3 install watchdog

# Create service file
cat > $SERVICE_PATH << EOL
[Unit]
Description=DS Save Sync Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 $SCRIPT_PATH
Restart=always
User=$SUDO_USER
Type=simple

[Install]
WantedBy=multi-user.target
EOL

# Set correct permissions
chmod 644 $SERVICE_PATH

# Reload systemd, enable and start the service
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME

echo "Service $SERVICE_NAME has been created, enabled, and started."
echo "You can check its status with: systemctl status $SERVICE_NAME"
echo "To view logs, use: journalctl -u $SERVICE_NAME -f"
