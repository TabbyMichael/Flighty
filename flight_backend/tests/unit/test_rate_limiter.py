"""
Unit tests for the rate limiting functionality.
"""

import pytest
from unittest.mock import patch, MagicMock
from app.core.rate_limiter import limiter
from app.core.rate_limit_config import (
    FLIGHTS_RATE_LIMIT,
    AUTH_RATE_LIMIT,
    BOOKINGS_RATE_LIMIT,
    AIRPORTS_RATE_LIMIT,
    AIRLINES_RATE_LIMIT,
    WEBHOOKS_RATE_LIMIT,
    ADMIN_RATE_LIMIT
)

class TestRateLimitConfig:
    """Test rate limit configuration values."""

    def test_flights_rate_limit(self):
        """Test flights rate limit configuration."""
        assert FLIGHTS_RATE_LIMIT == "30/minute"

    def test_auth_rate_limit(self):
        """Test auth rate limit configuration."""
        assert AUTH_RATE_LIMIT == "10/minute"

    def test_bookings_rate_limit(self):
        """Test bookings rate limit configuration."""
        assert BOOKINGS_RATE_LIMIT == "20/minute"

    def test_airports_rate_limit(self):
        """Test airports rate limit configuration."""
        assert AIRPORTS_RATE_LIMIT == "50/minute"

    def test_airlines_rate_limit(self):
        """Test airlines rate limit configuration."""
        assert AIRLINES_RATE_LIMIT == "50/minute"

    def test_webhooks_rate_limit(self):
        """Test webhooks rate limit configuration."""
        assert WEBHOOKS_RATE_LIMIT == "20/minute"

    def test_admin_rate_limit(self):
        """Test admin rate limit configuration."""
        assert ADMIN_RATE_LIMIT == "100/minute"

class TestRateLimiter:
    """Test rate limiter initialization."""

    def test_limiter_instance(self):
        """Test that limiter is properly initialized."""
        assert limiter is not None
        assert hasattr(limiter, '_key_func')
        assert limiter._key_func is not None