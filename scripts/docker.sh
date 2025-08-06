#!/bin/bash

# =============================================================================
# Docker Environment Management Script
# =============================================================================
# This script provides convenient commands to manage the Docker environment
# for the Duo Finance API project.
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo -e "${BLUE}Docker Environment Management Script${NC}"
    echo ""
    echo "Usage: $0 {command}"
    echo ""
    echo "Available commands:"
    echo "  up      - Start containers in detached mode"
    echo "  down    - Stop and remove containers"
    echo "  build   - Build or rebuild containers"
    echo "  logs    - Show container logs (follow mode)"
    echo "  migrate - Run Prisma migrations"
    echo "  studio  - Open Prisma Studio"
    echo "  shell   - Open shell in API container"
    echo "  restart - Restart all containers"
    echo "  status  - Show container status"
    echo "  clean   - Remove unused containers, networks, and images"
    echo ""
    echo "Examples:"
    echo "  $0 up"
    echo "  $0 logs"
    echo "  $0 migrate"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Main script logic
case "$1" in
    "up")
        print_status "Starting containers..."
        check_docker
        docker compose up -d
        print_status "Containers started successfully!"
        ;;
    "down")
        print_status "Stopping containers..."
        check_docker
        docker compose down
        print_status "Containers stopped successfully!"
        ;;
    "build")
        print_status "Building containers..."
        check_docker
        docker compose build
        print_status "Containers built successfully!"
        ;;
    "logs")
        print_status "Showing container logs (press Ctrl+C to exit)..."
        check_docker
        docker compose logs -f
        ;;
    "migrate")
        print_status "Running Prisma migrations..."
        check_docker
        docker compose exec api npx prisma migrate dev
        print_status "Migrations completed successfully!"
        ;;
    "studio")
        print_status "Opening Prisma Studio..."
        check_docker
        docker compose exec api npx prisma studio
        ;;
    "shell")
        print_status "Opening shell in API container..."
        check_docker
        docker compose exec api sh
        ;;
    "restart")
        print_status "Restarting containers..."
        check_docker
        docker compose restart
        print_status "Containers restarted successfully!"
        ;;
    "status")
        print_status "Container status:"
        check_docker
        docker compose ps
        ;;
    "clean")
        print_warning "This will remove unused containers, networks, and images."
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Cleaning up Docker resources..."
            check_docker
            docker system prune -f
            print_status "Cleanup completed!"
        else
            print_status "Cleanup cancelled."
        fi
        ;;
    *)
        print_error "Invalid command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac
