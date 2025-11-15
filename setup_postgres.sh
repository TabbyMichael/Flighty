#!/bin/bash

# Script to set up PostgreSQL database for Flight Booking Application

echo "Setting up PostgreSQL database for Flight Booking Application..."

# Start PostgreSQL service
echo "Starting PostgreSQL service..."
sudo systemctl start postgresql

# Wait a moment for the service to start
sleep 5

# Check if PostgreSQL is running
if systemctl is-active --quiet postgresql; then
    echo "PostgreSQL is running."
    
    # Create database user if it doesn't exist
    sudo -u postgres psql -tc "SELECT 1 FROM pg_user WHERE usename = 'user'" | grep -q 1 || \
        sudo -u postgres psql -c "CREATE USER \"user\" WITH PASSWORD 'password';"
    
    # Create database if it doesn't exist
    sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'flightdb'" | grep -q 1 || \
        sudo -u postgres psql -c "CREATE DATABASE flightdb WITH OWNER \"user\";"
    
    # Grant privileges
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE flightdb TO \"user\";"
    
    echo "Database setup completed successfully!"
    echo "Database: flightdb"
    echo "Username: user"
    echo "Password: password"
else
    echo "Failed to start PostgreSQL. Please make sure it's installed and configured properly."
    echo "You can install it with: sudo apt-get install postgresql postgresql-contrib"
fi