// simple cloth - Trevor Graham

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
int restLen = 15;
int height = 30;
int width = 30;
int heightOffset = 100;
int widthOffset = 200;

void setup(){
 size(800, 800, P3D);
 node_list = new ArrayList<ArrayList<Node>>(height +1);
 surface.setTitle("Assignment 2 Simple Cloth");
 beginSim();

}

void beginSim(){
 for(int i = 0; i <=height; i++ ){ // inital values for node_list
  ArrayList <Node> r = new ArrayList<Node>();  
  for(int j = 0; j <= width; j++){
   PVector pos = new PVector(widthOffset + i*restLen, heightOffset + j*restLen,0);
   PVector vel = new PVector(0,100,100);
   Node n = new Node(pos,vel,grav, 1); 
   r.add(n);
  }
  node_list.add(r);
 }
 
 
 for(int i = 0; i <= height; i++){ //creates ArrayList next_nodes that hold nodes that vel should be applied to
  for(int j = 0; j <= width; j++){
     Node curr_node = node_list.get(i).get(j);
     Node n2;
    if(i < height){
      n2 = node_list.get(i+1).get(j);
      curr_node.next_nodes.add(n2);    
    }
    if(j < width){
     n2 = node_list.get(i).get(j+1);
     curr_node.next_nodes.add(n2);
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
      n.vel= PVector.mult(n.vel,.9);
      }
    }
  }
}


void draw(){
  background(0,0,0);
  
  pushMatrix();
  fill(0,255,255);
  noStroke();
  lights();
  translate(spherePos.x,spherePos.y,spherePos.z);
  sphere(100);
  popMatrix();
  
  textSize(24);
  fill(255,255,255,255);
  String fr = "Frame Rate: " + frameRate;
  text(fr, 100, 100);
  
  for(int t = 0; t < 20; t++){
    update(.001);
  }
    stroke(255,255,255);
    noFill();
    for(int i = 0; i<= height; i++){
     for(int j = 0;j <= width; j++){
       Node curr_node = node_list.get(i).get(j);
       for(int n = 0; n < curr_node.next_nodes.size(); n++){
        line(curr_node.pos.x, curr_node.pos.y, curr_node.next_nodes.get(n).pos.x, curr_node.next_nodes.get(n).pos.y); 
       }
     }
    }  
} 

void keyPressed() {
  if (keyCode == RIGHT) {
    //node_list.get(height).get(width).vel.x += 20000;
    spherePos.x += 20;
    }
  if (keyCode == LEFT) {
    //node_list.get(0).get(width).vel.x -= 20000;
    spherePos.x -= 20;
  }
  if(keyCode == ENTER){
    drop_flag = 1;
  }
  if(keyCode == UP){
    node_list.get(0).get(height).vel.y += 20000;
    
  }
  if(keyCode == DOWN){
    node_list.get(0).get(height).vel.y -= 20000;
  }
  
}
