import processing.io.*;
import dmxP512.*;
import processing.serial.*;

import dmxP512.*;
import processing.serial.*;

DmxP512 dmxOutput;
int universeSize=128;

boolean LANBOX=false;
String LANBOX_IP="192.168.1.77";

boolean DMXPRO=true;
String DMXPRO_PORT="/dev/ttyUSB0";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;

int lightIntensity = 1; // between 0 - 255, minimi teho 0, maksimi teho 255
int lightIncrement = 1;

void setupDMX() {
 
  dmxOutput=new DmxP512(this, universeSize, false);

  if (LANBOX) {
    dmxOutput.setupLanbox(LANBOX_IP);
  }

  if (DMXPRO) {
    dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
  }
  dmxOutput.set(1, 0);
}


void drawDMX() {    
  
  dmxOutput.set(1, lightIntensity);
  fill(lightIntensity);
  rect(350,100,100,100);
}  
