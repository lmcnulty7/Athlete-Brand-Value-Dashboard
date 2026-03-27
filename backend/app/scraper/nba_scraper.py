"""NBA API scraper for player roster data."""
from nba_api.stats.endpoints import commonallplayers, commonplayerinfo, playercareerstats
from nba_api.stats.static import players as static_players
from typing import List, Dict, Optional
import time
from datetime import datetime

from app.models import Player
from app.database import SessionLocal


class NBAScraper:
    """Scraper for NBA player data using nba_api."""

    def __init__(self, rate_limit_seconds: float = 0.6):
        """
        Initialize NBA scraper.

        Args:
            rate_limit_seconds: Delay between API calls to respect rate limits
        """
        self.rate_limit = rate_limit_seconds
        self.session = SessionLocal()

    def __del__(self):
        """Close database session on cleanup."""
        if hasattr(self, 'session'):
            self.session.close()

    def _rate_limited_call(self, func, *args, **kwargs):
        """Execute function with rate limiting."""
        time.sleep(self.rate_limit)
        return func(*args, **kwargs)

    def get_current_season_players(self, season: str = "2025-26") -> List[Dict]:
        """
        Fetch all active players for current season from NBA API.

        Args:
            season: NBA season in format "YYYY-YY"

        Returns:
            List of player dictionaries
        """
        print(f"Fetching players for {season} season...")

        try:
            all_players = self._rate_limited_call(
                commonallplayers.CommonAllPlayers,
                season=season,
                is_only_current_season=1
            )

            df = all_players.get_data_frames()[0]
            players_data = df.to_dict('records')

            print(f"Found {len(players_data)} active players")
            return players_data

        except Exception as e:
            print(f"Error fetching players: {e}")
            return []

    def get_player_details(self, player_id: str) -> Optional[Dict]:
        """
        Fetch detailed information for a specific player.

        Args:
            player_id: NBA API person_id

        Returns:
            Player details dictionary or None if error
        """
        try:
            # Get player info
            info = self._rate_limited_call(
                commonplayerinfo.CommonPlayerInfo,
                player_id=player_id
            )
            info_df = info.get_data_frames()[0]

            if info_df.empty:
                return None

            player_info = info_df.iloc[0].to_dict()

            # Get career stats
            time.sleep(self.rate_limit)
            stats = playercareerstats.PlayerCareerStats(player_id=player_id)
            stats_df = stats.get_data_frames()[0]  # Regular season totals

            if not stats_df.empty:
                # Calculate career averages
                career_stats = stats_df.iloc[-1]  # Most recent season
                total_games = stats_df['GP'].sum()
                total_points = stats_df['PTS'].sum()
                total_assists = stats_df['AST'].sum()
                total_rebounds = stats_df['REB'].sum()

                player_info['career_ppg'] = round(total_points / total_games, 2) if total_games > 0 else 0
                player_info['career_apg'] = round(total_assists / total_games, 2) if total_games > 0 else 0
                player_info['career_rpg'] = round(total_rebounds / total_games, 2) if total_games > 0 else 0

            return player_info

        except Exception as e:
            print(f"Error fetching details for player {player_id}: {e}")
            return None

    def calculate_player_tier(self, allstar_count: int, ppg: float, championships: int = 0) -> str:
        """
        Classify player into tier based on achievements.

        Args:
            allstar_count: Number of All-Star selections
            ppg: Career points per game
            championships: Number of championships

        Returns:
            Player tier: Superstar, All-Star, Starter, Role Player, or Rookie
        """
        if allstar_count >= 5 or championships >= 2:
            return 'Superstar'
        elif allstar_count >= 1:
            return 'All-Star'
        elif ppg >= 15:
            return 'Starter'
        elif ppg >= 5:
            return 'Role Player'
        else:
            return 'Rookie'

    def sync_player_to_db(self, player_data: Dict) -> Optional[Player]:
        """
        Insert or update player in database.

        Args:
            player_data: Dictionary with player information from NBA API

        Returns:
            Player model instance or None if error
        """
        try:
            player_id = str(player_data.get('PERSON_ID'))

            # Check if player exists
            existing_player = self.session.query(Player).filter(
                Player.player_id == player_id
            ).first()

            # Map NBA API fields to our schema
            player_values = {
                'player_id': player_id,
                'full_name': player_data.get('DISPLAY_FIRST_LAST'),
                'first_name': player_data.get('FIRST_NAME'),
                'last_name': player_data.get('LAST_NAME'),
                'team_abbreviation': player_data.get('TEAM_ABBREVIATION'),
                'team_name': player_data.get('TEAM_NAME'),
                'position': player_data.get('POSITION'),
                'jersey_number': player_data.get('JERSEY'),
                'height_cm': self._parse_height(player_data.get('HEIGHT')),
                'weight_kg': self._parse_weight(player_data.get('WEIGHT')),
                'birth_date': player_data.get('BIRTHDATE'),
                'country': player_data.get('COUNTRY'),
                'career_ppg': player_data.get('career_ppg', 0),
                'career_apg': player_data.get('career_apg', 0),
                'career_rpg': player_data.get('career_rpg', 0),
                'is_active': player_data.get('ROSTERSTATUS') == 1,
                'nba_debut_year': player_data.get('FROM_YEAR'),
                'last_updated': datetime.utcnow()
            }

            # Calculate tier
            allstar_count = 0  # TODO: Could fetch from separate endpoint
            player_values['player_tier'] = self.calculate_player_tier(
                allstar_count,
                player_values['career_ppg'] or 0
            )

            if existing_player:
                # Update existing
                for key, value in player_values.items():
                    setattr(existing_player, key, value)
                print(f"Updated: {player_values['full_name']}")
                self.session.commit()
                return existing_player
            else:
                # Insert new
                new_player = Player(**player_values)
                self.session.add(new_player)
                self.session.commit()
                print(f"Inserted: {player_values['full_name']}")
                return new_player

        except Exception as e:
            print(f"Error syncing player to DB: {e}")
            self.session.rollback()
            return None

    def _parse_height(self, height_str: Optional[str]) -> Optional[int]:
        """Convert height string (e.g., '6-8') to cm."""
        if not height_str:
            return None
        try:
            parts = height_str.split('-')
            feet = int(parts[0])
            inches = int(parts[1]) if len(parts) > 1 else 0
            return int((feet * 12 + inches) * 2.54)
        except:
            return None

    def _parse_weight(self, weight_str: Optional[str]) -> Optional[int]:
        """Convert weight string to kg."""
        if not weight_str:
            return None
        try:
            lbs = int(weight_str)
            return int(lbs * 0.453592)
        except:
            return None

    def scrape_top_players(self, limit: int = 100) -> int:
        """
        Scrape top N players from current season.

        For portfolio purposes, focus on active players only.

        Args:
            limit: Number of players to scrape

        Returns:
            Count of successfully synced players
        """
        print(f"Starting NBA player scrape (limit: {limit})...")

        # Get current season players
        players_data = self.get_current_season_players()

        if not players_data:
            print("No players found")
            return 0

        # Limit to specified count
        players_to_scrape = players_data[:limit]

        success_count = 0
        for player_data in players_to_scrape:
            player = self.sync_player_to_db(player_data)
            if player:
                success_count += 1

        print(f"\nScrape complete: {success_count}/{len(players_to_scrape)} players synced")
        return success_count


def run_nba_scraper(limit: int = 100):
    """
    Convenience function to run NBA scraper.

    Can be called from CLI or scheduled task.
    """
    scraper = NBAScraper()
    return scraper.scrape_top_players(limit=limit)


if __name__ == "__main__":
    # Test scraper
    run_nba_scraper(limit=10)
