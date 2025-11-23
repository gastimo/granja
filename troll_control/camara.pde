// 
// CÁMARA
// Funciones y variables para la configuración de la cámara
// y la captura de video en tiempo real.
// Se utiliza la librería de video de Processing:
//
//   https://processing.org/reference/libraries/serial/index.html
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
import processing.video.*;

// Nombres con los que son reconocidas las cámaras utilizadas
String CAMARA_01_NOMBRE = "c922 Pro Stream Webcam";
String CAMARA_02_NOMBRE = "Integrated Camera";

// Dimensiones de cada fotograma capturado por la cámara principal
int CAMARA_ANCHO = 640;
int CAMARA_ALTO  = 480;

class Camara {
  Capture camara;
  boolean inicializada = false;
  
  /**
   * Este constructor función obtiene la lista de cámaras conectadas al equipo,
   * luego inicializa la cámara que corresponde a la granja y la activa.
   */
  public Camara(PApplet contenedor) {  
    String[] listadoDeCamaras = Capture.list();
    if (listadoDeCamaras.length > 0) {
        int indiceCamara = 0;
        for (int i = 0; i < listadoDeCamaras.length; i++) {
          if (listadoDeCamaras[i].startsWith(CAMARA_01_NOMBRE)) {
            indiceCamara = i;
            break;
          }
        }
        camara = new Capture(contenedor, listadoDeCamaras[indiceCamara], 30);
        camara.start();
        inicializada = true;
        println("CAMARA ACTIVADA");
    }
    else {
      println("No se detectó ninguna cámara.");
    }
  }
  
  public boolean imagenDisponible() {
    return camara.available();
  }
  
  public void capturar() {
    camara.read();
  }
  
  public Capture video() {
    return camara;
  }
  
  public boolean inicializada() {
    return inicializada;
  }
}
  
