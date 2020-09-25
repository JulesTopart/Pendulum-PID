
final float g = 9.81;

class Pendulum{
  
  PVector origin;
  float armLength;
  
  float airViscosity = 0.2;
  
  float joint, joint_velocity, joint_accel;
  float angle, angular_velocity, angular_accel;
  
  boolean isRunning = false;
  float joint_target = 0;
  float joint_previous = 0;
  float stepper_accel = 5;

  Pendulum(PVector _origin, float _armLength){
    armLength = _armLength;
    origin = _origin;
    
    reset();
    
  }
  
  void reset(){
    angle = -PI/2;
    angular_velocity = 0;
    angular_accel = 0;
    
    joint = 0;
    joint_velocity = 0;
    joint_accel = 0;
    
    perturbate();
  }
  
  void update(){
    checkBoundaries();
    updatePhysics();
    display();
  }
  
  float GetAngle(){
    return -angle;  
  }
  
  boolean isDead(){
    if(joint > 400 || joint < -400){
      return true;
    }
    if(angle > 0) return true;
    return false;
  }
  
  void checkBoundaries(){
    if(joint > 400 || joint < -400){
      bump();
    }
  }
  
  void mouseTest(){
    joint = (mouseX - width/2);
    joint_accel = (mouseX - pmouseX)/10;
    
  }
  
  void updateStepper(){
    if(isRunning){

      float newAccel = stepper_accel;
      if(joint_target - joint_previous < 0) newAccel = -stepper_accel;
      
      float travel = abs(joint_target - joint_previous);
      float travelled = abs(joint - joint_previous);
      if(travel > 0){
        if(travelled <= 0.2 * travel){
          joint_accel = newAccel; 
        }else if(travelled > 0.2 * travel){
          joint_accel = 0; 
        }else if(travelled >= 0.8 * travel){
          joint_accel = -newAccel; 
        }
        
        if(travel - travelled < 1){
          joint = joint_target;
          joint_accel = 0;
          joint_velocity = 0;
          isRunning = false;
        }
      }
    }
  }
  
  
  
  void updatePhysics(){
    
    updateStepper();
    
    joint_accel -= joint_velocity * airViscosity;
    joint_velocity += joint_accel;
    joint += joint_velocity;
    
    angular_accel = ( joint_accel*sin(angle) + (g * cos(angle))) / armLength;
    angular_accel -= angular_velocity * airViscosity;
    angular_velocity += angular_accel;
    angle += angular_velocity;

  }
  
  void bump(){
    joint_velocity *= -0.5;
    joint_accel *= -1;
    updatePhysics();
  }
  
  void switchDirection(){
    if(joint_velocity >= 0)
      joint_accel = 1;
    else
      joint_accel = -1;
  }
  
  
  void display(){
    
    line((width/2) - 400, origin.y, (width/2 + 400) , origin.y );
    
    PVector jointPos = new PVector(origin.x + joint, origin.y);
    PVector pos = new PVector(cos(angle), sin(angle));
    pos.mult(armLength);
    pos.add(jointPos);
    
    line(jointPos.x, jointPos.y, pos.x, pos.y);
    
    strokeWeight(10);
    point(pos.x, pos.y);
    point(jointPos.x, jointPos.y);
    strokeWeight(1);
  }
  
  void perturbate(){
   if(joint < 0)
     angular_velocity += 0.02;
   else
     angular_velocity -= 0.02;
  }
  
  void move(float dist){
    isRunning = true;
    joint_previous = joint;
    joint_target = joint + dist;
  }
  
  
  
 
}
