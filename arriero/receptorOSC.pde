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

class ReceptorOSC {
  OscP5 oscP5;
  NetAddress direccionLocal;
  boolean inicializado = false;
  
  public ReceptorOSC(PApplet contenedor, int puertoLocal) {
    direccionLocal = new NetAddress("192.168.0.198", puertoLocal);
    OscProperties prop = new OscProperties();
    prop.setRemoteAddress(direccionLocal);
    oscP5 = new OscP5(contenedor, prop);
    inicializado = true;
  }
}
