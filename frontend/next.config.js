// Same default as src/lib/api.ts, so a fresh clone builds without .env.local
const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: apiUrl + '/:path*',
      },
    ]
  },
}

module.exports = nextConfig
