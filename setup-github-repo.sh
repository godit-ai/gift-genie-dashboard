#!/bin/bash
# Gift Genie Dashboard - GitHub Repo Setup Script
# This creates a SEPARATE GitHub repository just for the dashboard

echo "🎁 Gift Genie Dashboard - GitHub Setup"
echo "======================================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install Git first."
    exit 1
fi

# Get current directory
DASHBOARD_DIR="$(pwd)"
echo "📁 Dashboard location: $DASHBOARD_DIR"
echo ""

# Check if already a git repo (part of workspace)
if [ -d ".git" ]; then
    echo "⚠️  This folder is already a git repository."
    echo ""
    echo "To create a SEPARATE GitHub repo for just the dashboard:"
    echo ""
    echo "Option 1: Remove existing git and start fresh"
    echo "   rm -rf .git"
    echo "   rm -rf ../.git"
    echo "   ./setup-github-repo.sh"
    echo ""
    echo "Option 2: Create a subtree split (advanced)"
    echo "   See docs/GITHUB_SETUP.md for details"
    echo ""
    read -p "Remove existing git and start fresh? (y/n): " choice
    if [ "$choice" = "y" ]; then
        rm -rf .git
        echo "✅ Removed existing git repository"
    else
        echo "❌ Setup cancelled"
        exit 1
    fi
fi

echo ""
echo "📝 Step 1: Creating README..."
cat > README.md << 'EOF'
# 🎁 Gift Genie Trends Dashboard

A beautiful dashboard for tracking trending gift research data across 6 categories.

## Features

- 📊 **60 Gift Database** - 6 categories (Overall, Tech, Fashion, Sports, Under $50, New & Launched)
- 📅 **Multi-Week Archive** - View historical data week by week
- 🔍 **Search & Filter** - Find gifts by name, category, or price
- 📱 **Social Content Dashboard** - Pre-written posts for Instagram, Twitter, TikTok, LinkedIn
- 💾 **Export to CSV** - Download data for analysis
- 🔐 **Password Protected** - Secure access via Netlify Identity

## Access

The dashboard is hosted at:
https://gift-genie-dashboard.netlify.app

## Categories

1. **🌟 Overall** - Top trending gifts across all categories
2. **💻 Tech** - Gadgets, electronics, smart devices
3. **👗 Fashion** - Clothing, accessories, jewelry
4. **⚽ Sports** - Fitness gear, outdoor equipment
5. **💰 Under $50** - Best budget-friendly gifts
6. **✨ New & Launched** - Products from the last 2 weeks

## Data Updates

- **Gift Research**: Every Monday at 9 AM MST (automated)
- **Social Content**: Every Wednesday at 10 AM MST (automated)
- **Archive**: Historical weeks preserved automatically

## Local Development

```bash
# Start local server
python3 -m http.server 8888

# View dashboard
open http://localhost:8888/gift-trends.html
```

## File Structure

```
├── gift-trends.html          # Main dashboard
├── social-content.html       # Social media content
├── data/
│   ├── gift-trends-latest.json
│   ├── index.json
│   ├── archive/              # Historical weeks
│   └── social/               # Social content
├── images/                   # Product images
└── README.md
```

## Brand

Built for [Gift Genie](https://giftgenie.info) - Never forget a gift again.

---

*Last updated: February 2026*
EOF

echo "✅ README created"
echo ""

# Initialize git
echo "🔧 Step 2: Initializing git repository..."
git init
git add .
git commit -m "Initial dashboard with 60 gifts and social content"

echo "✅ Git repository initialized"
echo ""

# Instructions
echo "📋 Step 3: Create GitHub Repository"
echo "==================================="
echo ""
echo "1. Go to https://github.com/new"
echo "2. Repository name: gift-genie-dashboard"
echo "3. Make it: Private (recommended for password protection)"
echo "4. DO NOT initialize with README, .gitignore, or license"
echo "5. Click 'Create repository'"
echo ""
echo "6. Then run these commands:"
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/gift-genie-dashboard.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""

# Create a helper script
cat > push-to-github.sh << 'PUSHEOF'
#!/bin/bash
# Push to GitHub - Run this after creating the GitHub repo

echo "Pushing to GitHub..."

# Check if remote exists
if git remote | grep -q "origin"; then
    echo "Remote already exists, updating..."
else
    echo "Enter your GitHub username:"
    read username
    git remote add origin https://github.com/$username/gift-genie-dashboard.git
fi

git branch -M main
git push -u origin main

echo "✅ Pushed to GitHub!"
echo ""
echo "Next step: Deploy to Netlify"
echo "Run: ./deploy-to-netlify.sh"
PUSHEOF

chmod +x push-to-github.sh

echo "✅ Created push-to-github.sh helper script"
echo ""

# Create Netlify deploy script
cat > deploy-to-netlify.sh << 'NETLIFYEOF'
#!/bin/bash
# Deploy to Netlify with password protection

echo "🚀 Deploy to Netlify"
echo "===================="
echo ""
echo "1. Go to https://app.netlify.com"
echo "2. Click 'Add new site' → 'Import an existing project'"
echo "3. Choose GitHub and authorize"
echo "4. Select: gift-genie-dashboard"
echo "5. Build settings (leave defaults):"
echo "   - Build command: (empty)"
echo "   - Publish directory: /"
echo "6. Click 'Deploy site'"
echo ""
echo "After deploy, set up password protection:"
echo ""
echo "7. In Netlify dashboard:"
echo "   Site settings → Identity → 'Enable Identity'"
echo "   Registration → 'Invite only'"
echo "   Services → Enable 'Git Gateway'"
echo "   Identity → 'Invite users' → Add partner's email"
echo ""
echo "8. Add login widget to gift-trends.html (see docs/SHARE_WITH_PARTNER.md)"
echo "9. Commit and push the change"
echo ""
echo "Your dashboard will be at: https://gift-genie-dashboard-xxx.netlify.app"
NETLIFYEOF

chmod +x deploy-to-netlify.sh

echo "✅ Created deploy-to-netlify.sh helper script"
echo ""

echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Create GitHub repo at https://github.com/new"
echo "2. Run: ./push-to-github.sh"
echo "3. Run: ./deploy-to-netlify.sh"
echo ""
echo "📖 Full instructions in docs/SHARE_WITH_PARTNER.md"
