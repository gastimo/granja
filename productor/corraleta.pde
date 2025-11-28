// 
// CORRALETA
// Este objeto permite almacenar ordenadamentelos píxeles fragmentados 
// por el módulo "Vichador" y recibidos por mensaje OSC.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

// Dimensiones de la matriz de leds de la pantalla del "Fragmentador"
final int FRAGMENTADOR_ANCHO = 11;
final int FRAGMENTADOR_ALTO  = 25;

// Dimensiones de cada celda (pixel) de la matriz del fragmentador
final int FRAGMENTO_ANCHO = PANTALLA_ANCHO / FRAGMENTADOR_ANCHO;
final int FRAGMENTO_ALTO  = PANTALLA_ALTO  / FRAGMENTADOR_ALTO;


class Corraleta {
  PImage imagen;
  
  public Corraleta() {  
    imagen = createImage(FRAGMENTADOR_ANCHO, FRAGMENTADOR_ALTO, RGB);
    imagen.loadPixels();
  }
  
  public PImage imagen() {
    return imagen;
  }
  
  
  /**
   * arrear
   * Acomoda los píxeles que van llegando en la posición de la
   * corraleta que les corresponde.
   */
  public void arrear(int x, int y, int rojo, int verde, int azul) {
    int indice = x + ((FRAGMENTADOR_ALTO - y - 1) * FRAGMENTADOR_ANCHO);
    imagen.pixels[indice] = color(rojo, verde, azul);
  }
  
  /**
   * encerrar
   * Asegura los píxeles en el lugar de la corraleta
   * que le corresponde a cada uno de ellos.
   */
  public void encerrar() {
    imagen.updatePixels();
  }

  
  /**
   * mostrar
   * Dibuja la imagen fragmentada en la ventana principal a partir
   * de las coordenadas x e y recibidas como argumento.
   */
  void mostrar(int posX, int posY) {
    int indice = 0;
    for (int j = 0; j < FRAGMENTADOR_ALTO; j++) {
      for (int i = 0; i < FRAGMENTADOR_ANCHO; i++) {
        fill(imagen.pixels[indice]);
        strokeWeight(1);
        stroke(0);
        rect(posX + (i * FRAGMENTO_ANCHO), posY + (j * FRAGMENTO_ALTO), FRAGMENTO_ANCHO, FRAGMENTO_ALTO);
        indice++;
      }
    }
  }
  
}
