// 
// VICHADOR
// Código principal del módulo "Vichador" de la obra que se ocupa de 
// la captura y procesamiento del video en vivo a través de una webcam.
// Sus funciones básicas son:
//  1. Identificar y notificar al "Capataz" de la granja las interacciones
//     del visitante con la obra. La comunicación se realiza por OSC.
//  2. Fragmentar cada fotograma de la imagen capturada en vivo para
//     luego poder ser mostrada en la pantalla de leds de la obra.
//  3. Enviar los datos de la imagen fragmentada hacia el módulo "Arriero".
//     El envío de los datos puede ser por OSC o por el puerto serial.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

// 
// Este módulo puede, o bien enviar los píxeles de la imagen fragmentada
// directamente a la pantalla de leds (al "Acorralador"), o bien puede 
// enviárselos al "Arriero" (un equipo intermediario) para que éste, a su
// vez, los encamine hacia la pantalla de leds para su encorralamiento.
//  - FALSE: el "Vichador" envía los pixeles a la pantalla (serial)
//  - TRUE : el "Vichador" envía los píxeles al "Arriero" (OSC)
//
final boolean ENVIAR_PIXELES_AL_ARRIERO = true;


// Definición de mensajes OSC a intercambiar con el "Arriero" 
final String MENSAJE_OSC_FOTOGRAMA = "/granja/fotograma";
final String MENSAJE_OSC_CIERRE    = "/granja/cierre";
final String MENSAJE_OSC_PAUSA     = "/granja/pausa";


// Transmisores para el "Capataz" y para el "Arriero"
Transmisor transmisorDeMensajes;
Transmisor transmisorDePixeles;


// Variables para el procesamiento y fragmentación del video
Camara camara;
Fragmentador fragmentador;
PImage imagenOriginal;
PImage imagenFragmentada;


/**
 * settings
 * Función estándar de Processing, usada en este caso para poder
 * definir las dimensiones de la ventana principal mediante variables.
 */
void settings() {
  // La ventana de processing muestra una previsualización de 
  // las imágenes capturadas por la cámara y su fragmentación
  size(VISTA_ANCHO * 2, CAMARA_ALTO);
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
  transmisorDeMensajes = new TransmisorOSC(this);  
  transmisorDePixeles = !ENVIAR_PIXELES_AL_ARRIERO ? new TransmisorSerial(this) : transmisorDeMensajes; 
  
  // Inicialización de la cámara 
  camara = new Camara(this);
  
  // Inicialización de los parámetros para la fragmentación
  fragmentador = new Fragmentador();
}


/**
 * Función estándar de Processing que se ejecuta en cada una de las
 * iteraciones del ciclo principal
 */
void draw() {
  if (camara.inicializada() && camara.imagenDisponible()) {
    camara.capturar();

    // Capturar la imagen del video en vivo y crear la imagen fragmentada
    imagenOriginal = camara.video().get(CAMARA_ANCHO/2 - VISTA_ANCHO/2, 0, VISTA_ANCHO, VISTA_ALTO);
    if (!transmisorDePixeles.enPausa()) {
      imagenFragmentada = fragmentador.procesar(imagenOriginal);
    }

    // Mostrar en el previsualizador y transmitir la imagen fragmentada hacia el arriero
    image(imagenOriginal, 0, 0, VISTA_ANCHO, VISTA_ALTO);
    fragmentador.mostrar(imagenFragmentada, VISTA_ANCHO, 0);
    
    if (frameCount % (ENVIAR_PIXELES_AL_ARRIERO ? 2 : 3) == 0) {
      transmisorDePixeles.enviar(imagenFragmentada);
    }
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
  
    // Al presionar la letra "Q" se dejan de enviar datos tanto al
    // "Capataz" como al "Arriero". La pantalla del "Fragmentador", se
    // apaga. Presionando cualquier otra tecla se reanuda la ejecución.
    if (key == 'q' || key == 'Q') {
      transmisorDeMensajes.pausar();
      transmisorDePixeles.pausar();
    }
    else {
      transmisorDeMensajes.reanudar();
      transmisorDePixeles.reanudar();
    }
    
    // Las teclas 1, 2, 3, 4 y 5 permiten alternar entre las distintas
    // configuraciones (predefinidas) de tinte, saturación y brillo del
    // "Fragmentador". Pueden ajustarse sus valores para un tuneo más fino.
    if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
      fragmentador.configurar(key);
    }
}
