from sqlalchemy import Column, String, Numeric, Text, ForeignKey, JSON
from sqlalchemy.dialects.postgresql import UUID
from .base import Base, BaseModel
import uuid

class Booking(Base, BaseModel):
    __tablename__ = "bookings"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    pnr = Column(String, unique=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    flight_id = Column(String)
    passenger = Column(JSON)
    extras = Column(JSON)
    total_price = Column(Numeric)
    currency = Column(String)
    status = Column(String)
    raw_payload = Column(JSON)