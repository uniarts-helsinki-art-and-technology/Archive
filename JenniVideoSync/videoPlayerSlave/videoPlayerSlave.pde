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
NetAddress myRemoteLocation;

Movie movie;
 
 boolean gotMessage = false;

void setup() {
  size(1280, 800, P2D);
  noCursor();
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "/Users/KuvaTila1/Desktop/slaveVideo.mov");
    movie.stop();

    /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  //if (movie.available() == true) {
  //  movie.read(); 
  //}
  
if(gotMessage){
movie.jump(0);
movie.play();
gotMessage = false;
}
  
  image(movie, 0, 0);
}

void oscEvent(OscMessage theOscMessage) {
  print(" addrpattern: "+theOscMessage.addrPattern());
  gotMessage=true;
}

int getFrame() {    
  return ceil(movie.time() * movie.frameRate) - 1;
}

int getLength() {
  return int(movie.duration() * movie.frameRate);
}
