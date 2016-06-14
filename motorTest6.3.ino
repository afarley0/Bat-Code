//This is to be run with the matlab program "arduinoInterface0_1.m"

#include <AccelStepper.h>

int n = 0;

// Define a stepper and the pins it will use
//AccelStepper stepper(1, 9, 8);
long pos = 3600;
int pulseCounter = 0;
int resetCounter = 0;

//Motor Control on Easy Driver #1 (TOP NOSE)
#define DirPin_1 22
#define StepPin_1 23
#define MS1_1 24
#define MS2_1 25
//Motor Control on Easy Driver #2 (LEFT NOSE)
#define DirPin_2 26
#define StepPin_2 27
#define MS1_2 28
#define MS2_2 29
//Motor Control on Easy Driver #3 (RIGHT NOSE)
#define DirPin_3 30
#define StepPin_3 31
#define MS1_3 32
#define MS2_3 33
//Motor Control on Easy Driver #4 (LEFT EAR)
#define DirPin_4 34
#define StepPin_4 35
#define MS1_4 36
#define MS2_4 37
//Motor Control on Easy Driver #5 (RIGHT EAR)
#define DirPin_5 38
#define StepPin_5 39
#define MS1_5 40
#define MS2_5 41

//Home Sensor Control on Top Nose
#define Home_TopNose 8
//Home Sensor Control on Left Nose
#define Home_LeftNose 9
//Home Sensor Control on Right Nose
#define Home_RightNose 10
//Home Sensor Control on Left Ear
#define Home_LeftEar 11
//Home Sensor Control on Right Ear
#define Home_RightEar 12
//Surface Sensor Control on Left Ear
#define Surface_LeftEar 13
//Surface Sensor Control on Right Ear
#define Surface_RightEar 14
//Emission pin
#define emitPin 15

AccelStepper stepper_1(1, StepPin_1, DirPin_1);
AccelStepper stepper_2(1, StepPin_2, DirPin_2);
AccelStepper stepper_3(1, StepPin_3, DirPin_3);
AccelStepper stepper_4(1, StepPin_4, DirPin_4);
AccelStepper stepper_5(1, StepPin_5, DirPin_5);

void setup() {
  Serial.begin(9600); 
  pinMode(52, INPUT);
  
  stepper_1.setMaxSpeed(6000);
  stepper_1.setAcceleration(3000);
  stepper_2.setMaxSpeed(6000);
  stepper_2.setAcceleration(3000);
  stepper_3.setMaxSpeed(6000);
  stepper_3.setAcceleration(3000);
  stepper_4.setMaxSpeed(6000);
  stepper_4.setAcceleration(3000);
  stepper_5.setMaxSpeed(6000);
  stepper_5.setAcceleration(3000);

}


void loop() {
  if (Serial.available() > 0){
    String go = Serial.readStringUntil(' ');
    if (go.equals("go"))
    {
      int noseStep = Serial.parseInt();
      Serial.println(noseStep);
      int earStep = Serial.parseInt();
      Serial.println(earStep);
      boolean runs = true;
      while (runs){
        String data = Serial.readStringUntil(';');
        if(data.equals("stop")){
          runs = false;
        }
        else if(data.equals("run")){
          neoDynamicControl(1, noseStep, earStep);
        }
        
        else if (data.equals("trigger")) {
          long timer = 1000000;
          int count = 0;
          while (timer > 0){
            timer--;
            if(count > 5){
              neoDynamicControl(1, noseStep, earStep);
              break;
            }
            else if (digitalRead(52) == HIGH){
              count++;
            }
          }
          
        }
        
      }
      
      Serial.println("RECIEVED ");
      
    }
  }
  
  
}
void dynamicControl(){

  if(n == 0) {
    stepper_1.moveTo(1000);
    n = 1;
  }
  else if (stepper_1.speed() == 0 && n == 1) {
    stepper_1.moveTo(-1000);
    stepper_4.moveTo(1000);
    n = 2;
  }
  else if (stepper_4.speed() == 0 && n == 2) {
    stepper_4.moveTo(-1000);
    n = 3;
  }
  else if (stepper_4.speed() == 0 && n == 3) {
    n= 0;
    //delayMicroseconds(1000000);
  }
  stepper_1.run();
  stepper_4.run();
  
  
}
void neoDynamicControl(int count, long noseStep, long earStep){
  int counter = 0;
  int control = 0;
  while (counter < count) {
    if(control == 0) {
      stepper_1.moveTo(noseStep);
      stepper_2.moveTo(noseStep);
      stepper_3.moveTo(-noseStep);
      control = 1;
    }
    else if (stepper_1.speed() == 0 && control == 1) {
      stepper_1.moveTo(0);
      stepper_2.moveTo(0);
      stepper_3.moveTo(0);
      stepper_4.moveTo(-earStep);
      stepper_5.moveTo(earStep);
      control = 2;
    }
    else if (stepper_4.speed() == 0 && control == 2) {
      stepper_4.moveTo(0);
      stepper_5.moveTo(0);
      control = 3;
    }
    else if (stepper_4.speed() == 0 && control == 3) {
      control = 0;
      //Serial.println("LOOP SUCCESSFULL");
      delay(1000);
      counter++;
    }
    stepper_1.run();
    stepper_2.run();
    stepper_3.run();
    stepper_4.run();
    stepper_5.run();
  }
}


