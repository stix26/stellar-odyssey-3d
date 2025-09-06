# 🧹 GitHub Repository Cleanup Guide

## ❌ Files/Directories to EXCLUDE from GitHub

### 🏗️ **Build Artifacts (243MB total)**
```bash
# These are generated files - don't commit to GitHub
web/          # 100MB - Web export files
builds/       # 57MB  - Desktop builds  
public/       # 43MB  - Vercel build files
docs/         # 43MB  - GitHub Pages files
```

### 🔧 **Deployment Files**
```bash
.netlify/     # Netlify deployment cache
.vercel/      # Vercel deployment cache
*.zip         # Binary releases (use GitHub Releases instead)
```

### 📁 **Godot Generated Files**
```bash
.godot/       # Godot editor cache
*.import      # Asset import files (regenerated automatically)
export_presets.cfg.bak  # Backup files
```

### 🖥️ **System Files**
```bash
.DS_Store     # macOS Finder files
Thumbs.db     # Windows thumbnail cache
Desktop.ini   # Windows folder settings
```

## ✅ Files to KEEP in GitHub

### 📋 **Essential Project Files**
```bash
project.godot           # Main Godot project file
export_presets.cfg      # Export configurations
README.md              # Project documentation
LICENSE                # License file
.gitignore             # Git ignore rules
```

### 🎮 **Game Source Code**
```bash
audio/                 # Sound files (.ogg)
environments/          # 3D environments (.tres)
materials/            # Materials and textures (.tres)
scenes/               # Game levels (.tscn)
scripts/              # Game logic (.gd)
ui/                   # User interface (.tscn)
icon.svg              # Game icon
```

### 🛠️ **Development Tools**
```bash
export_web.sh         # Web export script
deploy.sh             # Deployment automation
CONTRIBUTING.md       # Contribution guidelines
VIDEO_INSTRUCTIONS.md # Video setup guide
.github/              # GitHub Actions workflows
```

## 🚀 Clean Repository Setup

### Step 1: Remove Large Files
```bash
# Remove build directories (they'll be regenerated)
rm -rf web/ builds/ public/ docs/

# Remove deployment caches
rm -rf .netlify/ .vercel/

# Remove system files
find . -name ".DS_Store" -delete
find . -name "Thumbs.db" -delete
```

### Step 2: Initialize Clean Git Repository
```bash
# Initialize fresh git repository
git init
git branch -M main

# Add only source files
git add .
git commit -m "🎮 Initial commit: Stellar Odyssey 3D source code"

# Add remote and push
git remote add origin https://github.com/yourusername/stellar-odyssey-3d.git
git push -u origin main
```

### Step 3: Set Up Automated Builds
```bash
# GitHub Actions will automatically:
# 1. Export web build from source
# 2. Deploy to GitHub Pages
# 3. Create releases with downloads
# 4. Deploy to Netlify/Vercel

# No need to commit build files!
```

## 📊 Repository Size Comparison

### ❌ **With Build Files**: ~250MB
- Slow cloning
- Large storage usage
- Unnecessary binary files
- Merge conflicts on builds

### ✅ **Source Only**: ~15MB  
- Fast cloning
- Efficient storage
- Clean version history
- No build conflicts

## 🔄 Automated Workflow

### When You Push Source Code:
1. **GitHub Actions** automatically exports web build
2. **Deploys** to GitHub Pages, Netlify, Vercel
3. **Creates releases** with downloadable builds
4. **No manual build management** needed

### Benefits:
- ✅ Clean repository
- ✅ Automated deployments  
- ✅ Consistent builds
- ✅ Easy collaboration
- ✅ Professional workflow

## 📝 Updated File Structure

### ✅ **What Goes in GitHub**:
```
stellar-odyssey-3d/
├── 📁 audio/              # Game audio files
├── 📁 environments/       # 3D environments  
├── 📁 materials/          # Materials & textures
├── 📁 scenes/             # Game levels
├── 📁 scripts/            # Game logic
├── 📁 ui/                 # User interfaces
├── 📁 .github/            # GitHub Actions
├── 🔧 project.godot       # Main project file
├── 🔧 export_presets.cfg  # Export settings
├── 🚀 export_web.sh       # Build scripts
├── 🚀 deploy.sh           # Deployment scripts
├── 📋 README.md           # Documentation
├── 📋 LICENSE             # License
├── 📋 .gitignore          # Ignore rules
└── 📋 CONTRIBUTING.md     # Contribution guide
```

### ❌ **What Stays Out of GitHub**:
```
# These are generated/cached - not source code
web/                  # Built web files
builds/               # Compiled binaries
.godot/              # Editor cache
*.import             # Asset import cache
.netlify/            # Deployment cache
.vercel/             # Deployment cache
```

## 🎯 Best Practices

1. **Source Code Only**: Commit only the files you write
2. **Automate Builds**: Use CI/CD for consistent builds
3. **Use Releases**: Distribute binaries via GitHub Releases
4. **Keep It Clean**: Regular cleanup of generated files
5. **Document Everything**: Clear README and contribution guides

This approach gives you a **professional, maintainable repository** that's easy to collaborate on and automatically deploys your game! 🚀
