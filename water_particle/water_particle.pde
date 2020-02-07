// Water Particle System - 5611 Assignment 1
import java.util.Random;

Random r = new Random();
ArrayList<Particle> list = new ArrayList<Particle>();

void setup(){
 size(600,600, P3D); 
 noStroke();

}

void draw(){
  float startFrame = millis(); 
  background(173,216,230); 
 // System.out.println(list.size());
  fill(0,100,0);
  rect(-40,100,90,20);
  rect(0,400,600,200);
  translate(80, 120);
  Particle part = new Particle();
  list.add(part);
  
  
 
  for(int i = list.size() -1; i >= 0; i--){
  moveParticle(list.get(i), .15);
  if(list.get(i).isDead){
    list.remove(i); 
   }
  //translate(list.get(i).pos.x,list.get(i).pos.y,list.get(i).pos.z); // update position and particle values
  if(list.size() > 10){
  fill(list.get(i).currColor);
  ellipse(list.get(i).pos.x ,list.get(i).pos.y ,6,6);
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
    vel = new PVector(.2 +r.nextFloat(),0,0);
    accel = new PVector(0,.02,0 );
    currColor = color(0,r.nextInt(10),200 - (r.nextInt(100) + -50));
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

 
 part.lifespan -=3.5;
if(part.pos.y >= 400){
 part.vel.y = part.vel.y * -.3;
}
part.pos = part.pos.add(part.vel);
if(part.pos.y >= 400){
  part.isDead =true;
  
}

  part.vel = part.vel.add(part.accel);
  part.pos = part.pos.add(part.vel);
  
}
