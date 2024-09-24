import paho.mqtt.client as mqtt
from json import loads

from firebase_admin.firestore import SERVER_TIMESTAMP
from firebase import firebase

class MqttSubscriber: 
    def __init__(self, broker_address, port, topic):
        self.broker_address = broker_address
        self.port = port
        self.topic = topic
        self.client = None

    def connect_to_broker(self):
        self.client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
        self.client.on_message = self.on_message
        self.client.connect(self.broker_address, self.port)

    def subscribe_to_topic(self):
        print("Script is running...")
        self.client.subscribe(self.topic)
        self.client.loop_forever()

    def on_message(self, client, userdata, msg):
        try:
            message = msg.payload.decode('utf-8')
            message = loads(message)
            print(message)
            
            if all(key in message for key in ["soil_moisture_value", "temperature_value", "humidity_value", "ph_value"]):
                json_data = {
                    key: int(value) if key in ["soil_moisture", "temperature", "humidity"] else (float(value) if key == 'ph' else value)
                    for key, value in {
                        'soil_moisture': message["soil_moisture_value"],
                        'temperature': message["temperature_value"],
                        'humidity': message["humidity_value"],
                        'ph': message["ph_value"],
                        'date_time': SERVER_TIMESTAMP
                    }.items()
                }
                
                if json_data['soil_moisture'] < 100 and json_data['ph'] < 10:
                    firebase.insert_data(json_data)
                    print("Successfully inserted into firebase")

        except Exception as e:
            print(f"Error processing message: {e}")