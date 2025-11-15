from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class WebhookSubscriptionBase(BaseModel):
    name: str
    url: str
    events: List[str]
    active: bool = True

class WebhookSubscriptionCreate(WebhookSubscriptionBase):
    secret: str

class WebhookSubscriptionResponse(WebhookSubscriptionBase):
    id: str
    last_delivery: Optional[datetime] = None

class WebhookSubscriptionListResponse(BaseModel):
    subscriptions: List[WebhookSubscriptionResponse]

class WebhookTestRequest(BaseModel):
    url: str
    secret: str
    event_type: str
    payload: dict