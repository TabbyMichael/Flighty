#!/bin/bash

# Script to start both backend and frontend in separate terminals

echo "Starting Flight Booking Application"

# Function to clean up background processes
cleanup() {
    echo "Stopping backend server..."
    # Kill any uvicorn processes related to our app
    pkill -f "uvicorn app.main:app" 2>/dev/null || true
    exit 0
}

# Set up cleanup function to run on exit
trap cleanup EXIT INT TERM

# Kill any process using port 8000
echo "Checking for processes on port 8000..."
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
    echo "Killing process using port 8000..."
    lsof -ti tcp:8000 | xargs kill -9
    sleep 2
fi

# Start backend in a new terminal
echo "Starting backend server in new terminal on port 8000..."
gnome-terminal --title="Flight Backend" -- ./run_backend.sh

# Wait a bit for backend to start
sleep 15

# Start frontend in current terminal
echo "Starting Flutter app..."
./run_frontend.sh