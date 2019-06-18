
import processing.io.*;

boolean triggerWasOff = true;
boolean trigger = false;

import oscP5.*;
import netP5.*;

OscP5 oscP5;

String[] clientIp = {"127.0.0.1", "172.20.10.3", "172.20.10.3"}; 
NetAddress[] myRemoteLocation;

String s ="";
boolean pause = true;
color c = color (0);

int startTime = 0;
int endTimeFirstVideo = 5;
int endTime = endTimeFirstVideo;

int beginningSecondVideoInSeconds = 6;
int endSecondVideoInSeconds = 10;

void settings() {
  size(displayWidth, displayHeight);
}

void setup() {

  GPIO.pinMode(4, GPIO.INPUT);

  surface.setLocation(0, 0);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress[clientIp.length];


  myRemoteLocation[0] = new NetAddress(clientIp[0], 1234);
  myRemoteLocation[1] = new NetAddress(clientIp[1], 1234);
  myRemoteLocation[2] = new NetAddress(clientIp[2], 11000);


  frameRate(60);

  textAlign(CENTER);
  textSize(24);
  setupControls();

  timer = CountdownTimerService.getNewCountdownTimer(this).configure(SECOND_IN_MILLIS, HOUR_IN_MILLIS);
  updateTimeText();

  pause = false;
  timer.start(); // resume stopwatch
  timeTextColor = color(40);  
  cp5.getController("pause").setLabel("PLAYING");
  cp5.getController("pause").setColorBackground(color(20, 200, 30));
  cp5.getController("pause").setColorForeground(color(20, 150, 30));
}



void draw() {

  // sense the input pin
  if (GPIO.digitalRead(4) == GPIO.HIGH && elapsedTime < endTimeFirstVideo) {
    trigger = true;
  } else {
    trigger = false;  
    triggerWasOff = true;
  }

  if (trigger && triggerWasOff)
  {  
    println("the first switch is open");
    triggerWasOff = false;
    endTime = endSecondVideoInSeconds;
    seek(beginningSecondVideoInSeconds);
    //to the client raspberry pi
    sendTriggerSecondVideo();
  }

  if (pause) {
    c = color(128);
  } else {
    c = color(250, 220, 0);
  }
  background(c);
  fill(timeTextColor);  
  text(timeText, 100, timeTextY + 24);

  if (trigger) {
    fill(255);
  } else {
    fill(20);
  }  
  stroke(255);
  ellipse(width/2, height/2, width*0.75, height*0.75);

  if (elapsedTime > endTime) {
    seek(startTime);
  }
}
