from sqlalchemy import Column, String, Numeric, Text, ForeignKey, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import UUID
import uuid

Base = declarative_base()

class Booking(Base):
    __tablename__ = "bookings"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    pnr = Column(String, unique=True, index=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    flight_id = Column(String)
    passenger = Column(JSON)
    extras = Column(JSON)
    total_price = Column(Numeric)
    currency = Column(String)
    status = Column(String)
    raw_payload = Column(JSON)