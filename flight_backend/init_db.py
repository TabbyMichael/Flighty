from app.database.database import engine, Base
from app.models.user import User
from app.models.booking import Booking
from app.models.airport import Airport
from app.models.airline import Airline
from app.models.flight_cache import FlightCache
from app.models.webhook_subscription import WebhookSubscription
from app.models.analytics_event import AnalyticsEvent

def init_db():
    # Create all tables
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully!")

if __name__ == "__main__":
    init_db()