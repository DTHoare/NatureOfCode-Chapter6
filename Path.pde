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
  display
  Debugging function draws the path to screen
  ----------------------------------------------------------------------------- */
  void display() {
    //path boundary
    strokeWeight(radius*2);
    stroke(0,100);
   for (PVector v : points){
     vertex(v.x, v.y);
   }
   endShape();
    //centre line
    strokeWeight(1);
    stroke(0);
    for (PVector v : points){
     vertex(v.x, v.y);
   }
   endShape();
  }
}