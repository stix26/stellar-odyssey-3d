#!/bin/bash
cd "$(dirname "$0")"

# Try different common Godot executable names
if [ -f "./Godot" ]; then
    ./Godot --path ./stellar-odyssey-3d
elif [ -f "./godot" ]; then
    ./godot --path ./stellar-odyssey-3d
elif [ -f "./Godot_v4.4.1-stable_linux.x86_64" ]; then
    ./Godot_v4.4.1-stable_linux.x86_64 --path ./stellar-odyssey-3d
elif command -v godot &> /dev/null; then
    godot --path ./stellar-odyssey-3d
else
    echo "Godot executable not found!"
    echo "Please install Godot or place the Godot executable in this directory."
    echo "You can download Godot from: https://godotengine.org/download"
    read -p "Press Enter to exit..."
fi
