'use client'

import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell } from 'recharts'
import type { PlayerSummary } from '@/types'

interface TopPlayersChartProps {
  players: PlayerSummary[]
  limit?: number
}

export function TopPlayersChart({ players, limit = 10 }: TopPlayersChartProps) {
  const chartData = players.slice(0, limit).map((player, idx) => ({
    name: player.full_name.split(' ').slice(-1)[0], // Last name only
    value: (player.total_annual_value_usd || 0) / 100 / 1_000_000, // Convert cents to millions
    fullName: player.full_name,
    deals: player.active_deals_count,
    rank: idx + 1
  }))

  const getBarColor = (rank: number) => {
    if (rank === 1) return '#fbbf24' // gold
    if (rank === 2) return '#9ca3af' // silver
    if (rank === 3) return '#fb923c' // bronze
    return '#3b82f6' // blue
  }

  return (
    <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-gray-100 dark:border-slate-700">
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Top Players by Endorsement Value
        </h2>
        <p className="text-sm text-gray-600 dark:text-gray-400">
          Annual endorsement value in millions (USD)
        </p>
      </div>

      <ResponsiveContainer width="100%" height={400}>
        <BarChart data={chartData} margin={{ top: 20, right: 30, left: 20, bottom: 60 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis
            dataKey="name"
            angle={-45}
            textAnchor="end"
            height={100}
            tick={{ fill: '#6b7280', fontSize: 12 }}
          />
          <YAxis
            tick={{ fill: '#6b7280', fontSize: 12 }}
            label={{ value: 'Value ($M)', angle: -90, position: 'insideLeft', fill: '#6b7280' }}
          />
          <Tooltip
            content={({ active, payload }) => {
              if (active && payload && payload[0]) {
                const data = payload[0].payload
                return (
                  <div className="bg-white dark:bg-slate-800 p-4 rounded-lg shadow-xl border border-gray-200 dark:border-slate-700">
                    <p className="font-bold text-gray-900 dark:text-white mb-2">
                      #{data.rank} {data.fullName}
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Annual Value: <span className="font-semibold text-blue-600">${data.value.toFixed(1)}M</span>
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Active Deals: <span className="font-semibold">{data.deals}</span>
                    </p>
                  </div>
                )
              }
              return null
            }}
          />
          <Bar dataKey="value" radius={[8, 8, 0, 0]}>
            {chartData.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={getBarColor(entry.rank)} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}
