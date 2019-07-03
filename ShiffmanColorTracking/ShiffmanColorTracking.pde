// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-11: Simple color tracking

import processing.video.*;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor; 

boolean debug = false;
boolean showCam = true;

float threshold = 5;


float pavgX = 0;
float pavgY = 0;

void setup() {
  size(640, 480);
  //fullScreen(2);
  String[] cameras = Capture.list();
  for(int i =0; i < cameras.length; i++)
    println("Camara " + i + ": " + cameras[i]);
  // video = new Capture(this, width, height);
  video = new Capture(this, 640, 480, cameras[102]);
  video.start();
  // Start off tracking for green
  //trackColor = color(0, 255, 0);
  trackColor = -986896;
  background(0);
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  video.loadPixels();
  if (showCam)
    image(video, 0, 0);
  
  // XY coordinate of closest color
  float avgX = 0;
  float avgY = 0;

  int count = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.
      
      if (d < threshold) {
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    // Draw a circle at the tracked pixel
    fill(19, 96, 168);
    strokeWeight(6.0);
    stroke(19, 96, 168);
    // mapear resoluciones
    //float avgX_map, avgY_map;
    //avgX_map = map(avgX, 0, 640, 0, 800);
    //avgY_map = map(avgY, 0, 480, 0, 600);
    
    
    ellipse(avgX, avgY, 8, 8);
    
    //line(avgX, avgY, pavgX, pavgY);
    
    //pavgX = avgX;
    //pavgY = avgY;
    
    // ellipse(100,100,16,16);
  }
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  //trackColor = -515;
  println(trackColor);
  //background(0, 0, 0, 0.2);
}

void keyPressed() {
  if (key == 32) {
    background(0);
  }
  if (key == 'c' || key == 'C')
    showCam = !showCam;
  if (key == 'd' || key == 'D')
    debug = !debug;
}
