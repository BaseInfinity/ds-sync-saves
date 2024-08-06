# DS Sync Saves

DS Sync Saves is a Python script that automatically synchronizes save files for Nintendo DS games between `.dsv` and `.sav` formats. This tool is particularly useful for people who play across multiple devices or emulators, especially when using Syncthing

## Features

- Monitors specified directories for changes in `.dsv` or `.sav` files
- Automatically creates a copy of the changed file in the other format
- Works on both Windows and Linux
- Can be set up to run at system startup
- Works well with Syncthing for cross-device save file synchronization

This setup allows you to switch between playing on devices with DraStic and devices using RetroArch or other emulators without manually converting save files, ensuring your game progress is always up-to-date across all your devices.

## Prerequisites

- Python 3.6 or higher
- Syncthing (optional, but recommended for syncing across devices)

## Installation

1. Clone this repository or download the script files to your machine running Syncthing:

   ```
   git clone https://github.com/baseinfinity/ds-sync-saves.git
   cd ds-sync-saves
   ```

2. Run the setup script for your operating system:

   For Linux:
   ```
   sudo ./setup_linux.sh
   ```

   For Windows:
   ```
   .\setup_windows.bat
   ```

3. Edit the configuration file:

   ```
   nano config.json  # Use your preferred text editor
   ```

   Update the "watched_folders" array with the paths to your DS save directories.

## Usage

### Linux

The service runs automatically in the background. It will start on system boot and continue running until stopped.

To check the status of the service:

```
sudo systemctl status ds_sync_saves.service
```

To view the logs:

```
journalctl -u ds_sync_saves.service -f
```

To stop the service:

```
sudo systemctl stop ds_sync_saves.service
```

To start the service:

```
sudo systemctl start ds_sync_saves.service
```

### Windows

Run the script by double-clicking `run_ds_sync_saves.bat` or running it from the command prompt.

To run the script at startup:
1. Press Win+R
2. Type `shell:startup` and press Enter
3. Copy `run_ds_sync_saves.bat` to the opened folder

To stop the script, close the command prompt window where it's running.

## Notes

- This script is designed to run on the machine that is running Syncthing. It monitors the local directories that Syncthing synchronizes across your devices.
- Any changes to the Python script or configuration file require a restart of the script/service to take effect.
- Ensure that your Syncthing folders containing DS save files are included in the `config.json` file.

## Troubleshooting

If you encounter any issues:

1. Ensure the paths in your `config.json` are correct and accessible.
2. Verify that the required Python packages are installed correctly.
