from fastapi import APIRouter, Query, Depends, Request
from app.schemas.booking import BookingCreate, BookingResponse, BookingListResponse, PassengerInfo
from app.core.rate_limiter import limiter
from app.core.rate_limit_config import (
    BOOKINGS_RATE_LIMIT,
    BOOKINGS_CREATE_RATE_LIMIT,
    BOOKINGS_LIST_RATE_LIMIT,
    BOOKINGS_DETAIL_RATE_LIMIT
)
from datetime import datetime

router = APIRouter()

@router.post("/", response_model=BookingResponse)
@limiter.limit(BOOKINGS_CREATE_RATE_LIMIT)
def create_booking(request: Request, booking: BookingCreate):
    """
    Create a new booking.
    """
    # In a real implementation, this would:
    # 1. Validate the flight exists
    # 2. Check availability
    # 3. Create booking in database
    # 4. Emit webhook event
    # 5. Return booking details
    
    return BookingResponse(
        id="booking_id",
        pnr="ABC123",
        flight_id=booking.flight_id,
        passenger=booking.passenger,
        extras=booking.extras,
        total_price=booking.total_price,
        currency=booking.currency,
        status="confirmed",
        created_at=datetime(2023, 1, 1)
    )

@router.get("/", response_model=BookingListResponse)
@limiter.limit(BOOKINGS_LIST_RATE_LIMIT)
def list_bookings(request: Request, email: str = Query(..., description="User email")):
    """
    List bookings for a specific user.
    """
    # In a real implementation, this would query the database
    return BookingListResponse(bookings=[])

@router.get("/{pnr}", response_model=BookingResponse)
@limiter.limit(BOOKINGS_DETAIL_RATE_LIMIT)
def get_booking(pnr: str, request: Request):
    """
    Get details for a specific booking.
    """
    # In a real implementation, this would fetch from database
    return BookingResponse(
        id="booking_id",
        pnr=pnr,
        flight_id="flight_id",
        passenger=PassengerInfo(
            first_name="John",
            last_name="Doe",
            passport="P12345678",
            email="john@example.com"
        ),
        extras={},
        total_price=500.0,
        currency="USD",
        status="confirmed",
        created_at=datetime(2023, 1, 1)
    )