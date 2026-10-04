import type { DashboardStatsType, FilterOptions, PlayerSummary } from '@/types'

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'

export async function fetchDashboardStats(): Promise<DashboardStatsType> {
  const res = await fetch(`${API_BASE}/api/dashboard/stats`)
  if (!res.ok) throw new Error('Failed to fetch dashboard stats')
  return res.json()
}

export async function fetchLeaderboard(filters: FilterOptions): Promise<PlayerSummary[]> {
  const params = new URLSearchParams()
  if (filters.tier) params.set('tier', filters.tier)
  if (filters.limit) params.set('limit', String(filters.limit))

  const res = await fetch(`${API_BASE}/api/dashboard/leaderboard?${params}`)
  if (!res.ok) throw new Error('Failed to fetch leaderboard')
  return res.json()
}
