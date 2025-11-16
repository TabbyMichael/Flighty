import requests
import os

# Test AviationStack API directly
API_KEY = "02d420fb1991939a9ce1f6948495dbaa"

def test_basic_flight_request():
    """Test basic flight request with free plan compatible parameters"""
    print("Testing basic flight request...")
    
    # Simple request that should work with free plan
    params = {
        "access_key": API_KEY,
        "limit": 5
    }
    
    response = requests.get(
        "http://api.aviationstack.com/v1/flights",
        params=params,
        timeout=10
    )
    
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Number of flights returned: {len(data.get('data', []))}")
        if data.get('data'):
            flight = data['data'][0]
            print(f"Sample flight: {flight.get('airline', {}).get('name')} flight {flight.get('flight', {}).get('iata')}")
            print(f"From: {flight.get('departure', {}).get('airport')} ({flight.get('departure', {}).get('iata')})")
            print(f"To: {flight.get('arrival', {}).get('airport')} ({flight.get('arrival', {}).get('iata')})")
        return data
    else:
        print(f"Error: {response.text}")
        return None

def test_filtered_request():
    """Test filtered request that might not work with free plan"""
    print("\nTesting filtered request...")
    
    # This might not work with free plan
    params = {
        "access_key": API_KEY,
        "dep_iata": "JFK",
        "arr_iata": "LAX",
        "limit": 5
    }
    
    response = requests.get(
        "http://api.aviationstack.com/v1/flights",
        params=params,
        timeout=10
    )
    
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Number of flights returned: {len(data.get('data', []))}")
        return data
    else:
        print(f"Error: {response.text}")
        return None

if __name__ == "__main__":
    print("AviationStack API Test")
    print("=" * 30)
    
    # Test basic request
    basic_data = test_basic_flight_request()
    
    # Test filtered request
    filtered_data = test_filtered_request()
    
    print("\nTest completed.")