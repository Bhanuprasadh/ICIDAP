import logging
import structlog
from fastapi import FastAPI, Request
from prometheus_client import make_asgi_app, Counter
import uvicorn

structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ],
    logger_factory=structlog.stdlib.LoggerFactory(),
)
log = structlog.get_logger()

app = FastAPI()

# Setting-up Prometheus Metrics
EVENTS_COUNTER = Counter(
    "events_received_total",
    "Total number of events received",
    ["event_type", "status"]
)

metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)

@app.get("/")
async def health_check():
    return {"status": "ok"}

@app.post("/events")
async def receive_event(request: Request):
    data = await request.json()
    event_type = data.get("type", "unknown")

    EVENTS_COUNTER.labels(event_type=event_type, status =  "success").inc()

    log.info("event_received", event_type=event_type, payload=data)

    return {"status": "received", "event_type": event_type}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
