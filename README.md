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
