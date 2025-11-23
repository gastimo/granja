// 
// TRANSMISOR OSC
// Funciones de inicialización de los servicios de comunicación
// mediante el protocolo de red OSC (Open Sound Protocol).
// Se utiliza la librería "oscP5" de Andreas Schelegel:
//
//   https://sojamo.de/libraries/oscp5/
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
import oscP5.*;
import netP5.*;

// Contantes para definir los IPs y los puertos
final int PUERTO_LOCAL   = 12001;
final int PUERTO_DESTINO = 12000;
final String IP_DESTINO  = "192.168.0.3"; 

OscP5 oscP5;
NetAddress direccionRemota;
byte paquete[] = new byte[825];

class TransmisorOSC extends Transmisor {
  
  OscP5 oscP5;
  NetAddress direccionRemota;
  OscMessage mensajeOSC;
  boolean inicializado = false;
  
  public TransmisorOSC(PApplet contenedor) {
    // Se inicializa un objeto "oscP5", escuchando mensajes
    // entrantes en el puerto indicado como PUERTO_LOCAL
    oscP5 = new OscP5(contenedor, PUERTO_LOCAL);
    
    // La "direccion remota" es usada como parámetro en la invocación
    // de oscP5.send, es decir, al enviar mensajes hacia otra computadora.
    // Se debería configurar con el IP_DESTINO y el puerto donde la otra 
    // computadora se encuentre escuchando, o sea, PUERTO_DESTINO.
    //direccionRemota = new NetAddress(IP_DESTINO, PUERTO_DESTINO);
    
    inicializado = true;
  }
  
  public void enviar(byte[] datos) {
    if (inicializado) {
      mensajeOSC = new OscMessage("/granja");
      mensajeOSC.add(int(datos[0]));
      mensajeOSC.add(int(datos[1]));
      mensajeOSC.add(int(datos[2]));
      mensajeOSC.add(int(datos[3]));
      mensajeOSC.add(int(datos[4]));
      oscP5.send(mensajeOSC, direccionRemota);
    }
  }
  
  void oscEvent(OscMessage mensajeEntrante) {
    if (mensajeEntrante.checkAddrPattern("/granja") ) {
      if (mensajeEntrante.checkTypetag("iiiii")) {
          datos[0] = byte(mensajeEntrante.get(0).intValue());
          datos[1] = byte(mensajeEntrante.get(1).intValue());
          datos[2] = byte(mensajeEntrante.get(2).intValue());
          datos[3] = byte(mensajeEntrante.get(3).intValue());
          datos[4] = byte(mensajeEntrante.get(4).intValue());
          println("=> Mensaje OSC recibido= " + mensajeEntrante.get(0).intValue() + ", " + 
                                                mensajeEntrante.get(1).intValue() + ", " + 
                                                mensajeEntrante.get(2).intValue() + ", " + 
                                                mensajeEntrante.get(3).intValue() + ", " + 
                                                mensajeEntrante.get(4).intValue()); 
      }
    }
  }
}
