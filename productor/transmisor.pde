// 
// TRANSMISOR
// Se trata de un objeto que se encarga de llevar a cabo la 
// transmisión de datos (salientes y entrantes) ya sea a través
// del protocolo OSC o del puerto serial de comunicación.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

// Constantes para la transmisión
final int CODIGO_FIN_DE_CUADRO = 25;
final int CODIGO_PAUSA         = 99;


interface Transmisor {
  
  public void enviar(PImage imagen);
  public void enviar(byte[] paquete, String direccion);
  public void enviar(int numero, float valor, String direccion);
}
