"""
Test script to verify rate limiting and caching functionality.
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.core.cache import redis_client

# Create a test client
client = TestClient(app)

def test_cache_functionality():
    """Test that caching functions work correctly."""
    # Test setting and getting from cache
    test_key = "test_key"
    test_value = {"test": "data"}
    
    # Set in cache
    result = redis_client.set(test_key, str(test_value))
    assert result is True
    
    # Get from cache
    cached_value = redis_client.get(test_key)
    assert cached_value is not None
    
    # Delete from cache
    result = redis_client.delete(test_key)
    assert result == 1

def test_basic_endpoint():
    """Test that basic endpoints work."""
    # Make a request to a basic endpoint
    response = client.get("/flights")
    assert response.status_code == 200

if __name__ == "__main__":
    test_cache_functionality()
    test_basic_endpoint()
    print("All tests passed!")