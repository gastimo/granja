// 
// DIFUSORA
// Es el componente encargado de transmitir el video generado
// por el "Productor" para que sea captado, mapeado y proyectado
// en las pantallas de la granja.
// Para la difusión se utiliza el programa "Spout":
//
//         https://spout.zeal.co/
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
import spout.*;

public final String NOMBRE_DIFUSORA = "Productor de la Granja";


class Difusora {
  Spout spout;
  
  public Difusora(PApplet contenedor) {
    // Se crea el objeto "Spout" para la transmisión
    // y al mismo tiempo se instancia un "sender".
    spout = new Spout(contenedor);
    spout.createSender(NOMBRE_DIFUSORA);
  }
  
  public void transmitir() {
    spout.sendTexture();
  }
}
