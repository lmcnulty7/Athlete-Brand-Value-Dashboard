'use client'

import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from 'recharts'
import { useEffect, useState } from 'react'

interface CategoryData {
  category: string
  deal_count: number
  total_value_usd: number
  percentage: number
}

const CATEGORY_COLORS: Record<string, string> = {
  'Footwear/Apparel': '#3b82f6',      // blue
  'Food/Beverage': '#10b981',         // green
  'Technology': '#8b5cf6',            // purple
  'Financial/Insurance': '#f59e0b',   // amber
  'Telecom': '#06b6d4',               // cyan
  'Gaming/Media': '#ec4899',          // pink
  'Crypto/Finance': '#f97316',        // orange
  'E-Commerce': '#14b8a6',            // teal
  'Automotive': '#6366f1',            // indigo
  'Luxury Goods': '#eab308',          // yellow
  'Other': '#94a3b8',                 // slate
}

export function CategoryBreakdownChart() {
  const [data, setData] = useState<CategoryData[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadData()
  }, [])

  const loadData = async () => {
    try {
      const response = await fetch('http://localhost:8000/api/dashboard/category-breakdown')
      const categoryData = await response.json()
      setData(categoryData)
    } catch (error) {
      console.error('Error loading category data:', error)
    } finally {
      setLoading(false)
    }
  }

  const chartData = data.map(item => ({
    name: item.category,
    value: item.total_value_usd / 100 / 1_000_000, // Convert cents to millions
    percentage: item.percentage,
    deals: item.deal_count
  }))

  const formatCurrency = (value: number) => {
    if (value >= 1000) return `$${(value / 1000).toFixed(1)}B`
    return `$${value.toFixed(0)}M`
  }

  if (loading) {
    return (
      <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-gray-100 dark:border-slate-700">
        <div className="animate-pulse">
          <div className="h-6 bg-gray-200 dark:bg-gray-700 rounded w-1/3 mb-4"></div>
          <div className="h-64 bg-gray-200 dark:bg-gray-700 rounded"></div>
        </div>
      </div>
    )
  }

  return (
    <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-gray-100 dark:border-slate-700">
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Market Distribution by Category
        </h2>
        <p className="text-sm text-gray-600 dark:text-gray-400">
          Endorsement value breakdown across brand categories
        </p>
      </div>

      <div className="flex flex-col lg:flex-row items-center gap-8">
        {/* Donut Chart */}
        <div className="w-full lg:w-1/2">
          <ResponsiveContainer width="100%" height={350}>
            <PieChart>
              <Pie
                data={chartData}
                cx="50%"
                cy="50%"
                innerRadius={80}
                outerRadius={120}
                paddingAngle={2}
                dataKey="value"
                label={({ percentage }) => `${percentage.toFixed(1)}%`}
                labelLine={false}
              >
                {chartData.map((entry, index) => (
                  <Cell
                    key={`cell-${index}`}
                    fill={CATEGORY_COLORS[entry.name] || '#94a3b8'}
                  />
                ))}
              </Pie>
              <Tooltip
                content={({ active, payload }) => {
                  if (active && payload && payload[0]) {
                    const data = payload[0].payload
                    return (
                      <div className="bg-white dark:bg-slate-800 p-4 rounded-lg shadow-xl border border-gray-200 dark:border-slate-700">
                        <p className="font-bold text-gray-900 dark:text-white mb-2">
                          {data.name}
                        </p>
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          Value: <span className="font-semibold text-blue-600">{formatCurrency(data.value)}</span>
                        </p>
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          Share: <span className="font-semibold">{data.percentage.toFixed(1)}%</span>
                        </p>
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          Deals: <span className="font-semibold">{data.deals}</span>
                        </p>
                      </div>
                    )
                  }
                  return null
                }}
              />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Legend with Stats */}
        <div className="w-full lg:w-1/2">
          <div className="space-y-3">
            {chartData.map((item, index) => (
              <div
                key={index}
                className="flex items-center justify-between p-3 rounded-lg bg-gray-50 dark:bg-slate-900 hover:bg-gray-100 dark:hover:bg-slate-700 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <div
                    className="w-4 h-4 rounded-full"
                    style={{ backgroundColor: CATEGORY_COLORS[item.name] || '#94a3b8' }}
                  ></div>
                  <div>
                    <p className="text-sm font-medium text-gray-900 dark:text-white">
                      {item.name}
                    </p>
                    <p className="text-xs text-gray-500 dark:text-gray-400">
                      {item.deals} deals
                    </p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-sm font-bold text-gray-900 dark:text-white">
                    {formatCurrency(item.value)}
                  </p>
                  <p className="text-xs text-gray-500 dark:text-gray-400">
                    {item.percentage.toFixed(1)}%
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
