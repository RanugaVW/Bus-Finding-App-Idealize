import firebase_admin
from firebase_admin import credentials, firestore

class FirestoreService:
    def __init__(self):
        # Initialize Firebase (replace with your service account key path)
        if not firebase_admin._apps:
            cred = credentials.Certificate("D:/bus-finder-65525-firebase-adminsdk-fbsvc-6959bffe55.json")
            firebase_admin.initialize_app(cred)
        self.db = firestore.client()
    
    def test_connection(self):
        try:
            # Simple test - try to read from a test collection
            test_ref = self.db.collection('test').document('connection')
            test_ref.set({'timestamp': firestore.SERVER_TIMESTAMP, 'status': 'connected'})
            
            # Read it back
            doc = test_ref.get()
            if doc.exists:
                return {"status": "connected", "data": doc.to_dict()}
            else:
                return {"status": "error", "message": "Document not found"}
        except Exception as e:
            return {"status": "error", "message": str(e)}