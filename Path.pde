class Path {
  ArrayList<PVector> points;
  float radius;
  
  /* -----------------------------------------------------------------------------
  Init
  ----------------------------------------------------------------------------- */
  Path() {
    radius = 20;
    points = new ArrayList<PVector>();
  }
  
  /* -----------------------------------------------------------------------------
  addPoint
  allows a point to be added using coordinates seperately or as a vector
  ----------------------------------------------------------------------------- */
  void addPoint(float x, float y){
    PVector point = new PVector(x,y);
    points.add(point);
  }
  
  void addPoint(PVector vec) {
    points.add(vec.copy());
  }
  
  /* -----------------------------------------------------------------------------
  creation
  Create different types of path
  ----------------------------------------------------------------------------- */
  void leftToRightLine() {
    PVector one = new PVector(0, random(0,height));
    PVector two = new PVector(width, random(0,height));
    this.addPoint(one);
    this.addPoint(two);
  }
  
  void rightToLeftLine() {
    PVector one = new PVector(width, random(0,height));
    PVector two = new PVector(0, random(0,height));
    this.addPoint(one);
    this.addPoint(two);
  }
  
  void topToBottomLine() {
    PVector one = new PVector(random(0,width), 0);
    PVector two = new PVector(random(0,width), height);
    this.addPoint(one);
    this.addPoint(two);
  }
  
  void bottomToTopLine() {
    PVector one = new PVector(random(0,width), height);
    PVector two = new PVector(random(0,width), 0);
    this.addPoint(one);
    this.addPoint(two);
  }
  
  void spiralOutwards() {
    float a = 4;
    float w = 0.2;
    PVector centre = new PVector(width/2, height/2);
    for(int i = 0; i<100;i++) {
      PVector p = new PVector(a*i*cos(w*i), a*i*sin(w*i));
      this.addPoint(p.add(centre));
    }
  }
  
  void cornerChainsLR() {
    float y;
    float sign = round(random(2)-1);
    for(int i = 0; i < 9; i++) {
      y = height/2 + sign*(i-4)*(i-4)*(height/2 / 16);
      PVector point = new PVector(i*width/8, y);
      this.addPoint(point);
    }
  }
  
  void cornerChainsRL() {
    float y;
    float sign = round(random(2)-1);
    for(int i = 8; i >= 0; i--) {
      y = height/2 + sign*(i-4)*(i-4)*(height/2 / 16);
      PVector point = new PVector(i*width/8, y);
      this.addPoint(point);
    }
  }
  
  /* -----------------------------------------------------------------------------
  display
  Debugging function draws the path to screen
  ----------------------------------------------------------------------------- */
  void display() {
    //path boundary
    strokeWeight(radius*2);
    stroke(0,100);
   beginShape(); 
   for (PVector v : points){
     vertex(v.x, v.y);
   }
   endShape();
    //centre line
    strokeWeight(1);
    stroke(0);
   beginShape();
    for (PVector v : points){
     vertex(v.x, v.y);
   }
   endShape();
  }
}