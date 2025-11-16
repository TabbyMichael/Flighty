import requests
import os

# Test AviationStack API directly with the same parameters as our backend
API_KEY = "02d420fb1991939a9ce1f6948495dbaa"

def test_backend_equivalent_request():
    """Test with the exact same parameters our backend uses"""
    print("Testing with backend equivalent parameters...")
    
    params = {
        "dep_iata": "RUH",
        "arr_iata": "BHH", 
        "flight_date": "2025-11-16",
        "limit": 100,
        "access_key": API_KEY
    }
    
    print(f"Request params: {params}")
    
    response = requests.get(
        "http://api.aviationstack.com/v1/flights",
        params=params,
        timeout=10
    )
    
    print(f"Status Code: {response.status_code}")
    print(f"Response Headers: {dict(response.headers)}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"Number of flights returned: {len(data.get('data', []))}")
        return data
    else:
        print(f"Error response: {response.text}")
        return None

def test_simplified_request():
    """Test with simplified parameters"""
    print("\nTesting with simplified parameters...")
    
    params = {
        "access_key": API_KEY,
        "limit": 10
    }
    
    print(f"Request params: {params}")
    
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
        print(f"Error response: {response.text}")
        return None

if __name__ == "__main__":
    print("Detailed AviationStack API Test")
    print("=" * 40)
    
    # Test with backend equivalent parameters
    backend_data = test_backend_equivalent_request()
    
    # Test with simplified parameters
    simple_data = test_simplified_request()
    
    print("\nTest completed.")