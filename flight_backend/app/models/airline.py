from sqlalchemy import Column, String, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import UUID
import uuid

Base = declarative_base()

class Airline(Base):
    __tablename__ = "airlines"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    iata = Column(String, index=True)
    icao = Column(String)
    name = Column(String)
    raw = Column(JSON)