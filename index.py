import paho.mqtt.client as mqtt
from os import environ
from mqtt.mqtt_controller import MqttSubscriber

if __name__ == '__main__':

  BROKER_ADDRESS = environ.get("BROKER_ADDRESS")
  PORT = int(environ.get("PORT"))
  TOPIC = environ.get("TOPIC")
  USERNAME = environ.get("USERNAME")
  PASSWORD = environ.get("PASSWORD")

  subscriber = MqttSubscriber(BROKER_ADDRESS, PORT, TOPIC, USERNAME, PASSWORD)
  subscriber.connect_to_broker()
  subscriber.subscribe_to_topic()
