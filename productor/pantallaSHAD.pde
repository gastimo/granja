// 
// PANTALLA "SHAD"
// Pantalla SHADER
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaSHAD extends Pantalla {

  PShader shader;
  PImage imagen;
  PGraphics grafica;

  
  public PantallaSHAD(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto) {
    super(contenedor, id, pantallaAncho, pantallaAlto);
    shader = loadShader("shader.txt");
    grafica= createGraphics(pantallaAncho, pantallaAlto, P3D);
    imagen= loadImage("imagen.jpg"); 
  }
  
  
  public void mostrar(int x, int y) {
    shader.set("resolution", (float)ancho, (float)alto);
    shader.set("texture0", imagen);
    
    grafica.beginDraw();
    grafica.background(0);
    grafica.shader(shader);
    grafica.rect(0, 0, ancho, alto);
    grafica.endDraw();
  
    image(grafica, x, y, ancho, alto);    
  }
}
