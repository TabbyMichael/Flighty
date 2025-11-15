from fastapi import APIRouter

router = APIRouter()

@router.get("/metrics")
def get_metrics():
    """
    Prometheus metrics endpoint.
    """
    # In a real implementation, this would expose Prometheus metrics
    return {"message": "Metrics would go here"}

@router.get("/health")
def health_check():
    """
    Health check endpoint.
    """
    return {"status": "healthy"}