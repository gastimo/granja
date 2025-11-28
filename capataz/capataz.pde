// 
// CAPATAZ
// Módulo simulador del "Capataz" que envía mensajes de activación
// para cada una de las pantallas de la granja.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


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
final int PUERTO_LOCAL         = 9000;
final int PUERTO_DEL_VICHADOr  = 12000;
final int PUERTO_DEL_ARRIERO   = 12011;
final int PUERTO_DEL_PRODUCTOR = 12012;


// CONFIGURACIÓN DE LOS MENSAJES OSC
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// Definición de los nombres de los eventos OSC (sus direcciones) 
//
final String MENSAJE_OSC_ACTIVACION    = "/granja/activar";
final String MENSAJE_OSC_DESACTIVACION = "/granja/desactivar";
final String MENSAJE_OSC_FOTOGRAMA     = "/granja/fotograma";
final String MENSAJE_OSC_CIERRE        = "/granja/cierre";
final String MENSAJE_OSC_PAUSA         = "/granja/pausa";


// Transmisor de mensajes
TransmisorOSC notificador;
int pantallaActivada = 1;


/**
 * setup
 * Función estándar de Processing para ejecutar las tareas
 * iniciales y de configuración.
 */
void setup() {
  frameRate(30);
  background(0);
  notificador = new TransmisorOSC(this, PUERTO_LOCAL, IP_DEL_PRODUCTOR, PUERTO_DEL_PRODUCTOR);  
}


/**
 * Función estándar de Processing que se ejecuta en cada una de las
 * iteraciones del ciclo principal
 */
void draw() {
    if (frameCount % 45 == 0) {
      notificador.enviar(1, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = pantallaActivada == 6 ? 1 : pantallaActivada+1;
    }
}


void keyPressed() {
  
    if (key == '0') {
      notificador.enviar(1, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = 1;
    }
    else if (key == '2') {
      notificador.enviar(2, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = 2;
    }
    else if (key == '3') {
      notificador.enviar(3, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = 3;
    }
    else if (key == '4') {
      notificador.enviar(4, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = 4;
    }
    if (key == '5') {
      notificador.enviar(5, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = 5;
    }
    else if (key == '6') {
      notificador.enviar(6, 0, MENSAJE_OSC_ACTIVACION);
      pantallaActivada = 6;
    }
}
