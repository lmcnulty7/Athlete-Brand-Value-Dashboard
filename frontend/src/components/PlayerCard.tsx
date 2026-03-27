import type { PlayerSummary } from '@/types'
import { formatCurrency, getTierBadgeColor } from '@/lib/utils'
import { TrendingUp, Award, DollarSign } from 'lucide-react'

interface PlayerCardProps {
  player: PlayerSummary
  rank: number
}

export function PlayerCard({ player, rank }: PlayerCardProps) {
  const getRankColor = (rank: number) => {
    if (rank === 1) return 'bg-gradient-to-br from-yellow-400 to-yellow-600'
    if (rank === 2) return 'bg-gradient-to-br from-gray-300 to-gray-500'
    if (rank === 3) return 'bg-gradient-to-br from-orange-400 to-orange-600'
    return 'bg-gradient-to-br from-slate-600 to-slate-700'
  }

  const getRankIcon = (rank: number) => {
    if (rank <= 3) return '🏆'
    if (rank <= 10) return '⭐'
    return ''
  }

  return (
    <div className="group relative overflow-hidden rounded-xl bg-white dark:bg-slate-800 p-6 shadow-md hover:shadow-2xl transition-all duration-300 border border-gray-100 dark:border-slate-700">
      {/* Rank badge */}
      <div className="absolute top-4 left-4 z-10">
        <div className={`${getRankColor(rank)} text-white w-12 h-12 rounded-full flex items-center justify-center font-bold shadow-lg`}>
          <span className="text-lg">{rank}</span>
        </div>
        {getRankIcon(rank) && (
          <div className="absolute -top-1 -right-1 text-xl">
            {getRankIcon(rank)}
          </div>
        )}
      </div>

      {/* Player info */}
      <div className="ml-16">
        <div className="flex items-start justify-between mb-3">
          <div>
            <h3 className="text-xl font-bold text-gray-900 dark:text-white mb-1 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
              {player.full_name}
            </h3>
            <div className="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400">
              <span className="font-semibold">{player.team_abbreviation || 'FA'}</span>
              <span>•</span>
              <span>{player.position || 'N/A'}</span>
              {player.allstar_selections > 0 && (
                <>
                  <span>•</span>
                  <span className="flex items-center gap-1">
                    <Award className="w-3 h-3" />
                    {player.allstar_selections}x All-Star
                  </span>
                </>
              )}
            </div>
          </div>

          {/* Tier badge */}
          {player.player_tier && (
            <span className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${getTierBadgeColor(player.player_tier)}`}>
              {player.player_tier}
            </span>
          )}
        </div>

        {/* Stats grid */}
        <div className="grid grid-cols-3 gap-4 mt-4 pt-4 border-t border-gray-100 dark:border-slate-700">
          <div>
            <div className="flex items-center gap-1 text-xs text-gray-500 dark:text-gray-400 mb-1">
              <DollarSign className="w-3 h-3" />
              <span>Total Value</span>
            </div>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {formatCurrency(player.total_annual_value_usd)}
            </p>
          </div>

          <div>
            <div className="flex items-center gap-1 text-xs text-gray-500 dark:text-gray-400 mb-1">
              <TrendingUp className="w-3 h-3" />
              <span>Active Deals</span>
            </div>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {player.active_deals_count}
            </p>
          </div>

          <div>
            <div className="text-xs text-gray-500 dark:text-gray-400 mb-1">
              Avg Deal
            </div>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {formatCurrency(player.avg_deal_value_usd)}
            </p>
          </div>
        </div>

        {/* Brands */}
        {player.brands && (
          <div className="mt-4 pt-4 border-t border-gray-100 dark:border-slate-700">
            <p className="text-xs font-medium text-gray-500 dark:text-gray-400 mb-2">
              Brand Partners
            </p>
            <div className="flex flex-wrap gap-2">
              {player.brands.split(',').map((brand, idx) => (
                <span
                  key={idx}
                  className="px-3 py-1 text-xs font-medium bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 rounded-full"
                >
                  {brand.trim()}
                </span>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
