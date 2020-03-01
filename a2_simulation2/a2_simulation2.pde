// Advanced Cloth Simulation - Trevor Graham - 5611

import java.util.Random;

class Node{  // definition of Node class
 PVector pos;
 PVector vel;
 PVector acc;
 ArrayList<Node> next_nodes;
 float mass;
  Node(PVector position, PVector velocity, PVector acceleration, float m){
  pos = position;
  vel = velocity;
  acc = acceleration;
  next_nodes = new ArrayList<Node>(2);  
  mass = m;
 }
}

ArrayList<ArrayList<Node>> node_list; 
float k = 20;
float kv = .9;
PVector grav = new PVector(0,200,0);
int drop_flag = 0;
int r_flag = 0;
int l_flag = 0;
PVector spherePos = new PVector(100,400,0);
int restLen = 20;
int height = 30;
int width = 30;
int heightOffset = 200;
int widthOffset = 400;
int wind_flag = 0;
//PVector spherePos = new PVector(100,400,0);
Random r = new Random();
PVector wind = new PVector(2.5,0,0);

void setup(){
 size(1200,900, P3D);
 surface.setTitle("Assignment 2 Simple Cloth");
 node_list = new ArrayList<ArrayList<Node>>(height +1);
 beginSim();

}

void beginSim(){
 for(int i = 0; i <=height; i++ ){ // inital values for node_list
  ArrayList <Node> row = new ArrayList<Node>();  
  for(int j = 0; j <= width; j++){
   PVector pos = new PVector(widthOffset + i*restLen, heightOffset + j*restLen,0);
   PVector vel = new PVector(0,100,100);
   Node n = new Node(pos,vel,grav, 1); 
   row.add(n);
  }
  node_list.add(row);
 }
 
 Node n1,n2;
 for(int i = 0; i <= height; i++){ //.creates ArrayList with all the neighboring nodes
  for(int j = 0; j <= width; j++){
    n1 = node_list.get(i).get(j);
    if(i < height){
      n2 = node_list.get(i+1).get(j);
      n1.next_nodes.add(n2);    
    }
    if(j < width){
     n2 = node_list.get(i).get(j+1);
     n1.next_nodes.add(n2);
      
    }
  }   
 } 
}
  
void update(float dt){
  for(int i = 0; i <=height; i++){
    for(int j = 0; j <=width; j++){
      Node curr_node = node_list.get(i).get(j);
        for(int n = 0; n < curr_node.next_nodes.size(); n++){
        Node node = curr_node.next_nodes.get(n);
        PVector e = PVector.sub(node.pos, curr_node.pos);
        float len = sqrt(e.dot(e));
        e.normalize();
        float v1 = e.dot(curr_node.vel);
        float v2 = e.dot(node.vel);
        curr_node.vel.add(PVector.mult(curr_node.acc,dt));
        node.vel.add(PVector.mult(node.acc,dt));
        float f = -k*(restLen - len) - kv*(v1 - v2);
        curr_node.vel.add(PVector.mult(e,f));
        node.vel.sub(PVector.mult(e,f));   
      }
      if(wind_flag%2 ==1){
        curr_node.vel = PVector.add(curr_node.vel,wind);
    }
    } 
  }
  if(drop_flag == 0){
    for(int i = 0; i <=height; i++){ // anchor top of cloth
     node_list.get(0).get(i).vel.mult(0); 
    
    }
  }
  for(int i = 0; i <=height; i++){
   for(int j = 0; j <=width; j++){ 
    Node n = node_list.get(i).get(j);
    n.pos.add(PVector.mult(n.vel,dt));
    
    //if(PVector.dist(n.pos, spherePos) < 100){
    //  PVector normal = PVector.sub(n.pos,spherePos);
    //  normal.normalize();
    //  n.pos = PVector.add(spherePos, PVector.mult(normal,100));
    //  n.vel.sub(PVector.mult(normal, n.vel.dot(normal)));
    //  n.vel= PVector.mult(n.vel,.9);
    //  }
    }
  }
  }


void draw(){
  background(0,255,255);
  textSize(24);
  fill(255,255,255,255);
  String fr = "Frame Rate: " + frameRate;
  text(fr, 100, 100);
  
  pushMatrix();
  fill(150);
  noStroke();
  rect(360,150, 40,1200);
  popMatrix();
  
  pushMatrix();
  translate(380,150);
  fill(150);
  noStroke();
  sphere(30);
  popMatrix();
  
  
  pushMatrix();
  fill(255,255,0);
  noStroke();
  translate(100,200);
  sphere(100);
  popMatrix();
  
  for(int t = 0; t < 20; t++){
    update(.001);
  }
    
    noFill();
    for(int i = 0; i<= height; i++){
     for(int j = 0;j <= width; j++){
       Node curr_node = node_list.get(i).get(j);
       for(int n = 0; n < curr_node.next_nodes.size(); n++){
         stroke(r.nextInt(255),r.nextInt(255),r.nextInt(255));
        line(curr_node.pos.x, curr_node.pos.y, curr_node.next_nodes.get(n).pos.x, curr_node.next_nodes.get(n).pos.y); 
       }
     } 
    }
  
} 
void keyPressed() {
  //if (keyCode == RIGHT) {
    
  //  //node_list.get(height).get(width).vel.x += 20000;
  //  spherePos.x += 20;
  //  }
  
 
  //if (keyCode == LEFT) {
  //  //node_list.get(0).get(width).vel.x -= 20000;
  //  spherePos.x -= 20;
  //}
  if(keyCode == ENTER){
    drop_flag = 1;
  }
  if(keyCode == SHIFT){
   wind_flag++; 
    
  }
}
