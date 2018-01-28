public class Caster {
  
  float[] bg;
  
  float n = 1.3;  // index of refraction
  float d = 100;  // Distance to back wall
  float intensity = 1;
  
  boolean reset = false;
  long loopCount;
  
  public Caster() {
    bg = new float[width*height];
  }
  
  public void reset() {
    for (int i = 0; i < bg.length; i++) {
      bg[i] = 0;
    }
  }
  
  public void cast(float x, float y, float nX, float nY, float nZ, float thetaI) {
    // The angle of the refracted ray relative to the incident ray
    float thetaR = asin(n*sin(thetaI));
  
    // Refracted vector
    float rX = -nX;
    float rY = -nY;
    float rZ;
    if (rX == 0 && rY == 0) {
      rZ = -1;
    } else {
      rZ = -abs(sqrt(rX*rX+rY*rY)/sin(thetaI+PI-thetaR));
    }
    //float rZ = -sqrt(rX*rX + rY*rY)/sq(sin(thetaI+PI-thetaR));
    if (rZ > 0) {
      println("Sanity Error: refracted Z must be always negative. Was: " + rZ);
      exit();
    }
  
    float s = d/rZ;  // How much we need to scale the refracted vector to hit the back wall.
  
    // Coordinates where the vector hits the back wall    
    float hX = x+s*rX;
    float hY = y+s*rY; 
    
    if (hX > 0 && hX < width && hY > 0 && hY < height) {
      // Integer of closest pixel to the point of impact
      int flX = round(hX);
      int flY = round(hY);
      
      int index = flY*width +flX;
      if(index<bg.length && index >= 0) {
        bg[index] += intensity * (1-abs(flX-hX)) * (1-abs(flY-hY));
      }
      
      index++;  // right neighbour
      if(flX<hX && index<bg.length && index >= 0) {
        bg[index] += intensity * (hX-flX) * abs(flY-hY);
      }
      
      index-=2;  // left neighbour
      if(flX>hX && index<bg.length && index >= 0) {
        bg[index] += intensity * (flX-hX) * abs(flY - hY);
      }
      
      index++;
      index-=width;  // top neighbour
      if (flY > hY  && index<bg.length && index>=0) {
        bg[index] += intensity * (flY-hY) * abs(flX - hX);
      }
      
      index += 2*width; // bottom neighbour
      if (flY < hY  && index<bg.length && index>=0) {
        bg[index] += intensity * (hY - flY) * abs(flX - hX);
      }
    }
  }
  
}