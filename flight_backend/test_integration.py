#!/usr/bin/env python3
"""
Simple script to test the backend API integration
"""

import requests
import json
from datetime import datetime

BASE_URL = "http://127.0.0.1:8000"

def test_health():
    """Test the health endpoint"""
    print("Testing health endpoint...")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    print()

def test_flight_search():
    """Test the flight search endpoint"""
    print("Testing flight search endpoint...")
    # This will depend on your AviationStack API key
    params = {
        "origin": "JFK",
        "destination": "LAX",
        "date": "2023-12-01"
    }
    response = requests.get(f"{BASE_URL}/flights/search", params=params)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Found {len(data.get('flights', []))} flights")
    else:
        print(f"Error: {response.text}")
    print()

def test_create_booking():
    """Test creating a booking"""
    print("Testing booking creation...")
    booking_data = {
        "flight_id": "FL123",
        "passenger": {
            "first_name": "John",
            "last_name": "Doe",
            "passport": "P12345678",
            "email": "john.doe@example.com"
        },
        "extras": {
            "baggage": 1,
            "meal": 1
        },
        "total_price": 599.99,
        "currency": "USD"
    }
    
    response = requests.post(
        f"{BASE_URL}/bookings",
        headers={"Content-Type": "application/json"},
        data=json.dumps(booking_data)
    )
    
    print(f"Status: {response.status_code}")
    if response.status_code in [200, 201]:
        print(f"Booking created: {response.json()}")
    else:
        print(f"Error: {response.text}")
    print()

def test_list_bookings():
    """Test listing bookings"""
    print("Testing booking listing...")
    params = {"email": "john.doe@example.com"}
    response = requests.get(f"{BASE_URL}/bookings", params=params)
    
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Found {len(data.get('bookings', []))} bookings")
    else:
        print(f"Error: {response.text}")
    print()

if __name__ == "__main__":
    print("Flight Booking Backend Integration Tests")
    print("=" * 40)
    
    try:
        test_health()
        test_flight_search()
        test_create_booking()
        test_list_bookings()
        print("All tests completed!")
    except Exception as e:
        print(f"Error running tests: {e}")