// 
// PANTALLA
// Contenedor para la gráfica generativa de cada una de las
// pantallas de la granja.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class Pantalla {
  
  int ancho, alto;
  PGraphics contenido;
  
  public Pantalla() {
    this(PANTALLA_ANCHO, PANTALLA_ALTO);
  }
  
  public Pantalla(int pantallaAncho, int pantallaAlto) {
    ancho = pantallaAncho;
    alto = pantallaAlto;
  }
  
  public void mostrar(int x, int y) {
    push();
    fill(128);
    noStroke();
    rect(x, y, ancho, alto);
    pop();
  }
  
  public void activar(float valor) {
    println(">>> PANTALLA ACTIVADA");
  }
}
