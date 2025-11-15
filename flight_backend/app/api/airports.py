from fastapi import APIRouter, Query, Depends, Request
from app.schemas.airport import AirportResponse, AirportListResponse
from app.core.rate_limiter import limiter
from app.core.cache import get_cached_airport_info, cache_airport_info
from app.core.rate_limit_config import AIRPORTS_RATE_LIMIT

router = APIRouter()

@router.get("/", response_model=AirportListResponse)
@limiter.limit(AIRPORTS_RATE_LIMIT)
def list_airports(request: Request, skip: int = 0, limit: int = 100):
    """
    List airports with pagination.
    """
    # In a real implementation, this would query the database
    return AirportListResponse(airports=[])

@router.get("/{iata}", response_model=AirportResponse)
@limiter.limit(AIRPORTS_RATE_LIMIT)
def get_airport(iata: str, request: Request):
    """
    Get details for a specific airport.
    """
    # Check cache first
    cached_airport = get_cached_airport_info(iata)
    if cached_airport:
        return cached_airport
    
    # In a real implementation, this would fetch from database
    airport_data = AirportResponse(
        id="airport_id",
        iata=iata,
        name="Airport Name",
        city="City",
        country="Country",
        lat=0.0,
        lon=0.0
    )
    
    # Cache the result
    cache_airport_info(iata, airport_data, ttl=86400)  # Cache for 24 hours
    
    return airport_data

@router.post("/sync")
def sync_airports():
    """
    Admin endpoint to trigger full airport sync.
    """
    # In a real implementation, this would trigger a Celery task
    return {"message": "Airport sync started"}