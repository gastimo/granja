// 
// ARRIERO
// Código principal del módulo "Arriero".
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

// Transmisores para recibir información del "Vichador"
// y enviar los datos al "Acorraldor"
Transmisor transmisorDelVichador;
Transmisor transmisorDelAcorralador;

// Variables para el procesamiento y fragmentación del video
Fragmentador fragmentador;
PImage imagenFragmentada;
byte paquete[];


/**
 * settings
 * Función estándar de Processing, usada en este caso para poder
 * definir las dimensiones de la ventana principal mediante variables.
 */
void settings() {
  size(VISTA_ANCHO, CAMARA_ALTO);
}


/**
 * setup
 * Función estándar de Processing para ejecutar las tareas
 * iniciales y de configuración.
 */
void setup() {
  frameRate(60);
  colorMode(RGB, 255); 
  background(0);
  
  // Inicialización de los transmisores
  transmisorDelVichador    = new TransmisorOSC(this);  
  transmisorDelAcorralador = new TransmisorSerial(this); 
  
  // Inicialización de los parámetros para la fragmentación
  fragmentador = new Fragmentador();
  fragmentador.configurar(MODO_FRAGMENTACION);
  imagenFragmentada = createImage(FRAGMENTADOR_ANCHO, FRAGMENTADOR_ALTO, RGB);
  imagenFragmentada.loadPixels();
}


/**
 * Función estándar de Processing que se ejecuta en cada una de las
 * iteraciones del ciclo principal
 */
void draw() {
    fragmentador.mostrar(imagenFragmentada, 0, 0);
    if (frameCount % 3 == 0) {
      transmisorDelAcorralador.enviar(imagenFragmentada);
    }
}


void oscEvent(OscMessage mensajeEntrante) {
  int pixelX, pixelY, indice;
  
  if (mensajeEntrante.checkAddrPattern("/granja/fin")) {
    if (mensajeEntrante.checkTypetag("b")) {
      transmisorDelAcorralador.enviarFinDeCuadro();
    }
  }

  else if (mensajeEntrante.checkAddrPattern("/granja/cuadro")) {
    if (mensajeEntrante.checkTypetag("b")) {
      paquete = mensajeEntrante.get(0).blobValue();
      pixelX = 0;
      pixelY = 0;
      for (int i = 0; i + 2 < paquete.length; i += 3) {
        indice = pixelX + ((FRAGMENTADOR_ALTO - pixelY - 1) * FRAGMENTADOR_ANCHO);
        imagenFragmentada.pixels[indice] = color(int(paquete[i]), 
                                                 int(paquete[i+1]), 
                                                 int(paquete[i+2]));
        if (pixelY == 24) {
          pixelY = 0;
          pixelX++;
        }
        else {
          pixelY++;
        }
      }
      imagenFragmentada.updatePixels();
    }
  }
}
