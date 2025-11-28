// 
// VICHADOR
// Código principal del módulo "Vichador" de la obra que se ocupa de 
// la captura y procesamiento del video en vivo a través de una webcam.
// Sus funciones básicas son:
//  1. Identificar y notificar al "Capataz" de la granja las interacciones
//     del visitante con la obra. La comunicación se realiza por OSC a partir
//     del análisis del flujo óptico de la imagen capturada.
//  2. Fragmentar cada fotograma de la imagen capturada en vivo para
//     luego poder ser mostrada en la pantalla de leds de la obra.
//  3. Enviar los datos de la imagen fragmentada hacia la pantalla de leds.
//     Esto puede realizarse directamente por el puerto serial o también
//     se puede llevar a cabo a través del "Arriero" (por mensajes OSC).
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


// PARÁMETRO PARA MONITOREO DE LAS IMÁGENES DE VIDEO
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Este parámetro indica si la ventana principal de Processing debe mostrar
// las imágenes capturadas por la cámara junto con su fragmentación y el 
// cálculo del flujo óptico. Esta ventana se utiliza simplemente para el 
// monitoreo del funcionamiento de la cámara y las rutinas de análisis.
// Cuando la obra esté en funcionamiento, el parámetro debería estar en false.
//
boolean MONITOREO_ACTIVADO = true;


// PARÁMETRO PARA LA PANTALLA DE "FRAGMENTACIÓN"
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Este módulo puede, o bien enviar los píxeles de la imagen fragmentada
// directamente a la pantalla de leds (al "Acorralador"), o bien puede 
// enviárselos al "Arriero" (un equipo intermediario) para que éste, a su
// vez, los encamine hacia la pantalla de leds para su encorralamiento.
//  - FALSE: el "Vichador" envía los pixeles a la pantalla (serial)
//  - TRUE : el "Vichador" envía los píxeles al "Arriero" (OSC)
// 
boolean ENVIAR_PIXELES_AL_ARRIERO = true;


// CONFIGURACIÓN DE PARÁMETROS PARA EL ENVÍO DE MENSAJES OSC
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Configuración de las direcciones IPs y de los puertos para transmitir
// mensajes vía protocolo OSC
//
// CONFIGURACIÓN LOCAL
final String IP_DEL_CAPATAZ    = "192.168.0.5";
final String IP_DEL_VICHADOR   = "192.168.0.5";
final String IP_DEL_ARRIERO    = "192.168.0.9";
final String IP_DEL_PRODUCTOR  = "192.168.0.5";
final int PUERTO_LOCAL         = 12000;
final int PUERTO_DEL_CAPATAZ   = 9000;
final int PUERTO_DEL_ARRIERO   = 12011;
final int PUERTO_DEL_PRODUCTOR = 12012;
/*
// CONFIGURACIÓN PARA "CASA BELGRADO"
final String IP_DEL_CAPATAZ    = "192.168.1.43";
final String IP_DEL_VICHADOR   = "192.168.1.49";
final String IP_DEL_ARRIERO    = "192.168.1.49";
final String IP_DEL_PRODUCTOR  = "192.168.1.49";
final int PUERTO_LOCAL         = 12000;
final int PUERTO_DEL_CAPATAZ   = 9000;
final int PUERTO_DEL_ARRIERO   = 12011;
final int PUERTO_DEL_PRODUCTOR = 12012;
*/

// PARÁMETROS PARA EL CÁLCULO DEL FLUJO OPTICO
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Se definen los valores para calcular el "flujo óptico" en la imagen
// de video capturada.
final float FLUJO_OPTICO_TECHO    = 30;
final int   FLUJO_OPTICO_COLUMNAS = 5;
final int   FLUJO_OPTICO_FILAS    = 1;


// PARÁMETRO PARA LA PANTALLA DE "FRAGMENTACIÓN"
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Definición de los nombres de los eventos OSC (sus direcciones) para ser 
// enviados al "Capataz" de la granja y al "Arriero" (si aplica).
//
final String MENSAJE_OSC_FLUJO_OPTICO = "/granja/flujo";
final String MENSAJE_OSC_FOTOGRAMA    = "/granja/fotograma";
final String MENSAJE_OSC_CIERRE       = "/granja/cierre";
final String MENSAJE_OSC_PAUSA        = "/granja/pausa";
final String MENSAJE_OSC_ACTIVACION    = "/granja/activar";
final String MENSAJE_OSC_DESACTIVACION = "/granja/desactivar";


// VARIABLES GLOBALES PARA EL PROCESAMIENTO
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Definición de las variables para el procesamiento  de las imágenes y 
// de los transmisores para el envío de los mensajes (OSC y/o serial).
//
Camara camara;
Fragmentador fragmentador;
Interactor interactor;
boolean inicializado = false;
PImage imagenOriginal;
PImage imagenRecortada;
PImage imagenFragmentada;
float[][] flujoOptico;
Transmisor transmisorDePixeles;
TransmisorOSC transmisorDeFragmentos;
TransmisorOSC transmisorDeEventos;


/**
 * settings
 * Función estándar de Processing, usada en este caso para poder
 * definir las dimensiones de la ventana principal mediante variables.
 */
