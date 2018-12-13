// Include the Servo and LIDAR library
#include <Wire.h>
#include <Servo.h>
#include <LIDARLite.h>
#include <LIDARLite_v3HP.h>

// Create servo objects
Servo Servox10, Servox08;
/*LIDARLite lidarLite;
int cal_cnt = 0; int dist;*/

int servoPin7 = 7; int servoPin8 = 8;
int steps = 10;
int pulse_width;

int dataStore [11] [11];

void setup(){
  // import & set up control 
  Servox08.attach(servoPin7);
  Servox10.attach(servoPin8);

  Serial.begin(9600); // Initialize serial connection to display distance readings
  /*lidarLite.begin(0, true); // Set configuration to default and I2C to 400 kHz
  lidarLite.configure(0); // Change this number to try out alternate configuration */
  pinMode(2, OUTPUT); // Set pin 2 as trigger pin
  pinMode(3, INPUT); // Set pin 3 as monitor pin
  

  // mech control
  int dataStore [11] [11];
  for(int r = 1200; r <= 1800; r = r + 60 ){
    for(int c = 1200; c <= 1800; c = c + 60 ){ 
      if((r/20)%2 == 0){
        Servox10.writeMicroseconds(r);
        Servox08.writeMicroseconds(c);

        digitalWrite(2, LOW); // Set trigger LOW for continuous read
        pulse_width = pulseIn(3, HIGH); // Count how long the pulse is high in microseconds
        if(pulse_width != 0){ // If we get a reading that isn't zero, let's print it
          pulse_width = pulse_width/10; // 10usec = 1 cm of distance for LIDAR-Lite
          digitalWrite(2, HIGH); // Set trigger LOW for continuous read
        Serial.print(pulse_width);
        Serial.println(" cm");
        }
        dataStore[(r/100)-10][(c/100)-10] = pulse_width; // in cm 
        delay(10);
      }
      else{
        Servox10.writeMicroseconds(r);
        Servox08.writeMicroseconds(2100-c);

        digitalWrite(2, LOW); // Set trigger LOW for continuous read
        pulse_width = pulseIn(3, HIGH); // Count how long the pulse is high in microseconds
        if(pulse_width != 0){ // If we get a reading that isn't zero, let's print it
          pulse_width = pulse_width/10; // 10usec = 1 cm of distance for LIDAR-Lite
          digitalWrite(2, HIGH); // Set trigger LOW for continuous read
        Serial.print(pulse_width);
        Serial.println(" cm");
        }
        dataStore[(r/100)-10][(c/100)-10] = pulse_width; // in cm 
        delay(10);
      }
      /*// Increment reading counter
      cal_cnt++;
      cal_cnt = cal_cnt % 100;
        //Serial.println(dataStore)*/
    }
  }
  //return dataStore;
}

void loop() {
  // put your main code here, to run repeatedly:

}
