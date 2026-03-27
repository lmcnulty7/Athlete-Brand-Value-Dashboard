"""Application configuration using Pydantic settings."""
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    """Application settings with environment variable support."""

    # Database
    database_url: str = "postgresql://postgres:postgres@localhost:5432/endorsement_tracker"

    # API
    api_title: str = "NBA Endorsement Tracker API"
    api_version: str = "1.0.0"
    api_description: str = """
    RESTful API for tracking NBA player endorsement deals.

    Features:
    - Player roster management (sourced from NBA Stats API)
    - Endorsement deal aggregation from multiple sources
    - Analytics-optimized endpoints for dashboard consumption
    - Data quality confidence scoring
    """

    # Environment
    env: str = "development"
    debug: bool = True

    # CORS
    cors_origins: list[str] = ["http://localhost:3000", "http://127.0.0.1:3000"]

    # Scraper
    scraper_rate_limit_calls: int = 1
    scraper_rate_limit_period: int = 2  # seconds

    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()
