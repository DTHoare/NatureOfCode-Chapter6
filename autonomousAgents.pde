Vehicle vehicle;
FlowField field;
Path path1;
Path path2;
ArrayList<Vehicle> vehicles = new ArrayList();

void setup(){
  size(800,800);
  background(255);
  frameRate(30);
  
  //vehicle = new Vehicle(new PVector(width/2, height/2));
  for(int i = 0; i < 20000; i ++){
    vehicle = new Vehicle(new PVector(random(100,700), random(100,700)));
    vehicles.add(vehicle);
  }
  field = new FlowField(5);
  path1 = new Path();
  path2 = new Path();
  //path.display();
}

void draw(){
  //vehicle.seek(new PVector(mouseX,mouseY));
  //vehicle.wander();
  //vehicle.flow(field, 0.9);
  //vehicle.update();
  //vehicle.display();
  for(Vehicle vehicle:vehicles){
   vehicle.flow(field, 0.95);
   vehicle.followPath(path1);
   vehicle.followPath(path2);
   vehicle.update();
   vehicle.display();
  }
}

void mousePressed(){
  saveFrame("capture_#######.png");
}