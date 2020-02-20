// Trevor Graham - 5611 check in
import java.util.Random;

void setup() {
  size(400, 400, P3D);
  surface.setTitle("Rope Simulation");
}
Random r = new Random();
//0 gravity, pull left
//20 gravity, kick right, stiff

float ballx = 200;
float bally = 100;

float ball2x = 200;
float ball2y = 150;

float ball3x = 200;
float ball3y = 200;

float floor = 400;
float grav = 1000;
float radius = 10;
float velX = 0; //40
float velY = 0;
float vel2X = 0;
float vel2Y = 0;
float vel3X = 0;
float vel3Y = 0;

float anchorX = 200;
float anchorY = 50;
float restLen = 40;
float mass = 30;
float k = 10000; //1 1000
float kv = 10000;

void update(float dt){
  float sx = (ballx - anchorX);
  float sy = (bally - anchorY);
  float stringLen1 = sqrt(sx*sx + sy*sy);
  
  float sx2 = (ball2x - ballx);
  float sy2 = (ball2y - bally);
  float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
  
  float sx3 = (ball3x - ball2x);
  float sy3 = (ball3y - ball2y);
  float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
  //println(stringLen, " ", restLen);
  float stringF = -k*(stringLen1 - restLen);
  float dirX = sx/stringLen1;
  float dirY = sy/stringLen1;
  float projVel = velX*dirX + velY*dirY;
  float dampF = -kv*(projVel - 0);
  
  float stringF2 = -k*(stringLen2 - restLen);
  float dirX2 = sx2/stringLen2;
  float dirY2 = sy2/stringLen2;
  float projVel2 = vel2X*dirX2 + vel2Y*dirY2;
  float dampF2 = -kv*(projVel2 - projVel);
  
  float stringF3 = -k*(stringLen3 - restLen);
  float dirX3 = sx3/stringLen3;
  float dirY3 = sy3/stringLen3;
  float projVel3 = vel3X*dirX3 + vel3Y*dirY3;
  float dampF3 = -kv*(projVel3 - projVel2);
  
  float springForceX = (stringF+dampF)*dirX;
  float springForceY = (stringF+dampF)*dirY;
  
  float springForceX2 = (stringF2+dampF2)*dirX2;
  float springForceY2 = (stringF2+dampF2)*dirY2;
  
  float springForceX3 = (stringF3+dampF3)*dirX3   ;
  float springForceY3 = (stringF3+dampF3)*dirY3;
  
  float accY1 = grav +.5*(springForceY/mass) - .5 * (springForceY2/mass);
  float accY2 = grav +.5*(springForceY2/mass) - .5 * (springForceY3/mass);
  float accY3 = grav +.5*(springForceY3/mass);
  
   float accX1 = .5*(springForceX/mass) - .5 * (springForceX2/mass);
  float accX2 = .5*(springForceX2/mass) - .5 * (springForceX3/mass);
  float accX3 =.5*(springForceX3/mass);
  
  velX += accX1*dt;
  velY += accY1*dt;
  vel2X += accX2*dt;
  vel2Y += accY2*dt;
  vel3X += accX3*dt;
  vel3Y += accY3*dt;
  
  ballx += velX*dt;
  bally += velY*dt;
  
  ball2x += vel2X*dt;
  ball2y += vel2Y*dt;
  ball3x += vel3X*dt;
  ball3y += vel3Y*dt;
 
  
}

void keyPressed() {
  if (keyCode == RIGHT) {
    vel3X += 100;
  }
  if (keyCode == LEFT) {
    vel3X -= 100;
  }
}

void draw() {
  background(255,255,255);
  for (int i = 0; i < 30; i++){
    update(.001);
  }
 
  fill(r.nextInt(255),r.nextInt(255),r.nextInt(255));
  stroke(5);
  
  pushMatrix();
  
  fill(r.nextInt(255),r.nextInt(255),r.nextInt(255));
  line(anchorX,anchorY,ballx,bally);
  translate(ballx,bally);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  
  fill(r.nextInt(255),r.nextInt(255),r.nextInt(255));
line(ballx,bally,ball2x,ball2y);
  translate(ball2x,ball2y);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  
  fill(r.nextInt(255),r.nextInt(255),r.nextInt(255));
  line(ball2x,ball2y,ball3x,ball3y);
  translate(ball3x,ball3y);
  sphere(radius);
  popMatrix();
}
