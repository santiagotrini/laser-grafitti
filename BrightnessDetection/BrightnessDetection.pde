// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-11: Simple color tracking

import processing.video.*;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor; 

float threshold = 254;

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
  //image(video, 0, 0);
  
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
      float currentBrightness = brightness(video.pixels[loc]);
      /*
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.
      */
      if (currentBrightness > threshold) {
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    println("HOLAAAAA");
    println(avgX + ", " + avgY);
    // Draw a circle at the tracked pixel
    fill(178, 193, 217);
    strokeWeight(4.0);
    stroke(178, 193, 217);
    // mapear resoluciones
    float avgX_map, avgY_map;
    avgX_map = map(avgX, 0, 640, 0, 800);
    avgY_map = map(avgY, 0, 480, 0, 600);
    ellipse(avgX_map, avgY_map, 10, 10);
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
  if (keyCode == UP) {
    background(0);
  }
}
