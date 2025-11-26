// 
// PANTALLA
// Pantalla fragmentada
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaFragmentada extends Pantalla {
  
    Corraleta imagenFragmentada;
    
    public PantallaFragmentada(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto, Corraleta corraleta) {
      super(contenedor, id, pantallaAncho, pantallaAlto);
      imagenFragmentada = corraleta;
  }
  
  public void mostrar(int x, int y) {
    imagenFragmentada.mostrar(x, y);
  }

}
