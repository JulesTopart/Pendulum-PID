
class Plotter{
 
  ArrayList<Float> plotValue = new ArrayList<Float>();
  
  float scale = 1;
  int begin = 0;
  int offset = 0;
  
  Plotter(){}
  
 void plot(float value){
  plotValue.add(value); 
 }
 
 void reset(){
    float sum = 0;
    float max = 20;
    int min = -20;
    while(plotValue.size() - begin > width) begin += width;
    int index = 0;
    for (int i = begin; i < plotValue.size(); i++){
      sum+=plotValue.get(i);
      if(abs(plotValue.get(i)) > max) max = abs(plotValue.get(i));
      if(plotValue.get(i) <= min) min = int(plotValue.get(i));
      index++;
    }
    scale = ((sum/(index))*50)/max;
    /*
    if(min < 0)
      offset = int(abs(min) * scale);
    else
      offset = int(height - (min) * scale);
      */
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
    stroke (222,0,0);
    

    
    for (int i = begin; i < plotValue.size(); i++) {
      //line(30, i, 80, i);

      float resultScreen = height/2 - (plotValue.get(i) * scale);
      point ( i - begin, resultScreen - offset) ; 

      line (oldResultX-begin,oldResultY - offset,i - begin,resultScreen - offset);
      oldResultX=i; 
      oldResultY=resultScreen;
      
      if(i-begin > width || plotValue.size() == 1){
         reset();
         stroke (0);
         return;
      }
    } // for
    stroke (0);
  }
  
  
}
