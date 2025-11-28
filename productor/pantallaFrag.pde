// 
// PANTALLA "FRAG"
// Pantalla FRAGMENTADA
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaFRAG extends Pantalla {
  
  Corraleta imagenFragmentada;
  boolean esActiva = false;
  PGraphics grafica;
    
  public PantallaFRAG(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto, Corraleta corraleta) {
    super(contenedor, id, pantallaAncho, pantallaAlto);
    imagenFragmentada = corraleta;
    grafica= createGraphics(pantallaAncho, pantallaAlto, P3D);
  }
  
  public void mostrar(int x, int y) {
    if (!esActiva) {
      imagenFragmentada.mostrar(x, y);
    }
    else {
      int tiempoActivacion = millis() - inicioActivacion;
      float puntoMedio = (finActivacion - inicioActivacion) / 2;
      float valor = 0;
      if (tiempoActivacion <= puntoMedio) 
        valor = map(tiempoActivacion, 0, puntoMedio, 0, 1);
      else {
        valor = map(tiempoActivacion, puntoMedio, puntoMedio*2, 1, 0);
      }
      imagenFragmentada.mostrarImagen(0, 0, valor, grafica);
      image(grafica, x, y, ancho, alto);
    }
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
