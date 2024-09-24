#include <WiFi.h>
#include <PubSubClient.h>
#include <SoftwareSerial.h>

SoftwareSerial arduinoSerial(16, 17); // Pins for RX and TX on ESP32

// WiFi and MQTT Broker details
const char* ssid = "PLDTHOMEFIBRgky9c";
const char* password = "PLDTWIFIry2fp";
const char* mqtt_server = "192.168.1.7";

// Create WiFi and MQTT client objects
WiFiClient espClient;
PubSubClient client(espClient);

// Function to connect to WiFi
void setup_wifi() {
    delay(10);
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }

    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

// Function to connect to MQTT broker
void reconnect() {
    while (!client.connected()) {
        Serial.print("Attempting MQTT connection...");
        if (client.connect("ESP32Client")) {
        Serial.println("connected");
        } else {
        Serial.print("failed, rc=");
        Serial.print(client.state());
        delay(5000);
        }
    }
}

void setup() {
    Serial.begin(115200); 
    arduinoSerial.begin(9600); // Initialize serial communication for Arduino-ESP32

  setup_wifi();       // Connect to WiFi
  client.setServer(mqtt_server, 1883); // Set MQTT broker
}

void loop() {
    if (!client.connected()) {
        reconnect();
    }
    client.loop();

    if (arduinoSerial.available()) {

        String jsonString = arduinoSerial.readStringUntil('\n'); // Read JSON from serial
        Serial.println(jsonString);

        // Publish a message every 5 seconds
        static unsigned long lastMsg = 0;
        unsigned long now = millis();
        if (now - lastMsg > 5000) {
            lastMsg = now;

            // Publish the received JSON directly to the MQTT broker
            if (client.publish("conditions", jsonString.c_str())) {
                Serial.println("JSON data sent to MQTT broker successfully");
            } else {
                Serial.println("Failed to send JSON data to MQTT broker");
            }

        }
    }

    delay(1000);
}
