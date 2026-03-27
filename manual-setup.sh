#!/bin/bash
# Manual setup script for running without Docker

set -e

echo "======================================"
echo "NBA Endorsement Tracker - Manual Setup"
echo "======================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.11+"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 20+"
    exit 1
fi

if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL not found."
    echo ""
    echo "Install PostgreSQL using Homebrew:"
    echo "  brew install postgresql@15"
    echo "  brew services start postgresql@15"
    exit 1
fi

echo "✓ Python $(python3 --version)"
echo "✓ Node $(node --version)"
echo "✓ PostgreSQL installed"
echo ""

# Setup backend
echo "======================================"
echo "Setting up Backend..."
echo "======================================"

cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt

echo "✓ Backend dependencies installed"
cd ..

# Setup database
echo ""
echo "======================================"
echo "Setting up Database..."
echo "======================================"

# Create database
echo "Creating database 'endorsement_tracker'..."
createdb endorsement_tracker 2>/dev/null || echo "Database already exists"

# Initialize schema
echo "Initializing database schema..."
psql endorsement_tracker < database/init.sql > /dev/null 2>&1 || true

echo "✓ Database initialized"

# Setup frontend
echo ""
echo "======================================"
echo "Setting up Frontend..."
echo "======================================"

cd frontend

# Install dependencies
echo "Installing Node dependencies (this may take a minute)..."
npm install --silent

# Create .env.local
cat > .env.local << EOF
NEXT_PUBLIC_API_URL=http://localhost:8000
EOF

echo "✓ Frontend dependencies installed"
cd ..

echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "To start the application:"
echo ""
echo "Terminal 1 (Backend):"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  uvicorn app.main:app --reload"
echo ""
echo "Terminal 2 (Frontend):"
echo "  cd frontend"
echo "  npm run dev"
echo ""
echo "Terminal 3 (Seed Database):"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  python ../scripts/seed_database.py"
echo ""
echo "Then visit:"
echo "  Frontend: http://localhost:3000"
echo "  API Docs: http://localhost:8000/docs"
echo ""
