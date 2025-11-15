from fastapi import APIRouter, Request
from app.schemas.webhook import (
    WebhookSubscriptionCreate, 
    WebhookSubscriptionResponse, 
    WebhookSubscriptionListResponse,
    WebhookTestRequest
)
from app.core.rate_limiter import limiter
from app.core.rate_limit_config import (
    WEBHOOKS_RATE_LIMIT,
    WEBHOOKS_CREATE_RATE_LIMIT,
    WEBHOOKS_LIST_RATE_LIMIT,
    WEBHOOKS_TEST_RATE_LIMIT
)

router = APIRouter()

@router.post("/subscriptions", response_model=WebhookSubscriptionResponse)
@limiter.limit(WEBHOOKS_CREATE_RATE_LIMIT)
def create_webhook_subscription(request: Request, subscription: WebhookSubscriptionCreate):
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
@limiter.limit(WEBHOOKS_LIST_RATE_LIMIT)
def list_webhook_subscriptions(request: Request):
    """
    List all webhook subscriptions.
    """
    # In a real implementation, this would query the database
    return WebhookSubscriptionListResponse(subscriptions=[])

@router.post("/test")
@limiter.limit(WEBHOOKS_TEST_RATE_LIMIT)
def test_webhook_delivery(request: Request, test_request: WebhookTestRequest):
    """
    Test webhook delivery.
    """
    # In a real implementation, this would trigger a Celery task
    return {"message": "Webhook test delivery started"}