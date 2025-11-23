// 
// FRAGMENTADOR
// Lógica para llevar a cabo de la fragmentación de la imagen
// capturada en vivo, para desplegar en la pantalla de leds.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

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
final int FRAG00_TINTE      = 0;
final int FRAG00_SATURACION = 0;
final int FRAG00_BRILLO     = 0;

final int FRAG01_TINTE      = 21;
final int FRAG01_SATURACION = 75;
final int FRAG01_BRILLO     = -2;
        
final int FRAG02_TINTE      = 104;
final int FRAG02_SATURACION = 55;
final int FRAG02_BRILLO     = -8;

final int FRAG03_TINTE      = 221;
final int FRAG03_SATURACION = 65;
final int FRAG03_BRILLO     = -24;

final int FRAG04_TINTE      = 9;
final int FRAG04_SATURACION = 70;
final int FRAG04_BRILLO     = -41;

final int FRAG05_TINTE      = 78;
final int FRAG05_SATURACION = 93;
final int FRAG05_BRILLO     = -16;

final int FRAG06_TINTE      = 13;
final int FRAG06_SATURACION = 52;
final int FRAG06_BRILLO     = -11;


class Fragmentador {
  
  int ajusteTinte, ajusteSaturacion, ajusteBrillo;
  
  public Fragmentador() {  
    ajusteTinte      = FRAG00_TINTE;
    ajusteSaturacion = FRAG00_SATURACION;
    ajusteBrillo     = FRAG00_BRILLO;
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
    for (int j = 0; j < FRAGMENTADOR_ALTO; j++) {
      for (int i = FRAGMENTADOR_ANCHO - 1; i >= 0; i--) {
        color colorPixel = imagen.get((i * FRAGMENTO_ANCHO) + (FRAGMENTO_ANCHO/2), (j * FRAGMENTO_ALTO) + (FRAGMENTO_ALTO/2));
        boolean esFondo = saturation(colorPixel) < 18 || brightness(colorPixel) < 8;
        float colorTinte      = ajusteTinte == 0      ? hue(colorPixel) : esFondo ? (hue(colorPixel) + 172 + ajusteTinte/2) % 360 : (hue(colorPixel) + ajusteTinte) % 360;
        float colorSaturacion = ajusteSaturacion == 0 ? constrain(saturation(colorPixel) * 2.2, 0, 100) : 
                                                        esFondo ? constrain(ajusteSaturacion - 10, 0, 100) : constrain(ajusteSaturacion, 0, 100);
        float colorBrillo     = ajusteBrillo == 0     ? constrain(brightness(colorPixel) * 0.61, 0, 100) : 
                                                        esFondo ? constrain(brightness(colorPixel/10) + (ajusteBrillo*1.5), 0, 100) : constrain(brightness(colorPixel) + (ajusteBrillo*2), 0, 100);
        colorPixel = color(int(colorTinte), int(colorSaturacion), int(colorBrillo));   
        imagenFragmentada.pixels[indice++] = colorPixel;
      }
    }
    imagenFragmentada.updatePixels();
    pop();
    return imagenFragmentada;
  }
  
  
  void configurar(char modo) {
    if (modo == '0') {
      ajusteTinte      = FRAG00_TINTE;
      ajusteSaturacion = FRAG00_SATURACION;
      ajusteBrillo     = FRAG00_BRILLO;
    }    
    else if (modo == '1') {
      ajusteTinte      = FRAG01_TINTE;
      ajusteSaturacion = FRAG01_SATURACION;
      ajusteBrillo     = FRAG01_BRILLO;
    }
    else if (modo == '2') {
      ajusteTinte      = FRAG02_TINTE;
      ajusteSaturacion = FRAG02_SATURACION;
      ajusteBrillo     = FRAG02_BRILLO;
    }
    else if (modo == '3') {
      ajusteTinte      = FRAG03_TINTE;
      ajusteSaturacion = FRAG03_SATURACION;
      ajusteBrillo     = FRAG03_BRILLO;
    }
    else if (modo == '4') {
      ajusteTinte      = FRAG04_TINTE;
      ajusteSaturacion = FRAG04_SATURACION;
      ajusteBrillo     = FRAG04_BRILLO;
    }
    else if (modo == '5') {
      ajusteTinte      = FRAG05_TINTE;
      ajusteSaturacion = FRAG05_SATURACION;
      ajusteBrillo     = FRAG05_BRILLO;
    }
    else if (modo == '6') {
      ajusteTinte      = FRAG06_TINTE;
      ajusteSaturacion = FRAG06_SATURACION;
      ajusteBrillo     = FRAG06_BRILLO;
    }
  }
}
