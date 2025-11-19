import processing.serial.*;
import processing.video.*;
import gab.opencv.*;

// CONSTANTES
final String CAMARA_01_NOMBRE = "c922 Pro Stream Webcam";
final String CAMARA_02_NOMBRE = "Integrated Camera";

// Dimensiones de la matriz de leds de la pantalla del "Fragmentador"
final int FRAGMENTADOR_ANCHO = 11;
final int FRAGMENTADOR_ALTO  = 25;

// Dimensiones de cada fotograma capturado por la cámara
final int CAMARA_ANCHO = 640;
final int CAMARA_ALTO  = 480;

// Dimensiones de cada una de las vistas a mostrar en la ventana
final int VISTA_ANCHO  = FRAGMENTADOR_ANCHO * CAMARA_ALTO / FRAGMENTADOR_ALTO;
final int VISTA_ALTO   = CAMARA_ALTO;

// Dimensiones de la ventana de Processing
final int VENTANA_ANCHO = VISTA_ANCHO * 2;
final int VENTANA_ALTO  = CAMARA_ALTO;

// Dimensiones de cada celda de la matriz del fragmentador
final int FRAGMENTO_ANCHO = VISTA_ANCHO / FRAGMENTADOR_ANCHO;
final int FRAGMENTO_ALTO  = VISTA_ALTO  / FRAGMENTADOR_ALTO;


// VARIABLES GLOBALES
boolean serialInicializado = false;
boolean camaraInicializada = false;
byte[] datos = {0, 0, 0, 0, 0};
boolean terminar = false;
OpenCV opencv; 
Serial puertoArduino;
Capture camara;



/**
 * settings
 * Función estándar de Processing, usada en este caso para poder
 * definir las dimensiones de la ventana principal mediante variables.
 */
void settings() {
  size(VENTANA_ANCHO, VENTANA_ALTO);
}


/**
 * setup
 * Función estándar de Processing para ejecutar las tareas
 * iniciales y de configuración.
 */
void setup() {
  colorMode(HSB, 360, 100, 100); 
  background(0);
  serialInicializado = inicializarSerial();
  camaraInicializada = inicializarCamara();
}


/**
 * Función estándar de Processing que se ejecuta en cada una de las
 * iteraciones del ciclo principal
 */
void draw() {
  if (camaraInicializada && camara.available()) {
    camara.read();
    //opencv.loadImage(camara);
    
    PImage imagenOriginal    = camara.get(CAMARA_ANCHO/2 - VISTA_ANCHO/2, 0, VISTA_ANCHO, VISTA_ALTO);
    PImage imagenFragmentada = fragmentarImagen(imagenOriginal, 21, 75, 12);
    
    image(imagenOriginal,  0, 0, VISTA_ANCHO, VISTA_ALTO);
    mostrarImagenFragmentada(imagenFragmentada, VISTA_ANCHO, 0);
    serializarImagenFragmentada(imagenFragmentada);
  }
}


/**
 * fragmentarImagen
 * Crear una imagen como una versión pixelada de la imagen recibida como 
 * argumento. El tamaño de los píxeles dependen del ancho y el alto del
 * "Fragmentador".
 */
PImage fragmentarImagen(PImage imagen) {
  return fragmentarImagen(imagen, 0, 0, 0);
}


/**
 * fragmentarImagen
 * Crear una imagen como una versión pixelada de la imagen recibida como argumento. 
 * El tamaño de los píxeles dependen del ancho y el alto del "Fragmentador".
 * Si los parametros de "ajuste" de color son distintos de cero, se altera además
 * el tinte, la saturación y el brillo de cada pixel.
 */
PImage fragmentarImagen(PImage imagen, int ajusteTinte, int ajusteSaturacion, int ajusteBrillo) {
  int indice = 0;
  PImage imagenFragmentada = createImage(FRAGMENTADOR_ANCHO, FRAGMENTADOR_ALTO, HSB);
  imagenFragmentada.loadPixels();
  
  // Se completan los pixeles de la imagen fragmentada a partir de la imagen recibida como argumento
  boolean ajustarColor = ajusteTinte > 0 || ajusteSaturacion > 0 || ajusteBrillo > 0;
  for (int j = 0; j < FRAGMENTADOR_ALTO; j++) {
    for (int i = FRAGMENTADOR_ANCHO - 1; i >= 0; i--) {
      color colorPixel = imagen.get((i * FRAGMENTO_ANCHO) + (FRAGMENTO_ANCHO/2), (j * FRAGMENTO_ALTO) + (FRAGMENTO_ALTO/2));
      if (ajustarColor) {
        boolean esFondo = saturation(colorPixel) < 18 || brightness(colorPixel) < 8;
        colorPixel = color(esFondo ? (hue(colorPixel) + 172 + ajusteTinte/2) % 360 : (hue(colorPixel) + ajusteTinte) % 360,                          // TINTE
                           esFondo ? ajusteSaturacion : ajusteSaturacion,                                                                            // SATURACIÓN
                           esFondo ? brightness(colorPixel/10) + (ajusteBrillo*1.5) : constrain(brightness(colorPixel) + (ajusteBrillo*2), 0, 100)); // BRILLO
      }
      imagenFragmentada.pixels[indice++] = colorPixel;
    }
  }
  return imagenFragmentada;
}


