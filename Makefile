.PHONY: help setup start stop seed clean logs test

help:
	@echo "NBA Endorsement Tracker - Development Commands"
	@echo ""
	@echo "  make setup    - Initial setup (copy .env, install deps)"
	@echo "  make start    - Start all services with Docker Compose"
	@echo "  make stop     - Stop all services"
	@echo "  make seed     - Seed database with NBA players + endorsements"
	@echo "  make logs     - View logs from all services"
	@echo "  make clean    - Remove containers, volumes, and cached files"
	@echo "  make test     - Run backend tests"
	@echo ""

setup:
	@echo "Setting up project..."
	cp -n .env.example .env || true
	@echo "✓ Environment file created (.env)"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Edit .env if needed (defaults work for local dev)"
	@echo "  2. Run 'make start' to launch services"
	@echo "  3. Run 'make seed' to populate database"

start:
	@echo "Starting all services..."
	docker-compose up -d
	@echo ""
	@echo "Services started!"
	@echo "  Frontend:  http://localhost:3000"
	@echo "  API Docs:  http://localhost:8000/docs"
	@echo "  Database:  localhost:5432"
	@echo ""
	@echo "Run 'make seed' to populate database with sample data"

stop:
	docker-compose down

seed:
	@echo "Seeding database..."
	docker-compose exec api python /app/../scripts/seed_database.py

logs:
	docker-compose logs -f

clean:
	@echo "Cleaning up..."
	docker-compose down -v
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .next -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name node_modules -exec rm -rf {} + 2>/dev/null || true
	@echo "✓ Cleanup complete"

test:
	docker-compose exec api pytest tests/ -v --cov=app
