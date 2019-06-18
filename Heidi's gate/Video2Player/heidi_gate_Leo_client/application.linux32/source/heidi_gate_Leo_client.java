import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.io.*; 
import oscP5.*; 
import netP5.*; 
import controlP5.*; 
import com.dhchoi.CountdownTimer; 
import com.dhchoi.CountdownTimerService; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class heidi_gate_Leo_client extends PApplet {




boolean triggerWasOff = true;
boolean trigger = false;




OscP5 oscP5;

String[] clientIp = {"127.0.0.1"}; 
NetAddress[] myRemoteLocation;

String s ="";
boolean pause = true;
int c = color (0);

int startTime = 0;
int endTimeFirstVideo = 20;
int endTime = endTimeFirstVideo;

int beginningSecondVideoInSeconds = 30;
int endSecondVideoInSeconds = 50;

boolean secondVideoTrigger = false;
int lastPosition = 0;

public void settings() {
  size(displayWidth, displayHeight);
}

public void setup() {

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



public void draw() {


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
  ellipse(width/2, height/2, width*0.75f, height*0.75f);

  if (elapsedTime > endTime) {
    seek(lastPosition);
    lastPosition = startTime;
  }
}


ControlP5 cp5;

public void setupControls() {

  cp5 = new ControlP5(this);
  cp5.addFrameRate().setInterval(10).setPosition(0, height - 10);


  cp5.addTextfield("startTimeInput")
    .setPosition(130, 10)
    .setSize(30, 20)
    .setAutoClear(false)
    .setLabel("START (sec)")
    ;

  cp5.addTextfield("endTimeInput")
    .setPosition(180, 10)
    .setSize(30, 20)
    .setAutoClear(false)
    .setLabel("END")
    ;



  // create a toggle
  cp5.addButton("pause").setLabel("PAUSED")
    .setPosition(10, 70)
    .setSize(50, 50)
    .setColorBackground(color(255, 0, 50))
    .setColorForeground(color(240, 0, 0))
    .setColorActive(color(250, 250, 50));


  // create a new button with name 'buttonA'
  cp5.addButton("restart")
    .setPosition(80, 70)
    .setSize(50, 50).setColorBackground(color(51, 225, 240))
    .setColorActive(color(250, 250, 50))
    .setColorForeground(color(71, 163, 240));
  ;

  cp5.addButton("stop")
    .setPosition(timeTextX, 10)
    .setSize(30, 30).setColorBackground(color(51, 225, 240))
    .setColorActive(color(250, 250, 50))
    .setColorForeground(color(71, 163, 240));
  ;

  cp5.addToggle("fScreen")
    .setValue(true)
    .setPosition(60, 10)
    .setSize(30, 30);

  cp5.addSlider("alphaValue")
    .setPosition(10, 150)
    .setSize(300, 10)
    .setRange(0.f, 1.f)
    .setValue(1.0f)
    ;

  cp5.addSlider("seek")
    .setPosition(10, 170)
    .setSize(300, 10)
    .setRange(0, 100)
    .setValue(0)
    ;
}


public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
     println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
    if (theEvent.getName().equals("startTimeInput")) {
      startTime = PApplet.parseInt(theEvent.getStringValue());
    }

    if (theEvent.getName().equals("endTimeInput")) {
      endTime = PApplet.parseInt(theEvent.getStringValue());
    }
  }
}

public void alphaValue(float theColor) {
  OscMessage myMessage = new OscMessage("/setalpha");
  /* send the message */
  myMessage.add(str(theColor*255));
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }
}

public void seek(int time) {
  OscMessage myMessage = new OscMessage("/setposition");
  /* send the message */
  String stringTime = str(time * 1000000);
  println("time " + time + " stringTime " + stringTime);
  myMessage.add(stringTime);
  
    oscP5.send(myMessage, myRemoteLocation[0]);
    
  elapsedTime = time;
  updateTimeText();
}



public void stop() {

  OscMessage myMessage = new OscMessage("/stop");
  /* send the message */
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }
}

public void fScreen(boolean theFlag) {
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


public void pause() {
  pause = !pause;
  OscMessage myMessage = new OscMessage("/pause");
  /* send the message */
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }
  if (timer.isRunning()) {
    // STOP_IMMEDIATELY: stop immediately as soon as button was clicked
    timer.stop(CountdownTimer.StopBehavior.STOP_IMMEDIATELY); // stop stopwatch
    timeTextColor = color(255, 0, 0);  // red: stopped
  } else {
    timer.start(); // resume stopwatch
    timeTextColor = color(0, 255, 0);  // green: running
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
public void restart() {
  seek(0);
}

public void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/restartExt")) {  
    restart();
  };
  if (theOscMessage.addrPattern().equals("/secondVideo")) {  
    secondVideoTrigger = true;
  };
  println(" typetag: "+theOscMessage.typetag());
}

public void mouseClicked() {
  alphaValue(127);
}

public void keyPressed() {

  if (key == 'q') {

    OscMessage myMessage = new OscMessage("/stop");
    /* send the message */
    for (int i=0; i<clientIp.length; i++) {
      oscP5.send(myMessage, myRemoteLocation[i]);
    }
    println("send /stop");
  }
}



final long SECOND_IN_MILLIS = 1000;
final long HOUR_IN_MILLIS = 36000000;

CountdownTimer timer;
int elapsedTime = 0;

String timeText = "";
final int timeTextX = 15, timeTextY = 120;  // upper left corner of displayed text
int timeTextColor = color(255, 0, 0);  // color of text (red: stopped, green: running)
int timeTextFrames = 0, timeTextSeconds = 0, timeTextMinutes = 0; // the seconds and minutes to be displayed

final int framesPerSecondVideo = 24;

public void updateTimeText() {
  
  timeTextSeconds = (elapsedTime ) % 60;
  timeTextMinutes = (elapsedTime ) / 60;
  timeText = nf(timeTextMinutes, 2) + ':' + nf(timeTextSeconds, 2) ;
}

// this is called once per second when the timer is running
public void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  ++elapsedTime;
  updateTimeText();
}

// this will be called after the timer finishes running for an hour 
public void onFinishEvent(CountdownTimer t) {
  exit();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "heidi_gate_Leo_client" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
