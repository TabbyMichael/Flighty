from app.database.database import engine, Base
# Import all models to ensure they are registered with the metadata
from app.models.user import User
from app.models.booking import Booking
from app.models.airport import Airport
from app.models.airline import Airline
from app.models.flight_cache import FlightCache
from app.models.webhook_subscription import WebhookSubscription
from app.models.analytics_event import AnalyticsEvent

def init_db():
    # Create all tables
    table_names = list(Base.metadata.tables.keys())
    print("Creating tables for models:", table_names)
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully!")
    return table_names

if __name__ == "__main__":
    init_db()