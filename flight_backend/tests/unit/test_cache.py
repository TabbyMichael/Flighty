"""
Unit tests for the caching functionality.
"""

import pytest
import json
from unittest.mock import patch, MagicMock
from app.core.cache import (
    _generate_cache_key,
    get_from_cache,
    set_in_cache,
    delete_from_cache,
    invalidate_pattern,
    cache_flight_search,
    get_cached_flight_search,
    cache_airport_info,
    get_cached_airport_info,
    cache_airline_info,
    get_cached_airline_info
)

class TestCacheKeyGeneration:
    """Test cache key generation functionality."""

    def test_generate_cache_key_with_simple_params(self):
        """Test cache key generation with simple parameters."""
        params = {"origin": "JFK", "destination": "LAX"}
        key = _generate_cache_key("flights:search", params)
        assert key.startswith("flights:search:")
        assert len(key) > len("flights:search:")

    def test_generate_cache_key_with_complex_params(self):
        """Test cache key generation with complex parameters."""
        params = {
            "origin": "JFK",
            "destination": "LAX",
            "date": "2023-12-01",
            "passengers": 2,
            "class": "economy"
        }
        key1 = _generate_cache_key("flights:search", params)
        # Same params should generate same key
        key2 = _generate_cache_key("flights:search", params)
        assert key1 == key2

class TestCacheOperations:
    """Test basic cache operations."""

    @patch('app.core.cache.redis_client')
    def test_get_from_cache_success(self, mock_redis):
        """Test successful cache retrieval."""
        mock_redis.get.return_value = '{"test": "data"}'
        result = get_from_cache("test_key")
        assert result == {"test": "data"}
        mock_redis.get.assert_called_once_with("test_key")

    @patch('app.core.cache.redis_client')
    def test_get_from_cache_miss(self, mock_redis):
        """Test cache miss returns None."""
        mock_redis.get.return_value = None
        result = get_from_cache("test_key")
        assert result is None

    @patch('app.core.cache.redis_client')
    def test_get_from_cache_exception(self, mock_redis):
        """Test cache retrieval handles exceptions."""
        mock_redis.get.side_effect = Exception("Redis error")
        result = get_from_cache("test_key")
        assert result is None

    @patch('app.core.cache.redis_client')
    def test_set_in_cache_success(self, mock_redis):
        """Test successful cache storage."""
        mock_redis.setex.return_value = True
        result = set_in_cache("test_key", {"test": "data"}, 300)
        assert result is True
        mock_redis.setex.assert_called_once_with("test_key", 300, '{"test": "data"}')

    @patch('app.core.cache.redis_client')
    def test_set_in_cache_exception(self, mock_redis):
        """Test cache storage handles exceptions."""
        mock_redis.setex.side_effect = Exception("Redis error")
        result = set_in_cache("test_key", {"test": "data"}, 300)
        assert result is False

    @patch('app.core.cache.redis_client')
    def test_delete_from_cache_success(self, mock_redis):
        """Test successful cache deletion."""
        mock_redis.delete.return_value = 1
        result = delete_from_cache("test_key")
        assert result is True
        mock_redis.delete.assert_called_once_with("test_key")

    @patch('app.core.cache.redis_client')
    def test_delete_from_cache_exception(self, mock_redis):
        """Test cache deletion handles exceptions."""
        mock_redis.delete.side_effect = Exception("Redis error")
        result = delete_from_cache("test_key")
        assert result is False

    @patch('app.core.cache.redis_client')
    def test_invalidate_pattern_success(self, mock_redis):
        """Test successful pattern invalidation."""
        mock_redis.keys.return_value = ["key1", "key2"]
        mock_redis.delete.return_value = 2
        result = invalidate_pattern("flight:*")
        assert result == 2
        mock_redis.keys.assert_called_once_with("flight:*")
        mock_redis.delete.assert_called_once_with("key1", "key2")

    @patch('app.core.cache.redis_client')
    def test_invalidate_pattern_no_keys(self, mock_redis):
        """Test pattern invalidation with no matching keys."""
        mock_redis.keys.return_value = []
        result = invalidate_pattern("flight:*")
        assert result == 0
        mock_redis.keys.assert_called_once_with("flight:*")

    @patch('app.core.cache.redis_client')
    def test_invalidate_pattern_exception(self, mock_redis):
        """Test pattern invalidation handles exceptions."""
        mock_redis.keys.side_effect = Exception("Redis error")
        result = invalidate_pattern("flight:*")
        assert result == 0

class TestFlightSearchCaching:
    """Test flight search caching functions."""

    @patch('app.core.cache.set_in_cache')
    def test_cache_flight_search(self, mock_set_cache):
        """Test caching flight search results."""
        mock_set_cache.return_value = True
        params = {"origin": "JFK", "destination": "LAX"}
        data = {"flights": []}
        result = cache_flight_search(params, data, 600)
        assert result is True
        mock_set_cache.assert_called_once()

    @patch('app.core.cache.get_from_cache')
    def test_get_cached_flight_search(self, mock_get_cache):
        """Test retrieving cached flight search results."""
        mock_get_cache.return_value = {"flights": []}
        params = {"origin": "JFK", "destination": "LAX"}
        result = get_cached_flight_search(params)
        assert result == {"flights": []}
        mock_get_cache.assert_called_once()

class TestAirportCaching:
    """Test airport caching functions."""

    @patch('app.core.cache.set_in_cache')
    def test_cache_airport_info(self, mock_set_cache):
        """Test caching airport information."""
        mock_set_cache.return_value = True
        data = {"iata": "JFK", "name": "John F Kennedy International Airport"}
        result = cache_airport_info("JFK", data, 86400)
        assert result is True
        mock_set_cache.assert_called_once()

    @patch('app.core.cache.get_from_cache')
    def test_get_cached_airport_info(self, mock_get_cache):
        """Test retrieving cached airport information."""
        mock_get_cache.return_value = {"iata": "JFK", "name": "John F Kennedy International Airport"}
        result = get_cached_airport_info("JFK")
        assert result == {"iata": "JFK", "name": "John F Kennedy International Airport"}
        mock_get_cache.assert_called_once_with("airport:JFK")

class TestAirlineCaching:
    """Test airline caching functions."""

    @patch('app.core.cache.set_in_cache')
    def test_cache_airline_info(self, mock_set_cache):
        """Test caching airline information."""
        mock_set_cache.return_value = True
        data = {"iata": "AA", "name": "American Airlines"}
        result = cache_airline_info("AA", data, 86400)
        assert result is True
        mock_set_cache.assert_called_once()

    @patch('app.core.cache.get_from_cache')
    def test_get_cached_airline_info(self, mock_get_cache):
        """Test retrieving cached airline information."""
        mock_get_cache.return_value = {"iata": "AA", "name": "American Airlines"}
        result = get_cached_airline_info("AA")
        assert result == {"iata": "AA", "name": "American Airlines"}
        mock_get_cache.assert_called_once_with("airline:AA")