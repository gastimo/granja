// 
// PANTALLA
// Pantalla fragmentada
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaFragmentada extends Pantalla {
  
    Corraleta imagenFragmentada;
    
    public PantallaFragmentada(int pantallaAncho, int pantallaAlto, Corraleta corraleta) {
      super(pantallaAncho, pantallaAlto);
      imagenFragmentada = corraleta;
  }
  
  public void mostrar(int x, int y) {
    imagenFragmentada.mostrar(x, y);
  }

}
