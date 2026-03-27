# NBA Player Endorsement Analytics Dashboard

> **Elite sports analytics platform** tracking NBA player endorsement deals with professional-grade UI/UX and comprehensive market intelligence.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![Dashboard Preview](https://img.shields.io/badge/Status-Active_Development-blue)

---

## 🎯 Current Project Status

### ✅ Completed Features

**Data Layer:**
- ✅ PostgreSQL database with 6 tables, 2 materialized views, comprehensive indexing
- ✅ 40 NBA players with complete profiles (team, position, tier, All-Star selections)
- ✅ 84 active endorsement deals across 11 categories
- ✅ $522M total annual endorsement value
- ✅ 41 brands across footwear, tech, finance, food/beverage, automotive, gaming, and more

**API Layer:**
- ✅ FastAPI backend with 15+ RESTful endpoints
- ✅ Dashboard stats, player leaderboard, category breakdown endpoints
- ✅ Materialized views for optimized analytics queries
- ✅ Auto-generated OpenAPI documentation at `/docs`
- ✅ CORS-enabled for frontend consumption

**Frontend Layer:**
- ✅ **Premium player cards** with team colors, avatars, brand logos, rank badges
- ✅ **Brand power rankings** showing market distribution by category
- ✅ **Top 10 players bar chart** with gold/silver/bronze visual hierarchy
- ✅ **40+ brand logo system** with official colors (Nike, Adidas, Google, Chase, etc.)
- ✅ **30 NBA team color schemes** (official brand colors)
- ✅ Search functionality (player name or brand)
- ✅ Tier filtering (Superstar, All-Star, Starter, Role Player)
- ✅ Dark mode support
- ✅ Fully responsive design

**Design System:**
- ✅ Sports-first visual hierarchy (players are heroes)
- ✅ Professional typography and spacing
- ✅ Team-branded color accents
- ✅ Brand logo visual identification
- ✅ Elite header with gradient and grid texture
- ✅ Premium stat cards with category-specific gradients

### 📊 Current Data Snapshot

```
Players:        40 NBA athletes
Deals:          84 active endorsements
Market Value:   $522M annual
Categories:     11 (Footwear 37.5%, Food/Bev 13.2%, Tech 10.6%, Finance 8%, etc.)
Top Player:     LeBron James ($196M/year from 20 deals)
Top Brands:     Nike, Under Armour, Adidas, Google, Chase, Gatorade
```

---

## 🚀 Quick Start (5 Minutes)

### Prerequisites

- **Docker Desktop** (recommended) OR
- Python 3.11+, Node.js 20+, PostgreSQL 15+

### Option 1: Docker (Recommended)

```bash
# 1. Clone repository
git clone <your-repo-url>
cd Athlete-Brand-Value-Dashboard

# 2. Start all services
docker compose up -d

# 3. Verify services are running
docker compose ps
# Should see: endorsement_db (healthy), endorsement_api (up), endorsement_frontend (up)

# 4. Access the application
# Frontend:  http://localhost:3000
# API Docs:  http://localhost:8000/docs
# Database:  localhost:5432 (postgres/postgres)
```

**The database is already seeded!** You should immediately see 40 players with 84 deals when you open http://localhost:3000.

### Option 2: Manual Setup

See [MANUAL_SETUP.md](./manual-setup.sh) for detailed instructions.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│  FRONTEND (Next.js 14 + TypeScript + Tailwind)         │
│  - Premium player cards with team branding              │
│  - Brand power rankings & market analytics              │
│  - 40+ brand logos, 30 team color schemes              │
│  - Search, filter, sort functionality                   │
│  Port: 3000                                             │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP/REST
┌────────────────────▼────────────────────────────────────┐
│  API (FastAPI + Pydantic + SQLAlchemy)                  │
│  - /api/dashboard/stats                                 │
│  - /api/dashboard/leaderboard                           │
│  - /api/dashboard/category-breakdown                    │
│  - /api/players, /api/endorsements                      │
│  Port: 8000                                             │
└────────────────────┬────────────────────────────────────┘
                     │ SQLAlchemy ORM
┌────────────────────▼────────────────────────────────────┐
│  DATABASE (PostgreSQL 15)                               │
│  Tables: players, brands, endorsements, scrape_metadata │
│  Views:  player_endorsement_summary (materialized)      │
│          brand_portfolio_summary (materialized)         │
│  Port: 5432                                             │
└─────────────────────────────────────────────────────────┘
```

### Key Files & Directories

```
Athlete-Brand-Value-Dashboard/
├── backend/
│   ├── app/
│   │   ├── main.py              # FastAPI application entry
│   │   ├── models.py            # SQLAlchemy ORM models
│   │   ├── schemas.py           # Pydantic validation schemas
│   │   ├── routes/
│   │   │   ├── dashboard.py     # Dashboard analytics endpoints
│   │   │   ├── players.py       # Player CRUD endpoints
│   │   │   ├── endorsements.py  # Endorsement endpoints
│   │   │   └── brands.py        # Brand endpoints
│   │   └── scraper/             # Data collection scripts
│   └── requirements.txt
│
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   │   └── page.tsx         # Main dashboard page
│   │   ├── components/
│   │   │   ├── PlayerCardPremium.tsx      # Premium player cards
│   │   │   ├── BrandPowerRankings.tsx     # Category market analysis
│   │   │   ├── TopPlayersChart.tsx        # Bar chart visualization
│   │   │   ├── BrandLogo.tsx              # Brand logo system (40+ brands)
│   │   │   ├── StatCard.tsx               # Hero stat cards
│   │   │   └── FilterPanel.tsx            # Tier filtering
│   │   ├── lib/
│   │   │   ├── team-colors.ts   # NBA team color schemes (30 teams)
│   │   │   ├── utils.ts         # Utility functions
│   │   │   └── api.ts           # API client functions
│   │   └── types/               # TypeScript type definitions
│   └── package.json
│
├── database/
│   └── init.sql                 # Database schema & initial setup
│
├── scripts/
│   └── (seed scripts - data already in DB)
│
├── docker-compose.yml           # Multi-container orchestration
├── .env                         # Environment variables (already configured)
└── README.md                    # This file
```

---

## 📊 Database Schema

### Core Tables

**players** (40 records)
- player_id, full_name, team_abbreviation, position
- player_tier (Superstar/All-Star/Starter/Role Player)
- allstar_selections, is_active
- Includes: LeBron, Curry, Durant, Giannis, Luka, etc.

**brands** (41 records)
- brand_id, brand_name, brand_category
- parent_company, brand_tier
- Categories: Footwear/Apparel, Technology, Financial/Insurance, Food/Beverage, Automotive, Gaming/Media, Crypto/Finance, E-Commerce, Luxury Goods, Telecom

**endorsements** (84 active records)
- endorsement_id, player_id, brand_name
- deal_value_usd (stored in cents for precision)
- deal_value_type (annual/total)
- value_confidence (confirmed/estimated/rumored)
- contract_start_date, contract_end_date
- equity_percentage, is_active, is_public

### Materialized Views

**player_endorsement_summary**
- Pre-aggregated player stats (total value, deal count, avg deal, top brands)
- Refreshed via `SELECT refresh_dashboard_views();`
- Powers the leaderboard endpoint

---

## 🎨 Design System

### Brand Logo System (40+ Brands)

Located in: `frontend/src/components/BrandLogo.tsx`

Supported brands with official colors:
- **Footwear**: Nike, Jordan Brand, Adidas, Under Armour, New Balance, Puma, Anta, Li-Ning
- **Tech**: Apple, Google, Samsung, Meta, Sony, Beats by Dre, JBL
- **Finance**: Chase, American Express, State Farm, Coinbase, Crypto.com
- **Food/Bev**: Gatorade, Pepsi, Coca-Cola, Mountain Dew, Subway, Taco Bell
- **Auto**: Kia, Toyota, BMW
- **Media**: 2K Sports, Panini
- **And more...**

### Team Color System (30 NBA Teams)

Located in: `frontend/src/lib/team-colors.ts`

All 30 NBA teams with official primary, secondary, and accent colors:
- Lakers: Purple + Gold
- Warriors: Blue + Gold
- Celtics: Green + Gold
- Heat: Red + Orange
- Bucks: Green + Cream
- *...and 25 more*

---

## 🔌 API Endpoints

### Dashboard Analytics

```http
GET  /api/dashboard/stats
GET  /api/dashboard/leaderboard?tier=Superstar&limit=50
GET  /api/dashboard/category-breakdown
POST /api/dashboard/refresh-views
```

### Players

```http
GET  /api/players
GET  /api/players/{player_id}
GET  /api/players/{player_id}/endorsements
```

### Endorsements

```http
GET   /api/endorsements
POST  /api/endorsements
PATCH /api/endorsements/{endorsement_id}
```

### Interactive API Documentation

Visit http://localhost:8000/docs for full Swagger UI documentation with try-it-now functionality.

---

## 🛠️ Development Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f

# Restart individual service
docker compose restart frontend
docker compose restart api
docker compose restart db

# Check service status
docker compose ps

# Access database CLI
docker compose exec db psql -U postgres -d endorsement_tracker

# Rebuild after code changes
docker compose up -d --build

# Clean up (removes volumes - will delete data!)
docker compose down -v
```

---

## 📈 Next Development Steps

### High Priority (MVP Completion)

1. **Player Photos Integration**
   - NBA API has player headshots: `https://cdn.nba.com/headshots/nba/latest/1040x760/{player_id}.png`
   - Replace initials with real photos in `PlayerCardPremium.tsx`
   - Add fallback to initials if image fails

2. **Add More Data**
   - Currently 84 deals across 10 players
   - Expand to 50+ players with 200+ deals
   - Script template exists in `scripts/insert_comprehensive_endorsements.py`
   - Can be run via: `docker compose exec api python -c "..."`

3. **Advanced Filtering**
   - Add team filter dropdown (30 teams)
   - Add brand category filter (11 categories)
   - Add value range slider ($1M - $50M+)
   - Add date range filter (active in 2024, expiring soon, etc.)

### Medium Priority (Enhanced Features)

4. **Player Detail Modal/Page**
   - Click player card to open detailed view
   - Full deal list with start/end dates
   - Deal timeline visualization
   - Contract structure breakdown (cash vs equity)
   - Social media stats (if available)

5. **Brand Analytics View**
   - New tab/page: "By Brand" view
   - Which brands invest most in NBA?
   - Average deal size by brand
   - Player roster by brand (Nike's athletes, Adidas's athletes)

6. **Recent Deals Feed**
   - Timeline of recent signings
   - "Deals expiring in next 6 months" section
   - "New deals announced this month"

7. **Comparison Tool**
   - Select 2-3 players to compare side-by-side
   - Deal count, value, brand overlap analysis

### Lower Priority (Nice-to-Have)

8. **Export Functionality**
   - Download data as CSV/Excel
   - Generate PDF reports

9. **Historical Tracking**
   - Track deal value changes over time
   - Expired contracts view
   - Career earnings timeline

10. **Predictive Analytics**
    - Contract expiration alerts
    - Rising star detection (young players with growing portfolios)

---

## 🐛 Known Issues & Notes

### Current Limitations

1. **Player Photos**: Using initials instead of real headshots (easy to fix - see Next Steps #1)
2. **Data Scope**: 84 deals for 10 top players (needs expansion to 200+ deals across 50 players)
3. **No User Authentication**: Dashboard is public (not needed for portfolio/analytics use case)
4. **Static Tier Filter**: Only supports player tier filtering, not team/brand/value

### Technical Notes

- **Deal values in cents**: All `deal_value_usd` fields are stored as BIGINT in cents to avoid floating-point precision issues. Frontend converts to millions/billions for display.
- **Materialized views**: `player_endorsement_summary` must be refreshed after bulk data updates. API endpoint: `POST /api/dashboard/refresh-views`
- **Docker warnings**: `docker-compose.yml: the attribute 'version' is obsolete` - safe to ignore, cosmetic warning only
- **NBA API timeout**: The live NBA API can be slow/unreliable. Current data was seeded manually. For production, consider caching or scheduled scraping.

---

## 📚 Additional Resources

### Data Sources

- **Player data**: NBA Stats API via `nba_api` Python library
- **Endorsement values**: Public reporting (ESPN, Sports Business Journal, Spotrac estimates)
- **Brand info**: Company websites, press releases
- **Confidence levels**:
  - "confirmed" = Official press release
  - "estimated" = Industry reporting
  - "rumored" = Unverified sources

### Design Inspiration

- **ESPN Stats & Info**: Player-first design, team branding
- **NBA.com**: Official team colors, clean typography
- **The Athletic**: Premium editorial feel
- **Sportradar**: Data density, actionable insights

### Tech Documentation

- [Next.js 14 Docs](https://nextjs.org/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Recharts Examples](https://recharts.org/en-US/examples)
- [Tailwind CSS](https://tailwindcss.com/docs)

---

## 🤝 Contributing

This is a portfolio project. If continuing development:

1. **Branch naming**: `feature/player-photos`, `fix/api-timeout`, etc.
2. **Commit messages**: Descriptive (e.g., "Add player headshot integration with NBA CDN")
3. **Testing**: Test changes locally with `docker compose up -d` before committing
4. **Documentation**: Update this README if adding major features

---

## 📝 License

MIT License - see LICENSE file for details

---

## 🎓 Project Learnings

This project demonstrates:

✅ **Full-Stack Development**: Next.js frontend + FastAPI backend + PostgreSQL database
✅ **Database Design**: Star schema, materialized views, indexing strategies
✅ **API Design**: RESTful endpoints, OpenAPI docs, Pydantic validation
✅ **Frontend Engineering**: TypeScript, component architecture, responsive design
✅ **UI/UX Design**: Sports analytics patterns, visual hierarchy, brand systems
✅ **DevOps**: Docker containerization, multi-service orchestration
✅ **Data Engineering**: ETL concepts, data normalization, aggregation queries

---

**Last Updated**: March 26, 2026
**Current Version**: v1.0-alpha
**Status**: Active Development
