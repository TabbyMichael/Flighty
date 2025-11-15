from fastapi import APIRouter, Request
from app.schemas.airline import AirlineResponse, AirlineListResponse
from app.core.rate_limiter import limiter
from app.core.cache import get_cached_airline_info, cache_airline_info
from app.core.rate_limit_config import AIRLINES_RATE_LIMIT

router = APIRouter()

@router.get("/", response_model=AirlineListResponse)
@limiter.limit(AIRLINES_RATE_LIMIT)
def list_airlines(request: Request):
    """
    List all airlines.
    """
    # In a real implementation, this would query the database
    return AirlineListResponse(airlines=[])

@router.get("/{iata}", response_model=AirlineResponse)
@limiter.limit(AIRLINES_RATE_LIMIT)
def get_airline(iata: str, request: Request):
    """
    Get details for a specific airline.
    """
    # Check cache first
    cached_airline = get_cached_airline_info(iata)
    if cached_airline:
        return cached_airline
    
    # In a real implementation, this would fetch from database
    airline_data = AirlineResponse(
        id="airline_id",
        iata=iata,
        name="Airline Name"
    )
    
    # Cache the result
    cache_airline_info(iata, airline_data, ttl=86400)  # Cache for 24 hours
    
    return airline_data

@router.post("/sync")
def sync_airlines():
    """
    Admin endpoint to trigger full airline sync.
    """
    # In a real implementation, this would trigger a Celery task
    return {"message": "Airline sync started"}