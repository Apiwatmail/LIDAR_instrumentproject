// Include the Servo and LIDAR library
#include <Wire.h>
#include <Servo.h>
#include <LIDARLite.h>
#include <LIDARLite_v3HP.h>

// Create servo objects
Servo Servox10, Servox08;
LIDARLite lidarLite;
int cal_cnt = 0; int dist;

int servoPin7 = 7; int servoPin8 = 8; // to small & large servos respectively
int steps = 10;

int dataStore [11] [11];

void setup(){
  // import & set up control 
  Servox08.attach(servoPin7);
  Servox10.attach(servoPin8);

  Serial.begin(9600); // Initialize serial connection to display distance readings
  lidarLite.begin(0, true); // Set configuration to default and I2C to 400 kHz
  lidarLite.configure(0); // Change this number to try out alternate configuration 

  // mech control
  for(int r = 1000; r <= 2000; r = r + 100 ){
    for(int c = 1000; c <= 2000; c = c + 100 ){ 
      if((r/100)%2 == 0){
        Servox08.writeMicroseconds(r);
        Servox10.writeMicroseconds(c);
        
        // At the beginning of every 100 readings, take a measurement with receiver bias correction
        if ( cal_cnt == 0 ) {
          dist = lidarLite.distance();}      // With bias correction
        else {
          dist = lidarLite.distance(false);} // Without bias correction

        Serial.print(dist);
        Serial.println(" cm");
        //dataStore[r-1][c-1] = dist; // in cm 
        delay(10);
      }
      else{
        Servox08.writeMicroseconds(r);
        Servox10.writeMicroseconds(2100-c);
        
        // At the beginning of every 100 readings, take a measurement with receiver bias correction
        if ( cal_cnt == 0 ) {
          dist = lidarLite.distance();}      // With bias correction
        else {
          dist = lidarLite.distance(false);} // Without bias correction

        Serial.print(dist);
        Serial.println(" cm");
        //dataStore[r-1][c-1] = dist; // in cm 
        delay(10);
      }
      // Increment reading counter
      cal_cnt++;
      cal_cnt = cal_cnt % 100;
    }
  }
}
void loop() {
  // put your main code here, to run repeatedly:

}