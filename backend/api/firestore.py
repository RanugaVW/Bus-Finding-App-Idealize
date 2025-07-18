from fastapi import APIRouter
from Services.firestore_service import FirestoreService

router = APIRouter()
firestore_service = FirestoreService()

@router.get("/firestore-test")
def test_firestore():
    return firestore_service.test_connection()

@router.get("/ping")
def ping():
    return {"message": "pong", "firestore": "ready"}

# requirements.txt