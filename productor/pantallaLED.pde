// 
// PANTALLA "LED"
// Pantalla de LEDS
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


class PantallaLED extends Pantalla {
     
    Transmisor notificador;
    boolean notificarActivacion = false;
    boolean notificarDesactivacion = false;

    
    public PantallaLED(PApplet contenedor, int id, int pantallaAncho, int pantallaAlto, Transmisor transmisor) {
      super(contenedor, id, pantallaAncho, pantallaAlto);
      notificador = transmisor;
  }
 
  public void procesar() {
    if (inicioActivacion > 0 && millis() > finActivacion) {
      desactivar();
    }
    if (notificarActivacion) {
      notificador.enviar(identificador, 0, MENSAJE_OSC_ACTIVACION);
      notificarActivacion = false;
    }
    if (notificarDesactivacion) {
      notificador.enviar(identificador, 0, MENSAJE_OSC_DESACTIVACION);
      notificarDesactivacion = false;
    }
  }
  
  public void activar(float valor) {
    super.activar(valor);
    notificarActivacion = true;
  }
  
  public void desactivar() {
    super.desactivar();
    notificarDesactivacion = true;
  }
}
