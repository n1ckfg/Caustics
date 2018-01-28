import controlP5.*;

ControlP5 controlP5;
int controlW = 125;
int controlH = 8;
int controlX = 10;
int controlY = 10;
int controlSpace = 10;

void setupControls() {
  // Set up the UI controls
  controlP5.addSlider("rIntensity", 0, 100, cm.cR.intensity, controlX, cY(0), controlW, controlH);
  controlP5.addSlider("gIntensity", 0, 100, cm.cG.intensity, controlX, cY(1), controlW, controlH);
  controlP5.addSlider("bIntensity", 0, 100, cm.cB.intensity, controlX, cY(2), controlW, controlH);
  
  controlP5.addSlider("noiseScale", 0, 50, cm.noiseScale*1500, controlX, cY(5), controlW, controlH);
  
  controlP5.addSlider("boxW", 0,  width, cm.boxW, controlX, cY(7), controlW, controlH);
  controlP5.addSlider("boxH", 0, height, cm.boxH, controlX, cY(8), controlW, controlH);
  
  RadioButton r = controlP5.addRadio("emitMode", controlX, cY(10));
  r.add("spiral", 0);
  r.add("spiralclear", 1);
  r.add("random", 2);
  
  controlP5.addSlider("depth", 1,200, cm.cR.d, controlX, cY(15), controlW, controlH);
  
  controlP5.addSlider("ior", 1, 3, cm.cR.n, controlX, cY(17), controlW, controlH);
  controlP5.addSlider("iorDivergence", 0, 0.2, cm.cG.n-cm.cR.n, controlX, cY(18), controlW, controlH);
  
  controlP5.addButton("clear", 0, controlX, cY(20), controlW/2-2, controlH);
  controlP5.addButton("reset", 0, controlX+controlW/2+2, cY(20), controlW/2-2, controlH).setLabel("reseed");
}

void drawControls() {
  controlP5.show();
}

void keyPressed() {
  switch (key) {
    case 'r':  //reset
      reset();
      break;
    case 'c': //clear
      clear();
      break;
    case 'p':
      println("LoopCount: " + cm.loopCount);
      println("fps: " + cm.fps);
      break;
    case 's':
      controlP5.hide();
      saveFrame("SAVED"+millis()+".png");
      break;
    case 'm':
      record=!record;
      break;
    case 'a':
      cm.cycleAlgo();
      break;
    case 'f':
      if (fr > frMin) fr=frMin;
      else fr = frMax;
      frameRate(fr);
      break;
    }
}