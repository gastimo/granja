#include <Adafruit_NeoPixel.h>

#define CANTIDAD_TIRAS 6
#define INTENSIDAD_COLOR 30
#define DURACION_ACTIVACION 610


// PINES PARA LUCES TESTIGOS
// Definición de los pines digitales para encender las
// luces leds "testigos" del Troll Controll
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#define PIN_TESTIGO_01 A0
#define PIN_TESTIGO_02 A1

// PRIMERO DE LOS 6 PINES PARA ENTRADAS DIGITALES
// A través de estos 6 pines vienen las señales provenientes
// del "Domador" que indica cuál de las pantallas debe ser
// activada (y por ende su tira led encendida).
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#define PIN_ENTRADA_INICIAL 2

// PRIMERO DE LOS 6 PINES PARA LAS SALIDAS DIGITALES 
// A través de estos 6 pines se envía la señal a la plaqueta del
// "Troll Control" para encender la tira led que corresponda.
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#define PIN_LED_INICIAL 8


// Array para almacenar las lecturas
int lecturas[6]; 
int ultimaTira = -1;
long tiempos[] = {0, 0, 0, 0, 0, 0};


// Definición de las tiras de leds
int cantidades[] = {23, 23, 23, 23, 23, 23};
Adafruit_NeoPixel tira01 = Adafruit_NeoPixel(cantidades[0], PIN_LED_INICIAL, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira02 = Adafruit_NeoPixel(cantidades[1], PIN_LED_INICIAL + 1, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira03 = Adafruit_NeoPixel(cantidades[2], PIN_LED_INICIAL + 2, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira04 = Adafruit_NeoPixel(cantidades[3], PIN_LED_INICIAL + 3, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira05 = Adafruit_NeoPixel(cantidades[4], PIN_LED_INICIAL + 4, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tira06 = Adafruit_NeoPixel(cantidades[5], PIN_LED_INICIAL + 5, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel tiras[] = {tira01, tira02, tira03, tira04, tira05, tira06};


void setup() {
  Serial.begin(9600);

  // Definición de los pines para luces testigos
  pinMode(PIN_TESTIGO_01, OUTPUT);
  pinMode(PIN_TESTIGO_02, OUTPUT);

  // DEFINICIÓN DE LOS PINES DE ENTRADA
  // Son los que vienen del "Domador" y a pedido del "Capataz"
  for (int i = 0; i < CANTIDAD_TIRAS; i++) {
    pinMode(PIN_ENTRADA_INICIAL + i, INPUT);
  }

  // DEFINICIÓN DE LOS PINES DE SALIDA
  // Son los que van hacia la plaqueta del "Troll Control"
  for (int i = 0; i < CANTIDAD_TIRAS; i++) {
    pinMode(PIN_LED_INICIAL + i, OUTPUT);
  }

  // Inicialización de las tiras de leds
  for (int i = 0; i < CANTIDAD_TIRAS; i++) {
    tiras[i].begin(); 
    tiras[i].fill(tiras[i].Color(0,0,0)); 
    tiras[i].show();
  }
}


void loop() {
  // Lectura de las entradas digitales
  for (int i = 0; i < CANTIDAD_TIRAS; i++) {
    lecturas[i] = digitalRead(PIN_ENTRADA_INICIAL + i);
    if (lecturas[i] == HIGH && ultimaTira != i) {
      tiempos[i] = millis();
      ultimaTira = i;
    }
  }

  // Encendido y apagado de las luces testigos
  if (lecturas[0] == HIGH || lecturas[2] == HIGH || lecturas[4] == HIGH) {
    digitalWrite(PIN_TESTIGO_01, HIGH);
    digitalWrite(PIN_TESTIGO_02, LOW);
  }
  else {
    if (lecturas[1] == HIGH || lecturas[3] == HIGH || lecturas[5] == HIGH) {
      digitalWrite(PIN_TESTIGO_01, LOW);
      digitalWrite(PIN_TESTIGO_02, HIGH);
    }    
  }


  // Encendido y apagado de las tiras leds
  long tiempo = millis();
  for (int i = 0; i < CANTIDAD_TIRAS; i++) {
    if (tiempo - tiempos[i] <= DURACION_ACTIVACION * 6) {
      encender(i, tiempo);
    }
    else {
      tiras[i].fill(tiras[i].Color(0,0,0));
      tiempos[i] = 0; 
    }
    tiras[i].show();
  }

  // Monitor de los datos 
  mostrarDatos();
}


float lerp(float a, float b, float t) {
  return a + (b - a) * t;
}

void encender(int numeroTira, long tiempo) {
  float tiempoEncendido = DURACION_ACTIVACION / cantidades[numeroTira] * 2;  
  for (int i = 0; i < cantidades[numeroTira]; i++) {
    float t = tiempo - (tiempos[numeroTira] + (tiempoEncendido * i));
    if (t <= tiempoEncendido * 2 && t > tiempoEncendido * -1) {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(INTENSIDAD_COLOR, 0, 0)); 
    }
    else if (t < tiempoEncendido * 4 && t > tiempoEncendido * -3) {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(INTENSIDAD_COLOR * 0.6, 0, 0)); 
    }
    else if (t < tiempoEncendido * 6 && t > tiempoEncendido * -5) {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(INTENSIDAD_COLOR * 0.18, 0, 0)); 
    }
    else if (t < tiempoEncendido * 10 && t > tiempoEncendido * -9) {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(INTENSIDAD_COLOR * 0.06, 0, 0)); 
    }
    else if (t < tiempoEncendido * 16 && t > tiempoEncendido * -15) {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(INTENSIDAD_COLOR * 0.011, 0, 0)); 
    }
    else if (t < tiempoEncendido * 22 && t > tiempoEncendido * -21) {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(INTENSIDAD_COLOR * 0.001, 0, 0)); 
    }

    else {
      tiras[numeroTira].setPixelColor(i, tiras[numeroTira].Color(0, 0, 0)); 
    }
  }
}

void mostrarDatos() {
  Serial.print("SEÑALES DE ENTRADA = ");
  for (int i = 0; i < CANTIDAD_TIRAS; i++) {
    Serial.print(lecturas[i]);
    Serial.print(" ");
  }
  Serial.println("");
}