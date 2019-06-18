
import processing.io.*;

boolean triggerWasOff = true;
boolean trigger = false;

import oscP5.*;
import netP5.*;

OscP5 oscP5;

String[] clientIp = {"127.0.0.1"}; 
NetAddress[] myRemoteLocation;

String s ="";
boolean pause = true;
color c = color (0);

int startTime = 0;
int endTimeFirstVideo = 20;
int endTime = endTimeFirstVideo;

int beginningSecondVideoInSeconds = 30;
int endSecondVideoInSeconds = 50;

boolean secondVideoTrigger = false;
int lastPosition = 0;

void settings() {
  size(displayWidth, displayHeight);
}

void setup() {

  surface.setLocation(0, 0);
  /* start oscP5, listening for incoming messages at port 11000 */
  oscP5 = new OscP5(this, 11000);
  myRemoteLocation = new NetAddress[clientIp.length];


  myRemoteLocation[0] = new NetAddress(clientIp[0], 1234);

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


  if (secondVideoTrigger)
  {  
    println("the first switch is open");
    lastPosition = elapsedTime;
    secondVideoTrigger = false;
    endTime = endSecondVideoInSeconds;
    seek(beginningSecondVideoInSeconds);
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
    seek(lastPosition);
    lastPosition = startTime;
  }
}
