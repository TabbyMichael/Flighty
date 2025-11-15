from sqlalchemy import Column, String, Numeric, DateTime, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import UUID
import uuid

Base = declarative_base()

class FlightCache(Base):
    __tablename__ = "flight_cache"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    flight_number = Column(String)
    dep_iata = Column(String)
    arr_iata = Column(String)
    dep_time = Column(DateTime)
    arr_time = Column(DateTime)
    price = Column(Numeric)
    currency = Column(String)
    raw = Column(JSON)
    cached_at = Column(DateTime)