from fastapi import FastAPI
from api.ping import router as ping_router
from api.firestore import router as firestore_router

app = FastAPI(
    title="Your API",
    description="FastAPI Backend with Health Check",
    version="1.0.0"
)

# Include ping routes
app.include_router(ping_router, prefix="/api/v1", tags=["Health Check"])
app.include_router(firestore_router, prefix="/api")

# Add your other routers here
# app.include_router(other_router, prefix="/api/v1", tags=["Other"])

@app.get("/")
async def root():
    return {"message": "Welcome to your FastAPI backend!"}
