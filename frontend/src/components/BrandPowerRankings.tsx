'use client'

import { useEffect, useState } from 'react'
import { BrandLogo } from './BrandLogo'
import { TrendingUp, Users } from 'lucide-react'

interface CategoryData {
  category: string
  deal_count: number
  total_value_usd: number
  percentage: number
}

const formatValue = (cents: number) => {
  const billions = cents / 100 / 1_000_000_000
  if (billions >= 1) return `$${billions.toFixed(1)}B`
  const millions = cents / 100 / 1_000_000
  return `$${millions.toFixed(0)}M`
}

export function BrandPowerRankings() {
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

  if (loading) {
    return (
      <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-gray-100 dark:border-slate-700">
        <div className="animate-pulse space-y-4">
          <div className="h-6 bg-gray-200 dark:bg-gray-700 rounded w-1/3"></div>
          {[...Array(5)].map((_, i) => (
            <div key={i} className="h-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
          ))}
        </div>
      </div>
    )
  }

  return (
    <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-gray-100 dark:border-slate-700">
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Market Power by Category
        </h2>
        <p className="text-sm text-gray-600 dark:text-gray-400">
          Where the endorsement dollars are flowing
        </p>
      </div>

      <div className="space-y-3">
        {data.map((category, index) => {
          const isTop3 = index < 3
          const percentage = category.percentage

          return (
            <div
              key={category.category}
              className={`relative overflow-hidden rounded-xl p-5 transition-all duration-300 border ${
                isTop3
                  ? 'bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 border-blue-200 dark:border-blue-800'
                  : 'bg-gray-50 dark:bg-slate-900 border-gray-200 dark:border-slate-700 hover:bg-gray-100 dark:hover:bg-slate-800'
              }`}
            >
              {/* Progress bar background */}
              <div
                className="absolute inset-0 bg-gradient-to-r from-blue-500/10 to-purple-500/10"
                style={{ width: `${percentage}%` }}
              ></div>

              <div className="relative flex items-center justify-between">
                {/* Left side: Rank + Category */}
                <div className="flex items-center gap-4">
                  <div
                    className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm ${
                      isTop3
                        ? 'bg-gradient-to-br from-blue-500 to-purple-600 text-white'
                        : 'bg-gray-300 dark:bg-slate-700 text-gray-700 dark:text-gray-300'
                    }`}
                  >
                    {index + 1}
                  </div>
                  <div>
                    <h3 className="text-lg font-bold text-gray-900 dark:text-white mb-1">
                      {category.category}
                    </h3>
                    <div className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-400">
                      <span className="flex items-center gap-1">
                        <Users className="w-4 h-4" />
                        {category.deal_count} deals
                      </span>
                      <span>•</span>
                      <span className="flex items-center gap-1">
                        <TrendingUp className="w-4 h-4" />
                        {percentage.toFixed(1)}% share
                      </span>
                    </div>
                  </div>
                </div>

                {/* Right side: Value */}
                <div className="text-right">
                  <p className="text-2xl font-bold text-gray-900 dark:text-white">
                    {formatValue(category.total_value_usd)}
                  </p>
                  <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                    Total annual value
                  </p>
                </div>
              </div>
            </div>
          )
        })}
      </div>

      {/* Key Insights */}
      <div className="mt-6 pt-6 border-t border-gray-200 dark:border-slate-700">
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <p className="text-sm text-gray-600 dark:text-gray-400 mb-1">Top Category</p>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {data[0]?.category}
            </p>
          </div>
          <div>
            <p className="text-sm text-gray-600 dark:text-gray-400 mb-1">Market Leader</p>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {data[0]?.percentage.toFixed(1)}%
            </p>
          </div>
          <div>
            <p className="text-sm text-gray-600 dark:text-gray-400 mb-1">Categories</p>
            <p className="text-lg font-bold text-gray-900 dark:text-white">
              {data.length}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
