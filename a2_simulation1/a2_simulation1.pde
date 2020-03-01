// a2_simulation1 - Trevor Graham

class Node{  // definition of Node class
 PVector pos;
 PVector vel;
 PVector acc;
 ArrayList<Node> next_nodes;
 float mass;
 int x; // location in cloth
 int y;
  Node(PVector position, PVector velocity, PVector acceleration, float m, int i, int j){
  pos = position;
  vel = velocity;
  acc = acceleration;
  mass = m;
  x = i; 
  y = j;
  next_nodes = new ArrayList<Node>(2);  
 }
}

ArrayList<ArrayList<Node>> node_list;
int height = 30;
int width = 30;
int heightOffset = 100;
int restLen = 20;
int widthOffset = 400;
float k = 20;
float kv = .9;
PVector grav = new PVector(0,250,0);
int drop_flag = 0;
int r_flag = 0;
int l_flag = 0;
PVector spherePos = new PVector(600,400,-60);

void setup(){
 size(1200, 900, P3D);
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
   Node n = new Node(pos,vel,grav, 1, i, j); 
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
  PVector e;
  float len;
  float v1, v2;
  float f;
  for(int i = 0; i <=height; i++){
    for(int j = 0; j <=width; j++){
      Node curr_node = node_list.get(i).get(j);
      for(Node n : curr_node.next_nodes){
        e = PVector.sub(n.pos, curr_node.pos);
        len = sqrt(e.dot(e));
        e.normalize();
        v1 = e.dot(curr_node.vel);
        v2 = e.dot(n.vel);
        f = -k*(restLen - len) - kv*(v1 - v2);
        
        curr_node.vel.add(PVector.mult(curr_node.acc,dt));
        n.vel.add(PVector.mult(n.acc,dt));
        curr_node.vel.add(PVector.mult(e,f));
        n.vel.sub(PVector.mult(e,f));   
      }
      
    }
  }
  if(drop_flag == 0){
    for(int i = 0; i <=height; i++){ // anchor top of cloth
     node_list.get(i).get(0).vel.mult(0); 
    
    }
  }
  for(int i = 0; i <=height; i++){
   for(int j = 0; j <=width; j++){ 
    Node n = node_list.get(i).get(j);
    n.pos.add(PVector.mult(n.vel,dt));
    if(PVector.dist(n.pos, spherePos) < 100){
      PVector normal = PVector.sub(n.pos,spherePos);
      normal.normalize();
      n.pos = PVector.add(spherePos, PVector.mult(normal,100));
      n.vel.sub(PVector.mult(normal, n.vel.dot(normal)));
      
    }
  }
}
}

void draw(){
  background(0,0,0);
  textSize(24);
  fill(255,255,255,255);
  String fr = "Frame Rate: " + frameRate;
  text(fr, 100, 100);
  
  pushMatrix();
  fill(0,255,255);
  noStroke();
  lights();
  translate(spherePos.x,spherePos.y,spherePos.z);
  sphere(100);
  popMatrix();
  
  for(int t = 0; t < 20; t++){
    update(.001);
  }
    stroke(255,255,255);
    noFill();
    for(int i = 0; i<= height; i++){
     for(int j = 0;j <= width; j++){
       Node curr_node = node_list.get(i).get(j);
       for(Node n : curr_node.next_nodes){
        line(curr_node.pos.x, curr_node.pos.y, n.pos.x, n.pos.y); 
       }
     }
    }
  
} 
void keyPressed() {
  if (keyCode == RIGHT) {
    
    node_list.get(height).get(width).vel.x += 1000;
    }
  
 
  if (keyCode == LEFT) {
    node_list.get(height).get(width).vel.x -= 1000;
  }
  if(keyCode == ENTER){
    drop_flag = 1;
  }
}