void settings() {
  // La ventana de processing muestra una previsualización de 
  // las imágenes capturadas por la cámara y su fragmentación
  size(MONITOREO_ACTIVADO ? VISTA_ANCHO * 2 + CAMARA_ANCHO : 20, MONITOREO_ACTIVADO ? CAMARA_ALTO : 20);
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
  
  // Inicialización de los objetos para captura y análisis del video
  camara = new Camara(this);
  interactor = new Interactor(this, CAMARA_ANCHO, CAMARA_ALTO, FLUJO_OPTICO_COLUMNAS, FLUJO_OPTICO_FILAS);
  
  // Inicialización del "Fragmentador" (para la pantalla de leds)
  fragmentador = new Fragmentador();

  // Inicialización de los transmisores (OSC y serial)
  transmisorDeEventos = new TransmisorOSC(this, PUERTO_LOCAL, IP_DEL_CAPATAZ, PUERTO_DEL_CAPATAZ); 
  transmisorDeFragmentos = new TransmisorOSC(this, PUERTO_LOCAL, IP_DEL_PRODUCTOR, PUERTO_DEL_PRODUCTOR);  
  transmisorDePixeles = ENVIAR_PIXELES_AL_ARRIERO ? transmisorDeFragmentos.replicar(IP_DEL_ARRIERO, PUERTO_DEL_ARRIERO) : new TransmisorSerial(this);
}


/**
 * Función estándar de Processing que se ejecuta en cada una de las
 * iteraciones del ciclo principal
 */
void draw() {
  if (camara.inicializada() && camara.imagenDisponible()) {
    
    // 1. PROCESAMIENTO DE LA IMAGEN DE VIDEO CAPTURADA
    // En primer lugar, se captura el fotograma actual del video de la cámara,
    // se procesa el "flujo óptico" para determinar la interacción del visitante
    // y finalmente se fragmenta la imagen a transmitir a la pantalla de leds.
    // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    camara.capturar();
    imagenOriginal  = camara.video().get(0, 0, CAMARA_ANCHO, CAMARA_ALTO);
    imagenRecortada = imagenOriginal.get(CAMARA_ANCHO/2 - VISTA_ANCHO/2, 0, VISTA_ANCHO, VISTA_ALTO);
    if (frameCount % 2 == 0 || !inicializado) {
      flujoOptico = interactor.flujoOptico(imagenOriginal, FLUJO_OPTICO_TECHO);
      imagenFragmentada = fragmentador.procesar(imagenRecortada);
      inicializado = true;
    }


    // 2. TRANSMISIONES (DE LA IMAGEN FRAGMENTADA Y DE LOS EVENTOS AL CAPATAZ)
    // Una vez capturada la imagen, interpretada y fragmentada, se envía la información
    // tanto al "Capataz" para que se ocupe de activar las pantallas, como a la pantalla
    // de leds. Esto último puede realizarse con o sin la intervención del "Arriero".
    if (inicializado) {
      
      // ENVIAR MENSAJES (SERIAL) AL "ACORRALADOR"
      if (!ENVIAR_PIXELES_AL_ARRIERO && frameCount % 6 == 0) {
        transmisorDePixeles.enviar(imagenFragmentada);
      }
      
      // ENVÍO DE MENSAJES AL "PRODUCTOR" Y AL "ARRIERO"
      if (frameCount % 1 == 0) {
        transmisorDeFragmentos.enviar(imagenFragmentada);
      }
      
      // ENVÍO DE MENSAJES AL "CAPATAZ"
      if (frameCount % 2 == 0) {
        transmisorDeEventos.enviar(flujoOptico, MENSAJE_OSC_FLUJO_OPTICO);
      }
    }
    
    
    // 3. PREVISUALIZACIÓN DE MONITOREO
    // Este paso es simplemente de control. Se dibuja en la ventana principal de
    // Processing la imagen original capturada, la imagen fragmentada y el flujo
    // óptico analizado. Cuando la obra esté en funcionamiento, no es necesario 
    // mostrar nada en este punto. La generación de la gráfica es responsabilidad
    // del "Productor" de la granja que trabaja a pedido del "Capataz".
    // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    if (MONITOREO_ACTIVADO) {
      image(imagenRecortada, 0, 0, VISTA_ANCHO, VISTA_ALTO);
      fragmentador.mostrar(imagenFragmentada, VISTA_ANCHO, 0);
      interactor.mostrar(VISTA_ANCHO * 2, 0, FLUJO_OPTICO_TECHO);
    }
  }
}


/**
 * oscEvent
 * Función principal de la librería oscP5 que es invocada de
 * forma automática cada vez que un evento OSC es recibido.
 */
void oscEvent(OscMessage mensajeEntrante) {

  // MENSAJE DE ACTIVACIÓN DEL PRODUCTOR
  // El "Productor" le reenvía el mensaje de activación
  // de la pantalla de leds para que el "Vichador" pueda
  // modificar el modo de fragmentación.
  if (mensajeEntrante.checkAddrPattern(MENSAJE_OSC_ACTIVACION)) {
    if (mensajeEntrante.checkTypetag("if")) {
      int pantalla = mensajeEntrante.get(0).intValue();
      if (pantalla == 6) {
        int modo = int(random(0, 6)) + 1;
        fragmentador.configurar(modo == 1 ? '1' : modo == 2 ? '2' : modo == 3 ? '3' : modo == 4 ? '4' : modo == 5 ? '5' : '6');
        println("Cambiando MODO=" + modo);
      }
    }
  }
  if (mensajeEntrante.checkAddrPattern(MENSAJE_OSC_DESACTIVACION)) {
    if (mensajeEntrante.checkTypetag("if")) {
      int pantalla = mensajeEntrante.get(0).intValue();
      if (pantalla == 6) {
        fragmentador.configurar('0');
      }
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
    
    // Las teclas 1, 2, 3, 4 y 5 permiten alternar entre las distintas
    // configuraciones (predefinidas) de tinte, saturación y brillo del
    // "Fragmentador". Pueden ajustarse sus valores para un tuneo más fino.
    if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
      fragmentador.configurar(key);
    }
}
