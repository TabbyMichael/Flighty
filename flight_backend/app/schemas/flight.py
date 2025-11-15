from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class FlightBase(BaseModel):
    flight_number: str
    airline: str
    departure_airport: str
    arrival_airport: str
    departure_time: datetime
    arrival_time: datetime
    duration: int
    price: float
    currency: str
    stops: int

class FlightSearch(BaseModel):
    origin: str
    destination: str
    date: str
    passengers: int = 1

class FlightResponse(FlightBase):
    id: str

class FlightListResponse(BaseModel):
    flights: List[FlightResponse]