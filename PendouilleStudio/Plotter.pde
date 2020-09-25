
class Plotter2D{
 
  ArrayList<Float> plotValue = new ArrayList<Float>();
  
  float scale = 20;
  int offset = 0;
  
  int period = 200;
  
  
  Plotter2D(){}
  
 void plot(float value){
  plotValue.add(value); 
 }
 
 void reset(){
   plotValue.clear();
   
    float sum = 0;
    float max = 20;
    int min = -20;
    int index = 0;
    
    for (int i = 0; i < plotValue.size(); i++){
      sum+=plotValue.get(i);
      if(abs(plotValue.get(i)) > max) max = abs(plotValue.get(i));
      if(plotValue.get(i) <= min) min = int(plotValue.get(i));
      index++;
    }
    //scale = 10;
 }
 
  void update(){
    showCoord();
    display();
  }
  
  
  
  void showCoord(){
    stroke (0,254,254);
    fill (0,254,254);  
    strokeWeight(4);   // Thicker
    line(0, height, 0, 0);
    text ("x", width-10, height-10);
    line(0, height - offset, width, height - offset);
    text ("y", 10, 10);
    strokeWeight(1);   // thin
  }
  
  void display(){
      
      stroke(0,222,0);
      line (0,height/2,width,height/2);
      float oldResultX =0;
      float oldResultY =0;
      stroke (222,50,60);
      
  
      for (int i = 0; i < plotValue.size(); i++) {
        //line(30, i, 80, i);
  
        float resultScreen = float(height)/2 - (plotValue.get(i) * scale) + 206.0*scale;
        point ( float(i)/float(width/period), resultScreen - offset) ; 
  
        line (oldResultX,oldResultY - offset,(i)/(width/period),resultScreen - offset);
        oldResultX=(i)/(width/period); 
        oldResultY=resultScreen;
        
        if(i/width*period > width || plotValue.size() == 1){
           reset();
           stroke (0);
           return;
        }
      } // for
      stroke (0);
  }
  
  
}
