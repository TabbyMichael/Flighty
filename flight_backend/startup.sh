#!/bin/bash

# Exit on any error
set -e

echo "Starting Flight Booking Backend..."

# Kill any process using port 8000
echo "Checking for processes on port 8000..."
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
    echo "Killing process using port 8000..."
    lsof -ti tcp:8000 | xargs kill -9
    sleep 2
fi

# Create and activate virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example"
    if [ -f .env.example ]; then
        cp .env.example .env
    else
        touch .env
    fi
    echo "Please update the .env file with your actual credentials"
fi

# Install dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Install development dependencies if in development mode
if [ "$ENVIRONMENT" = "development" ] || [ -z "$ENVIRONMENT" ]; then
    if [ -f requirements-dev.txt ]; then
        echo "Installing development dependencies..."
        pip install -r requirements-dev.txt
    fi
fi

# Initialize database
echo "Initializing database..."
python init_db.py

# Start the application
echo "Starting the application on port 8000..."
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload