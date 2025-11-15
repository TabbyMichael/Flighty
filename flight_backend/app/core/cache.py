import json
import hashlib
from typing import Any, Optional, Dict
from app.config import settings
import redis

# Initialize Redis connection
redis_client = redis.Redis.from_url(settings.REDIS_URL, decode_responses=True)

def _generate_cache_key(prefix: str, params: Dict[str, Any]) -> str:
    """
    Generate a consistent cache key from prefix and parameters.
    """
    # Sort params to ensure consistent key generation
    sorted_params = json.dumps(params, sort_keys=True, default=str)
    param_hash = hashlib.sha256(sorted_params.encode()).hexdigest()
    return f"{prefix}:{param_hash}"

def get_from_cache(key: str) -> Optional[Any]:
    """
    Retrieve a value from Redis cache.
    """
    try:
        cached_value = redis_client.get(key)
        if cached_value:
            return json.loads(cached_value)
    except Exception as e:
        # Log error but don't fail the request
        print(f"Cache get error: {e}")
    return None

def set_in_cache(key: str, value: Any, ttl: int = 300) -> bool:
    """
    Store a value in Redis cache with TTL.
    """
    try:
        serialized_value = json.dumps(value, default=str)
        redis_client.setex(key, ttl, serialized_value)
        return True
    except Exception as e:
        # Log error but don't fail the request
        print(f"Cache set error: {e}")
        return False

def delete_from_cache(key: str) -> bool:
    """
    Delete a value from Redis cache.
    """
    try:
        redis_client.delete(key)
        return True
    except Exception as e:
        # Log error but don't fail the request
        print(f"Cache delete error: {e}")
        return False

def invalidate_pattern(pattern: str) -> int:
    """
    Invalidate all cache keys matching a pattern.
    Returns number of keys deleted.
    """
    try:
        keys = redis_client.keys(pattern)
        if keys:
            return redis_client.delete(*keys)
        return 0
    except Exception as e:
        # Log error but don't fail the request
        print(f"Cache pattern invalidation error: {e}")
        return 0

# Convenience functions for common cache operations
def cache_flight_search(params: Dict[str, Any], data: Any, ttl: int = 600) -> bool:
    """
    Cache flight search results.
    Default TTL: 10 minutes
    """
    key = _generate_cache_key("flights:search", params)
    return set_in_cache(key, data, ttl)

def get_cached_flight_search(params: Dict[str, Any]) -> Optional[Any]:
    """
    Get cached flight search results.
    """
    key = _generate_cache_key("flights:search", params)
    return get_from_cache(key)

def cache_airport_info(iata: str, data: Any, ttl: int = 86400) -> bool:
    """
    Cache airport information.
    Default TTL: 24 hours
    """
    key = f"airport:{iata}"
    return set_in_cache(key, data, ttl)

def get_cached_airport_info(iata: str) -> Optional[Any]:
    """
    Get cached airport information.
    """
    key = f"airport:{iata}"
    return get_from_cache(key)

def cache_airline_info(iata: str, data: Any, ttl: int = 86400) -> bool:
    """
    Cache airline information.
    Default TTL: 24 hours
    """
    key = f"airline:{iata}"
    return set_in_cache(key, data, ttl)

def get_cached_airline_info(iata: str) -> Optional[Any]:
    """
    Get cached airline information.
    """
    key = f"airline:{iata}"
    return get_from_cache(key)