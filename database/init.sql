-- NBA Player Endorsement Tracker Database Schema
-- Optimized for analytics and portfolio demonstration

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- DIMENSION TABLES
-- ============================================================================

-- Players dimension table (sourced from NBA API)
CREATE TABLE players (
    player_id VARCHAR(20) PRIMARY KEY,  -- NBA API person_id
    full_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    team_abbreviation VARCHAR(3),
    team_name VARCHAR(100),
    position VARCHAR(10),
    jersey_number INTEGER,
    height_cm INTEGER,
    weight_kg INTEGER,
    birth_date DATE,
    country VARCHAR(50),
    -- Performance metrics (for correlation analysis)
    career_ppg DECIMAL(5,2),
    career_apg DECIMAL(5,2),
    career_rpg DECIMAL(5,2),
    allstar_selections INTEGER DEFAULT 0,
    championships INTEGER DEFAULT 0,
    -- Derived player tier for segmentation
    player_tier VARCHAR(20) CHECK (player_tier IN ('Superstar', 'All-Star', 'Starter', 'Role Player', 'Rookie')),
    -- Metadata
    is_active BOOLEAN DEFAULT TRUE,
    nba_debut_year INTEGER,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Brand dimension table
CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) UNIQUE NOT NULL,
    brand_category VARCHAR(50) NOT NULL,  -- Footwear, Apparel, Beverage, Tech, Financial, etc.
    parent_company VARCHAR(100),
    brand_hq_country VARCHAR(50),
    brand_tier VARCHAR(20) CHECK (brand_tier IN ('Premium', 'Mass Market', 'Niche', 'Emerging')),
    website_url VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- FACT TABLE
-- ============================================================================

