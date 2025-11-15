from fastapi import APIRouter, Query, Depends, Request
from app.schemas.flight import FlightSearch, FlightListResponse, FlightResponse
from app.core.aviationstack_client import search_aviationstack
from app.core.cache import get_cached_flight_search, cache_flight_search
from app.core.rate_limiter import limiter
from app.core.rate_limit_config import (
    FLIGHTS_RATE_LIMIT,
    FLIGHTS_SEARCH_RATE_LIMIT,
    FLIGHTS_LIVE_RATE_LIMIT,
    FLIGHTS_TRACK_RATE_LIMIT,
    FLIGHTS_DETAIL_RATE_LIMIT
)
from typing import List

router = APIRouter()

@router.get("/", response_model=FlightListResponse)
@limiter.limit(FLIGHTS_RATE_LIMIT)
def list_flights(request: Request):
    """
    List all available flights (returns empty list in this mock implementation).
    In a real implementation, this would return cached or live flight data.
    """
    return FlightListResponse(flights=[])

@router.get("/search")
@limiter.limit(FLIGHTS_SEARCH_RATE_LIMIT)
def search_flights(
    request: Request,
    origin: str = Query(..., description="Origin airport code"),
    destination: str = Query(..., description="Destination airport code"),
    date: str = Query(..., description="Departure date (YYYY-MM-DD)"),
    passengers: int = Query(1, description="Number of passengers")
):
    """
    Search for flights between origin and destination on a specific date.
    Returns cached or live results from AviationStack.
    """
    params = {
        "dep_iata": origin,
        "arr_iata": destination,
        "flight_date": date,
        "limit": 100
    }
    
    # Check cache first
    cached_data = get_cached_flight_search(params)
    if cached_data:
        return cached_data
    
    # Search using AviationStack client
    data = search_aviationstack(params)
    
    # Process and return results
    flights = []
    if "data" in data:
        for flight_data in data["data"]:
            flight = {
                "id": flight_data.get("flight", {}).get("iata", ""),
                "flight_number": flight_data.get("flight", {}).get("number", ""),
                "airline": flight_data.get("airline", {}).get("name", ""),
                "departure_airport": flight_data.get("departure", {}).get("iata", ""),
                "arrival_airport": flight_data.get("arrival", {}).get("iata", ""),
                "departure_time": flight_data.get("departure", {}).get("scheduled", ""),
                "arrival_time": flight_data.get("arrival", {}).get("scheduled", ""),
                "duration": flight_data.get("flight_duration", 0),
                "price": 0,  # Price would come from a different source
                "currency": "USD",
                "stops": 0   # Would need to calculate based on segments
            }
            flights.append(flight)
    
    result = {"flights": flights}
    
    # Cache the results
    cache_flight_search(params, result, ttl=600)  # Cache for 10 minutes
    
    return result

@router.get("/{flight_id}")
@limiter.limit(FLIGHTS_DETAIL_RATE_LIMIT)
def get_flight(flight_id: str, request: Request):
    """
    Get detailed information for a specific flight.
    """
    # In a real implementation, this would fetch from cache or external API
    return {"flight_id": flight_id, "details": "Flight details would go here"}

@router.get("/live")
@limiter.limit(FLIGHTS_LIVE_RATE_LIMIT)
def get_live_flights(request: Request):
    """
    Get live flight data (proxies OpenSky).
    """
    # In a real implementation, this would fetch from OpenSky
    return {"message": "Live flight data would go here"}

@router.get("/track/{identifier}")
@limiter.limit(FLIGHTS_TRACK_RATE_LIMIT)
def track_flight(identifier: str, request: Request):
    """
    Start/return tracking info for a specific flight.
    """
    # In a real implementation, this would start tracking via OpenSky
    return {"identifier": identifier, "tracking": "Tracking info would go here"}