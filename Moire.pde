import processing.video.*;
import gab.opencv.*;

OpenCV opencv;
Capture before;

PImage  after, grayDiff, in;

boolean capture, blur, rend, erode = false;

int framecount = 0;

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


    opencv.brightness(-7);    //Hellikkeit/Kontrast verbessern
    opencv.contrast(6);

    if (erode==true) {    //Erode methode
      opencv.erode();
      opencv.dilate();
      opencv.dilate();
      opencv.erode();
    }

    if (blur==true) {    //bei bedarf Schwammig machen
      opencv. blur(8);
    }
  } else {      //Normabild und Zoom zum abstimmen
    scale(4);
    translate(-width/8, -height/8);
  }

  grayDiff = opencv.getSnapshot(); //aufnehmen

  image(grayDiff, 0, 0);

  if (capture==true) {      //daten aufnehmen
    saveFrame("schlieren/"+"schlieren-######"+".tif");
    before.save("data/"+"original-0"+(111111+framecount)+".tif");
    framecount++;
    println(framecount);
  }
}

void getFrame() {
  println("Getting reference image");

  while (before.available() == false) {
    println("Err, Waiting");
  }
  before.read();

  image(before, 0, 0);
  after = get(0, 0, width, height);
  after.save("diff_image.tif");

  println("Done");
}

void keyPressed() {    //neu setzen
  if (key == 'c') {
    getFrame();
  }
  if (key == 's') {
    capture = !capture;
  }
  if (key == 'b') {
    blur = !blur;
  }
  if (key == 'o') {
    rend = ! rend;
  }
  if (key == 'e') {
    erode = !erode;
  }
}
