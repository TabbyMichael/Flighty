#!/bin/bash

# Script to run Flutter tests

echo "Starting Flutter Tests"
echo "====================="

# Run unit tests for models
echo "Running model tests..."
flutter test test/unit/models/flight_test.dart
flutter test test/unit/models/booking_test.dart

# Run unit tests for services
echo "Running service tests..."
flutter test test/unit/services/haptics_service_test.dart

# Run unit tests for blocs
echo "Running bloc tests..."
flutter test test/unit/blocs/flight_bloc_test.dart

# Run widget tests
echo "Running widget tests..."
flutter test test/widget/search_form_test.dart

# Run integration tests
echo "Running integration tests..."
flutter test test/integration/api_service_test.dart

# Run backend integration tests
echo "Running backend integration tests..."
flutter test test/backend_integration_test.dart

echo "====================="
echo "All tests completed!"