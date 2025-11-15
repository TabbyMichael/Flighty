from fastapi import APIRouter
from app.schemas.airline import AirlineResponse, AirlineListResponse

router = APIRouter()

@router.get("/", response_model=AirlineListResponse)
def list_airlines():
    """
    List all airlines.
    """
    # In a real implementation, this would query the database
    return AirlineListResponse(airlines=[])

@router.get("/{iata}", response_model=AirlineResponse)
def get_airline(iata: str):
    """
    Get details for a specific airline.
    """
    # In a real implementation, this would fetch from database
    return AirlineResponse(
        id="airline_id",
        iata=iata,
        name="Airline Name"
    )

@router.post("/sync")
def sync_airlines():
    """
    Admin endpoint to trigger full airline sync.
    """
    # In a real implementation, this would trigger a Celery task
    return {"message": "Airline sync started"}