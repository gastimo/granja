// 
// RECEPTOR OSC
// Funciones de inicialización de los servicios de comunicación
// mediante el protocolo de red OSC (Open Sound Protocol).
// Se utiliza la librería "oscP5" de Andreas Schelegel:
//
//   https://sojamo.de/libraries/oscp5/
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
import oscP5.*;
import netP5.*;

OscP5 oscP5;
int puertoEntrante = 0;
boolean oscInicializado = false;

class ReceptorOSC {  
  NetAddress direccionRemota;
  OscMessage mensajeOSC;
  byte[] datos = {0x00, 0x00, 0x00, 0x00, 0x00};
  byte paquete[] = new byte[825];

  
  public ReceptorOSC(PApplet contenedor) {
    this(contenedor, 12000);
  }

  public ReceptorOSC(PApplet contenedor, int puertoLocal) {
    if (!oscInicializado) {
      oscP5 = new OscP5(contenedor, puertoLocal);
      puertoEntrante = puertoLocal;
      oscInicializado = true;
    }
    else {
      if (puertoEntrante != puertoLocal) {
        println("Error creando transmisor OSC para el puerto " + puertoLocal + 
                ". El servidor ya se encuentra escuchando en el puerto " + puertoEntrante);
      }
    }
  }
  
}
