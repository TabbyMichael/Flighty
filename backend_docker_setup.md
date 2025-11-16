# Flight Booking Backend - Docker Setup and Changes

This document explains how to run the Flight Booking backend using Docker and summarizes all the changes made to fix connection issues and improve functionality.

## Table of Contents
1. [Docker Services Overview](#docker-services-overview)
2. [Running the Backend with Docker](#running-the-backend-with-docker)
3. [Environment Configuration](#environment-configuration)
4. [Changes Made](#changes-made)
5. [API Endpoints](#api-endpoints)
6. [Troubleshooting](#troubleshooting)

## Docker Services Overview

The Flight Booking backend consists of the following Docker services defined in `docker-compose.yml`:

- **postgres**: PostgreSQL database for storing application data
- **redis**: Redis cache for performance optimization
- **backend**: FastAPI application serving the main API
- **celery**: Background task worker
- **celery-beat**: Scheduled task scheduler

## Running the Backend with Docker

### Prerequisites
- Docker and Docker Compose installed
- Free ports: 5433 (PostgreSQL), 6380 (Redis), 8000 (Backend)

### Starting Services
```bash
# Navigate to the backend directory
cd /home/kzer00/Documents/FLighty/flight_backend

# Start all services in detached mode
docker-compose up -d

# Check service status
docker-compose ps
```

### Stopping Services
```bash
# Stop all services
docker-compose down

# Stop services and remove volumes (complete reset)
docker-compose down -v
```

### Viewing Logs
```bash
# View backend logs
docker-compose logs backend

# View all service logs
docker-compose logs

# View recent logs with continuous updates
docker-compose logs -f --tail 50
```

## Environment Configuration

### Port Configuration
To avoid conflicts with system services, we've configured alternative ports:
- PostgreSQL: Host port 5433 (internal container port 5432)
- Redis: Host port 6380 (internal container port 6379)
- Backend: Host port 8000 (internal container port 8000)

### Environment Variables (.env file)
```bash
# Database
DATABASE_URL=postgresql://flightuser:flightpass@localhost:5433/flightdb

# Redis
REDIS_URL=redis://localhost:6380/0

# API Keys
AVIATIONSTACK_KEY=02d420fb1991939a9ce1f6948495dbaa
OPENSKY_USER=kZer00
OPENSKY_PASS="&p>jU=sr\"~*@2HP"

# Celery
CELERY_BROKER_URL=redis://localhost:6380/0
CELERY_RESULT_BACKEND=redis://localhost:6380/0

# JWT
JWT_SECRET=my_jwt_secret_key_12345
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=30

# Security
SECRET_KEY=my_app_secret_key_12345
ALGORITHM=HS257
```

## Changes Made

### 1. Docker Configuration Fixes

**Issue**: Redis connection refused errors due to incorrect port configuration.

**Fix**: Updated `docker-compose.yml` to use correct internal Redis port:
```yaml
# Before (incorrect)
REDIS_URL=redis://redis:6380/0

# After (correct)
REDIS_URL=redis://redis:6379/0
```

### 2. AviationStack API Integration

**Issue**: Free plan limitations preventing origin/destination filtering.

**Fix**: Modified `app/core/aviationstack_client.py` to:
- Only use `access_key` and `limit` parameters (free plan compatible)
- Implement local filtering as a workaround
- Handle API errors gracefully

### 3. Cache Configuration

**Issue**: Redis connection issues affecting caching functionality.

**Fix**: Updated cache configuration to use proper Redis URL:
- Internal container communication uses port 6379
- External host access uses port 6380

### 4. Port Conflict Resolution

**Issue**: Default ports conflicting with system services.

**Fix**: Changed service ports to avoid conflicts:
- PostgreSQL: 5432 → 5433
- Redis: 6379 → 6380

## API Endpoints

### Health Check
- **Endpoint**: `http://localhost:8000/health`
- **Response**: `{"status":"healthy"}`

### Flight Search
- **Endpoint**: `http://localhost:8000/flights/search`
- **Parameters**: 
  - `origin`: Origin airport code (e.g., JFK)
  - `destination`: Destination airport code (e.g., LAX)
  - `date`: Flight date (YYYY-MM-DD)
- **Response**: `{"flights":[]}`

### Flight List
- **Endpoint**: `http://localhost:8000/flights/`
- **Response**: `{"flights":[]}`

## Troubleshooting

### Common Issues and Solutions

1. **Port Conflicts**
   ```bash
   # Kill processes using specific ports
   sudo fuser -k 5433/tcp  # PostgreSQL
   sudo fuser -k 6380/tcp  # Redis
   sudo fuser -k 8000/tcp  # Backend
   ```

2. **Redis Connection Issues**
   - Ensure Redis URL in `.env` uses port 6380 for host access
   - Ensure Docker services use `redis://redis:6379/0` for internal communication

3. **AviationStack API Errors**
   - Free plan limitations prevent filtering by origin/destination
   - Solution: Use local filtering as implemented in the client

4. **Docker Container Issues**
   ```bash
   # Rebuild containers without cache
   docker-compose build --no-cache
   
   # Force recreate containers
   docker-compose up -d --force-recreate
   ```

5. **Cache Problems**
   ```bash
   # Clear Redis cache
   docker-compose exec redis redis-cli FLUSHALL
   ```

### Service Status Check
```bash
# Check if all services are running
docker-compose ps

# Expected output:
# - flight_backend_postgres_1: Up
# - flight_backend_redis_1: Up
# - flight_backend_backend_1: Up
# - flight_backend_celery_1: Up
# - flight_backend_celery-beat_1: Up
```

### Testing API Connectivity
```bash
# Test health endpoint
curl -I http://localhost:8000/health

# Test flight search endpoint
curl "http://localhost:8000/flights/search?origin=JFK&destination=LAX&date=2023-12-01"
```

## Conclusion

The Flight Booking backend is now properly configured to run with Docker using alternative ports to avoid conflicts. All services are correctly interconnected, and the AviationStack API integration works within free plan limitations. The system includes rate limiting, caching, and proper error handling for production use.