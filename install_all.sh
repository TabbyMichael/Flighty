#!/bin/bash

# Script to install dependencies for both backend and frontend

echo "Installing dependencies for Flight Booking Application"

# Install backend dependencies
echo "Installing backend dependencies..."
cd flight_backend
./install.sh

# Install frontend dependencies
echo "Installing frontend dependencies..."
cd ../flight_viewer
flutter pub get

echo "All dependencies installed successfully!"
echo "To start the application, run: ./start_all.sh"