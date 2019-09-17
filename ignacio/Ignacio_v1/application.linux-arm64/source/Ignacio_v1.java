import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.dhchoi.CountdownTimer; 
import com.dhchoi.CountdownTimerService; 
import oscP5.*; 
import netP5.*; 
import controlP5.*; 
import de.looksgood.ani.*; 
import processing.io.*; 
import dmxP512.*; 
import processing.serial.*; 
import dmxP512.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Ignacio_v1 extends PApplet {




final long SECOND_IN_MILLIS = 1000;
final long HOUR_IN_MILLIS = 36000000;

CountdownTimer timer;
int elapsedTime = 0;

String timeText = "";
final int timeTextX = 15, timeTextY = 120;  // upper left corner of displayed text
int timeTextColor = color(255, 0, 0);  // color of text (red: stopped, green: running)
int timeTextFrames = 0, timeTextSeconds = 0, timeTextMinutes = 0; // the seconds and minutes to be displayed

final int framesPerSecondVideo = 24;




OscP5 oscP5;

String[] clientIp = {"127.0.0.1", "169.254.191.87"}; 

int startTime = 0;
int endTime = 605;

NetAddress[] myRemoteLocation;



ControlP5 cp5;

String s ="";
boolean pause = true;
int c = color (0);

public void setup() {
  
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


public void draw() {
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
  println("stringTime " + stringTime);
  myMessage.add(stringTime);
  for (int i=0; i<clientIp.length; i++) {
    oscP5.send(myMessage, myRemoteLocation[i]);
  }  
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
public void restart() {
  seek(0);
      
      idKeyFrame = 0;
      row = table.getRow(idKeyFrame);
      keyFrameTime = row.getInt("keyFrameTime");
      println("sequence ended");
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
/**
 * shows how to loop a whole sequence
 *	 
 * KEYS
 * space           : toggle, pause and resume sequence
 * s               : start or restart sequence
 */



AniSequence seq;
// A Table object
Table table;
TableRow row ;

int idKeyFrame = 0;
int keyFrameTime = 0;
int lengthTransition = 1;
int lightIntensityTransition = 0;

boolean sequenceEnded = true;
boolean stroboMode = false;

float lampFactor = 200;

public void setupAni() {
  loadData();
  // Ani.init() must be called always first!
  Ani.init(this);
  //Ani.setDefaultTimeMode(Ani.FRAMES);
  // create a sequence
  // dont forget to call beginSequence() and endSequence()
  //seq = new AniSequence(this);
  //seq.beginSequence();
  //// step 0
  //seq.add(Ani.to(this, 10, "lightIntensity", 120));
  //// step 1
  //seq.add(Ani.to(this, 10, "lightIntensity", 0));
  //// step 2
  //seq.add(Ani.to(this, 9, "lightIntensity", 220));
  //// step 3
  //seq.add(Ani.to(this, 1, "lightIntensity", 0));
  //seq.endSequence();
}

public void updateSequence() {

  // You can access iterate over all the rows in a table

  if (elapsedTime > keyFrameTime && !sequenceEnded) {
    lengthTransition = row.getInt("lengthTransition");
    println("keyFrameTime " + keyFrameTime);
    println("lengthTransition " + lengthTransition);
    lightIntensityTransition = PApplet.parseInt(row.getInt("lightIntensity%") * lampFactor * 0.01f);
    println("lightIntensityTransition " + lightIntensityTransition);
    if (lightIntensityTransition < 0) {
      stroboMode = true;
    } else {
      stroboMode = false;
      Ani.to(this, lengthTransition, "lightIntensity", lightIntensityTransition);
    }
    if (idKeyFrame < table.getRowCount() - 1) {
      idKeyFrame++;
      row = table.getRow(idKeyFrame);
      keyFrameTime = row.getInt("keyFrameTime");
      println("next keyframe is " + idKeyFrame + " at time " + keyFrameTime);
    } else {
      sequenceEnded = true;
      idKeyFrame = 0;
      row = table.getRow(idKeyFrame);
      keyFrameTime = row.getInt("keyFrameTime");
      println("sequence ended");
    }
  }
}

public void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  table = loadTable("lightScore.csv", "header");
  row = table.getRow(idKeyFrame);
  keyFrameTime = row.getInt("keyFrameTime");
}
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
    .setSize(170, 10)
    .setRange(0.f, 1.f)
    .setValue(1.0f)
    ;

  cp5.addSlider("seek")
    .setPosition(10, 170)
    .setSize(170, 10)
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







DmxP512 dmxOutput;
int universeSize=128;

boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;
String DMXPRO_PORT="/dev/ttyUSB0";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;

int lightIntensity = 1; // between 0 - 255, minimi teho 0, maksimi teho 255
int lightIncrement = 1;

public void setupDMX() {
 
  dmxOutput=new DmxP512(this, universeSize, false);

  if (LANBOX) {
    dmxOutput.setupLanbox(LANBOX_IP);
  }

  if (DMXPRO) {
    dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
  }
  dmxOutput.set(1, 0);
}


public void drawDMX() {    
  
  dmxOutput.set(1, lightIntensity);
  fill(lightIntensity);
  rect(350,100,100,100);
}  
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
  public void settings() {  size(1800, 900, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Ignacio_v1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
