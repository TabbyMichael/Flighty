from sqlalchemy import Column, String, Numeric, DateTime, JSON
from sqlalchemy.dialects.postgresql import UUID
from .base import Base, BaseModel
import uuid

class FlightCache(Base, BaseModel):
    __tablename__ = "flight_cache"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    flight_number = Column(String)
    dep_iata = Column(String)
    arr_iata = Column(String)
    dep_time = Column(DateTime)
    arr_time = Column(DateTime)
    price = Column(Numeric)
    currency = Column(String)
    raw = Column(JSON)
    cached_at = Column(DateTime)