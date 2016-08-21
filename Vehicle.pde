/* -----------------------------------------------------------------------------
Most of this class comes from Nature of Code
----------------------------------------------------------------------------- */

class Vehicle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float maxSpeed;
  float maxForce;
  color col;
  
  /* -----------------------------------------------------------------------------
  Init
  ----------------------------------------------------------------------------- */
  Vehicle(PVector pos){
    position = pos.copy();
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = 1;
    maxSpeed = 10;
    maxForce = 0.5;
    col = color(180);
  }
  
  Vehicle(PVector pos, color col_){
    position = pos.copy();
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = 1;
    maxSpeed = 10;
    maxForce = 0.5;
    col = col_;
  }
  
  /* -----------------------------------------------------------------------------
  Display
  draws the vehicle to the screen as a rectangle
  ----------------------------------------------------------------------------- */
  void display(){
    stroke(0,150);
    fill(col);
    
    //face direction of travel
    float theta = velocity.heading();
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    rectMode(CENTER);
    rect(0,0, 10, 5);
    popMatrix();
  }
  
  /* -----------------------------------------------------------------------------
  update
  Applies physics to the vehicle
  ----------------------------------------------------------------------------- */
  void update(){
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    
    //reset acceleration
    acceleration.mult(0);
  }
  
  /* -----------------------------------------------------------------------------
  isInWindow
  Checks if the vehicle is within the window
  ----------------------------------------------------------------------------- */
  boolean isInWindow() {
    if(position.x < 0 ||
      position.x > width ||
      position.y < 0 ||
      position.y > height) {
        return false;
    }
    return true;
  }
  
  /* -----------------------------------------------------------------------------
  Apply force using F = ma
  ----------------------------------------------------------------------------- */
  void applyForce(PVector force) {
    acceleration.add(PVector.div(force,mass));
  }
  
  /* -----------------------------------------------------------------------------
  Seek
  move towards a target based on current movement
  ----------------------------------------------------------------------------- */
  void seek(PVector target) {
    PVector desired = PVector.sub(target,position);
    float d = desired.mag();
    desired.normalize();
    
    //slow down as you get closer
    if (d < 5*maxSpeed) {
      float m = map(d,0,100,0,maxSpeed);
      desired.mult(m);
    } else {
      desired.mult(maxSpeed);
    }
 
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  
  /* -----------------------------------------------------------------------------
  Wander
  Causes the vehicle to move aimlessly and randomly
  ----------------------------------------------------------------------------- */
  void wander() {
    //predict next position
    PVector predicted = PVector.add(position, PVector.mult(velocity,20));
    //wander in a random direction from there
    float theta = random(0,2*PI);
    float r = 100;
    PVector wander = new PVector(r*cos(theta), r*sin(theta));
    wander.add(predicted);
    //calculate the desired vector
    PVector desired = PVector.sub(wander, position);
    desired.normalize();
    desired.mult(maxSpeed);
    
    //apply this movement
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  
  /* -----------------------------------------------------------------------------
  flow
  causes the vehicle to be affected by a flow field
  ----------------------------------------------------------------------------- */
  void flow(FlowField field, float strength){
    PVector desired = field.lookup(PVector.add(position,velocity));
    desired.normalize();
    desired.mult(maxSpeed*strength);
    
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce*strength);
    applyForce(steer);
  }
  
  /* -----------------------------------------------------------------------------
  followPath
  Causes the vehicle to follow the nearest segment of a given linear path
  ----------------------------------------------------------------------------- */
  void  followPath(Path path) {
    PVector predict = velocity.copy();
    predict.normalize();
    predict.mult(3*maxSpeed);
    predict.add(position);
    
    PVector target = null;
    PVector pathSeg = null;
    float record=100000;
    
    //get normal points ahead on path based on predicted location
    for(int i = 0; i < path.points.size()-1;i++) {
      PVector a = path.points.get(i);
      PVector b = path.points.get(i+1);
      PVector normalPoint = getNormalPoint(predict, a, b);
      
      //confine normal to line segment, choosing nearest point
      if (normalPoint.x < min(a.x,b.x) || normalPoint.x > max(a.x,b.x)) {
        if(PVector.dist(normalPoint, a) < PVector.dist(normalPoint, b)) {
          normalPoint = a.copy();
        } else {
          normalPoint = b.copy();
        }
      }
      
      //find closest normal
      float distance = PVector.dist(predict, normalPoint);
      if(distance < record) {
        record = distance;
        target = normalPoint.copy();
        pathSeg = PVector.sub(b,a);
      }
    }
    
    //seek further along if on path
    if(PVector.dist(predict, target) < path.radius) {
      //target is very ahead of normal point
      target = pathSeg.normalize().mult(6*maxSpeed).add(target);
      seek(target);
    } else {
      //target is slightly ahead of normal point
      target = pathSeg.normalize().mult(3*maxSpeed).add(target);
      seek(target);
    }
    
  }
  
  /* -----------------------------------------------------------------------------
  seperate
  Causes a vehicle to move away from high concentrations of others
  ----------------------------------------------------------------------------- */
  void seperate(ArrayList<Vehicle> vehicles) {
    float personalSpace = 20;
    PVector sum = new PVector();
    int count = 0;
    
    for(Vehicle other : vehicles) {
      float distance = PVector.sub(position, other.position).magSq();
      
      //check distance and also ignore self
      if( (distance > 0) && (distance < personalSpace*personalSpace)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(distance);
        sum.add(diff);
        count ++;
      }
    }
    
    //move away super fast like
    if( count > 0) {
      sum.div(count);
      sum.setMag(maxSpeed);
      
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      
      applyForce(steer);
    }
  }
  
  /* -----------------------------------------------------------------------------
  cohesion
  causes vehicle to move close to others
  ----------------------------------------------------------------------------- */
  void cohesion(ArrayList<Vehicle> vehicles) {
  PVector sum = new PVector();
  int count = 0;
    
    for(Vehicle other : vehicles) {
      float distance = PVector.sub(position, other.position).magSq();
      
      //check distance and also ignore self
      if( (distance > 50*50)) {
        PVector diff = PVector.sub(other.position, position);
        diff.normalize();
        diff.mult(distance/2500);
        sum.add(diff);
        count ++;
      }
    }
    
    //maintain order
    if( count > 0) {
      sum.div(count);
      sum.setMag(maxSpeed);
      
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      
      applyForce(steer);
    }
  }
  
  /* -----------------------------------------------------------------------------
  getNormalPoint
  use vector arithmetic to get point normal to a line
  ----------------------------------------------------------------------------- */
  PVector getNormalPoint(PVector pos, PVector a, PVector b) {
    PVector ap = PVector.sub(pos,a);
    PVector ab = PVector.sub(b,a);
    
    ab.normalize();
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    
    return(normalPoint);
  }
}