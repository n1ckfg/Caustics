// by Xavier Snelgrove | http://wxs.ca/caustics/

long res = 10000000;
CastManager cm;

long savedFrames = 0;
boolean record=false;
int frMin = 2;
int frMax = 60;
int fr = frMax;
float nDiv = 0.02;

void setup() {
  size(800, 600, P2D);
  controlP5 = new ControlP5(this);
  background(0); 
  cm = new CastManager();
  cm.start();
  
  setupControls();
  frameRate(fr);
}

void draw() {
  drawControls();
  if (cm.algo == cm.SPIRAL_CLEAR_ALGO) {
    clear();
  }
  loadPixels();
  float sum = 0;
  float maxV = 0;
  float count=0;
  for (int i = 0; i < cm.cR.bg.length; i++) {
    float m = max(cm.cR.bg[i],cm.cG.bg[i], cm.cB.bg[i]);
    sum+=m;
    maxV = maxV>m?maxV:m;
    if (m!=0) count++;
  }
  float avg = sum/count;
  
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = color(cm.cR.bg[i]*128/avg, cm.cG.bg[i]*128/avg,cm.cB.bg[i]*128/avg);
    if (keyPressed && key=='n') pixels[i] = color(noise(i%width*cm.noiseScale, i/width*cm.noiseScale, cm.z*cm.noiseScale)*255);
  }
  updatePixels();
  
  if (record && cm.loopCount > res) {
    cm.loopCount = 0;
    cm.z+=0.8;
    cm.clear();
    saveFrame("f-" + savedFrames++ + ".png");
    background(0);
  }
}

// What y position should this controller be at?
int cY(int n) {
  return controlY + n*controlSpace; 
}

void depth(float d) {
  cm.cR.d = cm.cG.d = cm.cB.d = d;
  clear();
}

void ior(float n) {
  cm.cR.n = n;
  cm.cG.n = n+nDiv;
  cm.cB.n = n+nDiv*2;
  clear();
}
void iorDivergence(float d) {
  nDiv = d;
  ior(cm.cR.n);
}

void emitMode(int theID) {
  switch (theID) {
    case 0:
      cm.algo = cm.SPIRAL_ALGO;
      break;
    case 1:
      cm.algo = cm.SPIRAL_CLEAR_ALGO;
      break;
    case 2:
      cm.algo = cm.RANDOM_ALGO;
      break;
  }
}

void noiseScale(float s) {
  cm.noiseScale = s/1500.0;
  clear();
}

void rIntensity(float i) {
  cm.cR.intensity = i;
  clear();
}

void gIntensity(float i) {
  cm.cG.intensity = i;
  clear();
}

void bIntensity(float i) {
  cm.cB.intensity = i;
  clear();
}

void boxW(float w) {
  cm.boxW = w;
}

void boxH(float h) {
  cm.boxH = h;
}

void reset() {
      cm.reseed();
      cm.reset();
}

void clear() {
  cm.reset();
}