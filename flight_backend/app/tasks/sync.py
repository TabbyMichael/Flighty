from celery import Celery
from app.config import settings
from app.core.aviationstack_client import get_airport_details, get_airline_details

cel = Celery("skyscan", broker=settings.CELERY_BROKER_URL, backend=settings.CELERY_RESULT_BACKEND)

@cel.on_after_configure.connect
def setup_periodic_tasks(sender, **kwargs):
    sender.add_periodic_task(24*3600, sync_airports.s(), name='daily airports sync')
    sender.add_periodic_task(3600, sync_airlines.s(), name='hourly airlines sync')

@cel.task
def sync_airports():
    # This would fetch all airports from AviationStack and save to database
    # For now, we'll just return a placeholder
    return "Airports synced"

@cel.task
def sync_airlines():
    # This would fetch all airlines from AviationStack and save to database
    # For now, we'll just return a placeholder
    return "Airlines synced"