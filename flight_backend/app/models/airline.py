from sqlalchemy import Column, String, JSON
from sqlalchemy.dialects.postgresql import UUID
from .base import Base, BaseModel
import uuid

class Airline(Base, BaseModel):
    __tablename__ = "airlines"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    iata = Column(String, index=True)
    icao = Column(String)
    name = Column(String)
    raw = Column(JSON)