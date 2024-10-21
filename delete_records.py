import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore, auth
from datetime import datetime, timedelta
from os import getenv

class FirebaseAdmin:
    def __init__(self):
        # Initialize the Firebase app with the credentials from environment variables
        self.cred = credentials.Certificate(getenv("FIREBASE_CREDENTIALS"))
        firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()

        self.anonymous_login()
    
    def anonymous_login(self):
        try:
            # Anonymous sign-in using Firebase Auth (create an anonymous user)
            user = auth.create_user()
            return user
        
        except Exception as err:
            print(f"Unexpected error during anonymous login: {err}")
            return None
    
    def delete_documents_with_current_date(self, collection_name: str):
        # Get the current date (without time)
        today = datetime.utcnow().date()
        
        collection_ref = self.db.collection(collection_name)

        # Query documents that have a `date_time` field with today's date (ignoring time)
        docs = collection_ref.where('date_time', '>=', datetime(today.year, today.month, today.day)) \
                             .where('date_time', '<', datetime(today.year, today.month, today.day) + timedelta(days=1)) \
                             .stream()

        deleted_count = 0
        for doc in docs:
            print(f"Deleting document {doc.id} with date_time {doc.get('date_time')}")
            doc.reference.delete()
            deleted_count += 1
        
        print(f"Deleted {deleted_count} documents from {collection_name} for the current date.")

# Example usage
if __name__ == "__main__":
    firebase_admin = FirebaseAdmin()

    # Deleting all records from the "conditions" collection with today's date
    firebase_admin.delete_documents_with_current_date("conditions")
