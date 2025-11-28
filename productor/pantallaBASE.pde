// 
// PANTALLA "BASE"
// Pantalla BASE
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaBASE extends Pantalla {
  
  Corraleta corraleta;
  boolean esActiva = false;
  PGraphics salidaShader;
  PShader shader;
  
  public PantallaBASE(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto, Corraleta imagenCorraleta) {
    super(contenedor, id, pantallaAncho, pantallaAlto);
    corraleta = imagenCorraleta;
    shader = loadShader("shader.txt");
    salidaShader= createGraphics(pantallaAncho, pantallaAlto, P3D);
  }
  
  public void mostrar(int x, int y) {
    // Obtengo la imagen de la corraleta actualizada
    PImage imgc = corraleta.obtenerImagen();

    // Defino los parámetros "uniform" para el shader
    shader.set("resolution", (float) ancho, (float) alto);
    shader.set("texture0", imgc);
    
    // Dibujo el contenido de la pantalla con el shader
    salidaShader.beginDraw();
    salidaShader.background(0);
    salidaShader.shader(shader);
    salidaShader.rect(0, 0, ancho, alto);
    salidaShader.endDraw();
  
    // Finalmente, vuelvo la salida del shader en la ventana
    image(salidaShader, x, y, ancho, alto);      
  }
  
  public void activar(float valor) {
    super.activar(valor);
    esActiva = true;
  }
  
  public void desactivar() {
    super.desactivar();
    esActiva = false;
  }
  
  

}
