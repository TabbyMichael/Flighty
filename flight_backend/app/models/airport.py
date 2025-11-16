from sqlalchemy import Column, String, Numeric, JSON
from sqlalchemy.dialects.postgresql import UUID
from .base import Base, BaseModel
import uuid

class Airport(Base, BaseModel):
    __tablename__ = "airports"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    iata = Column(String, index=True)
    icao = Column(String)
    name = Column(String)
    city = Column(String)
    country = Column(String)
    lat = Column(Numeric)
    lon = Column(Numeric)
    raw = Column(JSON)