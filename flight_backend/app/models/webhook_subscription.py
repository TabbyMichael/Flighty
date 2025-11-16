from sqlalchemy import Column, String, Boolean, DateTime, ARRAY
from sqlalchemy.dialects.postgresql import UUID
from .base import Base, BaseModel
import uuid

class WebhookSubscription(Base, BaseModel):
    __tablename__ = "webhook_subscriptions"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String)
    url = Column(String)
    secret = Column(String)
    events = Column(ARRAY(String))
    active = Column(Boolean, default=True)
    last_delivery = Column(DateTime)