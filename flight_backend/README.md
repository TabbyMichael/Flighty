# Flight Booking Backend API

A production-ready backend for a flight booking application built with FastAPI, PostgreSQL, Redis, and Celery.

## Architecture

```
Flutter App  <---->  FastAPI Backend  <---->  PostgreSQL (primary)
                              |
                              +-- Redis (cache + Celery broker)
                              |
                              +-- Celery workers (tasks, cron, webhooks)
                              |
                              +-- External APIs: AviationStack, OpenSky
                              |
                              +-- Logging/Analytics: ELK (Filebeat → Elasticsearch + Kibana)
                              |
                              +-- Metrics: Prometheus + Grafana
                              |
                              +-- CDN/Ingress + HTTPS (NGINX/Traefik)
```

## Features

- **Flight Search**: Search flights using AviationStack API with Redis caching
- **Booking Management**: Create and manage flight bookings
- **User Authentication**: JWT-based authentication
- **Webhooks**: Subscribe to booking and flight status events
- **Caching**: Redis caching for improved performance
- **Background Tasks**: Celery for async processing and cron jobs
- **Analytics**: Structured logging and metrics
- **Security**: JWT auth, rate limiting, input sanitization

## Tech Stack

- **FastAPI**: Main HTTP API framework
- **PostgreSQL**: Primary database (SQLAlchemy + Alembic)
- **Redis**: Caching and Celery broker
- **Celery**: Background task processing
- **Celery Beat**: Scheduled tasks (cron)
- **AviationStack**: Flight/airport/airline data
- **OpenSky**: Live aircraft positions
- **Docker**: Containerization
- **Docker Compose**: Local development

## Setup

1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Start services with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

3. **Run database migrations**:
   ```bash
   alembic upgrade head
   ```

4. **Start the development server**:
   ```bash
   uvicorn app.main:app --reload
   ```

## API Endpoints

### Authentication
- `POST /auth/signup` - User registration
- `POST /auth/login` - User login
- `POST /auth/refresh` - Refresh access token

### Flights
- `GET /flights/search` - Search flights
- `GET /flights/{id}` - Get flight details
- `GET /flights/live` - Get live flight data
- `GET /flights/track/{identifier}` - Track a specific flight

### Bookings
- `POST /bookings` - Create a booking
- `GET /bookings` - List user bookings
- `GET /bookings/{pnr}` - Get booking details

### Airports
- `GET /airports` - List airports
- `GET /airports/{iata}` - Get airport details
- `POST /airports/sync` - Sync airports (admin)

### Airlines
- `GET /airlines` - List airlines
- `GET /airlines/{iata}` - Get airline details
- `POST /airlines/sync` - Sync airlines (admin)

### Webhooks
- `POST /webhooks/subscriptions` - Create webhook subscription
- `GET /webhooks/subscriptions` - List webhook subscriptions
- `POST /webhooks/test` - Test webhook delivery

### Admin
- `GET /admin/metrics` - Prometheus metrics
- `GET /admin/health` - Health check

## Development

### Database Migrations
```bash
# Create a new migration
alembic revision --autogenerate -m "Description of changes"

# Apply migrations
alembic upgrade head

# Rollback migrations
alembic downgrade -1
```

### Testing
```bash
# Run tests
pytest

# Run tests with coverage
pytest --cov=app
```

## Deployment

### Local Development
Use Docker Compose for local development:
```bash
docker-compose up -d
```

### Production
For production deployment, consider:
1. Kubernetes with Helm charts
2. Managed PostgreSQL (RDS/Cloud SQL)
3. Managed Redis (ElastiCache/Memorystore)
4. CI/CD pipeline (GitHub Actions)
5. Monitoring with Prometheus + Grafana
6. Logging with ELK stack

## Environment Variables

Create a `.env` file with the following variables (see `.env.example` for a template):
```
DATABASE_URL=postgresql://user:password@localhost:5432/flightdb
POSTGRES_DB=flightdb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
REDIS_URL=redis://localhost:6379/0
AVIATIONSTACK_KEY=your_aviationstack_api_key
OPENSKY_USER=your_opensky_username
OPENSKY_PASS=your_opensky_password
JWT_SECRET=your_jwt_secret_key
SECRET_KEY=your_secret_key
```