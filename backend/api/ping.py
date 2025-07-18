from fastapi import APIRouter
from Services.ping_service import PingService

router = APIRouter()

@router.get("/ping")
async def ping():
    """
    Health check endpoint to verify API is running
    """
    return await PingService.get_ping_response()

@router.get("/health")
async def health_check():
    """
    Detailed health check with system information
    """
    return await PingService.get_health_status()