// 
// PRODUCTOR
// Código del módulo del "Productor", encargado de la generación de la
// gráfica a ser proyectada en las pantallas. 
// Si bien este componente está produciendo la gráfica generativa de
// manera continua, escucha en simultáneo los mensajes del "Capataz"
// para realizar enturbiamientos en la pantalla que deba ser activada.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


// CONFIGURACIÓN DE LAS DIMENSIONES DE LA SALIDA DEL VIDEO
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// La gráfica para las 5 pantallas se genera en formato Full HD
final int VIDEO_ANCHO = 1280;
final int VIDEO_ALTO  = 720;


// CONFIGURACIÓN DE PARÁMETROS PARA EL ENVÍO DE MENSAJES OSC
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Este módulo recibe mensajes del "Capataz" y reenvía al "Vichador"
// CONFIGURACIÓN LOCAL
final String IP_DEL_CAPATAZ    = "192.168.0.5";
final String IP_DEL_VICHADOR   = "192.168.0.5";
final String IP_DEL_PRODUCTOR  = "192.168.0.5";
final int PUERTO_LOCAL         = 12012;
final int PUERTO_DEL_CAPATAZ   = 9000;
final int PUERTO_DEL_VICHADOR  = 12000;


// CONFIGURACIÓN DE LA CANTIDAD DE PANTALLAS A PROYECTAR
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// El contenido de cada una de las 5 pantallas es renderizado en la misma ventana
final int CANTIDAD_PANTALLAS = 5;


// DEFINICIÓN DE LAS PROPORCIONES (ASPECT RATIO) DE LAS PANTALLAS
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// La proporción de cada pantalla debe coincidir con las pantallas físicas de acrílico
final int PROPORCION_ANCHO = 11;
final int PROPORCION_ALTO  = 25;

// Dimensiones de las proyecciones de cada pantalla
final int PANTALLA_BORDE = 4;
final int PANTALLA_ANCHO = (VIDEO_ANCHO - (PANTALLA_BORDE * (CANTIDAD_PANTALLAS + 1))) / CANTIDAD_PANTALLAS;
final int PANTALLA_ALTO  = PANTALLA_ANCHO * PROPORCION_ALTO / PROPORCION_ANCHO;


// CONFIGURACIÓN DE LOS MENSAJES OSC
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Definición de los nombres de los eventos OSC (sus direcciones) que son 
// recibidos desde el módulo "Vichador" y desde el "Capataz".
//
final String MENSAJE_OSC_ACTIVACION    = "/granja/activar";
final String MENSAJE_OSC_DESACTIVACION = "/granja/desactivar";
final String MENSAJE_OSC_FOTOGRAMA     = "/granja/fotograma";
final String MENSAJE_OSC_CIERRE        = "/granja/cierre";
final String MENSAJE_OSC_PAUSA         = "/granja/pausa";

// Definición de las pantallas
Pantalla pantalla01, pantalla02, pantalla03, pantalla04, pantalla05, pantalla06;

// Definición del de mensajes OSC
TransmisorOSC receptor;
TransmisorOSC emisor;


// Definición de la difusora para transmitir el video
Difusora difusora;

// Variables para el arreo de píxeles
Corraleta corraleta;
byte paquete[];


void preload() {

}


/**
 * settings
 * Función estándar de Processing, usada en este caso para poder
 * definir las dimensiones de la ventana principal mediante variables.
 */
void settings() {
  size(VIDEO_ANCHO, VIDEO_ALTO, P3D);
}


/**
 * setup
 * Función estándar de Processing para ejecutar las tareas
 * iniciales y de configuración.
 */
