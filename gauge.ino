//Include libraries
#include "HX711.h"
#include <Wire.h> 
#include <EEPROM.h>

//Define global variables
byte DT=7;
byte CLK=8;
float fuerza_conocida[3] = {1.991, 0.921, 0.333};  // Array of known weights for 3 objects 
long escala; 

//Crate the "balanza" object
HX711 balanza;


// Calibration function
void calibration(){
  
  Serial.println("Calibration");
  int i = 0, cal=1;   // Select known weight for calibration (0, 1 or 2)
  float adc_lecture;

  Serial.println("Carga: ");
  Serial.println(i);

  delay(1500);
  balanza.read();
  balanza.set_scale(); // Default scale is 1
  balanza.tare(20);  // Tare function. Number 20 is the number of data used to tare (default = 10)

  // Start calibration process
  while(cal == 1){
    Serial.println("Fuerza Conocida:");
    Serial.println(fuerza_conocida[i], 2);
    delay(5000);

    Serial.println("Cargue y espere ...");
    delay(4000);
    
    // Read the HX711 value
    adc_lecture = balanza.get_value(100);
    
    // Calculate the scale taking the value measured divided the known one
    escala = adc_lecture / fuerza_conocida[i];

    // Store scale in EEPROM
    EEPROM.put( 0, escala );
    Serial.println("Retire carga");
    delay(100);
    cal = 0; // To break the while loop
    Serial.println("Ya midió");    
  }
}

void setup() {

  // Configure "balanza" object
  balanza.begin(DT, CLK);
  
  Serial.begin(9600);
  Serial.println("Entré a setup");

  // Read scale from EEPROM
  EEPROM.get( 0, escala );

  Serial.println("Retire la carga y espere");
  delay(2000);
  balanza.set_scale(escala); // Set scale
  balanza.tare(30);
  Serial.println(escala);

  Serial.println("Listo");  
  delay(1000);
}

void loop() {
  float carga;

  // Read the value from the gauge
  carga = balanza.get_units(10);
  Serial.println(carga, 2);
  
  // Read Serial strings
  if (Serial.available() > 0) { // Check if there is a string
    String receivedString = Serial.readStringUntil('\n'); // Read the string

    Serial.print("Received: ");
    Serial.println(receivedString); // Print the spring received

    if (receivedString == "Tara") { // If string = "Tara" then tares
      float valor_tara;
      Serial.println("Taró");
      balanza.tare(20);
      valor_tara = balanza.get_units(10);
    }
    else if (receivedString == "Calibrar") {  // If string = "Calibrar" starts the calibration function
      calibration();
    }
    else if(receivedString == "Prueba"){  // Flag to know when the test data starts
      Serial.println("Comienza prueba");
    }

  }

}

   

