// 
// FRAGMENTADOR
// Lógica para llevar a cabo de la fragmentación de la imagen
// capturada en vivo, para desplegar en la pantalla de leds.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

final boolean ACTIVAR_FILTRO_COLOR = true;
final int CAMARA_ALTO = 480;

// Dimensiones de la matriz de leds de la pantalla del "Fragmentador"
final int FRAGMENTADOR_ANCHO = 11;
final int FRAGMENTADOR_ALTO  = 25;

// Dimensiones de cada una de las vistas a mostrar en la ventana
final int VISTA_ANCHO  = FRAGMENTADOR_ANCHO * CAMARA_ALTO / FRAGMENTADOR_ALTO;
final int VISTA_ALTO   = CAMARA_ALTO;

// Dimensiones de cada celda (pixel) de la matriz del fragmentador
final int FRAGMENTO_ANCHO = VISTA_ANCHO / FRAGMENTADOR_ANCHO;
final int FRAGMENTO_ALTO  = VISTA_ALTO  / FRAGMENTADOR_ALTO;

// Constantes con valores predefinidos para la fragmentación
final int FRAG01_TINTE      = 21;
final int FRAG01_SATURACIÓN = 75;
final int FRAG01_BRILLO     = -2;
        
final int FRAG02_TINTE      = 104;
final int FRAG02_SATURACIÓN = 55;
final int FRAG02_BRILLO     = -8;

final int FRAG03_TINTE      = 221;
final int FRAG03_SATURACIÓN = 65;
final int FRAG03_BRILLO     = -24;

final int FRAG04_TINTE      = 9;
final int FRAG04_SATURACIÓN = 70;
final int FRAG04_BRILLO     = -41;

final int FRAG05_TINTE      = 78;
final int FRAG05_SATURACIÓN = 93;
final int FRAG05_BRILLO     = -16;

// Modo de fragmentación por defecto
final char MODO_FRAGMENTACION = '1';


class Fragmentador {
  
  int ajusteTinte, ajusteSaturacion, ajusteBrillo;
  
  public Fragmentador() {    
    ajusteTinte      = 0;
    ajusteSaturacion = 0;
    ajusteBrillo     = 0;
  }


  /**
   * mostrar
   * Dibuja la imagen fragmentada en la ventana principal a partir
   * de las coordenadas x e y recibidas como argumento.
   */
  void mostrar(PImage imagen, int posX, int posY) {
    int indice = 0;
    for (int j = 0; j < FRAGMENTADOR_ALTO; j++) {
      for (int i = 0; i < FRAGMENTADOR_ANCHO; i++) {
        fill(imagen.pixels[indice]);
        rect(posX + (i * FRAGMENTO_ANCHO), posY + (j * FRAGMENTO_ALTO), FRAGMENTO_ANCHO, FRAGMENTO_ALTO);
        indice++;
      }
    }
  }
  
  
  /**
   * procesar
   * Crear una imagen como una versión pixelada de la imagen recibida como argumento. 
   * El tamaño de los píxeles dependen de la anchura y la altura del "Fragmentador".
   * La imagen es, además, espejada horizontalmente para que funcione como "espejo".
   */
  PImage procesar(PImage imagen) {
    int indice = 0;
    PImage imagenFragmentada = createImage(FRAGMENTADOR_ANCHO, FRAGMENTADOR_ALTO, RGB);
    imagenFragmentada.loadPixels();
    
    // Se completan los pixeles de la imagen fragmentada a partir de la imagen recibida como argumento
    push();
    colorMode(HSB, 360, 100, 100);
    boolean ajustarColor = ajusteTinte > 0 || ajusteSaturacion > 0 || ajusteBrillo > 0;
    for (int j = 0; j < FRAGMENTADOR_ALTO; j++) {
      for (int i = FRAGMENTADOR_ANCHO - 1; i >= 0; i--) {
        color colorPixel = imagen.get((i * FRAGMENTO_ANCHO) + (FRAGMENTO_ANCHO/2), (j * FRAGMENTO_ALTO) + (FRAGMENTO_ALTO/2));
        if (ajustarColor && ACTIVAR_FILTRO_COLOR) {
          boolean esFondo = saturation(colorPixel) < 18 || brightness(colorPixel) < 8;
          colorPixel = color(esFondo ? (hue(colorPixel) + 172 + ajusteTinte/2) % 360 : (hue(colorPixel) + ajusteTinte) % 360,                          // TINTE
                             esFondo ? ajusteSaturacion : ajusteSaturacion,                                                                            // SATURACIÓN
                             esFondo ? brightness(colorPixel/10) + (ajusteBrillo*1.5) : constrain(brightness(colorPixel) + (ajusteBrillo*2), 0, 100)); // BRILLO
        }
        imagenFragmentada.pixels[indice++] = colorPixel;
      }
    }
    imagenFragmentada.updatePixels();
    pop();
    return imagenFragmentada;
  }
  
  
  void configurar(char modo) {
    if (modo == '1') {
      ajusteTinte      = FRAG01_TINTE;
      ajusteSaturacion = FRAG01_SATURACIÓN;
      ajusteBrillo     = FRAG01_BRILLO;
    }
    else if (modo == '2') {
      ajusteTinte      = FRAG02_TINTE;
      ajusteSaturacion = FRAG02_SATURACIÓN;
      ajusteBrillo     = FRAG02_BRILLO;
    }
    else if (modo == '3') {
      ajusteTinte      = FRAG03_TINTE;
      ajusteSaturacion = FRAG03_SATURACIÓN;
      ajusteBrillo     = FRAG03_BRILLO;
    }
    else if (modo == '4') {
      ajusteTinte      = FRAG04_TINTE;
      ajusteSaturacion = FRAG04_SATURACIÓN;
      ajusteBrillo     = FRAG04_BRILLO;
    }
    else if (modo == '5') {
      ajusteTinte      = FRAG05_TINTE;
      ajusteSaturacion = FRAG05_SATURACIÓN;
      ajusteBrillo     = FRAG05_BRILLO;
    }
  }
}
