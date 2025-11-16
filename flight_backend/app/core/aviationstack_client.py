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
        print(f"Cache hit for key: {key}")
        return json.loads(cached)
    
    print(f"Making request to AviationStack with params: {params}")
    
    # For free plan compatibility, only use access_key and limit
    # The free plan doesn't support dep_iata, arr_iata, or flight_date filters
    aviationstack_params = {
        "access_key": settings.AVIATIONSTACK_KEY,
        "limit": min(params.get("limit", 10), 10)  # Free plan limit is 10
    }
    
    resp = requests.get(
        "http://api.aviationstack.com/v1/flights", 
        params=aviationstack_params, 
        timeout=10
    )
    print(f"AviationStack response status: {resp.status_code}")
    
    if resp.status_code == 200:
        print(f"AviationStack response data: {resp.text[:200]}...")  # First 200 chars
        data = resp.json()
        
        # Filter results locally if origin/destination were requested (free plan workaround)
        if "dep_iata" in params or "arr_iata" in params:
            print("Filtering results locally for origin/destination (free plan workaround)")
            filtered_data = []
            for flight in data.get("data", []):
                match = True
                if "dep_iata" in params and flight.get("departure", {}).get("iata") != params["dep_iata"]:
                    match = False
                if "arr_iata" in params and flight.get("arrival", {}).get("iata") != params["arr_iata"]:
                    match = False
                # Note: We can't filter by date with free plan, so we'll just return what we have
                if match:
                    filtered_data.append(flight)
            data["data"] = filtered_data[:aviationstack_params["limit"]]  # Limit results
            print(f"Filtered to {len(data['data'])} flights")
    else:
        print(f"AviationStack request failed: {resp.text}")
        # Return empty data instead of failing
        data = {"data": []}
    
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