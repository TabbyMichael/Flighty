import requests
import hmac
import hashlib
import json
from celery import Celery
from app.config import settings

cel = Celery("skyscan", broker=settings.CELERY_BROKER_URL, backend=settings.CELERY_RESULT_BACKEND)

@cel.task(bind=True, max_retries=5)
def deliver_webhook(self, url, secret, event_type, payload):
    body = json.dumps({"type": event_type, "data": payload})
    signature = hmac.new(secret.encode(), body.encode(), hashlib.sha256).hexdigest()
    headers = {
        "Content-Type": "application/json", 
        "X-Skyscan-Signature": signature
    }
    try:
        r = requests.post(url, data=body, headers=headers, timeout=10)
        r.raise_for_status()
    except Exception as exc:
        raise self.retry(exc=exc, countdown=2 ** self.request.retries)
    return r.status_code