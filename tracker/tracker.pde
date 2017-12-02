import processing.video.*;

Capture cam;

float delta = 0.0;
int lightRadius = 5;
int trackerRadius = 50;
boolean isProjection = true;
boolean isCalibration = false;
float[] trackCenter = {249.0, 250.0, 249.0};
float[] trackSide = {200.0, 200.0, 249.0};

int projectionRadius = 150;

void setup() {
  
  size(1280, 960);
  
  String[] cameras = Capture.list();
  int cameraIdx = 0;
  
  if (cameras.length == 0) {
    println("No available camera");
    exit();
  } else {
    println("Available cameras");
    for (int i = 0; i < cameras.length; i ++) {
      println(i, cameras[i]);
    }
    println("Selected camera");
    println(cameras[cameraIdx]);
    cam = new Capture(this, cameras[cameraIdx]);
    cam.start();     
    delay(3000);
    smooth();
  }
}

void captureEvent(Capture cam) {
  cam.read(); 
}

void draw() {
  
  loadPixels();
  cam.loadPixels();
  
  if (!isProjection) {
    image(cam, 0, 0);
  }
  
  if (isCalibration) {
    int pointerIdx = mouseX + mouseY * width;
    int pointerPxl = cam.pixels[pointerIdx];
    println(red(pointerPxl), green(pointerPxl), blue(pointerPxl));
  }
  
  int cntP = 0;
  int sumX = 0;
  int sumY = 0;
  
  for (int y = 0; y < height; y ++) {
    for (int x = 0; x < width; x ++) {
      
      int captureIdx = x + y * cam.width;
      int capturePxl = cam.pixels[captureIdx];
      
      if (red(capturePxl) >= trackCenter[0] && green(capturePxl) >= trackCenter[1] && blue(capturePxl) >= trackCenter[2]) {
        

        int flag = 0;
          
        int cntL = 1;
        while (cntL < trackerRadius && (captureIdx - cntL - 1) % width > 0) {
          int captureL = cam.pixels[captureIdx - cntL];
          if (red(captureL) <= trackSide[0] && green(captureL) <= trackSide[1] && blue(captureL) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntL += 1;
        }
        
        int cntR = 1;
        while (cntR < trackerRadius && (captureIdx + cntR - 1) % width < (width - 1)) {
          int captureR = cam.pixels[captureIdx + cntR];
          if (red(captureR) <= trackSide[0] && green(captureR) <= trackSide[1] && blue(captureR) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntR += 1;
        }
        
        int cntU = lightRadius;
        while (cntU < trackerRadius && captureIdx - cntU * width > 0) {
          int captureU = cam.pixels[captureIdx - cntU * width]; 
          if (red(captureU) <= trackSide[0] && green(captureU) <= trackSide[1] && blue(captureU) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntU += 1;
        }
         
        int cntD = lightRadius;
        while (cntD < trackerRadius && captureIdx + cntD * width < height * width) {
          int captureD = cam.pixels[captureIdx + cntD * width];
          if (red(captureD) <= trackSide[0] && green(captureD) <= trackSide[1] && blue(captureD) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntD += 1;
        }
       
        if (flag == 4) {
          cntP += 1;
          sumX += x;
          sumY += y;
          //noFill();
          //stroke(0, 0, 255);
          //ellipse(x, y, 20, 20);
        }
      }    
    }
  }
  
  delta += 0.2;
  fill(0, 128);
  rect(0, 0, width, height);
  int radius = 25;
  
  if (cntP != 0) {    
    pushMatrix();
    translate(sumX / cntP, sumY / cntP);
    rotate(delta);
    noStroke();
    fill(255, 0, 0);
    ellipse(40 * cos(0), 40 * sin(0), radius, radius);
    ellipse(40 * cos(2 * PI / 3), 40 * sin(2 * PI / 3), radius, radius);
    ellipse(40 * cos(4 * PI / 3), 40 * sin(4 * PI / 3), radius, radius);
    popMatrix();
  }
}