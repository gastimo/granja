// 
// INTERACTOR
// Objeto que se encarga de procesar las imágenes de video 
// capturadas por la cámara, interpretarlas y luego, 
// notificar los flujos ópticos al "Capataz" para que éste
// lleve a cabo la activación de las pantallas y dispare
// lo sonidos asociados a la interacción del visitante.
// Se utiliza la librería "OpenCV" para Processing:
//
//   https://github.com/atduskgreg/opencv-processing
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

import gab.opencv.*;


/**
 * Interactor
 * Componente responsable de interpretar las imágenes de video capturadas 
 * por la cámara para analizarlas con las funciones de "Optical Flow"
 * de la librería de OpenCV de Processing. Los valores retornados por
 * la función que calcula el flujo óptico son utilizados para interpretar
 * la interacción de los visitantes con la obra y notificar, luego, esos
 * valores al "Capataz" de la granja.
 */
class Interactor {
  OpenCV opencv;
  Matriz matriz;
  
  public Interactor(PApplet contenedor, int ancho, int alto, int columnas, int filas) {
    matriz = new Matriz(columnas, filas, ancho, alto);
    opencv = new OpenCV(contenedor, ancho, alto);
  }
  
  public float[][] flujoOptico(PImage imagen, float techo) {
    opencv.loadImage(imagen);
    opencv.calculateOpticalFlow();
    matriz.calcular(opencv);
    return matriz.devolverCasillas(techo);
  }
  
  public void mostrar(float x, float y, float techo) {
    matriz.dibujar(x, y, techo);
  } 
}



/**
 * Matriz
 * Objeto auxiliar que define una matriz de filas y columnas para
 * poder realizar los cálculos de "Optical Flow" que provee la
 * librería OpenCV de Processing.
 */
class Matriz {
  int columnas;
  int filas;
  int ancho;
  int alto;
  float moduloH, moduloV;
  PVector m[][];
  float cuanto[][];

  Matriz(int columnas_, int filas_, int ancho_, int alto_) {
    ancho = ancho_;
    alto = alto_;
    columnas = columnas_;
    filas = filas_;
    moduloH = ancho*1.0/columnas;
    moduloV = alto*1.0/filas;
    m = new PVector[columnas][filas];
    cuanto = new float[columnas][filas];
  }

  void calcular( OpenCV opencv ) {
    for ( int i=0; i<columnas; i++ ) {
      for ( int j=0; j<filas; j++ ) {
        m[columnas-i-1][j] = opencv.getAverageFlowInRegion(int(i*moduloH), int(j*moduloV), int(moduloH), int(moduloV));
        cuanto[columnas-i-1][j] = m[columnas-i-1][j].mag();
      }
    }
  }

  float devolverCasilla( int columna, int fila, float techo ) {
    float valor = map( cuanto[columna][fila], 0, techo, 0, 255 );
    valor = constrain( valor, 0, 255 );
    return valor;
  }
  
  float[][] devolverCasillas(float techo) {
    float[][] casillas = new float[columnas][filas];
    for ( int i=0; i<columnas; i++ ) {
      for ( int j=0; j<filas; j++ ) {
        float valor = map( cuanto[i][j], 0, techo, 0, 1.5 );
        casillas[i][j] = constrain( valor, 0, 1 );
      }
    }
    return casillas;
  }

  void dibujar( float x, float y, float techo ) {
    for ( int i=0; i<columnas; i++ ) {
      for ( int j=0; j<filas; j++ ) {
        float valor = map( cuanto[i][j], 0, techo, 0, 255 );
        valor = constrain( valor, 0, 255 );
        fill( valor );
        rect( x+i*moduloH, y+j*moduloV, moduloH, moduloV );
      }
    }
  }
}
