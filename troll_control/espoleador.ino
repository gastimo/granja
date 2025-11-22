#include <Adafruit_NeoPixel.h>

// Pines para las entradas analógicas (LDR)
#define PIN_LDR_01 A0
#define PIN_LDR_02 A1

// Pines para las salidas digitales (tira led)
#define PIN_LED_01 7
#define PIN_LED_02 8
#define PIN_LED_03 9
#define PIN_LED_04 10
#define PIN_LED_05 11
#define PIN_LED_06 12

// Cantidades de leds de cada tira
#define CANTIDAD_LEDS_01 23
#define CANTIDAD_LEDS_02 23
#define CANTIDAD_LEDS_03 23
#define CANTIDAD_LEDS_04 23
#define CANTIDAD_LEDS_05 23
#define CANTIDAD_LEDS_06 23

#define UMBRAL_LDR 220

// Variables globales
int lectura1;
int lectura2;
boolean estado = true;
boolean estadoAnterior = false;
int tiraEncendida = 0;

// Definición de las tiras de leds
Adafruit_NeoPixel tira01 = Adafruit_NeoPixel(CANTIDAD_LEDS_01, PIN_LED_01, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira02 = Adafruit_NeoPixel(CANTIDAD_LEDS_02, PIN_LED_02, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira03 = Adafruit_NeoPixel(CANTIDAD_LEDS_03, PIN_LED_03, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira04 = Adafruit_NeoPixel(CANTIDAD_LEDS_04, PIN_LED_04, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira05 = Adafruit_NeoPixel(CANTIDAD_LEDS_05, PIN_LED_05, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira06 = Adafruit_NeoPixel(CANTIDAD_LEDS_06, PIN_LED_06, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tiras[] = {tira01, tira02, tira03, tira04, tira05, tira06};


void setup() {
  Serial.begin(9600);

  // Definición de los pines de entrada y salida
  pinMode(PIN_LDR_01, INPUT);
  pinMode(PIN_LDR_02, INPUT);
  pinMode(PIN_LED_01, OUTPUT);
  pinMode(PIN_LED_02, OUTPUT);
  pinMode(PIN_LED_03, OUTPUT);
  pinMode(PIN_LED_04, OUTPUT);
  pinMode(PIN_LED_05, OUTPUT);
  pinMode(PIN_LED_06, OUTPUT);

  // Inicialización de las tiras de leds
  tira01.begin(); 
  tira01.fill(tira01.Color(0,0,0)); 
  tira01.show();
}

void loop() {
  lectura1 = analogRead(PIN_LDR_01);
  lectura2 = analogRead(PIN_LDR_02);
  Serial.print("Lectura LDR 01=");
  Serial.print(lectura1);
  Serial.print("  - Lectura LDR 02=");
  Serial.println(lectura2);

  if (lectura1 > UMBRAL_LDR || lectura2 > UMBRAL_LDR) {
    estado = false;
  }
  else {
    estado = true;
  }

  // Detecto si se debe apagar la tira de leds encendida
  if (!estado && estadoAnterior) {
    tiras[tiraEncendida].fill(tiras[tiraEncendida].Color(0,0,0)); 
    tiras[tiraEncendida].show();
    estadoAnterior = estado;
    delay(20);
  }

  // Sino, detecto si se debe encender una tira led
  else if (estado && !estadoAnterior) {
    tiraEncendida = 5;          //random(6);
    Serial.print("NUEVA TIRA=");
    Serial.println(tiraEncendida);
    tiras[tiraEncendida].fill(tiras[tiraEncendida].Color(30,0,0)); 
    tiras[tiraEncendida].show();
    estadoAnterior = estado;
    delay(20);
  }
}
