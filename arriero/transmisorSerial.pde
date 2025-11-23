// 
// TRANSMISOR SERIAL
// Funciones de inicialización del puerto serial de comunicación
// y de envío de datos a través de este mismo puerto.
// Se utiliza la libreria "Serial" de Processing:
//
//   https://processing.org/reference/libraries/serial/index.html
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
import processing.serial.*;

// Constantes para la serialización
int TASA_TRANSFERENCIA = 115200;


class TransmisorSerial extends Transmisor {
  Serial puertoSerial;
  boolean inicializado = false;
  
  public TransmisorSerial(PApplet contenedor) {
    String[] puertos = Serial.list();
    if (puertos.length > 0) {
      
      // CREACIÓN DEL PUERTO 
      // Se crea un puerto serial que debe ser el mismo que el puerto
      // donde está conectado el arduino. La velocidad de transferencia
      // también debe coincidir en ambos casos.
      puertoSerial = new Serial(contenedor, Serial.list()[0], TASA_TRANSFERENCIA);
      
      // TASA DE TRANSFERENCIA
      // La matriz de "pixel leds" tiene en total 275 leds y por cada uno
      // de ellos se indican sus valores de rojo, verde y azul, que
      // ocupan un byte por cada canal. Además, por cada pixel se envía
      // también su posición <X,Y> en la matriz (un byte adicional por cada
      // coordenada). En resumen, se envía un paquete de 5 bytes por pixel.
      //
      //              275 * 5 * 8 = 11.600 bits/frame
      //
      // Es decir, enviar un único fotograma consume 11.600 bits de la tasa
      // de transferencia. Por lo tanto, a una velocidad de 115.200 bits por 
      // segundo, la tasa de fps debería ser inferior a los 10,5 fps.
      // 
      //    10.5 frames/seg. x 11.600 bits/frame = 115.500 bits/seg.
      //
      inicializado = true;
      println("PUERTO SERIAL CONECTADO");
    }
    else {
      println("No se detectó ningún puerto.");
    } 
  }
  
  public void enviar(byte[] datos) {
    if (inicializado) {
      puertoSerial.write(datos);
    }
  }
}
