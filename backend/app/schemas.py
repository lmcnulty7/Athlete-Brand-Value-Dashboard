"""Pydantic schemas for request/response validation."""
from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime, date
from typing import Optional, Literal
from uuid import UUID


# ============================================================================
# PLAYER SCHEMAS
# ============================================================================

class PlayerBase(BaseModel):
    """Base player attributes."""
    full_name: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    team_abbreviation: Optional[str] = None
    team_name: Optional[str] = None
    position: Optional[str] = None
    jersey_number: Optional[int] = None
    height_cm: Optional[int] = None
    weight_kg: Optional[int] = None
    birth_date: Optional[date] = None
    country: Optional[str] = None
    career_ppg: Optional[float] = None
    career_apg: Optional[float] = None
    career_rpg: Optional[float] = None
    allstar_selections: int = 0
    championships: int = 0
    player_tier: Optional[Literal['Superstar', 'All-Star', 'Starter', 'Role Player', 'Rookie']] = None
    is_active: bool = True
    nba_debut_year: Optional[int] = None


class PlayerCreate(PlayerBase):
    """Schema for creating a player."""
    player_id: str


class PlayerResponse(PlayerBase):
    """Schema for player API response."""
    player_id: str
    last_updated: datetime
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class PlayerWithEndorsements(PlayerResponse):
    """Player with endorsement summary."""
    endorsement_count: int = 0
    total_endorsement_value: Optional[int] = None  # In USD cents


# ============================================================================
# BRAND SCHEMAS
# ============================================================================

class BrandBase(BaseModel):
    """Base brand attributes."""
    brand_name: str
    brand_category: str
    parent_company: Optional[str] = None
    brand_hq_country: Optional[str] = None
    brand_tier: Optional[Literal['Premium', 'Mass Market', 'Niche', 'Emerging']] = None
    website_url: Optional[str] = None


class BrandCreate(BrandBase):
    """Schema for creating a brand."""
    pass


class BrandResponse(BrandBase):
    """Schema for brand API response."""
    brand_id: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ============================================================================
# ENDORSEMENT SCHEMAS
# ============================================================================

class EndorsementBase(BaseModel):
    """Base endorsement attributes."""
    brand_name: str
    deal_value_usd: Optional[int] = Field(None, description="Deal value in USD cents")
    deal_value_type: Optional[Literal['annual', 'total', 'estimated_annual', 'estimated_total']] = None
    deal_value_min: Optional[int] = None
    deal_value_max: Optional[int] = None
    value_confidence: Literal['confirmed', 'estimated', 'rumored', 'unverified'] = 'unverified'
    contract_start_date: Optional[date] = None
    contract_end_date: Optional[date] = None
    contract_duration_years: Optional[int] = None
    is_lifetime_deal: bool = False
    deal_type: Optional[str] = None
    has_signature_line: bool = False
    signature_product_name: Optional[str] = None
    equity_percentage: Optional[float] = None
    performance_bonuses: Optional[dict] = None
    data_source: Optional[str] = None
    source_type: Optional[Literal['nba_api', 'press_release', 'news_article', 'social_media', 'manual_entry', 'spotrac', 'other']] = 'manual_entry'
    is_active: bool = True
    needs_verification: bool = False
    is_public: bool = True
    notes: Optional[str] = None


class EndorsementCreate(EndorsementBase):
    """Schema for creating an endorsement."""
    player_id: str
    brand_id: Optional[int] = None


class EndorsementUpdate(BaseModel):
    """Schema for updating an endorsement (all fields optional)."""
    brand_name: Optional[str] = None
    deal_value_usd: Optional[int] = None
    deal_value_type: Optional[Literal['annual', 'total', 'estimated_annual', 'estimated_total']] = None
    value_confidence: Optional[Literal['confirmed', 'estimated', 'rumored', 'unverified']] = None
    contract_start_date: Optional[date] = None
    contract_end_date: Optional[date] = None
    is_active: Optional[bool] = None
    needs_verification: Optional[bool] = None
    notes: Optional[str] = None


class EndorsementResponse(EndorsementBase):
    """Schema for endorsement API response."""
    endorsement_id: UUID
    player_id: str
    brand_id: Optional[int]
    scraped_date: datetime
    last_verified: Optional[datetime]
    created_at: datetime
    updated_at: datetime

    # Nested relationships
    player_name: Optional[str] = None
    brand_category: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


# ============================================================================
# SUMMARY / ANALYTICS SCHEMAS
# ============================================================================

class PlayerSummary(BaseModel):
    """Player endorsement summary for leaderboard."""
    player_id: str
    full_name: str
    team_abbreviation: Optional[str]
    position: Optional[str]
    player_tier: Optional[str]
    allstar_selections: int
    active_deals_count: int
    total_annual_value_usd: Optional[int]
    avg_deal_value_usd: Optional[int]
    top_deal_value_usd: Optional[int]
    brands: Optional[str]
    next_expiration: Optional[date]

    model_config = ConfigDict(from_attributes=True)


class BrandSummary(BaseModel):
    """Brand portfolio summary."""
    brand_id: int
    brand_name: str
    brand_category: str
    brand_tier: Optional[str]
    athletes_signed: int
    total_annual_spend_usd: Optional[int]
    avg_player_prestige: Optional[float]
    athlete_roster: Optional[str]

    model_config = ConfigDict(from_attributes=True)


class DashboardStats(BaseModel):
    """Overall dashboard statistics."""
    total_players: int
    total_active_deals: int
    total_market_value_usd: int
    avg_player_value_usd: float
    top_brand_by_spend: Optional[str]
    top_player_by_value: Optional[str]


# ============================================================================
# SCRAPER METADATA SCHEMAS
# ============================================================================

class ScrapeRunResponse(BaseModel):
    """Scraper run metadata."""
    run_id: UUID
    run_timestamp: datetime
    players_processed: int
    endorsements_found: int
    endorsements_new: int
    endorsements_updated: int
    errors_count: int
    runtime_seconds: Optional[int]
    status: Literal['running', 'completed', 'failed', 'partial']
    triggered_by: str

    model_config = ConfigDict(from_attributes=True)


# ============================================================================
# UTILITY SCHEMAS
# ============================================================================

class MessageResponse(BaseModel):
    """Generic message response."""
    message: str
    detail: Optional[str] = None


class PaginationParams(BaseModel):
    """Pagination parameters."""
    skip: int = Field(0, ge=0)
    limit: int = Field(100, ge=1, le=1000)
