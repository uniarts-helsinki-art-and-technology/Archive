/**
 * Loop. 
 * 
 * Shows how to load and play a QuickTime movie file.  
 *
 */

import processing.video.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation1;
NetAddress myRemoteLocation2;

Movie movie;

int frame =240;

PFont font;
boolean specialStart = false;



void setup() {
  size(1280, 800, P2D);
  noCursor();
  background(0);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 8000);
  myRemoteLocation1 = new NetAddress("169.254.207.133", 12000);
  myRemoteLocation2 = new NetAddress("169.254.207.134", 12000);
  // Load and play the video in a loop
  movie = new Movie(this, "/Users/exlabadmin/Desktop/master_video.mov");
  movie.play();

  movie.jump(4700/24);

  font = loadFont("ArialMT-48.vlw");
  textFont(font, 48);
  
  println(getLength());
  
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  //if (movie.available() == true) {
  //  movie.read(); 
  //}
  background(0);
  image(movie, 0, 0, width, height);

  //text(getFrame(), width*0.2, height*0.9);

  if (getFrame() == getLength() - 3 || specialStart) {    
    sendPlayMessage();
    println("sent start message at frame " + getFrame());
  }


  if (getFrame() == getLength()-1 || specialStart) {
    specialStart = false;
    
    movie.play();
    movie.jump(0);
    
  }
}

void sendPlayMessage() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/startVideo");

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation1);
  oscP5.send(myMessage, myRemoteLocation2);
}


void keyPressed() {
  if (key == 's') {
    specialStart = true;
  }
  if (key == 'j') {
    
      movie.play();
    movie.jump(4700/24);
  }
}


int getFrame() {    
  return ceil(movie.time() * 24) - 1;
}

int getLength() {
  return int(movie.duration() * 24);
}
