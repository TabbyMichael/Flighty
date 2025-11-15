from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from fastapi import FastAPI

# Initialize the rate limiter
limiter = Limiter(key_func=get_remote_address)

def add_rate_limiting(app: FastAPI):
    """
    Add rate limiting to the FastAPI application.
    """
    # Add the rate limiter to the app
    app.state.limiter = limiter
    app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)
    
    # Add the middleware
    from slowapi.middleware import SlowAPIMiddleware
    app.add_middleware(SlowAPIMiddleware)