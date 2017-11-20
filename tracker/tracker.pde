import processing.video.*;

Capture cam;

int trackerRadius = 50;
boolean isProjection = false;
boolean isCalibration = false;
float[] trackCenter = {249.0, 250.0, 249.0};
float[] trackSide = {200.0, 250.0, 249.0};

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
  
  for (int y = 0; y < height; y ++) {
    for (int x = 0; x < width; x ++) {
      int captureIdx = x + y * cam.width;
      int capturePxl = cam.pixels[captureIdx];
      
      if (red(capturePxl) >= trackCenter[0] && green(capturePxl) >= trackCenter[1] && blue(capturePxl) >= trackCenter[2]) {
        
        int flag = 0;
        
        int cntL = 1;
        while (cntL < trackerRadius && (captureIdx - cntL - 1) % width > 0) {
          int captureL = cam.pixels[captureIdx - cntL];
          if (red(captureL) <= trackSide[0] && green(captureL) >= trackSide[1] && blue(captureL) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntL += 1;
        }
        
        int cntR = 1;
        while (cntR < trackerRadius && (captureIdx + cntR - 1) % width < (width - 1)) {
          int captureR = cam.pixels[captureIdx + cntR];       
          if (red(captureR) <= trackSide[0] && green(captureR) >= trackSide[1] && blue(captureR) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntR += 1;
        }
        
        int cntU = 1;
        while (cntU < trackerRadius && (captureIdx - cntU * width) / height > 0) {
          int captureU = cam.pixels[captureIdx - cntU * width]; 
          if (red(captureU) <= trackSide[0] && green(captureU) >= trackSide[1] && blue(captureU) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntU += 1;
        }
         
        int cntD = 1;
        while (cntD < trackerRadius && (captureIdx + cntD * width) / height < (height - 1)) {
          int captureD = cam.pixels[captureIdx + cntD * width];
          if (red(captureD) <= trackSide[0] && green(captureD) >= trackSide[1] && blue(captureD) >= trackSide[2]) {
            flag += 1;
            break;
          }
          cntD += 1;
        }
       
        if (flag == 4) {  
          noFill();
          stroke(0, 0, 255);
          ellipse(x, y, 20, 20);
        }
        
        
        
      }
    }
  }
}


//import processing.video.*;
 
//Capture video;
 
//PImage prevFrame;
 
//float threshold = 150;
//int Mx = 0;
//int My = 0;
//int ave = 0;
 
//int ballX = width/8;
//int ballY = height/8;
//int rsp = 5;
 
//void setup() {
//  size(320, 240);
//  video = new Capture(this, width, height, 30);
//  video.start();
//  prevFrame = createImage(video.width, video.height, RGB);
//}
 
//void draw() {
 
 
//  if (video.available()) {
 
//    prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
//    prevFrame.updatePixels();
//    video.read();
//  }
 
//  loadPixels();
//  video.loadPixels();
//  prevFrame.loadPixels();
 
//  Mx = 0;
//  My = 0;
//  ave = 0;
 
 
//  for (int x = 0; x < video.width; x ++ ) {
//    for (int y = 0; y < video.height; y ++ ) {
 
//      int loc = x + y*video.width;            
//      color current = video.pixels[loc];      
//      color previous = prevFrame.pixels[loc]; 
 
 
//      float r1 = red(current); 
//      float g1 = green(current); 
//      float b1 = blue(current);
//      float r2 = red(previous); 
//      float g2 = green(previous); 
//      float b2 = blue(previous);
//      float diff = dist(r1, g1, b1, r2, g2, b2);
 
 
//      if (diff > threshold) { 
//        pixels[loc] = video.pixels[loc];
//        Mx += x;
//        My += y;
//        ave++;
//      } 
//      else {
 
//        pixels[loc] = video.pixels[loc];
//      }
//    }
//  }
//  fill(255);
//  rect(0, 0, width, height);
//  if (ave != 0) { 
//    Mx = Mx/ave;
//    My = My/ave;
//  }
//  if (Mx > ballX + rsp/2 && Mx > 50) {
//    ballX+= rsp;
//  }
//  else if (Mx < ballX - rsp/2 && Mx > 50) {
//    ballX-= rsp;
//  }
//  if (My > ballY + rsp/2 && My > 50) {
//    ballY+= rsp;
//  }
//  else if (My < ballY - rsp/2 && My > 50) {
//    ballY-= rsp;
//  }
 
//  updatePixels();
//  noStroke();
//  fill(0, 0, 255);
//  ellipse(ballX, ballY, 20, 20);
//}