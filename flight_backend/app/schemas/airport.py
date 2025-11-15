from pydantic import BaseModel
from typing import Optional

class AirportBase(BaseModel):
    iata: str
    icao: Optional[str] = None
    name: str
    city: str
    country: str
    lat: float
    lon: float

class AirportResponse(AirportBase):
    id: str

class AirportListResponse(BaseModel):
    airports: list[AirportResponse]