@echo off
cd /d "%~dp0"
if exist "Godot.exe" (
    "Godot.exe" --path "./stellar-odyssey-3d"
) else if exist "Godot_v4.4.1-stable_win64.exe" (
    "Godot_v4.4.1-stable_win64.exe" --path "./stellar-odyssey-3d"
) else if exist "Godot_v4.4.1-stable_win32.exe" (
    "Godot_v4.4.1-stable_win32.exe" --path "./stellar-odyssey-3d"
) else (
    echo Godot executable not found! Please place Godot.exe in this directory.
    pause
)
