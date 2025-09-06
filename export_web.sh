#!/bin/bash

# Stellar Odyssey 3D - Web Export Script for Vercel
# This script exports the Godot game to HTML5/WebAssembly format

echo "🚀 Starting Stellar Odyssey 3D Web Export..."

# Set Godot path
GODOT_PATH="/Users/stilesseymens/Desktop/Godot.app/Contents/MacOS/Godot"

# Check if Godot exists
if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    exit 1
fi

# Create web directory if it doesn't exist
mkdir -p web

echo "📦 Installing/updating Web export templates..."
"$GODOT_PATH" --headless --export-pack Web ./web/game.pck 2>/dev/null || {
    echo "🔧 Downloading web export templates..."
    "$GODOT_PATH" --headless --export-release Web ./web/index.html --quit 2>/dev/null || true
}

echo "🌐 Exporting game to Web (HTML5/WebAssembly)..."

# Export the game
"$GODOT_PATH" --headless --export-release Web ./web/index.html --quit

# Check if export was successful
if [ $? -eq 0 ] && [ -f "./web/index.html" ]; then
    echo "✅ Export successful!"
    echo "📁 Web files created in ./web/"
    
    # List exported files
    echo "📄 Generated files:"
    ls -la ./web/
    
    # Create a simple local server script
    cat > ./web/serve.sh << 'EOF'
#!/bin/bash
echo "🌍 Starting local server at http://localhost:8000"
echo "🎮 Open your browser and go to http://localhost:8000 to play!"
python3 -m http.server 8000
EOF
    chmod +x ./web/serve.sh
    
    echo ""
    echo "🎉 Stellar Odyssey 3D is ready for Vercel deployment!"
    echo "📤 Next steps:"
    echo "   1. Initialize git repository: git init"
    echo "   2. Add files: git add ."
    echo "   3. Commit: git commit -m 'Initial deployment'"
    echo "   4. Deploy to Vercel: vercel --prod"
    echo ""
    echo "🧪 Test locally: cd web && python3 -m http.server 8000"
    
else
    echo "❌ Export failed. Please check the Godot project for errors."
    echo "💡 Make sure all scenes and scripts are error-free."
    exit 1
fi
