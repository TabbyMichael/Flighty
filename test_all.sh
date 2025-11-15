#!/bin/bash

# Script to run tests for both backend and frontend

echo "Running tests for Flight Booking Application"

# Run backend tests
echo "Running backend tests..."
cd flight_backend
source venv/bin/activate
python -m pytest tests/

# Run frontend tests
echo "Running frontend tests..."
cd ../flight_viewer
flutter test

echo "All tests completed!"