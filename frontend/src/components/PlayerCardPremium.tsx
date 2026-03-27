import type { PlayerSummary } from '@/types'
import { formatCurrency, getTierBadgeColor } from '@/lib/utils'
import { getTeamColors } from '@/lib/team-colors'
import { BrandLogo } from './BrandLogo'
import { TrendingUp, Award, DollarSign, Calendar } from 'lucide-react'

interface PlayerCardPremiumProps {
  player: PlayerSummary
  rank: number
}

export function PlayerCardPremium({ player, rank }: PlayerCardPremiumProps) {
  const teamColors = getTeamColors(player.team_abbreviation)
  const brandList = player.brands?.split(',').map(b => b.trim()).filter(b => b) || []

  const getRankBadge = (rank: number) => {
    if (rank === 1) return { emoji: '🥇', color: 'from-yellow-400 to-yellow-600', text: '#1' }
    if (rank === 2) return { emoji: '🥈', color: 'from-gray-300 to-gray-500', text: '#2' }
    if (rank === 3) return { emoji: '🥉', color: 'from-orange-400 to-orange-600', text: '#3' }
    return { emoji: null, color: 'from-blue-500 to-blue-700', text: `#${rank}` }
  }

  const rankBadge = getRankBadge(rank)

  // Get initials for avatar
  const getInitials = (name: string) => {
    return name.split(' ').map(n => n[0]).join('').substring(0, 2)
  }

  return (
    <div className="group relative bg-white dark:bg-slate-800 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 overflow-hidden border border-gray-100 dark:border-slate-700">
      {/* Team Color Accent Bar */}
      <div
        className="h-2 w-full"
        style={{ backgroundColor: teamColors.primary }}
      ></div>

      <div className="p-6">
        <div className="flex items-start gap-6">
          {/* Left: Avatar + Rank */}
          <div className="relative flex-shrink-0">
            {/* Avatar */}
            <div
              className="w-24 h-24 rounded-full flex items-center justify-center text-white text-2xl font-bold shadow-xl ring-4 ring-white dark:ring-slate-800"
              style={{ backgroundColor: teamColors.primary }}
            >
              {getInitials(player.full_name)}
            </div>

            {/* Rank Badge */}
            <div className={`absolute -top-2 -right-2 w-10 h-10 bg-gradient-to-br ${rankBadge.color} rounded-full flex items-center justify-center text-white font-bold text-sm shadow-lg border-2 border-white dark:border-slate-800`}>
              {rankBadge.emoji || rankBadge.text}
            </div>
          </div>

          {/* Right: Player Info */}
          <div className="flex-1 min-w-0">
            {/* Name + Team */}
            <div className="mb-4">
              <div className="flex items-center gap-3 mb-2">
                <h3 className="text-2xl font-bold text-gray-900 dark:text-white truncate">
                  {player.full_name}
                </h3>
                {player.player_tier && (
                  <span className={`px-3 py-1 text-xs font-semibold rounded-full ${getTierBadgeColor(player.player_tier)}`}>
                    {player.player_tier}
                  </span>
                )}
              </div>
              <div className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-400">
                <span
                  className="font-bold px-3 py-1 rounded-md text-white"
                  style={{ backgroundColor: teamColors.primary }}
                >
                  {player.team_abbreviation || 'FA'}
                </span>
                <span>{player.position || 'N/A'}</span>
                {player.allstar_selections > 0 && (
                  <>
                    <span>•</span>
                    <span className="flex items-center gap-1">
                      <Award className="w-4 h-4 text-yellow-500" />
                      {player.allstar_selections}x All-Star
                    </span>
                  </>
                )}
              </div>
            </div>

            {/* Stats Grid */}
            <div className="grid grid-cols-3 gap-4 mb-4">
              <div className="bg-gradient-to-br from-green-50 to-emerald-50 dark:from-green-900/20 dark:to-emerald-900/20 rounded-xl p-4 border border-green-100 dark:border-green-800">
                <div className="flex items-center gap-2 text-green-600 dark:text-green-400 mb-1">
                  <DollarSign className="w-4 h-4" />
                  <span className="text-xs font-medium uppercase tracking-wide">Total Value</span>
                </div>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">
                  {formatCurrency(player.total_annual_value_usd)}
                </p>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Annual
                </p>
              </div>

              <div className="bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 rounded-xl p-4 border border-blue-100 dark:border-blue-800">
                <div className="flex items-center gap-2 text-blue-600 dark:text-blue-400 mb-1">
                  <TrendingUp className="w-4 h-4" />
                  <span className="text-xs font-medium uppercase tracking-wide">Active Deals</span>
                </div>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">
                  {player.active_deals_count}
                </p>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Partnerships
                </p>
              </div>

              <div className="bg-gradient-to-br from-purple-50 to-pink-50 dark:from-purple-900/20 dark:to-pink-900/20 rounded-xl p-4 border border-purple-100 dark:border-purple-800">
                <div className="flex items-center gap-2 text-purple-600 dark:text-purple-400 mb-1">
                  <Calendar className="w-4 h-4" />
                  <span className="text-xs font-medium uppercase tracking-wide">Avg Deal</span>
                </div>
                <p className="text-2xl font-bold text-gray-900 dark:text-white">
                  {formatCurrency(player.avg_deal_value_usd)}
                </p>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Per partnership
                </p>
              </div>
            </div>

            {/* Brand Partners with Logos */}
            {brandList.length > 0 && (
              <div className="border-t border-gray-100 dark:border-slate-700 pt-4">
                <p className="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wide mb-3">
                  Brand Partners ({brandList.length})
                </p>
                <div className="flex flex-wrap gap-2">
                  {brandList.slice(0, 8).map((brand, idx) => (
                    <BrandLogo key={idx} brandName={brand} size="md" />
                  ))}
                  {brandList.length > 8 && (
                    <div className="w-10 h-10 rounded-lg bg-gray-100 dark:bg-slate-700 flex items-center justify-center text-gray-600 dark:text-gray-400 text-xs font-semibold">
                      +{brandList.length - 8}
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Hover effect overlay */}
      <div className="absolute inset-0 bg-gradient-to-r from-transparent to-transparent group-hover:from-blue-500/5 group-hover:to-purple-500/5 pointer-events-none transition-all duration-300"></div>
    </div>
  )
}
