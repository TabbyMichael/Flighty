from sqlalchemy import Column, String, Numeric, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import UUID
import uuid

Base = declarative_base()

class Airport(Base):
    __tablename__ = "airports"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    iata = Column(String, index=True)
    icao = Column(String)
    name = Column(String)
    city = Column(String)
    country = Column(String)
    lat = Column(Numeric)
    lon = Column(Numeric)
    raw = Column(JSON)