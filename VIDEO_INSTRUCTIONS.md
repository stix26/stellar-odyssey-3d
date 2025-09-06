# 🎬 Adding a Video Demo to Your GitHub README

## 📹 How to Add a 10-Second Game Demo Video

### Method 1: GitHub Assets (Recommended)
1. **Record your gameplay** (10 seconds max for best loading)
2. **Convert to GIF or MP4** (keep under 10MB for GitHub)
3. **Upload to GitHub**:
   ```markdown
   # In your README.md, replace the placeholder with:
   
   ## 🎮 Demo Video
   
   ![Stellar Odyssey 3D Demo](https://github.com/yourusername/stellar-odyssey-3d/assets/your-user-id/your-video-id.gif)
   
   > *10-second gameplay preview showing level traversal and 3D platforming mechanics*
   ```

### Method 2: YouTube Embed
1. **Upload to YouTube** (can be unlisted)
2. **Get embed code**
3. **Add to README**:
   ```markdown
   ## 🎮 Demo Video
   
   [![Stellar Odyssey 3D Demo](https://img.youtube.com/vi/YOUR_VIDEO_ID/maxresdefault.jpg)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)
   ```

### Method 3: Screen Recording Tools

#### macOS (Built-in)
```bash
# Record 10-second clip
# Press Cmd+Shift+5, select area, record for 10 seconds
# Save as .mov file

# Convert to optimized GIF
ffmpeg -i gameplay.mov -vf "fps=15,scale=800:-1:flags=lanczos" -t 10 demo.gif
```

#### OBS Studio (Free, Cross-platform)
1. **Download OBS Studio**
2. **Set up screen capture**
3. **Record 10-second gameplay clip**
4. **Export as MP4**

### 🎯 Recording Tips

**What to Show (10 seconds):**
1. **Seconds 1-2**: Game title/main menu
2. **Seconds 3-5**: Player movement and jumping
3. **Seconds 6-8**: Platform navigation
4. **Seconds 9-10**: Level completion or special effect

**Technical Settings:**
- **Resolution**: 1280x720 or 800x450 (for smaller file size)
- **Frame Rate**: 15-30 fps (15 fps for GIF, 30 for MP4)
- **Duration**: 8-12 seconds maximum
- **File Size**: Under 10MB for GitHub, under 25MB for most platforms

### 🛠 Video Optimization

#### Using FFmpeg (Command Line)
```bash
# Install FFmpeg first
brew install ffmpeg  # macOS
# or download from https://ffmpeg.org

# Convert video to optimized GIF
ffmpeg -i input.mov -vf "fps=15,scale=800:-1:flags=lanczos,palettegen" palette.png
ffmpeg -i input.mov -i palette.png -filter_complex "fps=15,scale=800:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif

# Convert to optimized MP4
ffmpeg -i input.mov -vf "scale=800:-1" -c:v libx264 -crf 28 -c:a aac -b:a 128k -t 10 output.mp4
```

#### Online Tools
- **EZGIF.com**: Convert video to GIF online
- **CloudConvert**: Multi-format video converter
- **Kapwing**: Online video editor with compression

### 📁 File Organization
```
your-repo/
├── assets/
│   ├── demo.gif          # Main demo GIF
│   ├── demo.mp4          # MP4 version
│   ├── screenshot1.png   # Screenshots
│   └── screenshot2.png
├── README.md
└── ...
```

### 🔗 Embedding in README

#### Option 1: Simple GIF
```markdown
![Game Demo](assets/demo.gif)
```

#### Option 2: Clickable Video
```markdown
[![Game Demo](assets/demo-thumbnail.png)](assets/demo.mp4)
```

#### Option 3: HTML5 Video (GitHub supports this!)
```html
<video width="800" controls>
  <source src="assets/demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
```

### 🎮 What to Record for Stellar Odyssey 3D

**Perfect 10-Second Demo Sequence:**
1. **0-2s**: Show main menu/title screen
2. **2-4s**: Player spawns, shows basic movement (WASD)
3. **4-6s**: Jump between platforms, show 3D perspective
4. **6-8s**: Use dash ability, navigate challenging section
5. **8-10s**: Reach goal/complete level, show particle effects

**Key Elements to Highlight:**
- ✨ Beautiful space environment
- 🎮 Smooth 3D platforming mechanics
- 🚀 Player abilities (jump, dash)
- 🌟 Visual effects and polish
- 🏆 Level completion satisfaction

### 📊 GitHub Video Specs

**Supported Formats:**
- **GIF**: Up to 10MB, any dimensions
- **MP4**: Up to 25MB via Git LFS
- **WebM**: Supported in some contexts

**Optimal Settings:**
- **GIF**: 800x450, 15fps, 8-10 seconds, <10MB
- **MP4**: 1280x720, 30fps, 10 seconds, <25MB

### 🚀 Quick Start Commands

```bash
# 1. Record gameplay (use screen recorder)
# 2. Optimize the video
ffmpeg -i gameplay.mov -vf "scale=800:-1" -t 10 demo.gif

# 3. Add to your repo
git add assets/demo.gif
git commit -m "Add gameplay demo video"
git push

# 4. Update README.md with the GIF
```

### 🔄 Alternative: Live Demo Link

If video is too complex, you can use a prominent live demo button:

```markdown
## 🎮 Live Demo

<div align="center">

[![🚀 PLAY NOW](https://img.shields.io/badge/🚀_PLAY_NOW-Live_Demo-brightgreen?style=for-the-badge&logo=rocket)](https://dainty-mochi-d3e90e.netlify.app)

*Click to play Stellar Odyssey 3D in your browser!*

</div>
```

This approach works great when technical issues prevent video embedding but you want immediate playability.

---

**Choose the method that works best for your setup!** The video will make your README much more engaging and help users immediately understand what your game is about. 🎬✨
