class VehicleSystem {
  ArrayList<Vehicle> vehicles;
  color col;
  boolean flock;
  Path path;
  
  /* -----------------------------------------------------------------------------
  Init
  Randomly populates the list of vehicles
  ----------------------------------------------------------------------------- */
  VehicleSystem(float borderW, float borderH, color col_) {
    vehicles = new ArrayList();
    col = col_;
    
    for(int i = 0; i < 1000; i ++){
      vehicle = new Vehicle(new PVector(random(borderW,width-borderW), random(borderH,height-borderH)), col);
      vehicles.add(vehicle);
    }
  }
  
  /* -----------------------------------------------------------------------------
  Run
  Uses an iterator to cycle through all the vehicles
  Causes them to be affected by the flow field, and follow the path
  Also allows for some flocking behaviour if enabled
  Removes vehicles when they leave the screen
  ----------------------------------------------------------------------------- */
  void run() {
    Iterator<Vehicle> it = vehicles.iterator();
    while (it.hasNext()) {
      Vehicle vehicle = it.next();
      vehicle.flow(field, 0.99);
      vehicle.followPath(path);
      
      if(flock) {
        vehicle.seperate(vehicles);
        vehicle.cohesion(vehicles);
      }
      
      vehicle.update();
      vehicle.display();
      
      if (!vehicle.isInWindow()) {
        it.remove();
      }
    }
  }
  
  
}