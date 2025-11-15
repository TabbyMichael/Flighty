from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Flight Booking API"}

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

def test_basic_endpoint_access():
    """Test that root endpoint is accessible."""
    # Create a fresh client to avoid rate limit issues from other tests
    fresh_client = TestClient(app)
    response = fresh_client.get("/")
    # Should be able to access the endpoint
    assert response.status_code == 200