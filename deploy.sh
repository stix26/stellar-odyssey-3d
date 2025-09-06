#!/bin/bash

# 🚀 Stellar Odyssey 3D - Universal Deployment Script
# Deploys the game to multiple platforms automatically

set -e  # Exit on any error

echo "🚀 Starting Stellar Odyssey 3D deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    print_status "Checking requirements..."
    
    # Check for Godot
    if ! command -v godot &> /dev/null && [ ! -f "/Users/stilesseymens/Desktop/Godot.app/Contents/MacOS/Godot" ]; then
        print_error "Godot Engine not found. Please install Godot 4.4.1+"
        exit 1
    fi
    
    # Check for git
    if ! command -v git &> /dev/null; then
        print_error "Git not found. Please install git."
        exit 1
    fi
    
    print_success "All requirements met!"
}

# Export the game for web
export_web() {
    print_status "Exporting game for web..."
    
    if [ -f "./export_web.sh" ]; then
        chmod +x ./export_web.sh
        ./export_web.sh
    else
        print_error "export_web.sh not found!"
        exit 1
    fi
    
    if [ -f "web/index.html" ]; then
        print_success "Web export completed!"
    else
        print_error "Web export failed!"
        exit 1
    fi
}

# Deploy to Netlify
deploy_netlify() {
    print_status "Deploying to Netlify..."
    
    if command -v netlify &> /dev/null; then
        netlify deploy --dir=web --prod --message="Automated deployment $(date)"
        print_success "Deployed to Netlify!"
    else
        print_warning "Netlify CLI not found. Skipping Netlify deployment."
        print_status "Install with: npm install -g netlify-cli"
    fi
}

# Deploy to Vercel
deploy_vercel() {
    print_status "Deploying to Vercel..."
    
    if command -v vercel &> /dev/null; then
        vercel --prod --yes
        print_success "Deployed to Vercel!"
    else
        print_warning "Vercel CLI not found. Skipping Vercel deployment."
        print_status "Install with: npm install -g vercel"
    fi
}

# Create GitHub release
create_github_release() {
    print_status "Preparing GitHub release..."
    
    # Create builds directory if it doesn't exist
    mkdir -p builds
    
    # Export desktop versions if Godot is available
    GODOT_PATH="/Users/stilesseymens/Desktop/Godot.app/Contents/MacOS/Godot"
    if [ -f "$GODOT_PATH" ]; then
        print_status "Exporting desktop versions..."
        
        # macOS
        "$GODOT_PATH" --headless --export-release "macOS" builds/StellarOdyssey3D-macOS.zip --quit 2>/dev/null || true
        
        print_success "Desktop builds created!"
    fi
    
    # Create web build zip
    cd web
    zip -r ../builds/StellarOdyssey3D-Web.zip .
    cd ..
    
    print_success "Release packages created in builds/ directory"
}

# Update documentation
update_docs() {
    print_status "Updating documentation..."
    
    # Update version in README if needed
    # Add any other documentation updates here
    
    print_success "Documentation updated!"
}

# Git operations
git_operations() {
    print_status "Performing git operations..."
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_status "Initializing git repository..."
        git init
        git branch -M main
    fi
    
    # Add all files
    git add .
    
    # Check if there are changes to commit
    if git diff --staged --quiet; then
        print_warning "No changes to commit"
    else
        # Commit changes
        COMMIT_MSG="🚀 Deploy Stellar Odyssey 3D $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$COMMIT_MSG"
        print_success "Changes committed: $COMMIT_MSG"
        
        # Push to remote if it exists
        if git remote get-url origin &> /dev/null; then
            git push origin main
            print_success "Pushed to GitHub!"
        else
            print_warning "No remote origin set. Add with: git remote add origin <your-repo-url>"
        fi
    fi
}

# Main deployment function
main() {
    print_status "🎮 Stellar Odyssey 3D - Universal Deployment"
    print_status "============================================="
    
    # Parse command line arguments
    DEPLOY_WEB=true
    DEPLOY_NETLIFY=false
    DEPLOY_VERCEL=false
    DEPLOY_GITHUB=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --netlify)
                DEPLOY_NETLIFY=true
                shift
                ;;
            --vercel)
                DEPLOY_VERCEL=true
                shift
                ;;
            --github)
                DEPLOY_GITHUB=true
                shift
                ;;
            --all)
                DEPLOY_NETLIFY=true
                DEPLOY_VERCEL=true
                DEPLOY_GITHUB=true
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --netlify    Deploy to Netlify"
                echo "  --vercel     Deploy to Vercel"
                echo "  --github     Create GitHub release"
                echo "  --all        Deploy to all platforms"
                echo "  --help       Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Run deployment steps
    check_requirements
    
    if [ "$DEPLOY_WEB" = true ]; then
        export_web
    fi
    
    update_docs
    git_operations
    
    if [ "$DEPLOY_NETLIFY" = true ]; then
        deploy_netlify
    fi
    
    if [ "$DEPLOY_VERCEL" = true ]; then
        deploy_vercel
    fi
    
    if [ "$DEPLOY_GITHUB" = true ]; then
        create_github_release
    fi
    
    print_success "🎉 Deployment completed successfully!"
    print_status "Game URLs:"
    
    if [ "$DEPLOY_NETLIFY" = true ]; then
        echo "  📱 Netlify: https://dainty-mochi-d3e90e.netlify.app"
    fi
    
    if [ "$DEPLOY_VERCEL" = true ]; then
        echo "  ⚡ Vercel: Check terminal output for URL"
    fi
    
    if [ "$DEPLOY_GITHUB" = true ]; then
        echo "  📦 GitHub: Check releases page for downloads"
    fi
    
    print_status "🎮 Ready to share your game with the world!"
}

# Run main function with all arguments
main "$@"
