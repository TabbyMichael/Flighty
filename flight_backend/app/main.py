from fastapi import FastAPI
from app.api import auth, flights, bookings, airports, airlines, webhooks, admin
from app.core.rate_limiter import limiter, add_rate_limiting

app = FastAPI(title="Flight Booking API", version="1.0.0")

# Add rate limiting
add_rate_limiting(app)

# Include routers
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(flights.router, prefix="/flights", tags=["flights"])
app.include_router(bookings.router, prefix="/bookings", tags=["bookings"])
app.include_router(airports.router, prefix="/airports", tags=["airports"])
app.include_router(airlines.router, prefix="/airlines", tags=["airlines"])
app.include_router(webhooks.router, prefix="/webhooks", tags=["webhooks"])
app.include_router(admin.router, prefix="/admin", tags=["admin"])

@app.get("/")
def read_root():
    return {"message": "Flight Booking API"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}