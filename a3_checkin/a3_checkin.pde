// Check-in 3 
// Trevor Graham

import java.util.Random;
import java.util.*;

class Node{  // def of Node class
  float x= 0;
  float y = 0;
  int id;
   Node(float xpos, float ypos, int idNum){
    x = xpos;
    y = ypos;
    id = idNum;
  }
}


ArrayList <Node> nodes;
Random r = new Random();
int idCount = 1;
int totNodes = 20;
int displayFlag = 0;
ArrayList<Integer>[] neighbors = new ArrayList[totNodes +1];
Boolean[] visited = new Boolean[totNodes+1];
int[] parent = new int[totNodes+1];
ArrayList<Integer> queue = new ArrayList();
ArrayList<Integer> path= new ArrayList();
 Node character = new Node(-9,9,-1);
 Node currNode = new Node(-9,9,0);
 Node targetNode= new Node(0,0,0);
 int pathId = 1; 
void setup(){
 size(220,220,P3D);
 surface.setTitle("A3 Check-in");
 for(int i = 0; i <= totNodes; i++) { 
    neighbors[i] = new ArrayList<Integer>(); 
    visited[i] = false;
    parent[i] = -1; //No partent yet
}
 nodes = new ArrayList();
 Node start = new Node(-9, 9, 0);
 nodes.add(start);
 selectCoords();
  Node goal = new Node(9, -9, 20);
 nodes.add(goal);
 for(int i = 1; i < nodes.size(); i ++){
  float dist = sqrt(pow((start.x - nodes.get(i).x),2) + pow((start.y - nodes.get(i).y),2));
  if(dist <= 9){
    neighbors[0].add(i);
  }
 }
 for(int j = 1; j < nodes.size(); j++){
  for(int i = 1; i < nodes.size(); i++){
    Node curr = nodes.get(j);
    Node comp = nodes.get(i);
    float dist = sqrt(pow((curr.x - comp.x),2) + pow((curr.y - comp.y),2));
    if(dist <= 7){
     neighbors[j].add(i); 
    }
  }
 }

 for(int i = 1; i < nodes.size(); i ++){
  float dist = sqrt(pow((goal.x - nodes.get(i).x),2) + pow((goal.y - nodes.get(i).y),2));
  if(dist <= 9){
    neighbors[20].add(i);
  }
 }
 for(Node n : nodes){
 println(n.x, " ", n.y, " ", n.id);
 }
 runDFS();
}

void draw(){
  int widthOffset = width - 10;
  int heightOffset = height - 10;
  line(widthOffset,heightOffset,10,heightOffset);
  line (10,10, widthOffset, 10);
  line (10,10, 10, heightOffset);
  line (widthOffset, heightOffset, widthOffset, 10);
  fill(0,0,0);
  ellipse(width/2, height/2, 40, 40); // Obstacle
  fill(0, 255, 0);
  pushMatrix();
  translate(width/2, height/2);
  ellipse((nodes.get(0).x * 10),  (nodes.get(0).y* 10), 10,10); // Start
  ellipse((nodes.get(totNodes).x * 10),  (nodes.get(totNodes).y* 10), 10,10);
  popMatrix();
  
  //ellipse(widthOffset - 10, 20, 10 ,10); // Goal 
  if(displayFlag%2 == 0){
  for(int i = 1; i < nodes.size() - 1; i++){
    fill(0,0,0);
    pushMatrix();
    translate(width/2, height/2);
  ellipse((nodes.get(i).x* 10), (nodes.get(i).y* 10), 10, 10); 
    popMatrix();
  }
  }
  update(.02);
  translate(width/2, height/2);
  if(displayFlag % 2 == 0){
  connectCoords();
  }
}

void selectCoords(){
 int count = 0;
 while(count <totNodes - 1){
   int x = r.nextInt(18)  - 9;
   int y = r.nextInt(18)  - 9;
   if(sqrt(pow(x,2) + pow(y,2)) > 4){
   Node randPos = new Node(x,y, idCount);
   idCount++;
   nodes.add(randPos);
   count++;
   }
 } 
}

void connectCoords(){ 
 for(int j = 0; j < neighbors.length ; j++){
  for(int i : neighbors[j]){
    Node curr = nodes.get(j);
    Node comp = nodes.get(i);
    line((comp.x * 10), (comp.y * 10), (curr.x * 10),(curr.y * 10)); 
  }
 }
}

void runDFS(){
 visited[nodes.get(0).id] = true;
 queue.add(nodes.get(0).id);
 
 while(queue.size() > 0){
  int currNode = queue.get(0);
  queue.remove(0);
  if(currNode == 20){
   println("Goal");
   break; 
  }
  for(int i = 0; i < neighbors[currNode].size(); i++){
   int neighborNode = neighbors[currNode].get(i); 
   if(!visited[neighborNode]){
     visited[neighborNode] = true;
     parent[neighborNode] = currNode;
     queue.add(neighborNode);  
     println("Added node", neighborNode, "to the fringe.");
      println(" Current Fringe: ", queue);
   }
  }
 }
 int prevNode = parent[parent.length -1 ];
print(parent.length - 1, " ");
path.add(parent.length -1);
while (prevNode >= 0){
  print(prevNode," ");
  path.add(prevNode);
  prevNode = parent[prevNode];
}
Collections.reverse(path);
println(path);
}

void update(float dt){
  if(currNode.id != totNodes){
    targetNode = nodes.get(path.get(pathId));
    println(targetNode.id, ", ", targetNode.x, ", ", targetNode.y);
    float dirX = (targetNode.x - currNode.x);
    float dirY = (targetNode.y - currNode.y);
    float dist = sqrt(pow((character.x - targetNode.x),2) + pow((character.y - targetNode.y),2));
    if(dist >= .001 ){
     character.x = character.x + (dt * dirX);
     character.y = character.y + (dt * dirY);
    }
    else if (pathId < path.size() - 1){
      println(pathId);
      pathId++;
      currNode = targetNode;
    }
    pushMatrix();
    fill(0,0,255);
    translate(width/2, height/2);
    ellipse(character.x * 10, character.y * 10, 5, 5);
    popMatrix();
    
  }
    
  //int startPos = path.size() - 2;
  //int targetId = path.get(startPos);
  //Node targetNode = nodes.get(targetId);
  //int currId = path.get(path.size() - 1);
  //Node currNode = nodes.get(currId);
  //float distX = currNode.x - targetNode.x;
  //float distY = currNode.y - targetNode.y;
  //Node character = new Node(currNode.x, currNode.y, -1);
  //character.x = character.x + dt * distX;
  //character.y = character.x + dt * distY;
  //if(distX <= .01 && distY <= .01){
  //  targetId = path.get(--startPos);
  //  targetNode = nodes.get(targetId);
   

}

void keyPressed(){
 if(keyCode == ENTER){
  displayFlag++; 
  println(displayFlag);
   
 }
  
  
}
