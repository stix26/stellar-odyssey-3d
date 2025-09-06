# 🎬 Video Recording Guide for Stellar Odyssey 3D

## 🎥 Recording with QuickTime Player

### Step 1: Prepare Your Game
1. **Export and run your game** for the best recording:
   ```bash
   # Option A: Run the Mac desktop version
   open builds/StellarOdyssey3D.app
   
   # Option B: Run the web version locally
   bash export_web.sh
   cd web && python3 -m http.server 8000
   # Then open http://localhost:8000 in your browser
   ```

2. **Set up ideal recording conditions**:
   - Close unnecessary applications
   - Set game to full screen or desired window size
   - Ensure good performance (60fps if possible)
   - Plan your gameplay showcase (10-15 seconds)

### Step 2: Record with QuickTime Player

1. **Open QuickTime Player**:
   ```bash
   open -a "QuickTime Player"
   ```

2. **Start Screen Recording**:
   - Click **File → New Screen Recording** (or press `Cmd+Ctrl+N`)
   - Click the **record button** (red circle)
   - Choose recording area:
     - **Entire screen**: Click anywhere
     - **Specific area**: Drag to select game window

3. **Record Your Gameplay** (10-15 seconds):
   - Show the main menu
   - Start a level
   - Demonstrate jumping/movement
   - Show a few platforms
   - Maybe complete a level or show the goal

4. **Stop Recording**:
   - Click the **stop button** in menu bar
   - Or press `Cmd+Ctrl+Esc`

### Step 3: Save and Optimize Video

1. **Save the video**:
   - File → Save
   - Name: `stellar-odyssey-gameplay.mov`
   - Location: Save to `media/` folder in your project

2. **Optimize for web** (optional but recommended):
   ```bash
   # If you have ffmpeg installed (brew install ffmpeg)
   ffmpeg -i media/stellar-odyssey-gameplay.mov \
          -vcodec libx264 \
          -crf 23 \
          -preset medium \
          -vf scale=1280:720 \
          -t 15 \
          media/stellar-odyssey-demo.mp4
   ```

## 🌐 Adding Video to README

### Option 1: Upload to GitHub (Recommended)
1. **Add video to your repository**:
   ```bash
   git add media/stellar-odyssey-gameplay.mov
   git commit -m "🎬 Add gameplay demo video"
   git push
   ```

2. **Embed in README**:
   ```markdown
   ## 🎮 Gameplay Demo
   
   https://github.com/yourusername/stellar-odyssey-3d/assets/youruserid/stellar-odyssey-gameplay.mov
   ```

### Option 2: Convert to GIF
```bash
# Using ffmpeg to create an animated GIF
ffmpeg -i media/stellar-odyssey-gameplay.mov \
       -vf "fps=15,scale=800:-1:flags=lanczos,palettegen" \
       media/palette.png

ffmpeg -i media/stellar-odyssey-gameplay.mov \
       -i media/palette.png \
       -filter_complex "fps=15,scale=800:-1:flags=lanczos[v];[v][1:v]paletteuse" \
       media/stellar-odyssey-demo.gif
```

Then embed the GIF:
```markdown
![Stellar Odyssey 3D Gameplay](media/stellar-odyssey-demo.gif)
```

### Option 3: YouTube/Vimeo (For longer videos)
1. Upload to YouTube/Vimeo
2. Embed in README:
   ```markdown
   [![Stellar Odyssey 3D Gameplay](https://img.youtube.com/vi/YOUR_VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)
   ```

## 📱 Recording Tips

### 🎯 **What to Show in 10-15 seconds**:
1. **Opening shot** (2-3s): Main menu or level start
2. **Core gameplay** (8-10s): Player movement, jumping between platforms
3. **Goal/Achievement** (2-3s): Reaching a goal or completing a level

### 🎨 **Visual Tips**:
- **Good lighting**: Bright, clear visuals
- **Smooth movement**: Don't rush, show fluid gameplay
- **Key features**: Highlight the 3D platforming mechanics
- **Audio**: Include game sound effects and music

### 📐 **Technical Settings**:
- **Resolution**: 1280x720 or 1920x1080
- **Frame rate**: 30-60 fps
- **Duration**: 10-15 seconds for README, longer for YouTube
- **Format**: .mov for GitHub, .mp4 for web, .gif for inline display

## 🚀 Quick Recording Workflow

```bash
# 1. Prepare game
bash export_web.sh
cd web && python3 -m http.server 8000 &

# 2. Open game in browser
open http://localhost:8000

# 3. Start QuickTime recording
open -a "QuickTime Player"
# Then: File → New Screen Recording

# 4. Record 10-15 seconds of gameplay

# 5. Save to media folder
# File → Save → media/stellar-odyssey-gameplay.mov

# 6. Add to git
git add media/
git commit -m "🎬 Add gameplay demo video"
```

## 📋 Checklist

- [ ] Game is running smoothly
- [ ] QuickTime Player is open
- [ ] Screen recording area selected
- [ ] 10-15 seconds of engaging gameplay recorded
- [ ] Video saved to `media/` folder
- [ ] Video added to README
- [ ] Changes committed to git

## 🎬 Example README Integration

```markdown
# 🌟 Stellar Odyssey 3D

A visually stunning 3D platformer adventure through space!

## 🎮 Gameplay Demo

https://github.com/yourusername/stellar-odyssey-3d/assets/youruserid/stellar-odyssey-gameplay.mov

*Experience precision platforming across 15 challenging levels in a beautiful space environment.*

## ✨ Features
...
```

Ready to create an amazing gameplay showcase! 🎮✨
