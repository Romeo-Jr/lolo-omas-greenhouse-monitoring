import logging
import paho.mqtt.client as mqtt
from json import loads
from firebase_admin.firestore import SERVER_TIMESTAMP
from firebase import firebase
from sys import exit

# Configure logging
logging.basicConfig(
    level=logging.INFO,  # Set the log level
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("logs/mqtt_subscriber.log"),  # Log to a file
        # logging.StreamHandler()
    ]
)

class MqttSubscriber: 
    def __init__(self, broker_address, port, topic):
        self.broker_address = broker_address
        self.port = port
        self.topic = topic
        self.client = None

    def connect_to_broker(self):
        try:
            self.client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
            self.client.on_message = self.on_message
            self.client.connect(self.broker_address, self.port)
            logging.info("Connected to MQTT broker successfully.")

        except Exception as error:
            logging.error(f'Error connecting to broker: {error}')
            exit(1)

    def subscribe_to_topic(self):
        try:
            logging.info("Subscribing to topic...")
            self.client.subscribe(self.topic)
            self.client.loop_forever()

        except Exception as error:
            logging.error(f'Error subscribing to topic: {error}')
            
        except KeyboardInterrupt:
            logging.info("Subscription stopped by user.")

    def on_message(self, client, userdata, msg):
        try:
            message = msg.payload.decode('utf-8')
            message = loads(message)
            logging.info(f"Received message: {message}")
            
            if all(key in message for key in ["sm", "tm", "hd", "ph"]):
                json_data = {
                    key: int(value) if key in ["soil_moisture", "temperature", "humidity"] else (float(value) if key == 'ph' else value)
                    for key, value in {
                        'soil_moisture': message["sm"],
                        'temperature': message["tm"],
                        'humidity': message["hd"],
                        'ph': message["ph"],
                        'date_time': SERVER_TIMESTAMP
                    }.items()
                }
                
                if json_data['soil_moisture'] < 100 and json_data['ph'] < 10 and json_data['soil_moisture'] != 0:
                    firebase.insert_data(json_data)
                    logging.info("Successfully inserted data into Firebase.")

        except Exception as e:
            logging.error(f"Error processing message: {e}")
