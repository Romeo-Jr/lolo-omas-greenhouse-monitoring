import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

from os import getenv

class FirebaseAdmin:
    def __init__(self):
        self.cred = credentials.Certificate(getenv("FIREBASE_CREDENTIALS"))
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()
    
    def insert_data(self, data:dict):
        return self.db.collection("conditions").add(data)