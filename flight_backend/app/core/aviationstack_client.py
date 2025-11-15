import requests
import hashlib
import json
from app.config import settings
import redis

r = redis.Redis.from_url(settings.REDIS_URL)

def _cache_key(prefix, params):
    h = hashlib.sha1(json.dumps(params, sort_keys=True).encode()).hexdigest()
    return f"{prefix}:{h}"

def search_aviationstack(params: dict, ttl: int = 120):
    key = _cache_key("aviation:search", params)
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    resp = requests.get(
        "http://api.aviationstack.com/v1/flights", 
        params={**params, "access_key": settings.AVIATIONSTACK_KEY}, 
        timeout=10
    )
    data = resp.json()
    r.set(key, json.dumps(data), ex=ttl)
    return data

def get_airport_details(iata: str, ttl: int = 86400):  # 24 hours
    key = f"aviation:airport:{iata}"
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    resp = requests.get(
        "http://api.aviationstack.com/v1/airports", 
        params={"iata_code": iata, "access_key": settings.AVIATIONSTACK_KEY}, 
        timeout=10
    )
    data = resp.json()
    r.set(key, json.dumps(data), ex=ttl)
    return data

def get_airline_details(iata: str, ttl: int = 86400):  # 24 hours
    key = f"aviation:airline:{iata}"
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    resp = requests.get(
        "http://api.aviationstack.com/v1/airlines", 
        params={"iata_code": iata, "access_key": settings.AVIATIONSTACK_KEY}, 
        timeout=10
    )
    data = resp.json()
    r.set(key, json.dumps(data), ex=ttl)
    return data