/*
a flickering led light for Dan Cole project
*/

int led = 9;           // the PWM pin the LED is attached to
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // set the brightness of pin 9:
  analogWrite(led, brightness);

  // change the brightness for next time through the loop:

  brightness = random(0, 255);
  if (brightness > 120) {
    brightness = 255;
  }
  else {
    brightness = 0;
  }


  // wait for a random time between 10 and 500 milliseconds
  delay(random(10, 500));
}
