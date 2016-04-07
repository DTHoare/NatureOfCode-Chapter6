class Vehicle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float maxSpeed;
  float maxForce;
  
  Vehicle(PVector pos){
    position = pos.copy();
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = 1;
    maxSpeed = 10;
    maxForce = 0.5;
  }
  
  void display(){
    stroke(0);
    fill(180);
    
    //face direction of travel
    float theta = velocity.heading();
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    rectMode(CENTER);
    rect(0,0, 10, 5);
    popMatrix();
  }
  
  void update(){
    //apply physics
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    
    //reset acceleration
    acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    acceleration.add(PVector.div(force,mass));
  }
  
  void seek(PVector target) {
    //move towards a target based on current movement
    PVector desired = PVector.sub(target,position);
    float d = desired.mag();
    desired.normalize();
    
    //slow down as you get closer
    if (d < 100) {
      float m = map(d,0,100,0,maxSpeed);
      desired.mult(m);
    } else {
      desired.mult(maxSpeed);
    }
 
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  
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
  
  void flow(FlowField field, float strength){
    PVector desired = field.lookup(PVector.add(position,velocity));
    desired.normalize();
    desired.mult(maxSpeed*strength);
    
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxForce*strength);
    applyForce(steer);
  }
}