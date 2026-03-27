"""Player API endpoints."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, or_
from typing import List, Optional

from app.database import get_db
from app.models import Player, Endorsement
from app.schemas import PlayerResponse, PlayerWithEndorsements, PlayerCreate

router = APIRouter()


@router.get("/", response_model=List[PlayerWithEndorsements])
def get_players(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    search: Optional[str] = Query(None, description="Search by player name"),
    team: Optional[str] = Query(None, description="Filter by team abbreviation"),
    tier: Optional[str] = Query(None, description="Filter by player tier"),
    active_only: bool = Query(True, description="Show only active players"),
    db: Session = Depends(get_db)
):
    """
    Get paginated list of players with endorsement counts.

    Supports filtering by:
    - Name (fuzzy search)
    - Team
    - Player tier (Superstar, All-Star, etc.)
    - Active status
    """
    query = db.query(
        Player,
        func.count(Endorsement.endorsement_id).label('endorsement_count'),
        func.sum(Endorsement.deal_value_usd).label('total_endorsement_value')
    ).outerjoin(
        Endorsement,
        (Endorsement.player_id == Player.player_id) &
        (Endorsement.is_active == True) &
        (Endorsement.is_public == True)
    )

    # Apply filters
    if active_only:
        query = query.filter(Player.is_active == True)

    if search:
        search_pattern = f"%{search}%"
        query = query.filter(
            or_(
                Player.full_name.ilike(search_pattern),
                Player.first_name.ilike(search_pattern),
                Player.last_name.ilike(search_pattern)
            )
        )

    if team:
        query = query.filter(Player.team_abbreviation == team.upper())

    if tier:
        query = query.filter(Player.player_tier == tier)

    # Group by player
    query = query.group_by(Player.player_id)

    # Order by endorsement value descending
    query = query.order_by(func.sum(Endorsement.deal_value_usd).desc().nullslast())

    # Paginate
    results = query.offset(skip).limit(limit).all()

    # Format response
    return [
        PlayerWithEndorsements(
            **player.__dict__,
            endorsement_count=count or 0,
            total_endorsement_value=total or 0
        )
        for player, count, total in results
    ]


@router.get("/{player_id}", response_model=PlayerResponse)
def get_player(player_id: str, db: Session = Depends(get_db)):
    """Get detailed information for a specific player."""
    player = db.query(Player).filter(Player.player_id == player_id).first()

    if not player:
        raise HTTPException(status_code=404, detail=f"Player {player_id} not found")

    return player


@router.get("/{player_id}/endorsements", response_model=List[dict])
def get_player_endorsements(
    player_id: str,
    active_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Get all endorsement deals for a specific player."""
    # Verify player exists
    player = db.query(Player).filter(Player.player_id == player_id).first()
    if not player:
        raise HTTPException(status_code=404, detail=f"Player {player_id} not found")

    # Query endorsements
    query = db.query(Endorsement).filter(Endorsement.player_id == player_id)

    if active_only:
        query = query.filter(Endorsement.is_active == True)

    endorsements = query.order_by(Endorsement.deal_value_usd.desc().nullslast()).all()

    return [
        {
            **endorsement.__dict__,
            "deal_value_display": f"${endorsement.deal_value_usd / 100:,.0f}" if endorsement.deal_value_usd else "Undisclosed"
        }
        for endorsement in endorsements
    ]


@router.post("/", response_model=PlayerResponse, status_code=201)
def create_player(player: PlayerCreate, db: Session = Depends(get_db)):
    """Create a new player (typically from NBA API data)."""
    # Check if player already exists
    existing = db.query(Player).filter(Player.player_id == player.player_id).first()
    if existing:
        raise HTTPException(status_code=400, detail=f"Player {player.player_id} already exists")

    db_player = Player(**player.model_dump())
    db.add(db_player)
    db.commit()
    db.refresh(db_player)

    return db_player
