
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
  println("time " + time + " stringTime " + stringTime);
  myMessage.add(stringTime);

  oscP5.send(myMessage, myRemoteLocation[0]);

  elapsedTime = time;
  updateTimeText();
}

void sendTriggerSecondVideo() {

  OscMessage myMessage = new OscMessage("/secondVideo");
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation[2]);
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
void restart() {
  seek(0);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/restartExt")) {  
    restart();
  };
  println(" typetag: "+theOscMessage.typetag());
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
}
