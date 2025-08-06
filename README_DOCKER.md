# Docker Setup - Duo Finance API

This project is configured to run with Docker and Docker Compose, using a separate PostgreSQL container.

## Prerequisites

- Docker
- Docker Compose

## Container Structure

- **PostgreSQL**: Separate container `duo-finance-pg` on port 5432
- **NestJS API**: Application on port 3000

## Initial Setup

### 1. PostgreSQL Container

The PostgreSQL container is already configured and running:

```bash
# Check if it's running
docker ps | grep duo-finance-pg

# If not running, start it:
docker run --name duo-finance-pg \
  -e POSTGRESQL_USERNAME=your_username \
  -e POSTGRESQL_PASSWORD=your_password \
  -e POSTGRESQL_DATABASE=duo-finance-db \
  -p 5432:5432 \
  bitnami/postgresql
```

### 2. Connect to Docker Network

```bash
# Connect the PostgreSQL container to the project network
docker network connect duo-finance-api_default duo-finance-pg
```

## Quick Commands

### Using the helper script:

```bash
# Start only the API (PostgreSQL already running)
./scripts/docker.sh up

# Stop the API
./scripts/docker.sh down

# View logs
./scripts/docker.sh logs

# Run migrations
./scripts/docker.sh migrate

# Open Prisma Studio
./scripts/docker.sh studio

# Access container shell
./scripts/docker.sh shell
```

### Using Docker Compose directly:

```bash
# Start API
docker-compose up -d

# Stop API
docker-compose down

# View logs
docker-compose logs -f

# Run migrations
docker-compose exec api npx prisma migrate dev

# Open Prisma Studio
docker-compose exec api npx prisma studio
```

## First Run

1. **Check if PostgreSQL is running**:

   ```bash
   docker ps | grep duo-finance-pg
   ```

2. **Start the API**:

   ```bash
   ./scripts/docker.sh up
   ```

3. **Run migrations**:

   ```bash
   ./scripts/docker.sh migrate
   ```

4. **Access the API**: http://localhost:3000

## Environment Variables

The following variables are configured:

- `DATABASE_URL`: postgresql://your_username:your_password@duo-finance-pg:5432/duo-finance-db?schema=public
- `NODE_ENV`: development

## Volumes

- `./:/app`: Application source code (hot reload)
- `./generated/prisma`: Generated Prisma client

## Ports

- **3000**: NestJS API
- **5432**: PostgreSQL (external)

## Troubleshooting

### Database connection error

If you encounter database access errors:

1. Check if the PostgreSQL container is running: `docker ps | grep duo-finance-pg`
2. Check if it's connected to the network: `docker network inspect duo-finance-api_default`
3. Test the connection: `docker-compose exec api npx prisma db pull`

### Rebuild required

If there are changes in the Dockerfile:

```bash
./scripts/docker.sh build
./scripts/docker.sh up
```

### Clean everything

To clean completely and start from scratch:

```bash
docker-compose down
docker stop duo-finance-pg
docker rm duo-finance-pg
# Recreate the PostgreSQL container as per instructions above
```

## Current Status

✅ PostgreSQL running on port 5432  
✅ NestJS API running on port 3000  
✅ Migrations applied  
✅ Hot reload working  
✅ Prisma Studio available

## Useful Commands

```bash
# View real-time logs
docker-compose logs -f api

# Execute commands in container
docker-compose exec api sh

# Check container status
docker-compose ps

# Access Prisma Studio
docker-compose exec api npx prisma studio --hostname 0.0.0.0 --port 5555
```

## Security Notes

⚠️ **Important**:

- Never commit real database credentials to version control
- Use environment variables for sensitive data
- Consider using Docker secrets for production deployments
- Regularly update base images for security patches
