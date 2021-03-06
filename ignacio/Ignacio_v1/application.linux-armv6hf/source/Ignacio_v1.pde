import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;

final long SECOND_IN_MILLIS = 1000;
final long HOUR_IN_MILLIS = 36000000;

CountdownTimer timer;
int elapsedTime = 0;

String timeText = "";
final int timeTextX = 15, timeTextY = 120;  // upper left corner of displayed text
color timeTextColor = color(255, 0, 0);  // color of text (red: stopped, green: running)
int timeTextFrames = 0, timeTextSeconds = 0, timeTextMinutes = 0; // the seconds and minutes to be displayed

final int framesPerSecondVideo = 24;

import oscP5.*;
import netP5.*;

OscP5 oscP5;

String[] clientIp = {"127.0.0.1", "169.254.191.87"}; 

int startTime = 0;
int endTime = 605;

NetAddress[] myRemoteLocation;

import controlP5.*;

ControlP5 cp5;

String s ="";
boolean pause = true;
color c = color (0);

void setup() {
  size(1800, 900, P2D);
  surface.setLocation(0, 0);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress[clientIp.length];

  for (int i=0; i<clientIp.length; i++) {
    myRemoteLocation[i] = new NetAddress(clientIp[i], 1234);
  }

  frameRate(60);
  textSize(40);
  textAlign(CENTER);

  setupControls();

  timer = CountdownTimerService.getNewCountdownTimer(this).configure(SECOND_IN_MILLIS, HOUR_IN_MILLIS);
  updateTimeText();
  //alphaValue(120);
  pause();
  seek(endTime - 10);

  setupDMX();
  setupAni();
  noCursor();
}


void draw() {
  if (pause) {
    c = color(128);
  } else {
    c = color(220, 220, 0);
  }
  background(c);
  fill(timeTextColor);  
  text(timeText, 300, 70);

  drawDMX();

  updateSequence();

  if (stroboMode) {
    lightIntensity = (frameCount % 2)*abs(lightIntensityTransition);
    println("lightIntensity " + lightIntensity);
  }
  //println("lightIntensity " + lightIntensity);

  if (elapsedTime > endTime) {
    // jump back to beginning of the video
    seek(startTime);
    // restart the DMX score
    sequenceEnded = false;
  }
}

void alphaValue(float theColor) {
  OscMessage myMessage = new OscMessage("/setalpha");
  /* send the message */
  myMessage.add(str(theColor*255));
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }
}

void seek(int time) {
  OscMessage myMessage = new OscMessage("/setposition");
  /* send the message */
  String stringTime = str(time * 1000000);
  println("stringTime " + stringTime);
  myMessage.add(stringTime);
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }  
  elapsedTime = time;
  updateTimeText();
}

void stop() {
  OscMessage myMessage = new OscMessage("/stop");
  /* send the message */
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }
}

void fScreen(boolean theFlag) {
  if (theFlag) {
    OscMessage myMessage = new OscMessage("/fullScreen");
    /* send the message */
    for (int i=0; i<clientIp.length; i++) {
      oscP5.send(myMessage, myRemoteLocation[i]);
    }
  } else {
    OscMessage myMessage = new OscMessage("/smallWindow");
    /* send the message */
    for (int i=0; i<clientIp.length; i++) {
      oscP5.send(myMessage, myRemoteLocation[i]);
    }
  }
}


void pause() {
  pause = !pause;
  OscMessage myMessage = new OscMessage("/pause");
  /* send the message */
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }
  if (timer.isRunning()) {
    // STOP_IMMEDIATELY: stop immediately as soon as button was clicked
    timer.stop(CountdownTimer.StopBehavior.STOP_IMMEDIATELY); // stop stopwatch
    timeTextColor = color(255, 20, 0);  // red: stopped
  } else {
    timer.start(); // resume stopwatch
    timeTextColor = color(20, 200, 0);  // green: running
  }
  if (pause) {
    cp5.getController("pause").setLabel("PAUSED");
    cp5.getController("pause").setColorBackground(color(255, 0, 50));
    cp5.getController("pause").setColorForeground(color(240, 0, 0));
  } else {  
    cp5.getController("pause").setLabel("PLAYING");
    cp5.getController("pause").setColorBackground(color(20, 200, 30));
    cp5.getController("pause").setColorForeground(color(20, 150, 30));
  }
  println("sent pause");
}
void restart() {
  seek(0);
      
      idKeyFrame = 0;
      row = table.getRow(idKeyFrame);
      keyFrameTime = row.getInt("keyFrameTime");
      println("sequence ended");
}

void mouseClicked() {
  alphaValue(127);
}

void keyPressed() {
  if (key == 'q') {
    OscMessage myMessage = new OscMessage("/stop");
    /* send the message */
    for (int i=0; i<clientIp.length; i++) {
      oscP5.send(myMessage, myRemoteLocation[i]);
    }
    println("send /stop");
  }
  // pause and resume animation by pressing SPACE
  // or press "s" to start the sequence

  else if (key == 's' || key == 'S')
  {
    seq.start();
  } else if (key == ' ') {
    if (seq.isPlaying())
    {
      seq.pause();
    } else seq.resume();
  }
}
