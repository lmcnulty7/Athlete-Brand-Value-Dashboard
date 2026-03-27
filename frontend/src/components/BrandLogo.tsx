interface BrandLogoProps {
  brandName: string
  size?: 'sm' | 'md' | 'lg'
}

const brandStyles: Record<string, { bg: string; text: string; abbr: string }> = {
  'Nike': { bg: '#FF6B00', text: '#FFFFFF', abbr: 'NK' },
  'Jordan Brand': { bg: '#000000', text: '#FFFFFF', abbr: 'JB' },
  'Adidas': { bg: '#000000', text: '#FFFFFF', abbr: 'AD' },
  'Under Armour': { bg: '#000000', text: '#FFFFFF', abbr: 'UA' },
  'New Balance': { bg: '#CC0000', text: '#FFFFFF', abbr: 'NB' },
  'Puma': { bg: '#000000', text: '#FFFFFF', abbr: 'PM' },
  'Anta': { bg: '#E60012', text: '#FFFFFF', abbr: 'AN' },
  'Li-Ning': { bg: '#DC1E2D', text: '#FFFFFF', abbr: 'LN' },

  'Apple': { bg: '#000000', text: '#FFFFFF', abbr: 'AP' },
  'Beats by Dre': { bg: '#E01F27', text: '#FFFFFF', abbr: 'BT' },
  'Google': { bg: '#4285F4', text: '#FFFFFF', abbr: 'GO' },
  'Samsung': { bg: '#1428A0', text: '#FFFFFF', abbr: 'SS' },
  'Meta': { bg: '#0668E1', text: '#FFFFFF', abbr: 'FB' },
  'Sony': { bg: '#000000', text: '#FFFFFF', abbr: 'SN' },

  'State Farm': { bg: '#E31837', text: '#FFFFFF', abbr: 'SF' },
  'Geico': { bg: '#005CA9', text: '#FFFFFF', abbr: 'GC' },
  'American Express': { bg: '#006FCF', text: '#FFFFFF', abbr: 'AX' },
  'Chase': { bg: '#117ACA', text: '#FFFFFF', abbr: 'CH' },
  'Capital One': { bg: '#004879', text: '#FFFFFF', abbr: 'C1' },

  'Gatorade': { bg: '#F87700', text: '#FFFFFF', abbr: 'GT' },
  'Pepsi': { bg: '#004B93', text: '#FFFFFF', abbr: 'PP' },
  'Coca-Cola': { bg: '#ED1C16', text: '#FFFFFF', abbr: 'CC' },
  'Mountain Dew': { bg: '#75C044', text: '#000000', abbr: 'MD' },
  'Sprite': { bg: '#00AF4D', text: '#FFFFFF', abbr: 'SP' },
  'Subway': { bg: '#00853F', text: '#FFD100', abbr: 'SW' },
  'Taco Bell': { bg: '#702082', text: '#FFFFFF', abbr: 'TB' },
  'Powerade': { bg: '#0076CE', text: '#FFFFFF', abbr: 'PW' },

  'Kia': { bg: '#BB162B', text: '#FFFFFF', abbr: 'KI' },
  'Toyota': { bg: '#EB0A1E', text: '#FFFFFF', abbr: 'TY' },
  'BMW': { bg: '#1C69D4', text: '#FFFFFF', abbr: 'BW' },

  '2K Sports': { bg: '#000000', text: '#FFFFFF', abbr: '2K' },
  'Panini': { bg: '#E31837', text: '#FFFFFF', abbr: 'PN' },

  'AT&T': { bg: '#00A8E1', text: '#FFFFFF', abbr: 'TT' },
  'Verizon': { bg: '#CD040B', text: '#FFFFFF', abbr: 'VZ' },

  'Crypto.com': { bg: '#002D74', text: '#FFFFFF', abbr: 'CR' },
  'Coinbase': { bg: '#0052FF', text: '#FFFFFF', abbr: 'CB' },

  'Rakuten': { bg: '#BF0000', text: '#FFFFFF', abbr: 'RK' },
  'Amazon': { bg: '#FF9900', text: '#000000', abbr: 'AZ' },
  'Walmart': { bg: '#0071CE', text: '#FFC220', abbr: 'WM' },

  'JBL': { bg: '#FF3300', text: '#FFFFFF', abbr: 'JB' },
  'Tissot': { bg: '#C8102E', text: '#FFFFFF', abbr: 'TS' },
  'Rolex': { bg: '#006039', text: '#A37E2C', abbr: 'RX' },
  'Honey': { bg: '#FFB900', text: '#000000', abbr: 'HN' },
  'Wingstop': { bg: '#E32636', text: '#FFFFFF', abbr: 'WS' },
  'Corona': { bg: '#FFCC00', text: '#005EB8', abbr: 'CO' },
}

const sizeClasses = {
  sm: 'w-7 h-7 text-xs',
  md: 'w-10 h-10 text-sm',
  lg: 'w-14 h-14 text-base',
}

export function BrandLogo({ brandName, size = 'md' }: BrandLogoProps) {
  const brand = brandStyles[brandName] || {
    bg: '#6B7280',
    text: '#FFFFFF',
    abbr: brandName.substring(0, 2).toUpperCase()
  }

  return (
    <div
      className={`${sizeClasses[size]} rounded-lg flex items-center justify-center font-bold shadow-md transition-transform hover:scale-110`}
      style={{ backgroundColor: brand.bg, color: brand.text }}
      title={brandName}
    >
      {brand.abbr}
    </div>
  )
}
