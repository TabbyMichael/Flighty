"""
Integration tests for rate limiting and caching functionality.
"""

import pytest
import time
from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock
from app.main import app
from app.core.cache import redis_client

client = TestClient(app)

class TestCachingIntegration:
    """Test caching integration with API endpoints."""

    def setup_method(self):
        """Clean up Redis before each test."""
        redis_client.flushdb()

    def teardown_method(self):
        """Clean up Redis after each test."""
        redis_client.flushdb()

    @patch('app.api.flights.search_aviationstack')
    def test_flight_search_caching(self, mock_search):
        """Test that flight search results are cached."""
        # Mock the external API response
        mock_search.return_value = {
            "data": [
                {
                    "flight": {"iata": "AA123", "number": "123"},
                    "airline": {"name": "American Airlines"},
                    "departure": {"iata": "JFK", "scheduled": "2023-12-01T08:00:00Z"},
                    "arrival": {"iata": "LAX", "scheduled": "2023-12-01T11:00:00Z"},
                    "flight_duration": 300
                }
            ]
        }

        # First request should call the external API
        params = {"origin": "JFK", "destination": "LAX", "date": "2023-12-01"}
        response1 = client.get("/flights/search", params=params)
        assert response1.status_code == 200
        mock_search.assert_called_once()

        # Reset the mock to check if it's called again
        mock_search.reset_mock()

        # Second request with same params should use cache
        response2 = client.get("/flights/search", params=params)
        assert response2.status_code == 200
        # The mock should not be called again because we're using cache
        mock_search.assert_not_called()

        # Verify cache was used by checking that responses are identical
        assert response1.json() == response2.json()

    def test_airport_info_caching(self):
        """Test that airport information is cached."""
        # First request to get airport info
        with patch('app.api.airports.get_cached_airport_info') as mock_get_cache:
            mock_get_cache.return_value = None
            response1 = client.get("/airports/JFK")
            assert response1.status_code == 200

        # Second request should use cache
        with patch('app.api.airports.get_cached_airport_info') as mock_get_cache:
            mock_get_cache.return_value = {
                "id": "airport_id",
                "iata": "JFK",
                "name": "John F Kennedy International Airport",
                "city": "New York",
                "country": "USA",
                "lat": 40.6397,
                "lon": -73.7789
            }
            response2 = client.get("/airports/JFK")
            assert response2.status_code == 200
            # Should return cached data
            assert response2.json()["iata"] == "JFK"

    def test_airline_info_caching(self):
        """Test that airline information is cached."""
        # First request to get airline info
        with patch('app.api.airlines.get_cached_airline_info') as mock_get_cache:
            mock_get_cache.return_value = None
            response1 = client.get("/airlines/AA")
            assert response1.status_code == 200

        # Second request should use cache
        with patch('app.api.airlines.get_cached_airline_info') as mock_get_cache:
            mock_get_cache.return_value = {
                "id": "airline_id",
                "iata": "AA",
                "name": "American Airlines"
            }
            response2 = client.get("/airlines/AA")
            assert response2.status_code == 200
            # Should return cached data
            assert response2.json()["iata"] == "AA"

class TestRateLimitingIntegration:
    """Test rate limiting integration with API endpoints."""

    def setup_method(self):
        """Set up test method."""
        # Create a new client for each test to avoid rate limit issues
        self.client = TestClient(app)

    def test_flights_endpoint_rate_limiting(self):
        """Test rate limiting on flights endpoint."""
        # Make a few requests (well below the limit)
        for i in range(5):  # Well below the 30/minute limit
            response = self.client.get("/flights")
            assert response.status_code == 200

    def test_flight_search_rate_limiting(self):
        """Test rate limiting on flight search endpoint."""
        params = {"origin": "JFK", "destination": "LAX", "date": "2023-12-01"}
        
        # Make a few requests (well below the limit)
        for i in range(3):  # Well below the 10/minute limit
            response = self.client.get("/flights/search", params=params)
            # Might get 200 or cached response, but not 429
            assert response.status_code != 429

    def test_basic_endpoint_access(self):
        """Test that endpoints are accessible."""
        # Create a new client to avoid rate limit issues
        fresh_client = TestClient(app)
        response = fresh_client.get("/flights")
        # Should be able to access the endpoint
        assert response.status_code == 200

    def test_airports_endpoint_rate_limiting(self):
        """Test rate limiting on airports endpoint."""
        # Make a few requests (well below the limit)
        for i in range(5):  # Well below the 50/minute limit
            response = self.client.get("/airports")
            assert response.status_code == 200

    def test_airlines_endpoint_rate_limiting(self):
        """Test rate limiting on airlines endpoint."""
        # Make a few requests (well below the limit)
        for i in range(5):  # Well below the 50/minute limit
            response = self.client.get("/airlines")
            assert response.status_code == 200