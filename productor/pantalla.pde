// 
// PANTALLA
// Contenedor para la gráfica generativa de cada una de las
// pantallas de la granja.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class Pantalla {
  int identificador;
  int ancho, alto;
  PApplet ventana;
  PGraphics contenido;
  PShader shader;
  
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
  
  public void activar(float valor) {
    println(">>> PANTALLA ACTIVADA");
  }
}
