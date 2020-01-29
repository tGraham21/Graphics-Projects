import java.util.Random;

String projectTitle = "Bouncing Ball";

float posx = 300;
float posy = 300;
float velx = 0;
float vely = 0;
float radius = 40;
float floor = 600;
int squash_flag = 0;
void setup(){
  size(600,600,P3D);
  noStroke();
  launch();
}

void launch(){
 Random r = new Random();
 velx = -50 + r.nextInt(100);
 vely = -50 + r.nextInt(100);
}
void computePhysics(float dt){
 float accelx = 0;
 float accely = 9.8;
 posx = posx + velx * dt;
 velx = velx + accelx * dt;
 
 posy = posy + vely *dt;
 vely = vely + accely * dt;
 
 if(posx + radius > floor){
  posx = floor - radius; 
  velx *= -.95; 
  squash_flag = 1;
 }
 else if(posx - radius < 0){
   posx = radius;
   velx *= -.95;
   squash_flag = 1;
 }
 
  if(posy + radius > floor){
  posy = floor - radius; 
  vely *= -.95; 
  squash_flag = 2;
 }
 else if(posy - radius < 0){
   posy = radius;
   vely *= -.95;
   squash_flag = 2;
 }
}

void drawScene(){
 background(255,255,255); 
 Random r = new Random();
 fill(r.nextInt(255),r.nextInt(255), r.nextInt(255));
 lights();
 translate(posx, posy);
 if(squash_flag == 2){
  scale(1.1,1); 
 }
 else if (squash_flag ==1){
   scale(1,1.1);
 }
 
 sphere(radius);
}

void draw(){
 computePhysics(.2); 
 drawScene();  
 squash_flag = 0;
}
