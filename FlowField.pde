class FlowField {
  PVector[][] field;
  int cols, rows;
  int resolution;
  
  /* -----------------------------------------------------------------------------
  Init
  ----------------------------------------------------------------------------- */

  FlowField(int res) {
    resolution = res;
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    
    noiseField();
  }
  
  /* -----------------------------------------------------------------------------
  noiseField
  create a flow field based off of perlin noise
  ----------------------------------------------------------------------------- */
  void noiseField(){
    //use xoff and yoff as offsets for perlin noise
    float xoff = 0;
      for (int i = 0; i < cols; i++) {
      float yoff = 0;
        for (int j = 0; j < rows; j++) {
          //create noise
          //if you use 0 to 2PI it averages PI ?
          float theta = stretch(noise(xoff,yoff), 5);
          theta = map(theta,0,1,0,2*PI);
          field[i][j] = new PVector(cos(theta),sin(theta));
          yoff += 0.05;
        }
      xoff += 0.05;
      }
    }
    
  /* -----------------------------------------------------------------------------
  lookup
  look up a co ordinate within the flow field, constraining to limits
  ----------------------------------------------------------------------------- */
  PVector lookup(PVector loc){
    int column = int(constrain(loc.x/resolution,0,cols-1));
    int row = int(constrain(loc.y/resolution,0,rows-1));
    
    return field[column][row].copy();
  }
 
}

/* -----------------------------------------------------------------------------
stretch
idea by Paolo Ceric
applies a function which stretches the gaussian like nature of perlin noise
in order to get something more uniform but still smoothly varying
----------------------------------------------------------------------------- */
float stretch(float p, float g){
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}