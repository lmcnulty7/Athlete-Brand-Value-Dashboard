#!/usr/bin/env python3
"""
Database seeding script.

Runs NBA player scraper and imports sample endorsement data.
"""
import sys
import os

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))

from app.scraper.nba_scraper import run_nba_scraper
from app.scraper.endorsement_scraper import EndorsementScraper
from app.database import SessionLocal, engine
from app.models import Base


def init_database():
    """Create all database tables."""
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("✓ Tables created")


def seed_players(limit: int = 100):
    """Scrape NBA players from API."""
    print(f"\nSeeding {limit} NBA players...")
    count = run_nba_scraper(limit=limit)
    print(f"✓ Seeded {count} players")
    return count


def seed_endorsements(csv_path: str = None):
    """Import endorsement data from CSV."""
    if not csv_path:
        csv_path = os.path.join(
            os.path.dirname(__file__),
            '..',
            'data',
            'endorsements_seed.csv'
        )

    print(f"\nSeeding endorsements from {csv_path}...")

    if not os.path.exists(csv_path):
        print(f"Warning: CSV file not found at {csv_path}")
        print("Skipping endorsement import. Add data manually or create the CSV file.")
        return 0

    scraper = EndorsementScraper()
    count = scraper.import_from_csv(csv_path)
    print(f"✓ Seeded {count} endorsement deals")
    return count


def refresh_views():
    """Refresh materialized views for dashboard."""
    print("\nRefreshing materialized views...")
    db = SessionLocal()
    try:
        from sqlalchemy import text
        db.execute(text("SELECT refresh_dashboard_views()"))
        db.commit()
        print("✓ Views refreshed")
    except Exception as e:
        print(f"Warning: Could not refresh views: {e}")
    finally:
        db.close()


def main():
    """Run full database seeding process."""
    print("=" * 60)
    print("NBA ENDORSEMENT TRACKER - Database Seeding")
    print("=" * 60)

    # Step 1: Initialize database
    init_database()

    # Step 2: Seed players from NBA API
    player_count = seed_players(limit=100)

    if player_count == 0:
        print("\nError: No players imported. Check NBA API connection.")
        return

    # Step 3: Seed endorsements from CSV
    endorsement_count = seed_endorsements()

    # Step 4: Refresh views
    refresh_views()

    # Summary
    print("\n" + "=" * 60)
    print("SEEDING COMPLETE")
    print("=" * 60)
    print(f"Players imported: {player_count}")
    print(f"Endorsements imported: {endorsement_count}")
    print("\nNext steps:")
    print("1. Start the API: docker-compose up api")
    print("2. Visit http://localhost:8000/docs to test endpoints")
    print("3. Start the frontend: docker-compose up frontend")
    print("=" * 60)


if __name__ == "__main__":
    main()
