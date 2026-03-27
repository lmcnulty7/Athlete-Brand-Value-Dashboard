"""Brand API endpoints."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional

from app.database import get_db
from app.models import Brand, Endorsement
from app.schemas import BrandResponse, BrandCreate, BrandSummary

router = APIRouter()


@router.get("/", response_model=List[BrandResponse])
def get_brands(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=500),
    category: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    """Get list of all brands with optional category filter."""
    query = db.query(Brand)

    if category:
        query = query.filter(Brand.brand_category == category)

    brands = query.order_by(Brand.brand_name).offset(skip).limit(limit).all()
    return brands


@router.get("/categories", response_model=List[str])
def get_brand_categories(db: Session = Depends(get_db)):
    """Get distinct list of brand categories for filtering."""
    categories = db.query(Brand.brand_category).distinct().order_by(Brand.brand_category).all()
    return [cat[0] for cat in categories if cat[0]]


@router.get("/summary", response_model=List[BrandSummary])
def get_brand_summaries(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db)
):
    """
    Get brand portfolio summaries from materialized view.

    Shows athlete count, total spend, average player prestige per brand.
    """
    # Query materialized view directly
    from sqlalchemy import text

    query = text("""
        SELECT
            brand_id,
            brand_name,
            brand_category,
            brand_tier,
            athletes_signed,
            total_annual_spend_usd,
            avg_player_prestige,
            athlete_roster
        FROM brand_portfolio_summary
        ORDER BY total_annual_spend_usd DESC NULLS LAST
        LIMIT :limit OFFSET :skip
    """)

    result = db.execute(query, {"limit": limit, "skip": skip})
    rows = result.fetchall()

    return [
        BrandSummary(
            brand_id=row[0],
            brand_name=row[1],
            brand_category=row[2],
            brand_tier=row[3],
            athletes_signed=row[4] or 0,
            total_annual_spend_usd=row[5],
            avg_player_prestige=float(row[6]) if row[6] else None,
            athlete_roster=row[7]
        )
        for row in rows
    ]


@router.get("/{brand_id}", response_model=BrandResponse)
def get_brand(brand_id: int, db: Session = Depends(get_db)):
    """Get details of a specific brand."""
    brand = db.query(Brand).filter(Brand.brand_id == brand_id).first()

    if not brand:
        raise HTTPException(status_code=404, detail="Brand not found")

    return brand


@router.post("/", response_model=BrandResponse, status_code=201)
def create_brand(brand: BrandCreate, db: Session = Depends(get_db)):
    """Create a new brand (manual entry or scraper addition)."""
    # Check for duplicates
    existing = db.query(Brand).filter(Brand.brand_name == brand.brand_name).first()
    if existing:
        raise HTTPException(status_code=400, detail=f"Brand '{brand.brand_name}' already exists")

    db_brand = Brand(**brand.model_dump())
    db.add(db_brand)
    db.commit()
    db.refresh(db_brand)

    return db_brand
