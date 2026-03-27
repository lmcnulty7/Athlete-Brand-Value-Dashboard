import type { DashboardStatsType } from '@/types'
import { formatCurrency } from '@/lib/utils'

interface Props {
  stats: DashboardStatsType
}

export function DashboardStats({ stats }: Props) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <StatCard
        title="Total Market Value"
        value={formatCurrency(stats.total_market_value_usd)}
        subtitle="Annual endorsement value"
      />
      <StatCard
        title="Active Players"
        value={stats.total_players.toString()}
        subtitle={`${stats.total_active_deals} total deals`}
      />
      <StatCard
        title="Avg Player Value"
        value={formatCurrency(stats.avg_player_value_usd)}
        subtitle="Per player annually"
      />
      <StatCard
        title="Top Brand"
        value={stats.top_brand_by_spend || 'N/A'}
        subtitle="By total spend"
      />
    </div>
  )
}

function StatCard({
  title,
  value,
  subtitle,
}: {
  title: string
  value: string
  subtitle: string
}) {
  return (
    <div className="bg-white dark:bg-slate-800 rounded-lg shadow p-6">
      <dt className="text-sm font-medium text-gray-500 dark:text-gray-400 truncate">
        {title}
      </dt>
      <dd className="mt-1 text-3xl font-semibold text-gray-900 dark:text-white">
        {value}
      </dd>
      <dd className="mt-1 text-sm text-gray-500 dark:text-gray-400">
        {subtitle}
      </dd>
    </div>
  )
}