-- Endorsement deals fact table
CREATE TABLE endorsements (
    endorsement_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_id VARCHAR(20) NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    brand_id INTEGER REFERENCES brands(brand_id) ON DELETE SET NULL,
    brand_name VARCHAR(100) NOT NULL,  -- Denormalized for performance

    -- Contract financials
    deal_value_usd BIGINT,  -- In USD cents to avoid floating point issues (e.g., 20000000 = $20M)
    deal_value_type VARCHAR(20) CHECK (deal_value_type IN ('annual', 'total', 'estimated_annual', 'estimated_total')),
    deal_value_min BIGINT,  -- For reported ranges like "$5-7M"
    deal_value_max BIGINT,
    value_confidence VARCHAR(20) NOT NULL DEFAULT 'unverified' CHECK (value_confidence IN ('confirmed', 'estimated', 'rumored', 'unverified')),

    -- Contract timeline
    contract_start_date DATE,
    contract_end_date DATE,
    contract_duration_years INTEGER,
    is_lifetime_deal BOOLEAN DEFAULT FALSE,

    -- Deal structure details
    deal_type VARCHAR(50),  -- 'cash', 'equity', 'cash+equity', 'product_only', 'revenue_share'
    has_signature_line BOOLEAN DEFAULT FALSE,
    signature_product_name VARCHAR(200),
    equity_percentage DECIMAL(5,2),
    performance_bonuses JSONB,  -- Structured data for bonus clauses

    -- Data provenance & quality
    data_source VARCHAR(500),  -- URL or source identifier
    source_type VARCHAR(50) CHECK (source_type IN ('nba_api', 'press_release', 'news_article', 'social_media', 'manual_entry', 'spotrac', 'other')),
    scraped_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_verified TIMESTAMP,

    -- Status flags
    is_active BOOLEAN DEFAULT TRUE,
    needs_verification BOOLEAN DEFAULT FALSE,
    is_public BOOLEAN DEFAULT TRUE,  -- Hide unverified deals from public dashboard
    notes TEXT,

    -- Audit trail
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- METADATA TABLES
-- ============================================================================

-- Scraper run metadata for monitoring
CREATE TABLE scrape_metadata (
    run_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    run_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    scraper_version VARCHAR(20),
    players_processed INTEGER DEFAULT 0,
    endorsements_found INTEGER DEFAULT 0,
    endorsements_new INTEGER DEFAULT 0,
    endorsements_updated INTEGER DEFAULT 0,
    errors_count INTEGER DEFAULT 0,
    runtime_seconds INTEGER,
    triggered_by VARCHAR(50) CHECK (triggered_by IN ('scheduled', 'manual_dashboard', 'api_call', 'cli')),
    status VARCHAR(20) CHECK (status IN ('running', 'completed', 'failed', 'partial')),
    error_log TEXT,
    completed_at TIMESTAMP
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Player indexes
CREATE INDEX idx_players_tier ON players(player_tier);
CREATE INDEX idx_players_team ON players(team_abbreviation);
CREATE INDEX idx_players_active ON players(is_active);
CREATE INDEX idx_players_name ON players(full_name);

-- Brand indexes
CREATE INDEX idx_brands_category ON brands(brand_category);
CREATE INDEX idx_brands_name ON brands(brand_name);

-- Endorsement indexes (critical for dashboard queries)
CREATE INDEX idx_endorsements_player ON endorsements(player_id);
CREATE INDEX idx_endorsements_brand ON endorsements(brand_id);
CREATE INDEX idx_endorsements_active ON endorsements(is_active);
CREATE INDEX idx_endorsements_public ON endorsements(is_public);
CREATE INDEX idx_endorsements_value ON endorsements(deal_value_usd DESC NULLS LAST);
CREATE INDEX idx_endorsements_dates ON endorsements(contract_start_date, contract_end_date);
CREATE INDEX idx_endorsements_confidence ON endorsements(value_confidence);

-- Composite index for common dashboard queries
CREATE INDEX idx_endorsements_active_public ON endorsements(is_active, is_public) WHERE is_active = TRUE AND is_public = TRUE;

-- ============================================================================
-- MATERIALIZED VIEWS FOR DASHBOARD PERFORMANCE
-- ============================================================================

-- Player endorsement summary (pre-aggregated for leaderboard)
CREATE MATERIALIZED VIEW player_endorsement_summary AS
SELECT
    p.player_id,
    p.full_name,
    p.team_abbreviation,
    p.position,
    p.player_tier,
    p.allstar_selections,
    COUNT(DISTINCT e.endorsement_id) FILTER (WHERE e.is_active = TRUE AND e.is_public = TRUE) AS active_deals_count,
    -- Normalized annual value calculation
    SUM(
        CASE
            WHEN e.deal_value_type LIKE '%annual%' THEN e.deal_value_usd
            WHEN e.deal_value_type LIKE '%total%' AND e.contract_duration_years > 0
                THEN e.deal_value_usd / e.contract_duration_years
            ELSE e.deal_value_usd
        END
    ) FILTER (WHERE e.is_active = TRUE AND e.is_public = TRUE AND e.deal_value_usd IS NOT NULL) AS total_annual_value_usd,
    AVG(
        CASE
            WHEN e.deal_value_type LIKE '%annual%' THEN e.deal_value_usd
            WHEN e.deal_value_type LIKE '%total%' AND e.contract_duration_years > 0
                THEN e.deal_value_usd / e.contract_duration_years
            ELSE e.deal_value_usd
        END
    ) FILTER (WHERE e.is_active = TRUE AND e.is_public = TRUE AND e.deal_value_usd IS NOT NULL) AS avg_deal_value_usd,
    MAX(e.deal_value_usd) FILTER (WHERE e.is_active = TRUE AND e.is_public = TRUE) AS top_deal_value_usd,
    STRING_AGG(DISTINCT e.brand_name, ', ' ORDER BY e.brand_name) FILTER (WHERE e.is_active = TRUE AND e.is_public = TRUE) AS brands,
    MAX(e.contract_end_date) FILTER (WHERE e.is_active = TRUE) AS next_expiration,
    p.last_updated
FROM players p
LEFT JOIN endorsements e ON p.player_id = e.player_id
WHERE p.is_active = TRUE
GROUP BY p.player_id, p.full_name, p.team_abbreviation, p.position, p.player_tier, p.allstar_selections, p.last_updated;

CREATE UNIQUE INDEX idx_player_summary_id ON player_endorsement_summary(player_id);

-- Brand portfolio summary
CREATE MATERIALIZED VIEW brand_portfolio_summary AS
SELECT
    b.brand_id,
    b.brand_name,
    b.brand_category,
    b.brand_tier,
    COUNT(DISTINCT e.player_id) FILTER (WHERE e.is_active = TRUE) AS athletes_signed,
    SUM(
        CASE
            WHEN e.deal_value_type LIKE '%annual%' THEN e.deal_value_usd
            WHEN e.deal_value_type LIKE '%total%' AND e.contract_duration_years > 0
                THEN e.deal_value_usd / e.contract_duration_years
            ELSE e.deal_value_usd
        END
    ) FILTER (WHERE e.is_active = TRUE AND e.deal_value_usd IS NOT NULL) AS total_annual_spend_usd,
    AVG(p.allstar_selections) FILTER (WHERE e.is_active = TRUE) AS avg_player_prestige,
    STRING_AGG(DISTINCT p.full_name, ', ' ORDER BY p.full_name) FILTER (WHERE e.is_active = TRUE) AS athlete_roster
FROM brands b
LEFT JOIN endorsements e ON b.brand_id = e.brand_id
LEFT JOIN players p ON e.player_id = p.player_id
GROUP BY b.brand_id, b.brand_name, b.brand_category, b.brand_tier;

CREATE UNIQUE INDEX idx_brand_summary_id ON brand_portfolio_summary(brand_id);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_endorsements_updated_at
    BEFORE UPDATE ON endorsements
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to refresh materialized views (call after data updates)
CREATE OR REPLACE FUNCTION refresh_dashboard_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY player_endorsement_summary;
    REFRESH MATERIALIZED VIEW CONCURRENTLY brand_portfolio_summary;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- INITIAL DATA - Brand categories
-- ============================================================================

INSERT INTO brands (brand_name, brand_category, parent_company, brand_tier) VALUES
    ('Nike', 'Footwear', 'Nike Inc.', 'Premium'),
    ('Adidas', 'Footwear', 'Adidas AG', 'Premium'),
    ('Under Armour', 'Apparel', 'Under Armour Inc.', 'Premium'),
    ('Puma', 'Footwear', 'Puma SE', 'Premium'),
    ('New Balance', 'Footwear', 'New Balance Inc.', 'Mass Market'),
    ('Jordan Brand', 'Footwear', 'Nike Inc.', 'Premium'),
    ('Anta', 'Footwear', 'Anta Sports', 'Mass Market'),
    ('Li-Ning', 'Footwear', 'Li-Ning Company', 'Mass Market'),
    ('Gatorade', 'Beverage', 'PepsiCo', 'Premium'),
    ('Coca-Cola', 'Beverage', 'The Coca-Cola Company', 'Premium'),
    ('Pepsi', 'Beverage', 'PepsiCo', 'Mass Market'),
    ('Beats', 'Tech', 'Apple Inc.', 'Premium'),
    ('State Farm', 'Insurance', 'State Farm Insurance', 'Mass Market'),
    ('AT&T', 'Telecom', 'AT&T Inc.', 'Mass Market'),
    ('2K Sports', 'Gaming', 'Take-Two Interactive', 'Mass Market'),
    ('Panini', 'Trading Cards', 'Panini Group', 'Niche')
ON CONFLICT (brand_name) DO NOTHING;
