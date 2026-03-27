"""
Endorsement scraper framework.

This module provides the foundation for scraping endorsement data
from various sources (Spotrac, social media, brand newsrooms).

For MVP: Focus on manual CSV import.
Future: Implement web scraping logic here.
"""
from typing import List, Dict, Optional
from datetime import datetime
import csv
import re

from app.models import Endorsement, Player, Brand
from app.database import SessionLocal


class EndorsementScraper:
    """Base class for endorsement data collection."""

    def __init__(self):
        self.session = SessionLocal()

    def __del__(self):
        if hasattr(self, 'session'):
            self.session.close()

    def import_from_csv(self, csv_path: str) -> int:
        """
        Import endorsement deals from CSV file.

        Expected CSV format:
        player_name,brand_name,deal_value_usd,deal_value_type,confidence,contract_start,contract_end,source_url,notes

        Args:
            csv_path: Path to CSV file

        Returns:
            Count of imported deals
        """
        print(f"Importing endorsements from {csv_path}...")

        imported_count = 0

        try:
            with open(csv_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)

                for row in reader:
                    success = self._import_row(row)
                    if success:
                        imported_count += 1

            self.session.commit()
            print(f"Successfully imported {imported_count} endorsement deals")
            return imported_count

        except Exception as e:
            print(f"Error importing CSV: {e}")
            self.session.rollback()
            return 0

    def _import_row(self, row: Dict) -> bool:
        """Import a single CSV row as an endorsement."""
        try:
            # Find player by name
            player_name = row.get('player_name', '').strip()
            player = self.session.query(Player).filter(
                Player.full_name.ilike(f"%{player_name}%")
            ).first()

            if not player:
                print(f"  Warning: Player '{player_name}' not found in database, skipping")
                return False

            # Find or create brand
            brand_name = row.get('brand_name', '').strip()
            brand = self.session.query(Brand).filter(
                Brand.brand_name == brand_name
            ).first()

            # Parse deal value (convert to cents)
            deal_value_str = row.get('deal_value_usd', '').strip()
            deal_value_usd = self._parse_currency(deal_value_str)

            # Parse dates
            start_date = self._parse_date(row.get('contract_start', '').strip())
            end_date = self._parse_date(row.get('contract_end', '').strip())

            # Create endorsement
            endorsement = Endorsement(
                player_id=player.player_id,
                brand_id=brand.brand_id if brand else None,
                brand_name=brand_name,
                deal_value_usd=deal_value_usd,
                deal_value_type=row.get('deal_value_type', 'estimated_annual').strip(),
                value_confidence=row.get('confidence', 'estimated').strip(),
                contract_start_date=start_date,
                contract_end_date=end_date,
                contract_duration_years=self._calculate_duration(start_date, end_date),
                data_source=row.get('source_url', '').strip(),
                source_type='manual_entry',
                notes=row.get('notes', '').strip(),
                is_active=True,
                is_public=True
            )

            self.session.add(endorsement)
            print(f"  ✓ {player_name} ← {brand_name}: ${deal_value_usd / 100:,.0f}")
            return True

        except Exception as e:
            print(f"  Error importing row: {e}")
            return False

    def _parse_currency(self, value_str: str) -> Optional[int]:
        """
        Parse currency string to integer (in cents).

        Examples:
        - "$20M" -> 2000000000 (cents)
        - "5 million" -> 500000000
        - "15000000" -> 1500000000
        """
        if not value_str:
            return None

        # Remove currency symbols and whitespace
        cleaned = value_str.upper().replace('$', '').replace(',', '').strip()

        # Handle million/billion notation
        multiplier = 1
        if 'M' in cleaned or 'MILLION' in cleaned:
            multiplier = 1_000_000
            cleaned = re.sub(r'[MB]|MILLION|BILLION', '', cleaned).strip()
        elif 'B' in cleaned or 'BILLION' in cleaned:
            multiplier = 1_000_000_000
            cleaned = re.sub(r'[MB]|MILLION|BILLION', '', cleaned).strip()

        try:
            amount = float(cleaned)
            # Convert to cents (multiply by 100)
            return int(amount * multiplier * 100)
        except ValueError:
            return None

    def _parse_date(self, date_str: str) -> Optional[datetime.date]:
        """Parse date string in various formats."""
        if not date_str or date_str.lower() == 'n/a':
            return None

        formats = [
            '%Y-%m-%d',
            '%m/%d/%Y',
            '%Y',  # Just year
        ]

        for fmt in formats:
            try:
                parsed = datetime.strptime(date_str, fmt)
                return parsed.date()
            except ValueError:
                continue

        return None

    def _calculate_duration(self, start_date, end_date) -> Optional[int]:
        """Calculate contract duration in years."""
        if not start_date or not end_date:
            return None

        duration = end_date.year - start_date.year
        return duration if duration > 0 else None


# TODO: Future scraper implementations

class SpotracScraper(EndorsementScraper):
    """Scraper for Spotrac endorsement data."""

    def scrape_player_page(self, player_name: str) -> List[Dict]:
        """
        Scrape endorsements from Spotrac player page.

        Placeholder for future implementation.
        """
        # TODO: Implement Playwright scraping
        pass


class SocialMediaScraper(EndorsementScraper):
    """Scraper for social media endorsement signals."""

    def scrape_instagram_bio(self, player_username: str) -> List[str]:
        """
        Extract brand mentions from Instagram bio.

        Placeholder for future implementation.
        """
        # TODO: Use Instagram Graph API
        pass


if __name__ == "__main__":
    # Test CSV import
    scraper = EndorsementScraper()
    # scraper.import_from_csv('data/endorsements_seed.csv')
