# 🚀 Stellar Odyssey 3D

<div align="center">

![Stellar Odyssey 3D](https://img.shields.io/badge/Godot-4.4.1-blue?logo=godot-engine&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Ready%20to%20Play-brightgreen)

**A visually stunning 3D platformer adventure through the cosmos**

*Navigate impossible geometries, conquer AI-generated fractal challenges, and embark on an epic journey through 15 levels of space-time!*

</div>

## 🎮 Demo Video

![Stellar Odyssey 3D Gameplay](media/stellar-odyssey-gameplay.mov)

*Experience precision platforming across 15 challenging levels in a beautiful space environment.*

> **🎬 Video recorded with QuickTime Player** - Shows gameplay mechanics, level traversal, and 3D platforming in action!

## 🌟 Features

- **🌌 15 Epic Levels** - From "Tutorial - Easy Start" to "Universe's End"
- **🤖 AI-Generated Fractals** - Levels created using advanced Mandelbrot and Fibonacci mathematics
- **🎮 Precise 3D Platforming** - Smooth controls with jump, dash, and movement mechanics
- **🎵 Immersive Audio** - Dynamic space soundtrack with spatial sound effects
- **🌍 Cross-Platform** - Play in browser or download native desktop apps
- **📱 Mobile Friendly** - Optimized for touch devices and mobile browsers
- **⚡ High Performance** - Built with Godot 4.4.1 for smooth 60fps gameplay

## 🎯 Game Highlights

| Level | Name | Difficulty | Platforms | Type |
|-------|------|------------|-----------|------|
| 1 | Tutorial - Easy Start | ★☆☆☆☆ | 4 | Tutorial |
| 7 | Supernova Echo | ★★★★☆ | 121 | AI Mandelbrot |
| 11 | Galactic Core | ★★★★★ | 42 | AI Fibonacci |
| 15 | Universe's End | ★★★★★ | 45 | Epic Final |

## 🚀 Quick Start

### Option 1: Run Locally
```bash
# Clone the repository
git clone https://github.com/stix26/stellar-odyssey-3d.git
cd stellar-odyssey-3d

# Run local development server
cd web && python3 -m http.server 8000

# Open browser
open http://localhost:8000
```

### Option 2: Download Desktop App
- **macOS**: Available in `builds/StellarOdyssey3D.zip` (57MB)
- **Windows/Linux**: Coming soon!

## 🛠 Development Setup

### Prerequisites
- **Godot Engine 4.4.1+** - [Download here](https://godotengine.org/download)
- **Git** - For version control
- **Python 3** - For local testing server
- **Modern Browser** - Chrome 56+, Firefox 51+, Safari 15+, or Edge 79+

### Local Development
```bash
# 1. Clone the repository
git clone https://github.com/stix26/stellar-odyssey-3d.git
cd stellar-odyssey-3d

# 2. Open in Godot
# Launch Godot Engine and import the project.godot file

# 3. Export for Web (if making changes)
./export_web.sh

# 4. Test locally
cd web
python3 -m http.server 8000
# Game available at http://localhost:8000
```

### Project Structure
```
stellar-odyssey-3d/
├── 📁 audio/              # Sound effects and music
├── 📁 environments/       # 3D environment assets
├── 📁 materials/          # PBR materials and textures
├── 📁 scenes/             # Game levels and UI scenes
├── 📁 scripts/            # GDScript game logic
├── 📁 ui/                 # User interface components
├── 📁 web/                # Exported web build
├── 📁 builds/             # Desktop builds
├── 🔧 project.godot       # Main Godot project file
├── 🔧 export_presets.cfg  # Export configurations
├── 🚀 export_web.sh       # Web export automation
└── 📋 README.md           # This file
```

## 🎮 Controls

| Action | Keyboard | Description |
|--------|----------|-------------|
| Move | `WASD` or `Arrow Keys` | Character movement |
| Jump | `Space` | Jump/Double jump |
| Dash | `Shift` | Quick dash ability |
| Pause | `ESC` | Pause game |
| Fullscreen | `F11` | Toggle fullscreen |

## 🌐 Deployment Options

### Local Web Server
```bash
# Export and serve locally
./export_web.sh
cd web && python3 -m http.server 8000
# Game available at http://localhost:8000
```

### Itch.io (Manual Upload)
```bash
# Create zip of web folder for itch.io
cd web && zip -r ../stellar-odyssey-3d-web.zip .
# Upload to itch.io with "This file will be played in the browser" checked
```

## 🔧 Technical Details

### Engine & Framework
- **Engine**: Godot 4.4.1 (Official)
- **Rendering**: Forward+ with mobile fallback
- **Audio**: OGG Vorbis with spatial audio
- **Physics**: Godot's built-in 3D physics
- **Export**: HTML5/WebAssembly + Native

### Performance Optimizations
- **WebGL1 Fallback**: Compatible with older browsers
- **Mobile Rendering**: Optimized for mobile devices
- **Asset Compression**: Efficient loading and memory usage
- **LOD System**: Distance-based detail reduction

### Browser Compatibility
| Browser | Version | WebGL2 | WebGL1 | Status |
|---------|---------|--------|--------|--------|
| Chrome | 56+ | ✅ | ✅ | Full Support |
| Firefox | 51+ | ✅ | ✅ | Full Support |
| Safari | 15+ | ✅ | ✅ | Full Support |
| Edge | 79+ | ✅ | ✅ | Full Support |

## 🐛 Troubleshooting

### Common Issues

**WebGL2 Not Supported Error**
```bash
# Solution 1: Enable hardware acceleration
# Chrome: Settings → Advanced → System → "Use hardware acceleration"

# Solution 2: Update browser
# Ensure you're running the latest version

# Solution 3: Try different browser
# Chrome generally has the best WebGL support

# Solution 4: Download desktop version
# Native app bypasses all browser issues
```

**Game Won't Load**
```bash
# Check browser console (F12) for errors
# Ensure HTTPS is enabled (some browsers require it)
# Clear browser cache and try again
# Test WebGL support: https://get.webgl.org/webgl2/
```

**Performance Issues**
```bash
# Enable hardware acceleration in browser
# Close other tabs/applications
# Try the desktop version for best performance
# Lower browser zoom level to 100%
```

## 🚀 Building from Source

### Web Export
```bash
# Ensure Godot 4.4.1 is installed
# Run the automated export script
./export_web.sh

# Or manually in Godot:
# Project → Export → Web → Export Project
```

### Desktop Export
```bash
# macOS
godot --headless --export-release "macOS" builds/StellarOdyssey3D.zip

# Windows (requires Windows export templates)
godot --headless --export-release "Windows Desktop" builds/StellarOdyssey3D.exe

# Linux
godot --headless --export-release "Linux/X11" builds/StellarOdyssey3D
```

## 📊 Game Statistics

- **Total Levels**: 15
- **Total Platforms**: 400+
- **AI-Generated Levels**: 3 (using fractal mathematics)
- **Audio Files**: 15 tracks + sound effects
- **Supported Languages**: English
- **Development Time**: Ongoing
- **Code Lines**: 2000+ (GDScript)

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **🐛 Bug Reports**: Open an issue with detailed reproduction steps
2. **💡 Feature Requests**: Suggest new levels, mechanics, or improvements
3. **🎨 Assets**: Contribute 3D models, textures, or audio
4. **🔧 Code**: Submit pull requests for bug fixes or enhancements
5. **📝 Documentation**: Improve this README or add tutorials

### Development Guidelines
```bash
# 1. Fork the repository
# 2. Create feature branch
git checkout -b feature/amazing-feature

# 3. Make changes and test
./export_web.sh  # Test web build
# Test in Godot editor

# 4. Commit changes
git commit -m "Add amazing feature"

# 5. Push and create PR
git push origin feature/amazing-feature
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License - Free to use, modify, and distribute
```

## 🙏 Acknowledgments

- **Godot Engine** - Amazing open-source game engine
- **Netlify** - Reliable web hosting platform
- **Mathematics** - Mandelbrot and Fibonacci sequences for AI level generation
- **Space** - Inspiration for the cosmic theme
- **Community** - Beta testers and feedback providers

---

<div align="center">

**⭐ Star this repository if you enjoyed the game! ⭐**

*Built with ❤️ using Godot Engine*

![Made with Godot](https://img.shields.io/badge/Made%20with-Godot-blue?logo=godot-engine&logoColor=white)

</div>