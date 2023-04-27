// Embedded Linux (EMLI)
// University of Southern Denmark
// ESP8266 Wifi client - MQTT - Remote For Watering Apperatus
// Magnus Ellehøj Jacobsen <majac18@student.sdu.dk>
// 23-04-23

// LED
#define PIN_LED_RED     14
#define PIN_LED_YELLOW  13
#define PIN_LED_GREEN   12

// button
#define PIN_BUTTON      4
#define DEBOUNCE_TIME 200 // milliseconds
volatile unsigned long countPrevTime;
volatile boolean buttonPressed;

// Wifi
#include <ESP8266WiFi.h>
const char* WIFI_SSID = "EMLI_TEAM_12";
const char* WIFI_PASSWORD = "raspberry";

// MQTT Setup
#include "Adafruit_MQTT.h"
#include "Adafruit_MQTT_Client.h"
#define MQTT_SERVER      "io.adafruit.com"
#define MQTT_SERVERPORT  1883                   // use 8883 for SSL
#define MQTT_USERNAME    "...your AIO username (see https://accounts.adafruit.com)..."
#define MQTT_KEY         "...your AIO key..."

WiFiClient client;
Adafruit_MQTT_Client mqtt(&client, MQTT_SERVER, MQTT_SERVERPORT, MQTT_USERNAME, MQTT_KEY);
Adafruit_MQTT_Subscribe clientNumber = Adafruit_MQTT_Subscribe(&mqtt, MQTT_USERNAME "/plant/nextClient");
Adafruit_MQTT_Publish clientReg = Adafruit_MQTT_Publish(&mqtt, MQTT_USERNAME "/plant/clientReg");

void MQTT_connect();

//Plant System Setup
int plantNumber;

ICACHE_RAM_ATTR void buttonIsr()
{
  if (millis() - countPrevTime > DEBOUNCE_TIME)
  {
    countPrevTime = millis();
    buttonPressed = true;
  }
}

