"""Endorsement API endpoints."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from uuid import UUID

from app.database import get_db
from app.models import Endorsement, Player, Brand
from app.schemas import EndorsementResponse, EndorsementCreate, EndorsementUpdate, MessageResponse

router = APIRouter()


@router.get("/", response_model=List[EndorsementResponse])
def get_endorsements(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    brand_category: Optional[str] = Query(None),
    confidence: Optional[str] = Query(None),
    active_only: bool = Query(True),
    public_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """
    Get paginated list of endorsement deals.

    Filters:
    - Brand category (Footwear, Apparel, etc.)
    - Confidence level (confirmed, estimated, rumored)
    - Active status
    - Public visibility
    """
    query = db.query(Endorsement).join(Player).outerjoin(Brand)

    # Apply filters
    if active_only:
        query = query.filter(Endorsement.is_active == True)

    if public_only:
        query = query.filter(Endorsement.is_public == True)

    if brand_category:
        query = query.filter(Brand.brand_category == brand_category)

    if confidence:
        query = query.filter(Endorsement.value_confidence == confidence)

    # Order by value descending
    query = query.order_by(Endorsement.deal_value_usd.desc().nullslast())

    # Paginate
    endorsements = query.offset(skip).limit(limit).all()

    # Enrich with player/brand names
    return [
        EndorsementResponse(
            **endorsement.__dict__,
            player_name=endorsement.player.full_name if endorsement.player else None,
            brand_category=endorsement.brand.brand_category if endorsement.brand else None
        )
        for endorsement in endorsements
    ]


@router.get("/{endorsement_id}", response_model=EndorsementResponse)
def get_endorsement(endorsement_id: UUID, db: Session = Depends(get_db)):
    """Get details of a specific endorsement deal."""
    endorsement = db.query(Endorsement).filter(Endorsement.endorsement_id == endorsement_id).first()

    if not endorsement:
        raise HTTPException(status_code=404, detail="Endorsement not found")

    return EndorsementResponse(
        **endorsement.__dict__,
        player_name=endorsement.player.full_name if endorsement.player else None,
        brand_category=endorsement.brand.brand_category if endorsement.brand else None
    )


@router.post("/", response_model=EndorsementResponse, status_code=201)
def create_endorsement(endorsement: EndorsementCreate, db: Session = Depends(get_db)):
    """
    Create a new endorsement deal.

    Used for manual data entry or scraper imports.
    """
    # Verify player exists
    player = db.query(Player).filter(Player.player_id == endorsement.player_id).first()
    if not player:
        raise HTTPException(status_code=404, detail=f"Player {endorsement.player_id} not found")

    # Get or create brand
    brand = None
    if endorsement.brand_id:
        brand = db.query(Brand).filter(Brand.brand_id == endorsement.brand_id).first()
    else:
        # Try to find brand by name
        brand = db.query(Brand).filter(Brand.brand_name == endorsement.brand_name).first()

    # Create endorsement
    db_endorsement = Endorsement(
        **endorsement.model_dump(exclude={'brand_id'}),
        brand_id=brand.brand_id if brand else None
    )

    db.add(db_endorsement)
    db.commit()
    db.refresh(db_endorsement)

    return EndorsementResponse(
        **db_endorsement.__dict__,
        player_name=player.full_name,
        brand_category=brand.brand_category if brand else None
    )


@router.patch("/{endorsement_id}", response_model=EndorsementResponse)
def update_endorsement(
    endorsement_id: UUID,
    endorsement_update: EndorsementUpdate,
    db: Session = Depends(get_db)
):
    """
    Update an existing endorsement deal.

    Useful for verifying scraped data or correcting values.
    """
    db_endorsement = db.query(Endorsement).filter(Endorsement.endorsement_id == endorsement_id).first()

    if not db_endorsement:
        raise HTTPException(status_code=404, detail="Endorsement not found")

    # Update only provided fields
    update_data = endorsement_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_endorsement, field, value)

    db.commit()
    db.refresh(db_endorsement)

    return EndorsementResponse(
        **db_endorsement.__dict__,
        player_name=db_endorsement.player.full_name if db_endorsement.player else None,
        brand_category=db_endorsement.brand.brand_category if db_endorsement.brand else None
    )


@router.delete("/{endorsement_id}", response_model=MessageResponse)
def delete_endorsement(endorsement_id: UUID, db: Session = Depends(get_db)):
    """Delete an endorsement deal."""
    endorsement = db.query(Endorsement).filter(Endorsement.endorsement_id == endorsement_id).first()

    if not endorsement:
        raise HTTPException(status_code=404, detail="Endorsement not found")

    db.delete(endorsement)
    db.commit()

    return MessageResponse(message="Endorsement deleted successfully")
