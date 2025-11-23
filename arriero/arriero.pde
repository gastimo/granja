// 
// ARRIERO
// Código principal del módulo "Arriero", quien recibe por el protocolo
// OSC los píxeles que forman parte de la imagen fragmentada. En la medida 
// que van llegando, los píxeles son interpretados, ordenados y guardados 
// en una estructura llamada "Corraleta", para luego ser transmitidos por
// el puerto serial de comunicación al "Acorralador", quien finalmente los
// acomoda (y los enciende) en la celda de la pantalla correspondiente. 
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

// Esta constante define la altura en píxeles de la 
// imagen de video capturada por el "Vichador"
final int CAMARA_ALTO = 480;


// Definición de mensajes OSC a intercambiar con el "Vichador" 
final String MENSAJE_OSC_FOTOGRAMA = "/granja/fotograma";
final String MENSAJE_OSC_CIERRE    = "/granja/cierre";
final String MENSAJE_OSC_PAUSA     = "/granja/pausa";


// Definición de transmisores/receptores para:
//  1. Recibir los datos dela imagen fragmentada desde el "Vichador"
//  2. Enviar los píxeles ordenados al "Acorralador" para colocarlos en la matriz
ReceptorOSC receptorDelVichador;
TransmisorSerial transmisorDelAcorralador;


// Variables para el arreo de píxeles
Corraleta corraleta;
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
  receptorDelVichador = new ReceptorOSC(this);  
  transmisorDelAcorralador = new TransmisorSerial(this); 
  
  // Inicialización de los parámetros para la fragmentación
  corraleta = new Corraleta();
}


/**
 * Función estándar de Processing que se ejecuta en cada una de 
 * las iteraciones del ciclo principal y dibuja el contenido de 
 * la ventana principal.
 */
void draw() {
    if (frameCount % 2 == 0) {
      corraleta.mostrar(0, 0);
    }
    // La información de los píxeles es enviada al "Acorralador" a
    // una tasa de 10 fps porque el puerto serial no es capaz de
    // procesar todos los bytes de cada fotograma más rápidamente
    if (frameCount % 6 == 0) {
      transmisorDelAcorralador.enviar(corraleta.imagen());
    }
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

  // MENSAJE DE "FIN DE CUADRO" (indica que el fotograma fue enviado)
  else if (mensajeEntrante.checkAddrPattern(MENSAJE_OSC_CIERRE)) {
    if (mensajeEntrante.checkTypetag("b")) {
      transmisorDelAcorralador.enviarFinDeCuadro();
    }
  }
}
