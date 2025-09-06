# Contributing to Stellar Odyssey 3D

Thank you for your interest in contributing to Stellar Odyssey 3D! 🚀

## 🎯 Ways to Contribute

### 🐛 Bug Reports
- Use the [issue tracker](https://github.com/yourusername/stellar-odyssey-3d/issues)
- Include detailed reproduction steps
- Mention your browser/OS version
- Attach screenshots if applicable

### 💡 Feature Requests  
- Suggest new levels or game mechanics
- Propose UI/UX improvements
- Request new platform support

### 🎨 Assets & Content
- 3D models and textures
- Audio tracks and sound effects  
- Level designs
- Art and promotional materials

### 🔧 Code Contributions
- Bug fixes
- Performance improvements
- New features
- Code documentation

## 🛠 Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/yourusername/stellar-odyssey-3d.git
   cd stellar-odyssey-3d
   ```

2. **Install Godot 4.4.1+**
   - Download from [godotengine.org](https://godotengine.org/download)

3. **Open Project**
   - Launch Godot
   - Import `project.godot`

4. **Test Changes**
   ```bash
   # Export web build
   ./export_web.sh
   
   # Test locally
   cd web && python3 -m http.server 8000
   ```

## 📋 Coding Standards

### GDScript Style
```gdscript
# Use snake_case for variables and functions
var player_speed: float = 100.0

# Use PascalCase for classes and signals
class_name PlayerController
signal health_changed(new_health: int)

# Add type hints
func move_player(direction: Vector3) -> void:
    # Implementation here
    pass
```

### File Organization
- Scripts in `scripts/` folder
- Scenes in `scenes/` folder  
- Assets in appropriate folders (`audio/`, `materials/`, etc.)

## 🔄 Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Follow coding standards
   - Test thoroughly
   - Update documentation if needed

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add amazing new feature"
   ```

4. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **PR Requirements**
   - Clear description of changes
   - Screenshots/videos for visual changes
   - Test instructions
   - Link related issues

## 🧪 Testing

### Manual Testing
- Test all game levels
- Verify controls work correctly
- Check audio/visual quality
- Test on different browsers

### Automated Testing
```bash
# Run export test
./export_web.sh

# Verify web build works
cd web && python3 -m http.server 8000
```

## 📝 Documentation

- Update README.md for new features
- Add code comments for complex logic
- Create tutorials for new mechanics
- Update troubleshooting guide

## 🏷 Commit Message Format

Use conventional commits:
```
feat: add new level design tool
fix: resolve WebGL compatibility issue  
docs: update installation instructions
style: improve code formatting
refactor: optimize rendering pipeline
test: add level completion tests
```

## 🎮 Level Design Guidelines

### New Levels
- Start with paper/digital sketches
- Consider difficulty progression
- Test platform spacing and jump distances
- Ensure visual clarity and navigation
- Add unique mechanics or challenges

### AI-Generated Levels
- Document mathematical formulas used
- Ensure playability despite complexity
- Balance difficulty with fairness
- Test edge cases and impossible sections

## 🔍 Code Review Process

1. **Automated Checks**
   - Code builds successfully
   - No syntax errors
   - Export process works

2. **Manual Review**
   - Code quality and readability
   - Performance implications
   - User experience impact
   - Security considerations

3. **Testing**
   - Functionality works as expected
   - No regressions introduced
   - Cross-browser compatibility

## 🏆 Recognition

Contributors will be:
- Listed in the README.md acknowledgments
- Mentioned in release notes
- Credited in the game's about section
- Invited to beta test new features

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for helping make Stellar Odyssey 3D even better!** 🌟
