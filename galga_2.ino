//Incluye las librerías
#include "HX711.h"
#include <Wire.h> 
#include <EEPROM.h>

//Define las variables globales
byte DT=7;
byte CLK=8;
float fuerza_conocida[3] = {1.991, 0.921, 0.333};
long escala; 

//Crear el objeto balanza
HX711 balanza;


//Función de calibración y ajuste
void calibration(){
  
  Serial.println("Calibration");
  int i = 0, cal=1;   // Elegir el objeto para la calibración (0, 1 o 2)
  float adc_lecture;

  Serial.println("Carga: ");
  Serial.println(i);

  delay(1500);
  balanza.read();
  balanza.set_scale(); //La escala por defecto es 1
  balanza.tare(20);  //Función para tarar. El número 20 indica las lecturas para obtener la tara, por defecto es 10

  //Inicia el proceso de ajuste y calibración
  while(cal == 1){
    Serial.println("Fuerza Conocida:");
    Serial.println(fuerza_conocida[i], 2);
    delay(5000);

    Serial.println("Cargue y espere ...");
    delay(4000);
    
    //Lee el valor del HX711
    adc_lecture = balanza.get_value(100);
    
    //Calcula la escala con el valor leido dividido el peso conocido
    escala = adc_lecture / fuerza_conocida[i];

    //Guarda la escala en la EEPROM
    EEPROM.put( 0, escala );
    Serial.println("Retire carga");
    delay(100);
    cal = 0; //Cambia la bandera para salir del while
    Serial.println("Ya midió");    
  }
}

void setup() {

  //Configura la balanza
  balanza.begin(DT, CLK);
  
  Serial.begin(9600);
  Serial.println("Entré a setup");

  //Lee el valor de la escala en la EEPROM
  EEPROM.get( 0, escala );

  //Mensaje inicial en el LCD
  Serial.println("Retire la carga y espere");
  delay(2000);
  balanza.set_scale(escala); // Establecemos la escala
  balanza.tare(30);
  Serial.println(escala);

  Serial.println("Listo");  
  delay(1000);
}

void loop() {
  float carga;

  //Mide el peso de la balanza
  carga = balanza.get_units(10);
  Serial.println(carga, 2);
  
  // Función para leer inputs en el Serial
  if (Serial.available() > 0) { // Reconoce si hay una indicación
    String receivedString = Serial.readStringUntil('\n'); // Lee el string ingresado

    Serial.print("Received: ");
    Serial.println(receivedString); // Imprime el string leído

    if (receivedString == "Tara") { // Si el string es "Tara" genera dicha acción
      float valor_tara;
      Serial.println("Taró");
      balanza.tare(20);
      valor_tara = balanza.get_units(10);
    }
    else if (receivedString == "Calibrar") {  // Si el string es "Calibrar" ingresa a la función de calibración
      calibration();
    }
    else if(receivedString == "Prueba"){  // Indicador de cuándo comienza a medir los datos de la prueba de medición
      Serial.println("Comienza prueba");
    }

  }

}

   

