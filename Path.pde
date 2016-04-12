class Path {
  PVector start;
  PVector end;
  
  float radius;
  
  Path() {
    radius = 20;
    start = new PVector(0,height/3);
    end = new PVector(width,2*height/3);
  }
  
  void display() {
    //path boundary
    strokeWeight(radius*2);
    stroke(0,100);
    line(start.x,start.y,end.x,end.y);
    //centre line
    strokeWeight(1);
    stroke(0);
    line(start.x,start.y,end.x,end.y);
  }
}