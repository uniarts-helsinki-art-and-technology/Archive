/**
 * shows how to loop a whole sequence
 *	 
 * KEYS
 * space           : toggle, pause and resume sequence
 * s               : start or restart sequence
 */

import de.looksgood.ani.*;

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

void setupAni() {
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

void updateSequence() {

  // You can access iterate over all the rows in a table

  if (elapsedTime > keyFrameTime && !sequenceEnded) {
    lengthTransition = row.getInt("lengthTransition");
    println("keyFrameTime " + keyFrameTime);
    println("lengthTransition " + lengthTransition);
    lightIntensityTransition = int(row.getInt("lightIntensity%") * lampFactor * 0.01);
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

void loadData() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  table = loadTable("lightScore.csv", "header");
  row = table.getRow(idKeyFrame);
  keyFrameTime = row.getInt("keyFrameTime");
}
