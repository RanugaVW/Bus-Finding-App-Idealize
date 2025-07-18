import time
from datetime import datetime
import platform
import psutil
from typing import Dict, Any

class PingService:
    
    @staticmethod
    async def get_ping_response() -> Dict[str, Any]:
        """
        Simple ping response
        """
        return {
            "status": "success",
            "message": "API is running",
            "timestamp": datetime.now().isoformat(),
            "response_time_ms": round(time.time() * 1000) % 1000
        }
    
    @staticmethod
    async def get_health_status() -> Dict[str, Any]:
        """
        Detailed health check with system information
        """
        try:
            # Get system information
            cpu_percent = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage('/')
            
            return {
                "status": "healthy",
                "timestamp": datetime.now().isoformat(),
                "server_info": {
                    "platform": platform.system(),
                    "python_version": platform.python_version(),
                    "architecture": platform.machine()
                },
                "system_metrics": {
                    "cpu_usage_percent": cpu_percent,
                    "memory_usage_percent": memory.percent,
                    "disk_usage_percent": disk.percent,
                    "available_memory_gb": round(memory.available / (1024**3), 2)
                },
                "uptime": "API is running successfully"
            }
        except Exception as e:
            return {
                "status": "degraded",
                "timestamp": datetime.now().isoformat(),
                "error": str(e),
                "message": "Health check encountered issues"
            }