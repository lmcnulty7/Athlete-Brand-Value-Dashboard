"""SQLAlchemy ORM models matching database schema."""
from sqlalchemy import (
    Column, String, Integer, BigInteger, Boolean, Date, DateTime, Text,
    ForeignKey, CheckConstraint, DECIMAL, func
)
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.database import Base


class Player(Base):
    """Player dimension table."""
    __tablename__ = "players"

    player_id = Column(String(20), primary_key=True)
    full_name = Column(String(100), nullable=False, index=True)
    first_name = Column(String(50))
    last_name = Column(String(50))
    team_abbreviation = Column(String(3), index=True)
    team_name = Column(String(100))
    position = Column(String(10))
    jersey_number = Column(Integer)
    height_cm = Column(Integer)
    weight_kg = Column(Integer)
    birth_date = Column(Date)
    country = Column(String(50))

    # Performance metrics
    career_ppg = Column(DECIMAL(5, 2))
    career_apg = Column(DECIMAL(5, 2))
    career_rpg = Column(DECIMAL(5, 2))
    allstar_selections = Column(Integer, default=0)
    championships = Column(Integer, default=0)

    # Derived tier
    player_tier = Column(String(20))

    # Metadata
    is_active = Column(Boolean, default=True, index=True)
    nba_debut_year = Column(Integer)
    last_updated = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    endorsements = relationship("Endorsement", back_populates="player", cascade="all, delete-orphan")

    __table_args__ = (
        CheckConstraint(
            "player_tier IN ('Superstar', 'All-Star', 'Starter', 'Role Player', 'Rookie')",
            name="player_tier_check"
        ),
    )


class Brand(Base):
    """Brand dimension table."""
    __tablename__ = "brands"

    brand_id = Column(Integer, primary_key=True, autoincrement=True)
    brand_name = Column(String(100), unique=True, nullable=False, index=True)
    brand_category = Column(String(50), nullable=False, index=True)
    parent_company = Column(String(100))
    brand_hq_country = Column(String(50))
    brand_tier = Column(String(20))
    website_url = Column(String(200))
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    endorsements = relationship("Endorsement", back_populates="brand")

    __table_args__ = (
        CheckConstraint(
            "brand_tier IN ('Premium', 'Mass Market', 'Niche', 'Emerging')",
            name="brand_tier_check"
        ),
    )


class Endorsement(Base):
    """Endorsement deals fact table."""
    __tablename__ = "endorsements"

    endorsement_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    player_id = Column(String(20), ForeignKey("players.player_id", ondelete="CASCADE"), nullable=False, index=True)
    brand_id = Column(Integer, ForeignKey("brands.brand_id", ondelete="SET NULL"), index=True)
    brand_name = Column(String(100), nullable=False)  # Denormalized

    # Financials
    deal_value_usd = Column(BigInteger)  # Stored in cents
    deal_value_type = Column(String(20))
    deal_value_min = Column(BigInteger)
    deal_value_max = Column(BigInteger)
    value_confidence = Column(String(20), nullable=False, default='unverified', index=True)

    # Timeline
    contract_start_date = Column(Date)
    contract_end_date = Column(Date)
    contract_duration_years = Column(Integer)
    is_lifetime_deal = Column(Boolean, default=False)

    # Structure
    deal_type = Column(String(50))
    has_signature_line = Column(Boolean, default=False)
    signature_product_name = Column(String(200))
    equity_percentage = Column(DECIMAL(5, 2))
    performance_bonuses = Column(JSONB)

    # Provenance
    data_source = Column(String(500))
    source_type = Column(String(50))
    scraped_date = Column(DateTime, default=datetime.utcnow)
    last_verified = Column(DateTime)

    # Status
    is_active = Column(Boolean, default=True, index=True)
    needs_verification = Column(Boolean, default=False)
    is_public = Column(Boolean, default=True, index=True)
    notes = Column(Text)

    # Audit
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    player = relationship("Player", back_populates="endorsements")
    brand = relationship("Brand", back_populates="endorsements")

    __table_args__ = (
        CheckConstraint(
            "deal_value_type IN ('annual', 'total', 'estimated_annual', 'estimated_total')",
            name="deal_value_type_check"
        ),
        CheckConstraint(
            "value_confidence IN ('confirmed', 'estimated', 'rumored', 'unverified')",
            name="value_confidence_check"
        ),
        CheckConstraint(
            "source_type IN ('nba_api', 'press_release', 'news_article', 'social_media', 'manual_entry', 'spotrac', 'other')",
            name="source_type_check"
        ),
    )


class ScrapeMetadata(Base):
    """Scraper run tracking."""
    __tablename__ = "scrape_metadata"

    run_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    run_timestamp = Column(DateTime, default=datetime.utcnow)
    scraper_version = Column(String(20))
    players_processed = Column(Integer, default=0)
    endorsements_found = Column(Integer, default=0)
    endorsements_new = Column(Integer, default=0)
    endorsements_updated = Column(Integer, default=0)
    errors_count = Column(Integer, default=0)
    runtime_seconds = Column(Integer)
    triggered_by = Column(String(50))
    status = Column(String(20))
    error_log = Column(Text)
    completed_at = Column(DateTime)

    __table_args__ = (
        CheckConstraint(
            "triggered_by IN ('scheduled', 'manual_dashboard', 'api_call', 'cli')",
            name="triggered_by_check"
        ),
        CheckConstraint(
            "status IN ('running', 'completed', 'failed', 'partial')",
            name="status_check"
        ),
    )
