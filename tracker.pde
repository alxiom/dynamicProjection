import processing.video.*;

Capture cam;

int trackerRadius = 50;
boolean isProjection = false;
boolean isCalibration = true;
float[] trackerCenterColor = {249.0, 250.0, 249.0};
float[] trackerSideColor = {200.0, 250.0, 249.0};

int projectionRadius = 150;

void setup() {
  size(1280, 960);
  
  String[] cameras = Capture.list();
  int cameraIdx = 0;
  
  if (cameras.length == 0) {
    println("No available cameras");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i ++) {
      println(i, cameras[i]);
    }
    
    println(cameras[cameraIdx]);
    cam = new Capture(this, cameras[cameraIdx]);
    cam.start();     
  }   
  delay(3000);
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
    int pointerPixel = cam.pixels[pointerIdx];
    //float pointerR = red(cam.pixels[pointerIdx]);
    //float pointerG = green(cam.pixels[pointerIdx]);
    //float pointerB = blue(cam.pixels[pointerIdx]);
    //println(pointerR, pointerG, pointerB);
    println(red(pointerPixel), green(pointerPixel), blue(pointerPixel));
  }
  
  for (int y = 0; y < height; y ++) {
    for (int x = 0; x < width; x ++) {
      int captureIdx = x + y * cam.width;
      float pR = red(cam.pixels[captureIdx]);
      float pG = green(cam.pixels[captureIdx]);
      float pB = blue(cam.pixels[captureIdx]);
      
      if (pR >= 249.0 && pG >= 250.0 && pB >= 249.0) {
        
        int flagL = 0;
        int flagR = 0;
        int flagD = 0;
        int flagU = 0;
        
        int cntL = 1;
        int cntR = 1;
        int cntU = 1;
        int cntD = 1;
        
        while (cntL < trackerRadius && (captureIdx - cntL) % width > 0) {
          float lR = red(cam.pixels[captureIdx - cntL]);
          float lG = green(cam.pixels[captureIdx - cntL]);
          float lB = blue(cam.pixels[captureIdx - cntL]);
           
          if (lR <= 200.0 && lG >= 250.0 && lB >= 249.0) {
            
            flagL = 1;
            break;
          }
          cntL = cntL + 1;
        }
        
        while (cntR < trackerRadius && (captureIdx + cntR) % width < (width - 1)) {
          float rR = red(cam.pixels[captureIdx + cntR]);
          float rG = green(cam.pixels[captureIdx + cntR]);
          float rB = blue(cam.pixels[captureIdx + cntR]);
           
          if (rR <= 200.0 && rG >= 250.0 && rB >= 249.0) {
            flagR = 1;
            break;
          }
          cntR = cntR + 1;
        }
         
        while (cntU < trackerRadius && (captureIdx - cntU * width) / height > 1) {
          float uR = red(cam.pixels[captureIdx - cntU * width]);
          float uG = green(cam.pixels[captureIdx - cntU * width]);
          float uB = blue(cam.pixels[captureIdx - cntU * width]);
           
          if (uR <= 200.0 && uG >= 250.0 && uB >= 249.0) {
            flagU = 1;
            break;
          }
          cntU = cntU + 1;
        }
         
        while (cntD < trackerRadius && (captureIdx + cntD * width) / height < (height - 1)) {
          float dR = red(cam.pixels[captureIdx + cntD * width]);
          float dG = green(cam.pixels[captureIdx + cntD * width]);
          float dB = blue(cam.pixels[captureIdx + cntD * width]);
           
          if (dR <= 200.0 && dG >= 250.0 && dB >= 249.0) {
            flagD = 1;
            break;
          }
          cntD = cntD + 1;
        }
       
        if (flagL * flagR * flagU * flagD != 0) {  
          noFill();
          stroke(0, 0, 255);
          ellipse(x, y, 20, 20);
        }
      }
      //pixels[captureIdx] = color(pR, pG, pB);
    }
  }
  
  //updatePixels();
  
  //int mloc = mouseX + mouseY * width;
  //float mr = red(cam.pixels[mloc]);
  //float mg = green(cam.pixels[mloc]);
  //float mb = blue(cam.pixels[mloc]);
  //println(mr, mg, mb);
  
  
  //for (int y = 0; y < height - stride; y += 10) {
  //  for (int x = 0; x < width - stride; x += 10) {
  //    float rSum = 0.0;
  //    float gSum = 0.0;
  //    float bSum = 0.0;
  //    for (int ys = 0; ys < stride; ys ++) {
  //      for (int xs = 0; xs < stride; xs ++) {
  //        int loc = (x + xs) + (y + ys) * width; 
  //        rSum += red(cam.pixels[loc]);
  //        gSum += green(cam.pixels[loc]);
  //        bSum += blue(cam.pixels[loc]);
  //      }
  //    }
  //    float rAvg = rSum / stride / stride;
  //    float gAvg = gSum / stride / stride;
  //    float bAvg = bSum / stride / stride;      
  //    if (rAvg <= 200.0 && gAvg >= 255.0 && bAvg >= 255.0) {
  //      noFill();
  //      stroke(0, 0, 255);
  //      ellipse(x, y, 20, 20);
  //    }
      
  //  }
  //}
  
  //for (int x = 0; x < cam.width; x++) {    
  //  for (int y = 0; y < cam.height; y++) {      
  //    // Calculate the 1D location from a 2D grid
  //    int loc = x + y * cam.width;      
    
  //    // Get the red, green, blue values from a pixel      
  //    float r = red  (cam.pixels[loc]);      
  //    float g = green(cam.pixels[loc]);      
  //    float b = blue (cam.pixels[loc]);      
      
  //    // Calculate an amount to change brightness based on proximity to the mouse      
  //    float d = dist(x, y, mouseX, mouseY);      
  //    float adjustbrightness = map(d, 0, 100, 4, 0);      
  //    r *= adjustbrightness;      
  //    g *= adjustbrightness;      
  //    b *= adjustbrightness;      
      
  //    // Constrain RGB to make sure they are within 0-255 color range      
  //    r = constrain(r, 0, 255);      
  //    g = constrain(g, 0, 255);      
  //    b = constrain(b, 0, 255);      
    
  //    // Make a new color and set pixel in the window      
  //    color c = color(r, g, b);      
  //    pixels[loc] = c;    
  //  }  
  //}  
  
  //updatePixels();
  
  
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