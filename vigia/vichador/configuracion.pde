// 
// CONFIGURACIÓN
// Conjunto de definiciones y parámetros generales para la obra
// accesibles de manera global por todas las funciones.
//
// vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


// =========================================================
// 
//  MANEJO DE CÁMARAS EN PROCESSING
//
// =========================================================

// Nombres con los que son reconocidas las cámaras utilizadas
String CAMARA_01_NOMBRE = "c922 Pro Stream Webcam";
String CAMARA_02_NOMBRE = "Integrated Camera";

// Dimensiones de cada fotograma capturado por la cámara principal
int CAMARA_ANCHO = 640;
int CAMARA_ALTO  = 480;



// =========================================================
// 
//  PARÁMETROS PARA LA COMUNICACIÓN SERIAL
//
// =========================================================
int TASA_TRANSFERENCIA = 115200;
int CODIGO_FIN_DE_CUADRO = 25;
int CODIGO_PAUSA         = 99;


// =========================================================
// 
//  DIMENSIONES DE PANTALLAS, VENTANAS Y CAPTURAS
//
// =========================================================

// Dimensiones de la matriz de leds de la pantalla del "Fragmentador"
int FRAGMENTADOR_ANCHO = 11;
int FRAGMENTADOR_ALTO  = 25;

// Dimensiones de cada una de las vistas a mostrar en la ventana
int VISTA_ANCHO  = FRAGMENTADOR_ANCHO * CAMARA_ALTO / FRAGMENTADOR_ALTO;
int VISTA_ALTO   = CAMARA_ALTO;

// Dimensiones de la ventana de Processing de previsualización
int VENTANA_ANCHO = VISTA_ANCHO * 2;
int VENTANA_ALTO  = CAMARA_ALTO;

// Dimensiones de cada celda (pixel) de la matriz del fragmentador
int FRAGMENTO_ANCHO = VISTA_ANCHO / FRAGMENTADOR_ANCHO;
int FRAGMENTO_ALTO  = VISTA_ALTO  / FRAGMENTADOR_ALTO;



// =========================================================
// 
//  PARÁMETROS DEL "FRAGMENTADOR"
//
// =========================================================

int FRAG01_TINTE      = 21;
int FRAG01_SATURACIÓN = 75;
int FRAG01_BRILLO     = -2;
        
int FRAG02_TINTE      = 104;
int FRAG02_SATURACIÓN = 55;
int FRAG02_BRILLO     = -8;

int FRAG03_TINTE      = 221;
int FRAG03_SATURACIÓN = 65;
int FRAG03_BRILLO     = -24;

int FRAG04_TINTE      = 9;
int FRAG04_SATURACIÓN = 70;
int FRAG04_BRILLO     = -41;

int FRAG05_TINTE      = 78;
int FRAG05_SATURACIÓN = 93;
int FRAG05_BRILLO     = -16;