void setup() {
  frameRate(30);
  textureMode(NORMAL);
  colorMode(RGB, 255);
  background(0);

  // Inicialización de los parámetros para la fragmentación
  corraleta = new Corraleta();
  
  // Inicialización del receptor y el emisor
  receptor = new TransmisorOSC(this, PUERTO_LOCAL, null, 0); 
  emisor   = new TransmisorOSC(this, PUERTO_LOCAL, IP_DEL_VICHADOR, PUERTO_DEL_VICHADOR); 
  
  
  // Creación de las pantallas
  pantalla01 = new Pantalla     (this, 1, PANTALLA_ANCHO, PANTALLA_ALTO);
  pantalla02 = new Pantalla     (this, 2, PANTALLA_ANCHO, PANTALLA_ALTO);
  pantalla03 = new PantallaFRAG (this, 3, PANTALLA_ANCHO, PANTALLA_ALTO, corraleta);
  pantalla04 = new Pantalla     (this, 4, PANTALLA_ANCHO, PANTALLA_ALTO);
  pantalla05 = new Pantalla     (this, 5, PANTALLA_ANCHO, PANTALLA_ALTO);
  pantalla06 = new PantallaLED  (this, 6, PANTALLA_ANCHO, PANTALLA_ALTO, emisor);
  
  // Creación de la "Difusora" encargada de la transmisión del
  // video generado por el "Productor" a través de Spout.
  difusora = new Difusora(this);
}


/**
 * Función estándar de Processing que se ejecuta en cada una de 
 * las iteraciones del ciclo principal y dibuja el contenido de 
 * la ventana principal.
 */
void draw() {
  
  // Procesar el contenido de cada pantalla
  pantalla01.procesar();
  pantalla02.procesar();
  pantalla03.procesar();
  pantalla04.procesar();
  pantalla05.procesar();
  pantalla06.procesar();

  
  // Dibujar los contenidos de cada pantalla
  int bordeSuperior = (VIDEO_ALTO - PANTALLA_ALTO) / 2;
  pantalla01.mostrar(PANTALLA_BORDE, bordeSuperior);
  pantalla02.mostrar(PANTALLA_BORDE * 2 + PANTALLA_ANCHO, bordeSuperior);
  pantalla03.mostrar(PANTALLA_BORDE * 3 + PANTALLA_ANCHO * 2, bordeSuperior);
  pantalla04.mostrar(PANTALLA_BORDE * 4 + PANTALLA_ANCHO * 3, bordeSuperior);
  pantalla05.mostrar(PANTALLA_BORDE * 5 + PANTALLA_ANCHO * 4, bordeSuperior);
  
  difusora.transmitir();
}


/**
 * oscEvent
 * Función principal de la librería oscP5 que es invocada de
 * forma automática cada vez que un evento OSC es recibido.
 */
void oscEvent(OscMessage mensajeEntrante) {
  int pixelX, pixelY;

  // MENSAJE CON LOS DATOS DEL FOTOGRAMA
  // El mensaje contiene una estructura de datos de tipo BLOB de
  // 825 bytes de longitud. Se utilizan 3 bytes por pixel (uno por
  // cada canal RGB) y se disponen como una secuencia ordenada.
  if (mensajeEntrante.checkAddrPattern(MENSAJE_OSC_FOTOGRAMA)) {
    if (mensajeEntrante.checkTypetag("b")) {
      pixelX = 0;
      pixelY = 0;
      paquete = mensajeEntrante.get(0).blobValue();
      for (int i = 0; i + 2 < paquete.length; i += 3) {
        corraleta.arrear(pixelX, pixelY, int(paquete[i]), int(paquete[i+1]), int(paquete[i+2]));
        if (pixelY == 24) {
          pixelY = 0;
          pixelX++;
        }
        else
          pixelY++;
      }
      corraleta.encerrar();
    }
  }
  
  // MENSAJE DEL CAPATAZ PARA LA ACTIVACIÓN DE PANTALLAS
  // El mensaje contiene la información de la pantalla que debe ser
  // activada, es decir, disparar la operación de enturbiamiento.
  else if (mensajeEntrante.checkAddrPattern(MENSAJE_OSC_ACTIVACION)) {
    if (mensajeEntrante.checkTypetag("if")) {
      int pantalla = mensajeEntrante.get(0).intValue();
      if (pantalla == 1)
        pantalla01.activar(0);
      else if (pantalla == 2)
        pantalla02.activar(0);
      else if (pantalla == 3)
        pantalla03.activar(0);
      else if (pantalla == 4)
        pantalla04.activar(0);
      else if (pantalla == 5)
        pantalla05.activar(0);
      else if (pantalla == 6)
        pantalla06.activar(0);
    }
  } 
}