/**
 * mostrarImagenFragmentada
 * Dibuja la imagen fragmentada en la ventana principal a partir
 * de las coordenadas x e y recibidas como argumento.
 */
void mostrarImagenFragmentada(PImage imagen, int posX, int posY) {
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
 * serializarImagen
 * Envia los valores de cada uno de los píxeles de la imagen fragmentada
 * recibida como argumento a través del puerto serial de comunicación.
 */
void serializarImagenFragmentada(PImage imagen) {
   
  if (!terminar) {
    int indice = 0;
    for (int i = 0; i < FRAGMENTADOR_ANCHO; i++) {
      for (int j = FRAGMENTADOR_ALTO - 1; j >= 0; j--) {
        indice = i + (j * FRAGMENTADOR_ANCHO);
        color colorPixel = imagen.pixels[indice];
        int pixelX = i;
        int pixelY = FRAGMENTADOR_ALTO - j - 1;
        
        // 2. SERIALIZACIÓN
        // Luego, envío el valor del pixel por el puerto serial de comunicación
        datos[0] = byte(pixelX);
        datos[1] = byte(pixelY);
        datos[2] = byte(red(colorPixel));
        datos[3] = byte(green(colorPixel));
        datos[4] = byte(blue(colorPixel));
        if (serialInicializado) {
          puertoArduino.write(datos);
        }
      }
    }
    enviarFinDeCuadro();
  }
  else {
    enviarPausa();
  }
}

void enviarFinDeCuadro() {
    datos[0] = byte(25);
    datos[1] = byte(25);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    puertoArduino.write(datos); 
}

void enviarPausa() {
    datos[0] = byte(99);
    datos[1] = byte(99);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    puertoArduino.write(datos); 
}

/**
 * inicializarSerial
 * Esta función obtiene la lista de puertos seriales habilitados
 * para la comunicación con la placa Arduino que controla la
 * pantalla de leds (el "Fragmentador"),
 */
boolean inicializarSerial() {
  
  String[] puertos = Serial.list();
  if (puertos.length > 0) {
    
    // CREACIÓN DEL PUERTO 
    // Se crea un puerto serial que debe ser el mismo que el puerto
    // donde está conectado el arduino. La velocidad de transferencia
    // también debe coincidir en ambos casos (baud rate => 115200).
    //
    puertoArduino = new Serial(this, Serial.list()[0], 115200); //115200);
    
    // VELOCIDAD DE TRANSFERENCIA
    // Como la matriz de "pixel leds" tiene en total 275 leds y por cada
    // uno de ellos se indican sus valores de rojo, verde y azul, que
    // ocupan 1 byte por cada canal, entonces la velocidad en bits es:
    //
    //             275 * 3 * 8 = 6.600 bits/frame
    //
    // Es decir, enviar un único fotograma consume 6.600 bits de la 
    // tasa de transferencia. Por lo tanto, la velocidas de fps más 
    // rápida permitida serían de 17fps:
    //     17 frames/seg. x 6.600 bits/frame = 112.200 bits/seg.
    // 
    frameRate(12);
    println("PUERTO SERIAL CONECTADO");
    return true;
  }
  else {
    println("No se detectó ningún puerto.");
    return false;
  }
}


/**
 * inicializarCamara
 * Esta función obtiene la lista de cámaras conectadas al equipo,
 * luego inicializa la cámara que corresponde a la granja y la activa.
 */
boolean inicializarCamara() {  
  String[] listadoDeCamaras = Capture.list();
  if (listadoDeCamaras.length > 0) {
      printArray(listadoDeCamaras);
      int indiceCamara = 0;
      for (int i = 0; i < listadoDeCamaras.length; i++) {
        if (listadoDeCamaras[i].startsWith(CAMARA_01_NOMBRE)) {
          indiceCamara = i;
          break;
        }
      }
      camara = new Capture(this, listadoDeCamaras[indiceCamara], 30);
      camara.start();
      
      // Inicializar un objeto de OpenCV para manipular el video
      // https://github.com/atduskgreg/opencv-processing
      opencv = new OpenCV(this, CAMARA_ANCHO, CAMARA_ALTO);
      println("CAMARA ACTIVADA");
      return true;
  }
  else {
    println("No se detectó ninguna cámara.");
    return false;
  }
}


void keyPressed() {
  
    if (key == 'q' || key == 'Q') {
      enviarPausa();
      terminar = true;
    }
    else {
      terminar = false;
    }
}
