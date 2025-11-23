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
final int PUERTO_LOCAL   = 12000;
final int PUERTO_DESTINO = 12001;         // Puerto del "Arriero" 
//final String IP_DESTINO  = "192.168.0.3"; // IP del "Arriero"
final String IP_DESTINO  = "192.168.0.9";  // IP del "Arriero"



OscP5 oscP5;
NetAddress direccionRemota;
byte paquete[] = new byte[825];


class TransmisorOSC extends Transmisor {
  
  OscP5 oscP5;
  NetAddress direccionRemota;
  OscMessage mensajeOSC;
  byte[] datos = {0x00, 0x00, 0x00, 0x00, 0x00};
  boolean inicializado = false;
  
  
  public TransmisorOSC(PApplet contenedor) {
    // Se inicializa un objeto "oscP5", escuchando mensajes
    // entrantes en el puerto indicado como PUERTO_LOCAL
    oscP5 = new OscP5(contenedor, PUERTO_LOCAL);
    
    // La "direccion remota" es usada como parámetro en la invocación
    // de oscP5.send, es decir, al enviar mensajes hacia otra computadora.
    // Se debería configurar con el IP_DESTINO y el puerto donde la otra 
    // computadora se encuentre escuchando, o sea, PUERTO_DESTINO.
    direccionRemota = new NetAddress(IP_DESTINO, PUERTO_DESTINO);
    
    inicializado = true;
  }
  
  
  public void enviar(byte[] paquete, String dirección) {
    if (inicializado) {
      mensajeOSC = new OscMessage(dirección);
      mensajeOSC.add(paquete);
      oscP5.send(mensajeOSC, direccionRemota);
    }
  }  
  
  
  public void enviarFinDeCuadro() {
    datos[0] = byte(CODIGO_FIN_DE_CUADRO);
    datos[1] = byte(CODIGO_FIN_DE_CUADRO);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    enviar(datos, MENSAJE_OSC_CIERRE);
  }
  
  
  public void enviarPausa() {
    datos[0] = byte(CODIGO_PAUSA);
    datos[1] = byte(CODIGO_PAUSA);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    enviar(datos, MENSAJE_OSC_PAUSA);
  }
    
    
  /**
   * enviar
   * Envia los valores de cada uno de los píxeles de la imagen (fragmentada)
   * recibida como argumento. El mensaje OSC se construye como un tipo de dato 
   * BLOB, colocando en orden y en secuencia los 3 bytes de los canales RGB de
   * cada uno de los píxeles de la imagen. Es decir, el paquete de datos del 
   * mensaje OSC tiene un tamaño de 825 bytes (3 bytes/pixel x 275 pixels). 
   * Por ejemplo, los primeros 6 bytes serían:
   *   PAQUETE[0] = canal "Rojo" del pixel  "0"
   *   PAQUETE[1] = canal "Verde" del pixel "0"
   *   PAQUETE[2] = canal "Azul" del pixel  "0"
   *   PAQUETE[3] = canal "Rojo" del pixel  "1"
   *   PAQUETE[4] = canal "Verde" del pixel "1"
   *   PAQUETE[5] = canal "Azul" del pixel  "1"
   *   ...
   */
  void enviar(PImage imagen) {
    if (!enPausa) {
      int indice = 0;
      int contador = 0;
      for (int i = 0; i < imagen.width; i++) {
        for (int j = imagen.height - 1; j >= 0; j--) {
          indice = i + (j * imagen.width);
          color colorPixel = imagen.pixels[indice];
          paquete[contador++] = byte(red(colorPixel));
          paquete[contador++] = byte(green(colorPixel));
          paquete[contador++] = byte(blue(colorPixel));
          imagen.pixels[indice] = color(byte(red(colorPixel)),
                                        byte(green(colorPixel)),
                                        byte(blue(colorPixel)));
        }
      }
      imagen.updatePixels();
      enviar(paquete, MENSAJE_OSC_FOTOGRAMA);
    }
    else {
      enviarPausa();
    }
  }  
}
