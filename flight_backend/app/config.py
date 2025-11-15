import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Database - Defaulting to SQLite if PostgreSQL is not available
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./flight_booking.db")
    
    # Redis
    REDIS_URL: str = os.getenv("REDIS_URL", "redis://localhost:6379/0")
    
    # API Keys
    AVIATIONSTACK_KEY: str = os.getenv("AVIATIONSTACK_KEY", "")
    OPENSKY_USER: str = os.getenv("OPENSKY_USER", "")
    OPENSKY_PASS: str = os.getenv("OPENSKY_PASS", "")
    
    # Celery
    CELERY_BROKER_URL: str = os.getenv("CELERY_BROKER_URL", "redis://localhost:6379/0")
    CELERY_RESULT_BACKEND: str = os.getenv("CELERY_RESULT_BACKEND", "redis://localhost:6379/0")
    
    # JWT
    JWT_SECRET: str = os.getenv("JWT_SECRET", "secret_key")
    JWT_ALGORITHM: str = os.getenv("JWT_ALGORITHM", "HS256")
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("JWT_ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
    
    # Security
    SECRET_KEY: str = os.getenv("SECRET_KEY", "secret_key")
    ALGORITHM: str = os.getenv("ALGORITHM", "HS256")
    
    class Config:
        env_file = ".env"

settings = Settings()