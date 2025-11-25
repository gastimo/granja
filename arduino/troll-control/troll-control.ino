#include <Adafruit_NeoPixel.h>


// PINES PARA LAS ENTRADAS DIGITALES (DESDE EL "DOMADOR")
// A través de estos pines vienen las señales provenientes
// del "Domador" que indica cuál de las pantallas debe ser
// activada (y por ende su tira led encendida).
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#define PIN_ENTRADA_01 2
#define PIN_ENTRADA_02 3
#define PIN_ENTRADA_03 4
#define PIN_ENTRADA_04 5
#define PIN_ENTRADA_05 6
#define PIN_ENTRADA_06 7

int pinActivo = 0;
int duracion = 1000;
long encendido = 0;

void setup() {
  Serial.begin(9600);

  pinMode(PIN_ENTRADA_01, OUTPUT);
  pinMode(PIN_ENTRADA_02, OUTPUT);
  pinMode(PIN_ENTRADA_03, OUTPUT);
  pinMode(PIN_ENTRADA_04, OUTPUT);
  pinMode(PIN_ENTRADA_05, OUTPUT);
  pinMode(PIN_ENTRADA_06, OUTPUT);
}


void loop() {

  // Inicialización
  if (encendido == 0) {
    encendido = millis();
    pinActivo++;
    if (pinActivo > 6) {
      pinActivo = 1;
    }
  }

  // Verificación de tiempo de encendido
  long tiempo = millis();
  if (tiempo - encendido > duracion) {
    encendido = 0;
  }

  // Envío de la señal digital
  digitalWrite(PIN_ENTRADA_01, pinActivo == 1 ? HIGH : LOW);
  digitalWrite(PIN_ENTRADA_02, pinActivo == 2 ? HIGH : LOW);
  digitalWrite(PIN_ENTRADA_03, pinActivo == 3 ? HIGH : LOW);
  digitalWrite(PIN_ENTRADA_04, pinActivo == 4 ? HIGH : LOW);
  digitalWrite(PIN_ENTRADA_05, pinActivo == 5 ? HIGH : LOW);
  digitalWrite(PIN_ENTRADA_06, pinActivo == 6 ? HIGH : LOW);

  Serial.println(pinActivo);
}
