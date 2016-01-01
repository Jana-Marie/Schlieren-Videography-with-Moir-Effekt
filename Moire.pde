import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
Capture before;

PImage  after, grayDiff, in;

boolean capture, blur, rend = false;

void setup() {

  size(720, 576, P2D);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    exit();
  } else {
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[0]);
    }
  }

  before = new Capture(this, cameras[1]);  //Kamera öffnen
  before.start();

  getFrame();
  
  before.read();  
  opencv = new OpenCV(this, before); //Neues Objekt
}

void draw() {
  if (before.available() == true) {
    before.read();
  }

  opencv.loadImage(before);   //objekt laden

  if (rend != true) {
    opencv.diff(after); //Differenz berechnen

    opencv.brightness(-9);    //Hellikkeit/Kontrast verbessern
    opencv.contrast(6);

    if (blur==true) {    //bei bedarf Schwammig machen
      opencv. blur(4);
    }
  } else {      //Normabild und Zoom zum abstimmen
    scale(4);
    translate(-width/8, -height/8);
  }
  
  grayDiff = opencv.getSnapshot(); //aufnehmen

  pushMatrix();
  image(grayDiff, 0, 0);
  popMatrix();
  
  if (capture==true) {
    saveFrame();
  }
}

void getFrame() {
  while (before.available() == false) {
    println("Err, Waiting");
  }
  before.read();
  image(before, 0, 0); 
  after = get(0, 0, width, height);
  background(0);
}

void keyPressed() {    //neu setzen
  if (key == 'c') {
    getFrame();
  }
  if (key == 's') {
    //saveFrame();
    capture = !capture;
    println("!");
  }
  if (key == 'b') {
    blur = !blur;
  }
  if (key == 'o') {
    rend = ! rend;
  }
}
