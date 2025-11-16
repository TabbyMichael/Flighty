from fastapi import APIRouter, HTTPException, Depends, Query, Request
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
import random

from app.database.database import get_db
from app.schemas.flight import FlightResponse, FlightListResponse, FlightSearch
from app.core.rate_limit_config import (
    FLIGHTS_RATE_LIMIT,
    FLIGHTS_SEARCH_RATE_LIMIT,
    FLIGHTS_LIVE_RATE_LIMIT,
    FLIGHTS_TRACK_RATE_LIMIT,
    FLIGHTS_DETAIL_RATE_LIMIT
)
from app.core.rate_limiter import limiter

router = APIRouter()

# Mock flight data for demonstration
MOCK_FLIGHTS = [
    {
        "id": "FL001",
        "flight_number": "AA101",
        "airline": "American Airlines",
        "departure_airport": "JFK",
        "arrival_airport": "LAX",
        "departure_time": "2023-06-15T08:00:00",
        "arrival_time": "2023-06-15T11:30:00",
        "duration": 330,
        "price": 299.99,
        "currency": "USD",
        "stops": 0
    },
    {
        "id": "FL002",
        "flight_number": "DL202",
        "airline": "Delta Airlines",
        "departure_airport": "JFK",
        "arrival_airport": "LAX",
        "departure_time": "2023-06-15T14:00:00",
        "arrival_time": "2023-06-15T17:45:00",
        "duration": 345,
        "price": 349.99,
        "currency": "USD",
        "stops": 0
    },
    {
        "id": "FL003",
        "flight_number": "UA303",
        "airline": "United Airlines",
        "departure_airport": "JFK",
        "arrival_airport": "LAX",
        "departure_time": "2023-06-15T20:00:00",
        "arrival_time": "2023-06-15T23:30:00",
        "duration": 330,
        "price": 279.99,
        "currency": "USD",
        "stops": 0
    }
]

@router.get("/search", response_model=FlightListResponse)
@limiter.limit(FLIGHTS_SEARCH_RATE_LIMIT)
def search_flights(
    request: Request,
    origin: str = Query(..., description="Origin airport code"),
    destination: str = Query(..., description="Destination airport code"),
    date: str = Query(..., description="Flight date (YYYY-MM-DD)"),
    db: Session = Depends(get_db)
):
    """Search for flights between origin and destination on a specific date."""
    # In a real implementation, this would query a flight database or external API
    # For now, we'll return mock data
    filtered_flights = [flight for flight in MOCK_FLIGHTS 
                       if flight["departure_airport"] == origin 
                       and flight["arrival_airport"] == destination]
    
    return {"flights": filtered_flights}

@router.get("/{flight_id}", response_model=FlightResponse)
@limiter.limit(FLIGHTS_DETAIL_RATE_LIMIT)
def get_flight(
    request: Request,
    flight_id: str,
    db: Session = Depends(get_db)
):
    """Get details for a specific flight."""
    # In a real implementation, this would query the database
    # For now, we'll search in our mock data
    for flight in MOCK_FLIGHTS:
        if flight["id"] == flight_id:
            return flight
    
    raise HTTPException(status_code=404, detail="Flight not found")

@router.get("/live")
@limiter.limit(FLIGHTS_LIVE_RATE_LIMIT)
def get_live_flights(request: Request):
    """Get live flight data."""
    # In a real implementation, this would connect to a live flight data API
    # For now, we'll return mock data with random statuses
    live_flights = []
    for flight in MOCK_FLIGHTS[:2]:  # Return first 2 flights
        live_flight = flight.copy()
        live_flight["status"] = random.choice(["On Time", "Delayed", "Boarding"])
        live_flights.append(live_flight)
    
    return {"flights": live_flights}

@router.get("/track/{identifier}")
@limiter.limit(FLIGHTS_TRACK_RATE_LIMIT)
def track_flight(request: Request, identifier: str):
    """Track a specific flight by identifier."""
    # In a real implementation, this would connect to a flight tracking API
    # For now, we'll return mock data
    for flight in MOCK_FLIGHTS:
        if flight["id"] == identifier or flight["flight_number"] == identifier:
            return {
                "flight": flight,
                "tracking_info": {
                    "status": "In Flight",
                    "altitude": f"{random.randint(30000, 40000)} ft",
                    "speed": f"{random.randint(500, 600)} mph",
                    "location": "Over Kansas"
                }
            }
    
    raise HTTPException(status_code=404, detail="Flight not found")