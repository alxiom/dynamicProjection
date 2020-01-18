int record = 5;
int radious = 50;
float[] snapshotX = new float[record];
float[] snapshotY = new float[record];

void setup() {
  size(1280, 720);
  println(width);
  println(height);
  noStroke();
  background(0);
}

void draw() {
  background(0);
  watchMouse(color(255, 128, 128));
  recordMouse();
}

void keyPressed() {
  for (int i = record - 2; i >= 0; i --) {
    snapshotX[i + 1] = snapshotX[i];
    snapshotY[i + 1] = snapshotY[i];
  }
  snapshotX[0] = mouseX;
  snapshotY[0] = mouseY;
}

void watchMouse(color c) {
  fill(c);
  noStroke();
  ellipse(mouseX, mouseY, radious, radious);
}

void recordMouse() {
  for (int i = 0; i < record; i++) {
    fill(int(255 * (1.0 - i / float(record))));
    noStroke();
    ellipse(snapshotX[i], snapshotY[i], radious, radious);
  }
}
