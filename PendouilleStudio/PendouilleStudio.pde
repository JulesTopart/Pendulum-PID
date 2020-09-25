
Plotter2D data;

void setup(){
  size( 1000, 800);
  
  data = new Plotter2D();
  initSerial();
  
  
}



void draw(){
  background(255);
  
  data.update();
  

  
  
}
