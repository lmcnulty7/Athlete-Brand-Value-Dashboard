'use client'

import { useEffect, useState } from 'react'
import { StatCard } from '@/components/StatCard'
import { PlayerCardPremium } from '@/components/PlayerCardPremium'
import { TopPlayersChart } from '@/components/TopPlayersChart'
import { BrandPowerRankings } from '@/components/BrandPowerRankings'
import { FilterPanel } from '@/components/FilterPanel'
import { fetchDashboardStats, fetchLeaderboard } from '@/lib/api'
import type { PlayerSummary, DashboardStatsType, FilterOptions } from '@/types'
import { DollarSign, Users, TrendingUp, Award, Search, RefreshCw, Filter } from 'lucide-react'

export default function Home() {
  const [stats, setStats] = useState<DashboardStatsType | null>(null)
  const [players, setPlayers] = useState<PlayerSummary[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [filters, setFilters] = useState<FilterOptions>({
    tier: null,
    limit: 50,
  })

  useEffect(() => {
    loadData()
  }, [filters])

  const loadData = async () => {
    setLoading(true)
    try {
      const [statsData, playersData] = await Promise.all([
        fetchDashboardStats(),
        fetchLeaderboard(filters),
      ])
      setStats(statsData)
      setPlayers(playersData)
    } catch (error) {
      console.error('Error loading dashboard data:', error)
    } finally {
      setLoading(false)
    }
  }

  const filteredPlayers = players.filter(player =>
    player.full_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    (player.brands?.toLowerCase().includes(searchTerm.toLowerCase()))
  )

  const formatMarketValue = (value: number) => {
    const billions = value / 100 / 1_000_000_000
    if (billions >= 1) return `$${billions.toFixed(1)}B`
    const millions = value / 100 / 1_000_000
    return `$${millions.toFixed(0)}M`
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-gray-50 to-slate-100 dark:from-slate-950 dark:via-slate-900 dark:to-slate-950">
      {/* Premium Header */}
      <header className="relative overflow-hidden bg-gradient-to-r from-slate-900 via-blue-900 to-indigo-900 dark:from-slate-950 dark:via-blue-950 dark:to-indigo-950 border-b-4 border-blue-500">
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAxMCAwIEwgMCAwIDAgMTAiIGZpbGw9Im5vbmUiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS1vcGFjaXR5PSIwLjA1IiBzdHJva2Utd2lkdGg9IjEiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZ3JpZCkiLz48L3N2Zz4=')] opacity-20"></div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="flex items-center justify-between">
            <div>
              <div className="flex items-center gap-4 mb-3">
                <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl flex items-center justify-center shadow-2xl">
                  <Award className="w-9 h-9 text-white" />
                </div>
                <div>
                  <h1 className="text-4xl font-bold text-white mb-1">
                    NBA Endorsement Analytics
                  </h1>
                  <p className="text-blue-200 text-lg font-medium">
                    Professional Sports Marketing Intelligence Platform
                  </p>
                </div>
              </div>
            </div>
            <button
              onClick={loadData}
              disabled={loading}
              className="flex items-center gap-2 px-6 py-3 bg-white/10 backdrop-blur-md text-white rounded-xl hover:bg-white/20 transition-all duration-300 border border-white/20 disabled:opacity-50 shadow-lg"
            >
              <RefreshCw className={`w-5 h-5 ${loading ? 'animate-spin' : ''}`} />
              <span className="font-semibold">Refresh</span>
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-4 pb-16">
        {/* Hero Stats */}
        {stats && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <StatCard
              title="Total Market Value"
              value={formatMarketValue(stats.total_market_value_usd)}
              subtitle="Annual endorsement spend"
              icon={DollarSign}
              gradient="bg-gradient-to-br from-green-500 to-emerald-600"
              trend={{ value: "12.5%", isPositive: true }}
            />
            <StatCard
              title="Active Players"
              value={stats.total_players.toString()}
              subtitle="With endorsement deals"
              icon={Users}
              gradient="bg-gradient-to-br from-blue-500 to-blue-700"
            />
            <StatCard
              title="Total Deals"
              value={stats.total_active_deals.toString()}
              subtitle="Active partnerships"
              icon={TrendingUp}
              gradient="bg-gradient-to-br from-purple-500 to-purple-700"
            />
            <StatCard
              title="Top Player"
              value={stats.top_player_by_value?.split(' ').slice(-1)[0] || 'N/A'}
              subtitle={stats.top_player_by_value || 'No data'}
              icon={Award}
              gradient="bg-gradient-to-br from-yellow-500 to-orange-600"
            />
          </div>
        )}

        {/* Dual Analytics Section */}
        {!loading && players.length > 0 && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            <TopPlayersChart players={players} limit={10} />
            <BrandPowerRankings />
          </div>
        )}

        {/* Search and Filter Bar */}
        <div className="mb-6 bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-4 border border-gray-100 dark:border-slate-700">
          <div className="flex flex-col lg:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
              <input
                type="text"
                placeholder="Search players or brands..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-12 pr-4 py-3 rounded-xl border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all font-medium"
              />
            </div>
            <div className="flex items-center gap-3">
              <Filter className="text-gray-400 w-5 h-5" />
              <FilterPanel filters={filters} onFilterChange={setFilters} />
            </div>
          </div>
        </div>

        {/* Player Rankings */}
        <div>
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-1">
                Player Rankings
              </h2>
              <p className="text-gray-600 dark:text-gray-400">
                Showing {filteredPlayers.length} of {players.length} players ranked by total endorsement value
              </p>
            </div>
          </div>

          {loading ? (
            <div className="grid grid-cols-1 gap-6">
              {[...Array(5)].map((_, i) => (
                <div key={i} className="animate-pulse bg-white dark:bg-slate-800 rounded-2xl h-48 border border-gray-100 dark:border-slate-700"></div>
              ))}
            </div>
          ) : filteredPlayers.length === 0 ? (
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-16 text-center border border-gray-100 dark:border-slate-700">
              <div className="text-gray-400 mb-4">
                <Search className="w-20 h-20 mx-auto" />
              </div>
              <p className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                No players found
              </p>
              <p className="text-gray-600 dark:text-gray-400">
                Try adjusting your search or filters
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-6">
              {filteredPlayers.map((player, index) => (
                <PlayerCardPremium key={player.player_id} player={player} rank={index + 1} />
              ))}
            </div>
          )}
        </div>
      </main>

      {/* Premium Footer */}
      <footer className="mt-20 bg-slate-900 dark:bg-slate-950 border-t border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="text-center">
            <p className="text-sm text-slate-400 mb-2">
              Data sourced from NBA API, Spotrac, and public reporting. Values are estimates.
            </p>
            <p className="text-xs text-slate-500">
              Built with Next.js 14, FastAPI, PostgreSQL & Recharts • © 2026 NBA Endorsement Analytics
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}
