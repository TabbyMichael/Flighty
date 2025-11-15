from pydantic import BaseModel
from typing import Dict, Optional
from datetime import datetime

class PassengerInfo(BaseModel):
    first_name: str
    last_name: str
    passport: str
    email: str

class BookingCreate(BaseModel):
    flight_id: str
    passenger: PassengerInfo
    extras: Dict[str, int] = {}
    total_price: float
    currency: str = "USD"

class BookingResponse(BookingCreate):
    id: str
    pnr: str
    status: str
    created_at: datetime

class BookingListResponse(BaseModel):
    bookings: list[BookingResponse]