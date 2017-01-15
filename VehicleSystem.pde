class VehicleSystem {
  ArrayList<Vehicle> vehicles;
  color col;
  boolean flock;
  boolean uniform;
  Path path;
  
  /* -----------------------------------------------------------------------------
  Init
  Randomly populates the list of vehicles
  ----------------------------------------------------------------------------- */
  VehicleSystem(float borderW, float borderH, color col_, int N) {
    vehicles = new ArrayList();
    col = col_;
    color colMod;
    
    if(random(0,1) <0.7) {
      uniform = true;
    } else {
      uniform = false;
    }
    
    for(int i = 0; i < N; i ++){
      if(uniform) {
        colMod = col;
      } else {
        colMod = color(hue(col), saturation(col)+random(-20,60), brightness(col));
      }
      Vehicle vehicle = new Vehicle(new PVector(random(borderW,width-borderW), random(borderH,height-borderH)), colMod);
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
  
  /* -----------------------------------------------------------------------------
  isEmpty
  Checks if any vehicles remain
  ----------------------------------------------------------------------------- */
  boolean isEmpty() {
    if(vehicles.size() == 0) {
      return true;
    }
    return false;
  }
  
}