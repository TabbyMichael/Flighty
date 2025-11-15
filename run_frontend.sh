#!/bin/bash

# Script to run only the Flutter app

echo "Starting Flight Booking Flutter App..."

cd flight_viewer

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Run the app
echo "Starting Flutter app..."
flutter run