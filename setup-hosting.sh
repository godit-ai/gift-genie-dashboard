#!/bin/bash
# Gift Genie Dashboard Setup Script
# This script helps you set up the dashboard with multi-week support and deploy to hosting

echo "🎁 Gift Genie Dashboard Setup"
echo "=============================="
echo ""

# Check if we're in the right directory
if [ ! -f "gift-trends.html" ]; then
    echo "❌ Error: Please run this script from the dashboard directory"
    exit 1
fi

echo "✅ Found dashboard files"
echo ""

# Create archive directory structure
echo "📁 Setting up archive structure..."
mkdir -p data/archive
cp data/gift-trends-latest.json "data/archive/week-$(date +%Y-%m-%d).json"
echo "✅ Archive directory created"
echo ""

# Create index.json if it doesn't exist
if [ ! -f "data/index.json" ]; then
echo "📝 Creating archive index..."
cat > data/index.json << 'EOF'
{
  "version": "1.0",
  "currentWeek": "$(date +%Y-%m-%d)",
  "weeks": [],
  "months": []
}
EOF
echo "✅ Index created"
echo ""
fi

# Check for Git
echo "🔍 Checking prerequisites..."
if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install Git first."
    exit 1
fi
echo "✅ Git found"
echo ""

# GitHub setup instructions
echo "📋 Next Steps:"
echo "=============="
echo ""
echo "1. Create GitHub Repository:"
echo "   - Go to https://github.com/new"
echo "   - Name: gift-genie-dashboard"
echo "   - Make it Private (for password protection)"
echo "   - Don't initialize with README"
echo ""
echo "2. Push to GitHub:"
echo "   cd $(pwd)"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial dashboard commit'"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/YOUR_USERNAME/gift-genie-dashboard.git"
echo "   git push -u origin main"
echo ""
echo "3. Deploy to Netlify (Recommended):"
echo "   a. Go to https://app.netlify.com"
echo "   b. Click 'Add new site' → 'Import an existing project'"
echo "   c. Choose GitHub and select your repo"
echo "   d. Build settings: leave default (no build command needed)"
echo "   e. Click Deploy"
echo ""
echo "4. Enable Password Protection:"
echo "   a. In Netlify, go to Site settings → Identity"
echo "   b. Click 'Enable Identity'"
echo "   c. Go to 'Registration' tab"
echo "   d. Set 'Registration preferences' to 'Invite only'"
echo "   e. In 'External providers', enable Google or GitHub (optional)"
echo "   f. Click 'Services' tab and enable 'Git Gateway'"
echo "   g. Go to Identity → 'Invite users' and add your business partner's email"
echo ""
echo "5. Add Login Widget to Dashboard:"
echo "   - Open gift-trends.html"
echo "   - Add this before </body>:"
echo ""
cat << 'NETLIFY_CODE'
   <script src="https://identity.netlify.com/v1/netlify-identity-widget.js"></script>
   <script>
     if (window.netlifyIdentity) {
       window.netlifyIdentity.on("init", user => {
         if (!user) {
           window.netlifyIdentity.on("login", () => {
             document.location.href = "/";
           });
         }
       });
     }
   </script>
NETLIFY_CODE
echo ""
echo "6. Your partner will receive an email invite to access the dashboard"
echo ""
echo "🌐 Dashboard will be available at: https://gift-genie-dashboard.netlify.app"
echo ""

# Create weekly archive script
cat > ../scripts/archive-weekly-data.sh << 'ARCHIVE_EOF'
#!/bin/bash
# Archive Weekly Data Script
# Run this after each weekly research completes

DATE=$(date +%Y-%m-%d)
WEEK_NUM=$(date +%V)

echo "📦 Archiving week $DATE..."

# Copy current data to archive
cp dashboard/data/gift-trends-latest.json "dashboard/data/archive/week-$DATE.json"

# Update index.json
node -e "
const fs = require('fs');
const index = JSON.parse(fs.readFileSync('dashboard/data/index.json', 'utf8'));
const data = JSON.parse(fs.readFileSync('dashboard/data/gift-trends-latest.json', 'utf8'));

const weekInfo = {
  date: '$DATE',
  weekNumber: $WEEK_NUM,
  file: 'week-$DATE.json',
  label: new Date('$DATE').toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }),
  gifts: Object.values(data.reports).reduce((sum, r) => sum + (r.gifts?.length || 0), 0),
  categories: Object.keys(data.reports)
};

// Add week if not exists
if (!index.weeks.find(w => w.date === '$DATE')) {
  index.weeks.push(weekInfo);
  index.weeks.sort((a, b) => new Date(b.date) - new Date(a.date));
}

index.currentWeek = '$DATE';
index.stats.totalWeeks = index.weeks.length;
index.stats.totalGifts = index.weeks.reduce((sum, w) => sum + w.gifts, 0);
index.stats.dateRange.end = '$DATE';

fs.writeFileSync('dashboard/data/index.json', JSON.stringify(index, null, 2));
console.log('✅ Archive updated');
"

echo "✅ Week $DATE archived successfully"
ARCHIVE_EOF

chmod +x ../scripts/archive-weekly-data.sh
echo "✅ Created archive-weekly-data.sh script"
echo ""

echo "🚀 Ready to deploy!"
echo ""
echo "Run this script anytime to archive a new week:"
echo "   ./scripts/archive-weekly-data.sh"
