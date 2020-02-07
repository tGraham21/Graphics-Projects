// Fire Particle System - 5611 Assignment 1
import java.util.Random;

Random r = new Random();
ArrayList<Particle> list = new ArrayList<Particle>();
boolean overSpot = false;
boolean lock = false;
float sx,sy;
float xOffset = 0.0;
float yOffset = 0.0;

void setup(){
   
 size(600,600, P3D); 
 sx = width/2.0;
 sy = height /2.0;
 noStroke();

}

void draw(){
  
  float startFrame = millis(); 
  if((mouseX > sx - 3 && mouseX < sx +3) && (mouseY > sy -3 && sy < sy+3)){
    overSpot= true;
  }
  else{
   overSpot = false; 
  }
  background(0,0,0); 
  pushMatrix();
  translate(sx,sy - 5);
  fill(139,69,19);
  
  rect(-10,0,20,175);
  popMatrix();
  System.out.println(list.size());
 for(int i = 0; i < 30; i++){
   if(!lock || (r.nextInt(6) == 1)){
  Particle part = new Particle();
  list.add(part);
  
  Particle part2 = new Particle();
  list.add(part2);
    Particle part3 = new Particle();
  list.add(part3);
  }
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
    vel = new PVector(r.nextFloat() + -.5, -2 , r.nextFloat() + -.5 );
    accel = new PVector(0, 0, 0 );
    currColor = color(225 - (r.nextInt(60) + -30),225 - (r.nextInt(60) + -30),0);
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
  float rad = 80 * sqrt(r.nextFloat());
  float theta = 2 * PI * r.nextFloat();
  float x = rad * sin(theta);
  float z = rad * cos(theta);
  pos.x = x + sx;
  pos.y = - sqrt(pow(20,2) - pow(x,2) - pow(z,2)) + sy;
  pos.z= z;
}

void moveParticle(Particle part, float dt){
  
 //float xVal = r.nextFloat();
 //if(xVal >= .5){o
 // vec.x = vec.x + .1;
 //}
 //else{
 //  vec.x = vec.x - .1;
 //}
 part.lifespan -=3.5;
 if(lock){
  part.lifespan -= 5; 
 }
  if (part.lifespan < 0){ // particle dies
    part.isDead = true;
  }
  else if(part.lifespan < 280){
    part.vel.x = part.vel.x *((3 *r.nextFloat()) + -1.5);
    part.vel.z = part.vel.z *((3 * r.nextFloat()) + -1.5);
    
  }
  if(part.lifespan < 90){
    float val = r.nextFloat();
    if(val > .5){
   part.currColor = color(100,alpha(part.currColor) - 4);
   
    }
 }
 else {
   if(r.nextFloat() > .15){
  part.currColor = color(red(part.currColor) ,green(part.currColor) -4 , 0, alpha(part.currColor) -4) ;
   }
 }
  part.vel = part.vel.add(part.accel);
  part.pos = part.pos.add(part.vel);
  
}

void mousePressed() {
 if(overSpot){
   lock = true;
   
 }
 else{
   lock = false;
 }
 xOffset = mouseX - sx;
 yOffset = mouseY - sy;
  
}

void mouseDragged(){
 if(lock){
   sx = mouseX - xOffset;
   sy = mouseY - yOffset;
 }
}

void mouseReleased(){
  lock = false; 
 }
