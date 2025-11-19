// 
// VICHADOR
// Es la pieza principal del módulo VIGÍA de la obra y se ocupa de 
// la captura y procesamiento del video en vivo a través de una webcam.
//
// Cumple dos funciones principales:
//  1. Detectar mediante la cámara los eventos de interacción del
//     visitante y notificarlos por OSC al módulo OPERADOR.
//  2. Realizar la fragmentación de la imagen capturada para, luego,
//     ser enviada por un puerto de comunicación serial a la placa
//     Arduino responsable de controlar los leds del "Fragmentador".
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

import processing.serial.*;
import processing.video.*;


// Variables para inicialización
boolean serialInicializado = false;
boolean camaraInicializada = false;

// Variables para la comunicación por el puerto serial
Serial puertoArduino;
byte[] datos = {0, 0, 0, 0, 0};
boolean pausar = false;

// Imágenes para almacenar el video capturado y su fragmentación
Capture camara;
PImage imagenOriginal, imagenFragmentada;

// Parámetros de configuración para la fragmentación
int fragConfigTinte, fragConfigSaturacion, fragConfigBrillo;


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
  
  // Ajustes para la fragmentación de la imagen
  fragConfigTinte      = FRAG01_TINTE;
  fragConfigSaturacion = FRAG01_SATURACIÓN;
  fragConfigBrillo     = FRAG01_BRILLO;
}


/**
 * Función estándar de Processing que se ejecuta en cada una de las
 * iteraciones del ciclo principal
 */
void draw() {
  if (camaraInicializada && camara.available()) {
    camara.read();

    // Capturar la imagen del video y crear la imagen para la fragmentación
    imagenOriginal    = camara.get(CAMARA_ANCHO/2 - VISTA_ANCHO/2, 0, VISTA_ANCHO, VISTA_ALTO);
    imagenFragmentada = fragmentarImagen(imagenOriginal, fragConfigTinte, fragConfigSaturacion, fragConfigBrillo);

    // Mostrar en el previsualizador y enviar la imagen fragmentada por el puerto serial
    image(imagenOriginal, 0, 0, VISTA_ANCHO, VISTA_ALTO);
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
 * La imagen es, además, espejada horizontalmente para que funcione como "espejo".
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
 * Por cada pixel de la imagen fragmentada se envía un paquete de 5 bytes:
 *   - BYTE #0: Coordenada X (entre 0 y 10)
 *   - BYTE #1: Coordenada Y traspuesta (entre 0 y 24)
 *   - BYTE #2: Valor numérico para el canal rojo del color del pixel
 *   - BYTE #3: Valor numérico para el canal verde del color del pixel
 *   - BYTE #4: Valor numérico para el canal azul del color del pixel
 */
void serializarImagenFragmentada(PImage imagen) {
   
  if (!pausar) {
    int indice = 0;
    for (int i = 0; i < FRAGMENTADOR_ANCHO; i++) {
      for (int j = FRAGMENTADOR_ALTO - 1; j >= 0; j--) {
        indice = i + (j * FRAGMENTADOR_ANCHO);
        color colorPixel = imagen.pixels[indice];
        int pixelX = i;
        int pixelY = FRAGMENTADOR_ALTO - j - 1;
        
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


/**
 * enviarFinDeCuadro
 * Envía un paquete de 5 bytes para indicar que ya fueron
 * transmitidos todos los pixels de la imagen.
 */
void enviarFinDeCuadro() {
    datos[0] = byte(CODIGO_FIN_DE_CUADRO);
    datos[1] = byte(CODIGO_FIN_DE_CUADRO);
    datos[2] = byte(0);
    datos[3] = byte(0);
    datos[4] = byte(0);
    puertoArduino.write(datos); 
}


/**
 * enviarPausa
 * Envía un paquete de 5 bytes para indicar que la transferencia
 * por el puerto serial ha sido pausada.
 */
void enviarPausa() {
    datos[0] = byte(CODIGO_PAUSA);
    datos[1] = byte(CODIGO_PAUSA);
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
    // también debe coincidir en ambos casos.
    //
    puertoArduino = new Serial(this, Serial.list()[0], TASA_TRANSFERENCIA);
    
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
    frameRate(10);
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
      int indiceCamara = 0;
      for (int i = 0; i < listadoDeCamaras.length; i++) {
        if (listadoDeCamaras[i].startsWith(CAMARA_01_NOMBRE)) {
          indiceCamara = i;
          break;
        }
      }
      camara = new Capture(this, listadoDeCamaras[indiceCamara], 30);
      camara.start();
      println("CAMARA ACTIVADA");
      return true;
  }
  else {
    println("No se detectó ninguna cámara.");
    return false;
  }
}


/**
 * keyPressed
 * Función estándar de Processing para detectar las teclas presionadas.
 * En este caso se utiliza para pausar la ejecución del fragmentador y
 * también para alternar y "tunear" las configuraciones posibles de
 * tinte, saturación y brillo del "Fragmentador".
 */
void keyPressed() {
  
    // Al presionar la letra "Q" la pantalla del "Fragmentador" se
    // apaga y no se envían paquetes de datos por el puerto serial.
    // Presionando cualquier otra tecla se reanuda la ejecución.
    if (key == 'q' || key == 'Q') {
      enviarPausa();
      pausar = true;
    }
    else {
      pausar = false;
    }
    
    
    // Las teclas 1, 2, 3, 4 y 5 permiten alternar entre las distintas
    // configuraciones (predefinidas) de tinte, saturación y brillo del
    // "Fragmentador". Pueden ajustarse sus valores para un tuneo más fino.
    if (key == '1') {
      fragConfigTinte      = FRAG01_TINTE;
      fragConfigSaturacion = FRAG01_SATURACIÓN;
      fragConfigBrillo     = FRAG01_BRILLO;
    }
    else if (key == '2') {
      fragConfigTinte      = FRAG02_TINTE;
      fragConfigSaturacion = FRAG02_SATURACIÓN;
      fragConfigBrillo     = FRAG02_BRILLO;
    }
    else if (key == '3') {
      fragConfigTinte      = FRAG03_TINTE;
      fragConfigSaturacion = FRAG03_SATURACIÓN;
      fragConfigBrillo     = FRAG03_BRILLO;
    }
    else if (key == '4') {
      fragConfigTinte      = FRAG04_TINTE;
      fragConfigSaturacion = FRAG04_SATURACIÓN;
      fragConfigBrillo     = FRAG04_BRILLO;
    }
    else if (key == '5') {
      fragConfigTinte      = FRAG05_TINTE;
      fragConfigSaturacion = FRAG05_SATURACIÓN;
      fragConfigBrillo     = FRAG05_BRILLO;
    }
}
