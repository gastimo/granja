// 
// PANTALLA
// Contenedor para la gráfica generativa de cada una de las
// pantallas de la granja.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


// CONFIGURACIÓN DE PARÁMETROS PARA ACTIVACIÓN DE PANTALLAS
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
// La gráfica para las 5 pantallas se genera en formato Full HD
final int DURACION_ACTIVACION = 500;


class Pantalla {
  int identificador;
  int ancho, alto;
  PApplet ventana;
  PGraphics contenido;
  PShader shader;
  int inicioActivacion = 0;
  int finActivacion = 0;
  
  public Pantalla(PApplet contenedor, int id) {
    this(contenedor, id, PANTALLA_ANCHO, PANTALLA_ALTO);
  }
  
  public Pantalla(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto) {
    identificador = id;
    ventana = contenedor;
    ancho = pantallaAncho;
    alto = pantallaAlto;
  }
  
  public void mostrar(int x, int y) {
    push();
    fill( identificador == 1 ? color(255, 255,0) : identificador == 2 ? color(255, 0, 255) : identificador == 4 ? color(0, 255, 0) : identificador == 5 ? color(0, 255, 255) : color(127));
    noStroke();
    rect(x, y, ancho, alto);
    pop();
  }
  
  public void procesar() {
    if (inicioActivacion > 0 && millis() > finActivacion) {
      desactivar();
    }
  }
  
  public boolean estaActiva() {
      return millis() <= finActivacion;
  }
  
  public void activar(float valor) {
    inicioActivacion = millis();
    finActivacion = inicioActivacion + DURACION_ACTIVACION;
    println(">>> PANTALLA " + identificador + " ACTIVADA");
  }
  
  public void desactivar() {
    inicioActivacion  = 0;
    finActivacion = 0;
    println(">>> PANTALLA " + identificador + " DESACTIVADA");
  }
}
