export function formatCurrency(cents: number | null | undefined): string {
  if (cents == null) return 'N/A'
  const dollars = cents / 100
  if (dollars >= 1_000_000_000) return `$${(dollars / 1_000_000_000).toFixed(1)}B`
  if (dollars >= 1_000_000) return `$${(dollars / 1_000_000).toFixed(1)}M`
  if (dollars >= 1_000) return `$${(dollars / 1_000).toFixed(0)}K`
  return `$${dollars.toFixed(0)}`
}

export function getTierBadgeColor(tier: string): string {
  switch (tier.toLowerCase()) {
    case 'superstar': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
    case 'star':      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'starter':   return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'role player':
    case 'role_player': return 'bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400'
    default:          return 'bg-slate-100 text-slate-800 dark:bg-slate-900/30 dark:text-slate-400'
  }
}
