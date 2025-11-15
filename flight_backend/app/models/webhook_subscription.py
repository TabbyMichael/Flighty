from sqlalchemy import Column, String, Boolean, DateTime, ARRAY
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import UUID
import uuid

Base = declarative_base()

class WebhookSubscription(Base):
    __tablename__ = "webhook_subscriptions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String)
    url = Column(String)
    secret = Column(String)
    events = Column(ARRAY(String))
    active = Column(Boolean, default=True)
    last_delivery = Column(DateTime)