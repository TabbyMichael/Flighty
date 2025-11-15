from fastapi import APIRouter, Query, Depends
from app.schemas.airport import AirportResponse, AirportListResponse

router = APIRouter()

@router.get("/", response_model=AirportListResponse)
def list_airports(skip: int = 0, limit: int = 100):
    """
    List airports with pagination.
    """
    # In a real implementation, this would query the database
    return AirportListResponse(airports=[])

@router.get("/{iata}", response_model=AirportResponse)
def get_airport(iata: str):
    """
    Get details for a specific airport.
    """
    # In a real implementation, this would fetch from database
    return AirportResponse(
        id="airport_id",
        iata=iata,
        name="Airport Name",
        city="City",
        country="Country",
        lat=0.0,
        lon=0.0
    )

@router.post("/sync")
def sync_airports():
    """
    Admin endpoint to trigger full airport sync.
    """
    # In a real implementation, this would trigger a Celery task
    return {"message": "Airport sync started"}