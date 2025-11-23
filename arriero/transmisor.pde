// 
// TRANSMISOR
// Se trata de un objeto que se encarga de llevar a cabo la 
// transmisión de datos (salientes y entrantes) ya sea a través
// del protocolo OSC o del puerto serial de comunicación.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

// Constantes para la transmisión
final int CODIGO_FIN_DE_CUADRO = 25;
final int CODIGO_PAUSA         = 99;


class Transmisor {
  PApplet ventana;
  byte[] datos = {0x00, 0x00, 0x00, 0x00, 0x00};
  boolean enPausa = false;
  
  public Transmisor() {
  }

  public Transmisor(PApplet contenedor) {
    ventana = contenedor;
  }
  
  public boolean enPausa() {
    return enPausa;
  }
  
  public void pausar() {
    enviarPausa();
    enPausa = true;
  }
  
  public void reanudar() {
    enPausa = false;
  }
  
  public void enviar(byte[] datos) {
    // Esta función no se debería ejecutar nunca. El método enviar 
    // de las clases hijas debería ser ejecutado en su lugar.
    println("Transmitiendo " + datos.length + " bytes de datos...");
  }
  
  /**
   * enviarFinDeCuadro
   * Envía un paquete de 5 bytes para indicar que ya fueron
   * transmitidos todos los pixels de la imagen.
   */
  public void enviarFinDeCuadro() {
    datos[0] = byte(CODIGO_FIN_DE_CUADRO);
    datos[1] = byte(CODIGO_FIN_DE_CUADRO);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    enviar(datos);
  }
  
  /**
   * enviarPausa
   * Envía un paquete de 5 bytes para indicar que la transferencia
   * por el puerto serial ha sido pausada.
   */
  public void enviarPausa() {
    datos[0] = byte(CODIGO_PAUSA);
    datos[1] = byte(CODIGO_PAUSA);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    enviar(datos);
  }
  
  /**
   * enviar
   * Envia los valores de cada uno de los píxeles de la imagen (fragmentada)
   * recibida como argumento. Por cada pixel de la imagen se envía un paquete
   * de 5 bytes, según la siguiente especificación:
   *   - BYTE #0: Coordenada X (entre 0 y 10)
   *   - BYTE #1: Coordenada Y traspuesta (entre 0 y 24)
   *   - BYTE #2: Valor numérico para el canal rojo del color del pixel
   *   - BYTE #3: Valor numérico para el canal verde del color del pixel
   *   - BYTE #4: Valor numérico para el canal azul del color del pixel
   */
  public void enviar(PImage imagen) {
    if (!enPausa) {
      int indice = 0;
      for (int i = 0; i < imagen.width; i++) {
        for (int j = imagen.height - 1; j >= 0; j--) {
          indice = i + (j * imagen.width);
          color colorPixel = imagen.pixels[indice];
          int pixelX = i;
          int pixelY = imagen.height - j - 1;
          
          datos[0] = byte(pixelX);
          datos[1] = byte(pixelY);
          datos[2] = byte(red(colorPixel));
          datos[3] = byte(green(colorPixel));
          datos[4] = byte(blue(colorPixel));
          enviar(datos);
        }
      }
      enviarFinDeCuadro();
    }
    else {
      enviarPausa();
    }
  }  
}
