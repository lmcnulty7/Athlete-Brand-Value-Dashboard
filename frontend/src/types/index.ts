export interface PlayerSummary {
  player_id: string
  full_name: string
  team_abbreviation: string | null
  position: string | null
  player_tier: string | null
  allstar_selections: number
  active_deals_count: number
  total_annual_value_usd: number | null
  avg_deal_value_usd: number | null
  top_deal_value_usd: number | null
  brands: string | null
  next_expiration: string | null
}

export interface DashboardStatsType {
  total_players: number
  total_active_deals: number
  total_market_value_usd: number
  avg_player_value_usd: number
  top_brand_by_spend: string | null
  top_player_by_value: string | null
}

export interface FilterOptions {
  tier: string | null
  limit: number
}

export interface Endorsement {
  endorsement_id: string
  player_id: string
  brand_name: string
  brand_category: string | null
  deal_value_usd: number | null
  deal_value_type: string | null
  value_confidence: string
  contract_start_date: string | null
  contract_end_date: string | null
  is_active: boolean
  player_name: string | null
}
