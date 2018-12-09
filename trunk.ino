// Include the Servo and LIDAR library
#include <Wire.h>
#include <Servo.h>
#include <LIDARLite.h>
#include <LIDARLite_v3HP.h>

// Create servo objects
Servo Servox10, Servox08;
LIDARLite lidarLite;
int cal_cnt = 0; int dist;

int servoPin7 = 7; int servoPin8 = 8;
int steps = 10;

int dataStore[steps+1][steps+1]

void setup(){
  // import & set up control 
  Servox08.attach(servoPin7);
  Servox10.attach(servoPin8);

  Servox08.writeMicroseconds(1000);
  Servox10.writeMicroseconds(1000);

  Serial.begin(9600); // Initialize serial connection to display distance readings
  lidarLite.begin(0, true); // Set configuration to default and I2C to 400 kHz
  lidarLite.configure(0); // Change this number to try out alternate configuration 

  // mech control
  for(int r = 1; r <= steps; r = r + 1 ){
    for(int c = 1; i <= steps; c = c + 1){
      if(r%2 = 1){
        Servox08.writeMicroseconds(r);
        Servox10.writeMicroseconds(c);
        
        // At the beginning of every 100 readings, take a measurement with receiver bias correction
        if ( cal_cnt == 0 ) {
          dist = lidarLite.distance();      // With bias correction} 
        else {
          dist = lidarLite.distance(false); // Without bias correction}

        dataStore[r][c] = dist; // in cm 
        delay(10);
      }
      else{
        Servox08.writeMicroseconds(r);
        Servox10.writeMicroseconds(steps+1-c);
        
        // At the beginning of every 100 readings, take a measurement with receiver bias correction
        if ( cal_cnt == 0 ) {
          dist = lidarLite.distance();      // With bias correction} 
        else {
          dist = lidarLite.distance(false); // Without bias correction}

        dataStore[r][c] = dist; // in cm 
        delay(10);
      }
      // Increment reading counter
      cal_cnt++;
      cal_cnt = cal_cnt % 100;
    }
  }
}
