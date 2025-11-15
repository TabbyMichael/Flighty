"""
pytest configuration and fixtures.
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app

@pytest.fixture
def client():
    """Create a test client for the FastAPI app."""
    with TestClient(app) as test_client:
        yield test_client

@pytest.fixture
def mock_redis():
    """Mock Redis client for testing."""
    with patch('app.core.cache.redis_client') as mock_redis:
        yield mock_redis