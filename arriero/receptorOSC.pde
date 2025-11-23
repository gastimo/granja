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

// Puerto donde está escuchando el "Arriero". Este módulo sólo
// recibe mensajes OSC desde el "Vichador" y desde el "Capataz".
// No envía ningún mensaje, por lo tanto, no es necesaria la
// configuración de los puertos e IPs de destino o salida.
final int PUERTO_LOCAL = 12001; 

class ReceptorOSC extends Transmisor {
  OscP5 oscP5;
  NetAddress direccionRemota;
  boolean inicializado = false;
  
  public ReceptorOSC(PApplet contenedor) {
    // Se inicializa un objeto "oscP5", escuchando mensajes entrantes
    oscP5 = new OscP5(contenedor, PUERTO_LOCAL);
    inicializado = true;
  }
}
