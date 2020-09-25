
Pendulum pendule;
Plotter plotterAngle;

float kp,ki,kd;

float error, pError, dError, sError;

float target = PI/2;

float max =  100;
float min = -100;

void setup(){
  
  size(1000,1000);
  plotterAngle = new Plotter();
  pendule = new Pendulum(new PVector(width/2,200), 100);
  
  kp = 7; //20.5
  ki = 0;   //0
  kd = 0;  //5
  
  error = dError = pError = sError = 0; 
}



void draw(){
  background(255);
  //pendule.mouseTest();
  pendule.update();
  
  float dt = 0.1;
  float pError = error;
  float error = target - pendule.GetAngle();
  
  float temp = (error) * 180/PI;
  println(temp);
  plotterAngle.plot(temp);
  
  sError += error;// * dt;
  dError = (error - pError);///dt;
  
  float commande = kp * error;
  commande += ki * sError;
  commande += kd * dError;
  
  // Restrict to max/min
  if( commande > max )
      commande = max;
  else if( commande < min )
      commande = min;
  
  if(!pendule.isDead()){
    pendule.move(commande);
  }
  
  plotterAngle.update();
}




void keyPressed(){
  
   if(key == ' '){
     pendule.perturbate();
     
   }
}
