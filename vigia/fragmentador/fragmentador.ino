#include <Adafruit_NeoPixel.h>

#define PI 3.1415926535
int pinLed = 6;
int cantPixeles = 275;
int pixelesRecibidos = 0;
int noBrillo = 0;
float maxBrilloR = 10;
float maxBrilloG = 10;
float maxBrilloB = 11;

int posX = 0;
int posY = 0;
int valorR = int(maxBrilloR);
int valorG = int(maxBrilloG);
int valorB = int(maxBrilloB);

byte datos[5];
Adafruit_NeoPixel strip(cantPixeles, pinLed, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);  // Debe coincidir con la velocidad definida en Processing
  strip.begin(); 
  strip.fill(strip.Color(0,0,0)); 
  strip.show();
}

void loop() {
  int indice = 0;
  while (Serial.available() > 0) {
    int bytesLeidos = Serial.readBytes(datos, 5);
    if (bytesLeidos == 5) {
      posX = int(datos[0]);
      posY = int(datos[1]);
      if (posX < 25 && posY < 25) { 
        valorR = int(datos[2]) * maxBrilloR / 255;
        valorG = int(datos[3]) * maxBrilloG / 255;
        valorB = int(datos[4]) * maxBrilloB / 255;
        indice = (posX * 25) + posY;
        strip.setPixelColor(indice, strip.Color(valorR, valorG, valorB));
      }
      else if (posX == 99 && posY == 99) {
        strip.fill(strip.Color(0,0,0)); 
        strip.show();
        break;
      }
      else {
        strip.show();
        break;
      }
    }
    if (pixelesRecibidos >= cantPixeles/11) {
      pixelesRecibidos = 0;
      strip.show();
    }
  }
}