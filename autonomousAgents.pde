/* -----------------------------------------------------------------------------
autonomousAgents.pde
Daniel Hoare 2016
Based on the corresponding Nature of Code chapter by Daniel Shiffman
----------------------------------------------------------------------------- */ 
import java.util.*;

/* -----------------------------------------------------------------------------
Globals
----------------------------------------------------------------------------- */ 
Vehicle vehicle;
FlowField field;
Path path1;
Path path2;
Path path3;
Path path4;
VehicleSystem vehicles;
VehicleSystem vehicles2;
VehicleSystem vehicles3;
VehicleSystem vehicles4;

/* -----------------------------------------------------------------------------
Setup
----------------------------------------------------------------------------- */
void setup(){
  //setup canvas
  size(1024,512);
  background(255);
  frameRate(30);
  colorMode(HSB);
  
  //properties for vehicleSystems
  float borderW = random(200,400);
  float borderH = random(100,200);
  
  //use two different colours for vehicles
  //chose complimentary or secondary colours
  float hue = random(0,255);
  float hue2;
  if(random(0,1) > 0.5) {
    hue2 = (hue + 128)%255;
  } else {
    hue2 = (hue + 64)%255;
  }
  color col1 = color(hue,255,205);
  color col2 = color(hue2,255,205);

  //make vehicleSystems
  vehicles = new VehicleSystem(borderW, borderH, col1);
  vehicles2 = new VehicleSystem(borderW, borderH, col2);
  vehicles3 = new VehicleSystem(borderW, borderH, col1);
  vehicles4 = new VehicleSystem(borderW, borderH, col2);
  
  //make field: vector force field applied to vehicles
  field = new FlowField(2);
  
  //make paths for vehicleSystems to follow
  path1 = new Path();
  path2 = new Path();
  path3 = new Path();
  path4 = new Path();
  
  //4 paths made, with two unique lines
  //second and fourth path are opposite of other two
  PVector one = new PVector(0, random(0,height));
  PVector two = new PVector(width, random(0,height));
  path1.addPoint(two);
  path1.addPoint(one);
  path2.addPoint(one);
  path2.addPoint(two);
  
  PVector three = new PVector(0, random(0,height));
  PVector four = new PVector(width, random(0,height));
  path3.addPoint(four);
  path3.addPoint(three);
  path4.addPoint(four);
  path4.addPoint(three);

  //update VehicleSystems
  vehicles.path = path1;
  vehicles2.path = path2;
  vehicles3.path = path3;
  vehicles4.path = path4;
  
  vehicles.flock = true;
  vehicles4.flock = true;
  
  //path.display();
}

/* -----------------------------------------------------------------------------
Draw
----------------------------------------------------------------------------- */
void draw(){
  //run the vehicleSystems
  vehicles.run();
  vehicles2.run();
  vehicles3.run();
  vehicles4.run();

}

void mousePressed(){
  saveFrame("capture_#######.png");
}