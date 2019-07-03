import processing.video.*;
float x, y, sumX, sumY, cant, xant, yant;
int tiempo=0;
Capture cam;
int TH = 255;
void setup() {
  //size(640, 480);
  fullScreen(2);
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[102]);
    cam.start();
  }
  background(0);
}

void draw() {
  if(keyPressed)background(0);
  if (cam.available() == true) {
    cam.read();


    xant =x;
    yant =y;
    x =0;
    y =0;
    sumX =0;
    sumY =0;
    cant =0;
    filtrarImg(cam);
    //PVector p = brightPointDetector();
     image(cam, 0, 0, width, height);
    tiempo+=5;
   if(tiempo>100){
    if (xant !=0 && x!=0) {
     stroke(255,0,0);
    strokeWeight(5);
    x=map(x, 0, 640, 0-20, 800-60);
    y=map(y, 0, 480, 0-20, 600-40);
     line(x, y, xant,yant);
      fill(255, 0, 0);
    //  ellipse(map(x, 0, 640, 0, 800), map(y, 0, 480, 0, 600), 25, 25);
    }
   }
  }
}


void filtrarImg(PImage img) {
  img.loadPixels();

  for (int x =0; x<img.width; x++) {
    for (int y =0; y<img.height; y++) {
      int i = y*img.width + x;
      if (brightness(img.pixels[i])<TH) {
        img.pixels[i] = 0;
      } else {
        cant++;
        sumX+=x;
        sumY+=y;
      }
    }
  }
  img.updatePixels();
  if (cant>0) {
    x=sumX/cant;
    y= sumY/cant;
    println(x, y);
  }
}

/*
PVector brightPointDetector() {
 int idx = 0;
 float max = 0;
 cam.loadPixels();
 for (int i = 0; i < cam.pixels.length; i++) {
 float pb = brightness(cam.pixels[i]);
 if ( pb >= max) {
 max = pb;
 idx = i;
 }
 }
 int x = idx%cam.width;
 int y = (idx-x)/cam.width;
 return new PVector(x, y);
 }
 */
