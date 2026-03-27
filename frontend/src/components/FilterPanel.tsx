import type { FilterOptions } from '@/types'
import { Filter } from 'lucide-react'

interface Props {
  filters: FilterOptions
  onFilterChange: (filters: FilterOptions) => void
}

export function FilterPanel({ filters, onFilterChange }: Props) {
  const playerTiers = [
    { value: null, label: 'All Tiers', color: 'bg-gray-100' },
    { value: 'Superstar', label: 'Superstar', color: 'bg-yellow-100' },
    { value: 'All-Star', label: 'All-Star', color: 'bg-blue-100' },
    { value: 'Starter', label: 'Starter', color: 'bg-green-100' },
    { value: 'Role Player', label: 'Role Player', color: 'bg-gray-100' },
  ]

  return (
    <div className="relative">
      <div className="absolute left-4 top-1/2 transform -translate-y-1/2 pointer-events-none">
        <Filter className="w-5 h-5 text-gray-400" />
      </div>
      <select
        value={filters.tier || ''}
        onChange={(e) =>
          onFilterChange({
            ...filters,
            tier: e.target.value === '' ? null : e.target.value,
          })
        }
        className="w-full pl-12 pr-4 py-3 rounded-xl border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all appearance-none cursor-pointer font-medium"
      >
        {playerTiers.map((tier) => (
          <option key={tier.value || 'all'} value={tier.value || ''}>
            {tier.label}
          </option>
        ))}
      </select>
    </div>
  )
}
