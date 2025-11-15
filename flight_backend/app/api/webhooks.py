from fastapi import APIRouter
from app.schemas.webhook import (
    WebhookSubscriptionCreate, 
    WebhookSubscriptionResponse, 
    WebhookSubscriptionListResponse,
    WebhookTestRequest
)

router = APIRouter()

@router.post("/subscriptions", response_model=WebhookSubscriptionResponse)
def create_webhook_subscription(subscription: WebhookSubscriptionCreate):
    """
    Create a new webhook subscription.
    """
    # In a real implementation, this would save to database
    return WebhookSubscriptionResponse(
        id="subscription_id",
        name=subscription.name,
        url=subscription.url,
        events=subscription.events,
        active=subscription.active
    )

@router.get("/subscriptions", response_model=WebhookSubscriptionListResponse)
def list_webhook_subscriptions():
    """
    List all webhook subscriptions.
    """
    # In a real implementation, this would query the database
    return WebhookSubscriptionListResponse(subscriptions=[])

@router.post("/test")
def test_webhook_delivery(test_request: WebhookTestRequest):
    """
    Test webhook delivery.
    """
    # In a real implementation, this would trigger a Celery task
    return {"message": "Webhook test delivery started"}