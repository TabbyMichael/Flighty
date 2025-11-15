#!/bin/bash

# Script to run all tests for the Flight Booking Backend

echo "Starting Flight Booking Backend Tests"
echo "===================================="

# Activate virtual environment
source venv/bin/activate

# Run unit tests
echo "Running Unit Tests..."
python -m pytest tests/unit/ -v

# Run integration tests
echo "Running Integration Tests..."
python -m pytest tests/integration/ -v

# Run main tests
echo "Running Main Tests..."
python -m pytest tests/test_main.py -v

# Run integration test script
echo "Running Integration Test Script..."
python test_integration.py

echo "===================================="
echo "All tests completed!"