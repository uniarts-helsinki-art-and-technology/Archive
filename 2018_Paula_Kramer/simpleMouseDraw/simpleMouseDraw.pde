
import processing.video.*;

//Capture cam;
Movie movie;
PImage maskImage;

PGraphics drawing;

//boolean cameraOff=true;
boolean videoOff=false;

int numPixels;
int[] backgroundPixels;

void setup() {
  // set window size according to the video resolution
  size(1920, 1080);
  
  maskImage = loadImage("mask.jpg");

  // Load and play the video in a loop
  movie = new Movie(this, "transit.mov");
  movie.loop();

//  cam = new Capture(this, "name=FaceTime HD Camera,size=640x360,fps=30");
//  cam.start();

  drawing = createGraphics(width, height);
  drawing.stroke(0);
 // frame.setBackground(new java.awt.Color(0, 0, 0));

  numPixels = width * height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
//  if (!cameraOff) {
//    if (cam.available() == true) {
//      cam.read();
//  }
      // image(cam, 0, 0, width/2, height);
//    set(0, 0, cam);
//  }   

  if (!videoOff) {
  //  tint(255, 126); 
    image(movie, 0, 0, width, height);
  }
  image(drawing, 0, 0, width, height);
}


void mouseDragged() {
  drawing.beginDraw();
  drawing.stroke(maskImage.get(mouseX, mouseY),50);
  drawing.line(pmouseX, pmouseY, mouseX, mouseY); 
  drawing.endDraw();
}



void keyPressed() {
  if (key == 'x') {
    drawing.beginDraw();
    drawing.clear();
    drawing.endDraw();
  } else if (key=='c') {
  } else if (key=='v') {
  }
}