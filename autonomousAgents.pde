/* -----------------------------------------------------------------------------
autonomousAgents.pde
Daniel Hoare 2016
Based on the corresponding Nature of Code chapter by Daniel Shiffman
----------------------------------------------------------------------------- */ 
import java.util.*;

/* -----------------------------------------------------------------------------
Globals
----------------------------------------------------------------------------- */ 
VehicleSystem vehicles;
Path path;
FlowField field;
ArrayList<VehicleSystem> vehicleSystems; 
ArrayList<Path> paths;
color[] colours;

/* -----------------------------------------------------------------------------
Setup
----------------------------------------------------------------------------- */
void setup(){
  //setup canvas
  size(1024,512);
  background(255);
  frameRate(30);
  colorMode(HSB);
  
  generateColours();
  
  vehicleSystems = new ArrayList<VehicleSystem>();
  paths = new ArrayList<Path>();
  int numberOfSystems = round(random(2,7));
  
  //generate vehicle systems
  for(int i=0; i < numberOfSystems; i++) {
    //properties for vehicleSystems
    float borderW = random(380,480);
    float borderH = random(190,250);
    int numberOfVehicles = round(random(20,900));
    color colour = randomColour();
    vehicles = new VehicleSystem(borderW, borderH, colour, numberOfVehicles);
    
    path = randomPath();
    vehicles.path = path;
    
    //small portion of vehicles flock
    if(random(1) > 0.3) {
      vehicles.flock=true;
      
      //large portion of vehicles that flock have a different coloured twin
      //as this looks very pleasing
      if(random(1) > 0.7) {
        color newColour = randomColour();
        while( newColour == colour) {
          newColour = randomColour();
        }
        VehicleSystem vehicles2 = new VehicleSystem(borderW, borderH, newColour, numberOfVehicles);
        vehicles2.flock=true;
        vehicles2.path = path;
        vehicleSystems.add(vehicles2);
      }
    }
    
    vehicleSystems.add(vehicles);
  }
  
  //make field: vector force field applied to vehicles
  field = new FlowField(ceil(random(1,10)));
}

/* -----------------------------------------------------------------------------
Draw
----------------------------------------------------------------------------- */
void draw(){
  //run the vehicleSystems
  for(VehicleSystem v : vehicleSystems) {
    v.run();
  }
  
  //save conditions
  
  if(allEmpty()) {
    save("image.png");
    exit();
  }
  
  if(frameCount >= 1200) {
    save("image.png");
    exit();
  }
  
  if(frameCount == 600) {
    field = new FlowField(ceil(random(1,10)));  
  }

}

/* -----------------------------------------------------------------------------
Functions
----------------------------------------------------------------------------- */
void mousePressed(){
  saveFrame("capture_#######.png");
}

void generateColours() {
  float r = random(0,1);
  if(r < 0.4) {
    twoToneColours();
    print("twotone");
  } else if(r<0.8) {
    monotoneColours();
    print("monotone");
  } else {
    pastelRainbow();
    print("rainbow");
  }
}

void twoToneColours() {
   //use two different colours for vehicles
  //chose complimentary or secondary colours
  float hue = random(0,255);
  float hue2;
  if(random(0,1) > 0.5) {
    hue2 = (hue + 128)%255;
  } else {
    hue2 = (hue + 64)%255;
  }
  float hue3 = (hue + 32)%255;
  float hue4 = (hue2 + 32)%255;
  
  color col1 = color(hue,random(120,170),215);
  color col2 = color(hue2,random(40,90),215);
  color col3 = color(hue3,random(190,210),215);
  color col4 = color(hue4,random(40,255),215);
  
  colours = new color[4];
  colours[0] = col1;
  colours[1] = col2;
  colours[2] = col3;
  colours[3] = col4;
}

//colours that are similar to each other
void monotoneColours() {
  float hue = random(0,255);
  float hue2 = (hue + 8)%255;
  float hue3 = (hue + 16)%255;
  float hue4 = (hue + 24)%255;
  
  color col1 = color(hue,random(120,170),215);
  color col2 = color(hue2,random(40,90),215);
  color col3 = color(hue3,random(120,170),215);
  color col4 = color(hue4,random(40,90),215);
  
  colours = new color[4];
  colours[0] = col1;
  colours[1] = col2;
  colours[2] = col3;
  colours[3] = col4;
}

//bright pastel colours in a large spectrum
void pastelRainbow() {
  colours = new color[7];
  float r = random(0,20);
  for(int i=0; i<7; i++) {
    colours[i] = color(r+ 255/7*i, random(50,120), 255);
  }
}

color randomColour() {
  return(colours[floor(random(colours.length))]);
}

//creates a random path out of several different types
Path randomPath() {
  Path path = new Path();
  switch(ceil(random(5))) {
    case 1:
      path.cornerChainsLR();
      break;
    case 2:
      path.cornerChainsRL();
      break;
    case 3:
      path.leftToRightLine();
      break;
    case 4:
      path.rightToLeftLine();
      break;
    case 5:
      path.topToBottomLine();
      break;
    case 6:
      path.bottomToTopLine();
      break;
  }  
  return path;
}

boolean allEmpty() {
  for(VehicleSystem v : vehicleSystems) {
    if(v.isEmpty() == false) {
      return false;  
    }
  } 
  return true;
}