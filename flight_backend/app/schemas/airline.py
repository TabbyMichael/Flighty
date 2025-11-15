from pydantic import BaseModel
from typing import Optional

class AirlineBase(BaseModel):
    iata: str
    icao: Optional[str] = None
    name: str

class AirlineResponse(AirlineBase):
    id: str

class AirlineListResponse(BaseModel):
    airlines: list[AirlineResponse]