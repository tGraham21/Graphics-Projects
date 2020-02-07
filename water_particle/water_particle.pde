// Fire Particle System - 5611 Assignment 1
import java.util.Random;

Random r = new Random();
ArrayList<Particle> list = new ArrayList<Particle>();
PVector center = new PVector(200,400,0);
void setup(){
 size(600,600, P3D); 
 noStroke();

}

void draw(){
  float startFrame = millis(); 
  background(0,0,0); 
 // System.out.println(list.size());
  pushMatrix();
  translate(200,400, 0);
  fill(0,100,0);
  sphere(30);
  popMatrix(); 
  
  translate(50,100);
  rotateZ(PI/2);

 
 for(int i = 0; i < 5; i++){
  
  Particle part = new Particle();
  list.add(part);
  }
  
 
  for(int i = list.size() -1; i >= 0; i--){
  moveParticle(list.get(i), .15);
  if(list.get(i).isDead){
    list.remove(i); 
   }
  //translate(list.get(i).pos.x,list.get(i).pos.y,list.get(i).pos.z); // update position and particle values
  if(list.size() > 10){
  fill(list.get(i).currColor);
  ellipse(list.get(i).pos.x ,list.get(i).pos.y , 10,10);
  }
  }
 
  float endFrame = millis();
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ 
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(runtimeReport);
  //print(runtimeReport);
 
}

class Particle{
  PVector pos;
  PVector vel;
  PVector accel; 
  int direction;
  color currColor;
  float lifespan;
  float transparency;
  boolean isDead;
  Particle(){
    pos = new PVector();
    randSpawn(pos);
    vel = new PVector(0,-.5,0);
    accel = new PVector(.01,0,0 );
    currColor = color(0,0,225 - (r.nextInt(60) + -30));
    lifespan = 300 - r.nextInt(50);
    isDead = false;
    if(pos.x >= 0){
      direction =1;
  }
  else{
    direction = 0;
  }
  }

}

void randSpawn(PVector pos){
  float rad = 30 * sqrt(r.nextFloat());
  float theta = 2 * PI * r.nextFloat();
  float x = rad * sin(theta);
  float z = rad * cos(theta);
  pos.x = x;
  pos.y = - sqrt(abs(pow(20,2) - pow(x,2) - pow(z,2)));
  pos.z= z;
}

void moveParticle(Particle part, float dt){
  if((center.y - (-1 * part.pos.y + 250)) <=20 && (center.x - part.pos.x) <=15  ){
   part.vel =  part.vel.mult(-.8);
 }
 
 part.lifespan -=3.5;
if(part.pos.y > 600){
 part.isDead = true;
}
 // if (part.lifespan < 0){ // particle dies
 //   part.isDead = true;
 // }
 // else if(part.lifespan < 280){
 //   part.vel.x = part.vel.x *((3 *r.nextFloat()) + -1.5);
 //   part.vel.z = part.vel.z *((3 * r.nextFloat()) + -1.5);
    
 // }
 // if(part.lifespan < 90){
 //   float val = r.nextFloat();
 //   if(val > .5){
 //  part.currColor = color(100,alpha(part.currColor) - 4);
   
 //   }
 //}
 //else {
 //  if(r.nextFloat() > .15){
 // part.currColor = color(red(part.currColor) ,green(part.currColor) -4 , 0, alpha(part.currColor) -4) ;
 //  }
 //}
 
 //System.out.println(PVector.dist(part.pos,center));
 
  part.vel = part.vel.add(part.accel);
  part.pos = part.pos.add(part.vel);
  
}