void setup(){
  Serial.begin(115200);
  delay(10);

  // LEDs
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  pinMode(PIN_LED_RED, OUTPUT);
  digitalWrite(PIN_LED_RED, LOW);
  pinMode(PIN_LED_YELLOW, OUTPUT);
  digitalWrite(PIN_LED_YELLOW, LOW);
  pinMode(PIN_LED_GREEN, OUTPUT);
  digitalWrite(PIN_LED_GREEN, LOW);
  
  Serial.println(F("Plant Watering Remote - Monitoring and Triggering."));
  Serial.println(F("========================================================="));
  Serial.println();


  //Setup WiFi
  Serial.println(F("Connecting to WiFi"));
  Serial.println(F("---------------------------------------------------------"));
  Serial.print(F("Connecting to "));
  Serial.print(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  int i = 0;
  while (WiFi.status() != WL_CONNECTED) {
    i++;
    delay(500);
    Serial.print(".");
    if(i==30) break;
  }
  if(WiFi.status() != WL_CONNECTED){
    Serial.println(F("Failure"));
    Serial.println(F("Error: Couldn't connect to specified WiFi"));
    Serial.println(F("Restarting in 5s due to Error"));
    delay(5000);
    ESP.restart();
  }else{
    Serial.println(F("Success"));
    Serial.println(F("WiFi Connected"));
    Serial.print(F("IP: "));
    Serial.println(WiFi.localIP());
  }

  //Register Plant
  Serial.println();
  Serial.println(F("Attempting to get plant registration number through MQTT"));
  Serial.println(F("---------------------------------------------------------"));
  Serial.print(F("Requesting ID from MQTT server..."));
  if (! clientACK.publish("ACK")) {
        Serial.println(F("Failure"));
        Serial.println(F("Error: Failed to send ID Request to MQTT"));
        Serial.println(F("Restarting in 5s due to Error"));
        delay(5000);
        ESP.restart();
      } else {
        Serial.println(F("OK!"));
      }
  Serial.print(F("Reading topic "));
  Serial.println(clientNumber.topic);
  mqtt.subscribe(&clientNumber);
  Adafruit_MQTT_Subscribe *subscription;
  while (subscription = mqtt.readSubscription(5000)) {
    if (subscription == &clientNumber) {
      if (! clientACK.publish("ACK")) {
        Serial.println(F("Failed"));
      } else {
        Serial.println(F("OK!"));
      }
      Serial.print(F("Got: "));
      Serial.println((char *)clientNumber.lastread);
      plantNumber = int(clientNumber.lastread);
      
    } else {
      Serial.println(F("Failure"));
      Serial.println(F("Error: Failed to register planter in MQTT"));
      Serial.println(F("Restarting in 5s due to Error"));
      delay(5000);
      ESP.restart();
    }
  }


  mqtt.unsubscribe(&clientNumber);

  char[40] str;
  sprintf(str, "plant/%i/remote/button", plantnumber)
  Adafruit_MQTT_Publish buttonTopic = Adafruit_MQTT_Publish(&mqtt, MQTT_USERNAME str);
  
  sprintf(str, "plant/%i/remote/led/red", plantnumber)
  Adafruit_MQTT_Subscribe ledRed = Adafruit_MQTT_Subscribe(&mqtt, MQTT_USERNAME str);
  
  sprintf(str, "plant/%i/remote/led/yellow", plantnumber)
  Adafruit_MQTT_Subscribe ledYellow = Adafruit_MQTT_Subscribe(&mqtt, MQTT_USERNAME str);
  
  sprintf(str, "plant/%i/remote/led/green", plantnumber)
  Adafruit_MQTT_Subscribe ledGreen = Adafruit_MQTT_Subscribe(&mqtt, MQTT_USERNAME str);
  digitalWrite(LED_BUILTIN, LOW);
}

void loop()
{
  MQTT_connect();
  
  //Button Handler
  if (buttonPressed){
    Serial.print(F("Attempting to publish buttonpress..."))
    if (! buttonTopic.publish(1)) {
      Serial.println(F("Failed"));
    } else {
      Serial.println(F("Published! "));
    }
  }


  //Read Subscriptions
  Adafruit_MQTT_Subscribe *subscription;
  while ((subscription = mqtt.readSubscription(2000))) {
    if (subscription == &ledRed) {
      Serial.print(F("Got Red LED: "));
      Serial.println((char *)ledRed.lastread);
      if (ledRed.lastread = ON){
        digitalWrite(PIN_LED_RED, HIGH);
      } else {
        digitalWrite(PIN_LED_RED, LOW);  
      }
      
    }
    if (subscription == &ledYellow) {
      Serial.print(F("Got Yellow LED: "));
      Serial.println((char *)ledYellow.lastread);
      if (ledRed.lastread = ON){
        digitalWrite(PIN_LED_YELLOW, HIGH);
      } else {
        digitalWrite(PIN_LED_YELLOW, LOW);  
      }
    }
    if (subscription == &ledGreen) {
      Serial.print(F("Got Green LED: "));
      Serial.println((char *)ledGreen.lastread);
      if (ledRed.lastread = ON){
        digitalWrite(PIN_LED_GREEN, HIGH);
      } else {
        digitalWrite(PIN_LED_GREEN, LOW);  
      }
    }
  }
  
  
  
  delay(1000);
  
  
}


void MQTT_connect() {
  int8_t ret;

  // Stop if already connected.
  if (mqtt.connected()) {
    return;
  }

  Serial.print("Connecting to MQTT... ");

  while ((ret = mqtt.connect()) != 0) { // connect will return 0 for connected
       Serial.println(mqtt.connectErrorString(ret));
       Serial.println("Retrying MQTT connection in 5 seconds...");
       mqtt.disconnect();
       delay(5000);  // wait 5 seconds
  }
  Serial.println("MQTT Connected!");
}
