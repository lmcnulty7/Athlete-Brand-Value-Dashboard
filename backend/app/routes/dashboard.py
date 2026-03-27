"""Dashboard analytics endpoints."""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import text, func, case
from typing import List

from app.database import get_db
from app.models import Player, Endorsement, Brand, ScrapeMetadata
from app.schemas import PlayerSummary, DashboardStats, ScrapeRunResponse, MessageResponse

router = APIRouter()


@router.get("/stats", response_model=DashboardStats)
def get_dashboard_stats(db: Session = Depends(get_db)):
    """
    Get high-level dashboard statistics.

    Returns:
    - Total active players with endorsements
    - Total active deals
    - Aggregate market value
    - Top brand and player
    """
    # Total players with endorsements
    total_players = db.query(Player).filter(Player.is_active == True).count()

    # Total active deals
    total_active_deals = db.query(Endorsement).filter(
        Endorsement.is_active == True,
        Endorsement.is_public == True
    ).count()

    # Total market value (sum of all active deals, normalized to annual)
    market_value_query = db.query(
        func.sum(
            case(
                (Endorsement.deal_value_type.like('%annual%'), Endorsement.deal_value_usd),
                else_=Endorsement.deal_value_usd / func.coalesce(Endorsement.contract_duration_years, 1)
            )
        )
    ).filter(
        Endorsement.is_active == True,
        Endorsement.is_public == True,
        Endorsement.deal_value_usd.isnot(None)
    ).scalar()

    total_market_value = int(market_value_query or 0)

    # Average player value
    avg_player_value = total_market_value / total_players if total_players > 0 else 0

    # Top brand by spend
    top_brand = db.query(Brand.brand_name).join(Endorsement).filter(
        Endorsement.is_active == True
    ).group_by(Brand.brand_name).order_by(
        func.sum(Endorsement.deal_value_usd).desc()
    ).first()

    # Top player by value
    top_player = db.query(Player.full_name).join(Endorsement).filter(
        Endorsement.is_active == True,
        Endorsement.is_public == True
    ).group_by(Player.full_name).order_by(
        func.sum(Endorsement.deal_value_usd).desc()
    ).first()

    return DashboardStats(
        total_players=total_players,
        total_active_deals=total_active_deals,
        total_market_value_usd=total_market_value,
        avg_player_value_usd=avg_player_value,
        top_brand_by_spend=top_brand[0] if top_brand else None,
        top_player_by_value=top_player[0] if top_player else None
    )


@router.get("/leaderboard", response_model=List[PlayerSummary])
def get_leaderboard(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    tier: str = Query(None),
    db: Session = Depends(get_db)
):
    """
    Get player leaderboard from materialized view.

    Pre-aggregated data for fast dashboard rendering.
    Sorted by total endorsement value descending.
    """
    query = text("""
        SELECT
            player_id,
            full_name,
            team_abbreviation,
            position,
            player_tier,
            allstar_selections,
            active_deals_count,
            total_annual_value_usd,
            avg_deal_value_usd,
            top_deal_value_usd,
            brands,
            next_expiration
        FROM player_endorsement_summary
        WHERE (:tier IS NULL OR player_tier = :tier)
        ORDER BY total_annual_value_usd DESC NULLS LAST, active_deals_count DESC
        LIMIT :limit OFFSET :skip
    """)

    result = db.execute(query, {"tier": tier, "limit": limit, "skip": skip})
    rows = result.fetchall()

    return [
        PlayerSummary(
            player_id=row[0],
            full_name=row[1],
            team_abbreviation=row[2],
            position=row[3],
            player_tier=row[4],
            allstar_selections=row[5] or 0,
            active_deals_count=row[6] or 0,
            total_annual_value_usd=int(row[7]) if row[7] is not None else None,
            avg_deal_value_usd=int(row[8]) if row[8] is not None else None,
            top_deal_value_usd=int(row[9]) if row[9] is not None else None,
            brands=row[10],
            next_expiration=row[11]
        )
        for row in rows
    ]


@router.post("/refresh-views", response_model=MessageResponse)
def refresh_materialized_views(db: Session = Depends(get_db)):
    """
    Manually refresh materialized views.

    Call this after scraper runs or bulk data updates to update
    dashboard aggregations.
    """
    try:
        db.execute(text("SELECT refresh_dashboard_views()"))
        db.commit()
        return MessageResponse(
            message="Dashboard views refreshed successfully",
            detail="player_endorsement_summary and brand_portfolio_summary updated"
        )
    except Exception as e:
        return MessageResponse(
            message="Failed to refresh views",
            detail=str(e)
        )


@router.get("/category-breakdown")
def get_category_breakdown(db: Session = Depends(get_db)):
    """
    Get endorsement value breakdown by brand category.

    Returns aggregated deal values grouped by category (Footwear, Tech, Finance, etc.)
    """
    query = text("""
        SELECT
            b.brand_category,
            COUNT(e.endorsement_id) as deal_count,
            SUM(e.deal_value_usd) as total_value_usd,
            ROUND(100.0 * SUM(e.deal_value_usd) / SUM(SUM(e.deal_value_usd)) OVER (), 2) as percentage
        FROM endorsements e
        LEFT JOIN brands b ON e.brand_name = b.brand_name
        WHERE e.is_active = true AND e.is_public = true
        GROUP BY b.brand_category
        ORDER BY total_value_usd DESC NULLS LAST
    """)

    result = db.execute(query)
    rows = result.fetchall()

    return [
        {
            "category": row[0] or "Other",
            "deal_count": row[1] or 0,
            "total_value_usd": int(row[2]) if row[2] else 0,
            "percentage": float(row[3]) if row[3] else 0.0
        }
        for row in rows
    ]


@router.get("/scraper-runs", response_model=List[ScrapeRunResponse])
def get_scraper_runs(
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db)
):
    """Get recent scraper run history for monitoring."""
    runs = db.query(ScrapeMetadata).order_by(
        ScrapeMetadata.run_timestamp.desc()
    ).limit(limit).all()

    return runs
