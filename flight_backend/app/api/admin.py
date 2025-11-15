from fastapi import APIRouter, Request
from app.core.rate_limiter import limiter
from app.core.rate_limit_config import (
    ADMIN_RATE_LIMIT,
    ADMIN_METRICS_RATE_LIMIT,
    ADMIN_HEALTH_RATE_LIMIT
)

router = APIRouter()

@router.get("/metrics")
@limiter.limit(ADMIN_METRICS_RATE_LIMIT)
def get_metrics(request: Request):
    """
    Prometheus metrics endpoint.
    """
    # In a real implementation, this would expose Prometheus metrics
    return {"message": "Metrics would go here"}

@router.get("/health")
@limiter.limit(ADMIN_HEALTH_RATE_LIMIT)
def health_check(request: Request):
    """
    Health check endpoint.
    """
    return {"status": "healthy"}