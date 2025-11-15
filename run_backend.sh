#!/bin/bash

# Script to run only the backend server

echo "Starting Flight Booking Backend Server..."

cd flight_backend

# Kill any process using port 8000
echo "Checking for processes on port 8000..."
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
    echo "Killing process using port 8000..."
    lsof -ti tcp:8000 | xargs kill -9
    sleep 2
fi

# Check if virtual environment exists, if not create it
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install/update dependencies
echo "Installing/updating dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Initialize database if needed
if [ -f "init_db.py" ]; then
    echo "Initializing database..."
    python init_db.py
fi

# Start the backend server
echo "Starting backend server on http://127.0.0.1:8000"
echo "Use Ctrl+C to stop the server"
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload