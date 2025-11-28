// 
// PANTALLA "FRAG"
// Pantalla FRAGMENTADA
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaFRAG extends Pantalla {
  
    Corraleta imagenFragmentada;
    
    public PantallaFRAG(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto, Corraleta corraleta) {
      super(contenedor, id, pantallaAncho, pantallaAlto);
      imagenFragmentada = corraleta;
  }
  
  public void mostrar(int x, int y) {
    imagenFragmentada.mostrar(x, y);
  }

}
