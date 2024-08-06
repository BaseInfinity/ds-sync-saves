@echo off
echo Setting up DS Sync Saves for Windows...

REM Check for Python installation
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python 3.6 or higher and try again.
    exit /b 1
)

REM Install required packages
pip install watchdog

REM Create a config file if it doesn't exist
if not exist config.json (
    echo Creating sample config file...
    echo { > config.json
    echo   "watched_folders": [ >> config.json
    echo     "C:\\Path\\To\\DraStic\\Saves", >> config.json
    echo     "C:\\Path\\To\\RetroArch\\Saves" >> config.json
    echo   ] >> config.json
    echo } >> config.json
    echo Please edit config.json with your desired watch folders.
)

REM Create a batch file to run the script
echo @echo off > run_ds_sync_saves.bat
echo python ds_sync_saves.py >> run_ds_sync_saves.bat

echo Setup complete. You can now run the script using run_ds_sync_saves.bat
echo To run the script at startup, press Win+R, type 'shell:startup', and copy run_ds_sync_saves.bat to the opened folder.
