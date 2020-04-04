// A3 Scenario 1 - Trevor Graham

import java.util.Random;
import java.util.*;

class Node{
 float x = 0;
 float y = 0;
 int id;
 ArrayList<Integer>neighbors = new ArrayList<Integer>();

 boolean visited = false;
 int parentId = -1;
 float f,g,h;
 
 Node(float xpos, float ypos, int idNum){
   x = xpos;
   y = ypos;
   id = idNum;
   f = 0;
   g = 0;
   h = 0;
 }
}

class Crowd{
 ArrayList <Boid> boids;
 
 Crowd(){
  boids = new ArrayList<Boid>(); 
 }
 
 void addBoid(Boid b){
   boids.add(b);
 }
 void removeBoid(Boid b){
   boids.remove(b); 
 }
 void run(){
   
  for(Boid b: boids){
    // PVector end = new PVector(goal.x, goal.y);
    //if(PVector.dist(b.pos, end) < .1){
    // crowd.removeBoid(b);
      
    //}
    b.move(boids);
  }
 }

}

class Boid{
 PVector pos;
 PVector vel;
 PVector accel;
 Node target;
 Boid(float xPos, float yPos){
   pos = new PVector(xPos, yPos);
   vel = new PVector(-3, -3); //set initial to calculated direction;
   accel = new PVector(0,0);
   target = nodes.get(path.get(1)) ;
 }
   void move(ArrayList <Boid> boids){
     calcForces(boids);
     updateBoid();
   }
   
   void calcForces(ArrayList <Boid> boids){
     PVector cohesion = cohesion(boids);     
     PVector alignment = alignment(boids);
     PVector seperation = seperation(boids);

   
     PVector obstacleForces = obstacleForces(obstacles);
     cohesion.mult(.5);
     alignment.mult(.5);
     seperation.mult(.1);
     obstacleForces.mult(.90);
     accel.add(cohesion);
     accel.add(alignment);
     accel.add(seperation);
     accel.add(obstacleForces);
     
   }
   void updateBoid(){
     
    vel.add(accel);
    pos.add(vel);
    
    int pId = path.indexOf(target.id);
   // println(pId);
    ArrayList <Boolean> collisions = new ArrayList <Boolean>();
    for(int p : path){
      collisions.add(hasCollision(p, pos));
    }
    for(int i = pId; i < collisions.size() -1 ; i++){
      if(collisions.get(i) == false){
        target = nodes.get(path.get(i+1)); 
      }
    }
    
    PVector nextTarget = new PVector(target.x, target.y);
    PVector dir = direction(nextTarget);
    //println(dir);
    dir.mult(1.5);
    vel.add(dir); // steer towards targetNode
    //println("vel:", vel);
    accel.mult(0);
     
   
   }
   
   PVector direction(PVector p){ // return PVector leading towards position
     PVector direction = PVector.sub(p, pos);
     direction.normalize();
     
     direction.sub(vel);
     return direction;
   }
   
   PVector cohesion(ArrayList <Boid> boids){
     PVector cohesion = new PVector(0,0); // 
     int totalVectors = 0;
     for(Boid b: boids){
       float dist = PVector.dist(pos, b.pos);
       if(dist > 0 && dist < 20){
         cohesion.add(b.vel); 
       }
     }
     
     if(totalVectors > 0){
      cohesion.div(totalVectors); // average position to be pulled towards
      PVector c = direction(cohesion); // use direction to incorporate vel 
      return c;
     }
     return cohesion;
   }
   
   PVector alignment(ArrayList <Boid> boids){
     PVector alignment = new PVector(0,0);
     int totalVectors = 0;
     for(Boid b: boids){
       float dist = PVector.dist(pos, b.pos);
       if(dist > 0 && dist < 20){
       alignment.add(b.vel);
       totalVectors++;
       }
     }
     
     if(totalVectors > 0){
       alignment.div(totalVectors); 
       alignment.normalize();
       PVector a = PVector.sub(alignment, vel);
       return a;
     }
    
     return alignment;
   }
   
   PVector seperation(ArrayList <Boid> boids){
     PVector sep = new PVector(0,0);
     int totalVectors = 0;
       
     for(Boid b: boids){
       float dist = PVector.dist(pos,b.pos);
       if(dist > 0 && dist < 20){
         PVector s = PVector.sub(pos, b.pos);
         s.normalize();
         s.div(dist);  // weight by how close
         sep.add(s);
         totalVectors++;
       }
       
     }
     
     if(totalVectors > 0){
      sep.div(totalVectors); // average seperation of all close boids
     }
     if(sep.mag() > 0){
       sep.normalize();
       sep.mult(2);
       
       
     }
     
     return sep;
   }
   
   PVector obstacleForces(ArrayList <Obstacle> obstacles){
     PVector obstacleForces = new PVector(0,0);
     for(Obstacle o: obstacles){
      float dist = PVector.dist(pos, o.pos); 
      
      if(dist > 0 && dist < o.r + 10){
        PVector force = PVector.sub(pos, o.pos);
        force.normalize();
        obstacleForces.add(force);
      } 
     }    
     return obstacleForces;
   }
   
 }
  


class Obstacle{
 float x = 0;
 float y = 0;
 int id;
 int r;
 PVector pos;
 Obstacle(float xPos, float yPos, int idNum, int radius){
   x = xPos;
   y = yPos;
   pos = new PVector(xPos, yPos);
   id = idNum;
   r = radius;
 }
}

class SortByF implements Comparator<Node>{
  public int compare(Node n1, Node n2){
    return (n1.f > n2.f) ? 1:0;
  }
}
ArrayList <Node> open;
ArrayList <Node> closed;
ArrayList <Integer> queue = new  ArrayList<Integer>();
ArrayList <Integer> path;
ArrayList <Node> nodes;
ArrayList <Obstacle> obstacles;
Random r = new Random();
int idCount = 1;
int totNodes = 10000;
Node start, goal;
Node currNode;
Node targetNode;
int pathId =0;
Node character;
int[] parent = new int[totNodes+1];
Boolean[] visited = new Boolean[totNodes +1];
ArrayList<Integer>[] neighbors = new ArrayList[totNodes+1];
ArrayList<PVector>vList = new ArrayList<PVector>();
Crowd crowd;
ArrayList<Boolean>collisionList = new ArrayList<Boolean>();

void setup(){
 size(600,600);
 surface.setTitle("A3 Scenario 1"); 
 background(125);
 nodes = new ArrayList<Node>();
 obstacles = new ArrayList<Obstacle>();
 open = new ArrayList<Node>();
 closed = new ArrayList<Node>();
 path = new ArrayList<Integer>();
   for(int i = 0; i <= totNodes; i++){
    parent[i] = -1;
    visited[i] = false;
    neighbors[i] = new ArrayList<Integer>();
  }
  start = new Node(-270, 270,0);
  goal = new Node(270, -270, totNodes - 1);
  character = new Node(start.x, start.y, -1);
  currNode = start;
 initObstacles();
 makePRM();
 runDFS();
 targetNode = nodes.get(path.get(0));
 
 crowd = new Crowd();
for(int i = 0; i < 10; i++){
   
  float xVariability = -2 + r.nextInt(4); 
  float yVariability = -2 + r.nextInt(4); 
  Boid b = new Boid(start.x + xVariability , start.y + yVariability  ); 
  crowd.addBoid(b); 
}
}

void draw(){
  background(125);
 translate(width/2, height/2);
 for(Node n : nodes){
   fill(0, 0, 0);
   if(n.id == 0 || n.id == (totNodes - 1)){
     fill(0,255,0); 
     ellipse(n.x, n.y, 10, 10);
   }
   else if(path.contains(n.id)){
     fill(255,0,0);
       pushMatrix();
   ellipse(n.x, n.y, 10, 10);
   popMatrix();
   }
 
 }
 for(Obstacle o: obstacles){
  fill(255,255,255);
  ellipse(o.x,o.y,o.r - 30,o.r - 30 );
 }
 //for(int i = 0; i < 600; i++){
 //update(.002);
 //}

 fill(0,0,255);
 
// println(character.x, character.y);
 //ellipse(character.x, character.y, 6, 6);
 //for(int i = 0; i < neighbors.length ; i++){
 // for(int j : neighbors[i]){
 //   Node curr = nodes.get(i);
 //   Node comp = nodes.get(j); //<>//
 //   line((comp.x), (comp.y), (curr.x),(curr.y)); 
 // }
 //}

 updateCrowd();
 
 updateCrowd();
 for(int i = 0; i < crowd.boids.size(); i ++){
  fill(0,0, 200);
  PVector goalPos = new PVector(goal.x, goal.y);
  if(PVector.dist(crowd.boids.get(i).pos,goalPos) > 15){
  //println(b.pos.x, b.pos.y); //<>//
  ellipse(crowd.boids.get(i).pos.x,crowd.boids.get(i).pos.y, 10, 10); 
  }
  else{
    crowd.boids.remove(crowd.boids.get(i));
  }
 }
}
void updateCrowd(){
 crowd.run();
}

void makePRM(){
 start = new Node(-270, 270,0);
 nodes.add(start);
 
 int count = 1;
 while(count < totNodes -1){  // Random Node Sampling
   int x = r.nextInt(600) - 300;
   int y = r.nextInt(600) - 300;
   int flag = 0;
   for(int i = 0; i < obstacles.size(); i++ ){
     //ellipse radius = 10 - change if needed
     if(sqrt(pow(x - obstacles.get(i).x,2) + pow(y - obstacles.get(i).y,2)) < obstacles.get(i).r/2 + 10 ){
      flag = 1;
      break;
     }
   }
   if(flag == 0){
      Node randNode = new Node(x,y,idCount);
       idCount++;
       nodes.add(randNode);
       count++;
   }
 }
 

 nodes.add(goal); 
 // loop through nodes and compaare to other nodes - if close and less than n neighbors add to neighbors
 // sort by distance from currNode and then take first 2
 for(int i = 0; i < nodes.size(); i ++){
   Node currNode = nodes.get(i);
   for(int j = 0; j < nodes.size(); j++){
    Node compNode = nodes.get(j);
    float dist = sqrt(pow((currNode.x - compNode.x),2) + pow((currNode.y - compNode.y),2));
    if(dist < 55  && dist > 0){
       neighbors[i].add(j);
     }
    }     
    }
    //int c = 0;
    //while(c < 2){
    // float minDist = Collections.min(distances);
    // print(minDist);
    // int index = distances.indexOf(minDist);
    // println(" ", distances.get(index));
    // if(minDist< 20 ){
    // currNode.neighbors.add(index);
    // println(currNode.x," ", currNode.y,"---->", nodes.get(index).x, " ",nodes.get(index).y );
    // distances.remove(index);
    // c++;
    // }
    // else{ // break out of loop if neighbor isn't close enough
    //   break;
    // }
    //}
    }
  
   
 
 
void initObstacles(){
 Obstacle obs1 = new Obstacle(-180, 180,0, 120 );
 obstacles.add(obs1);
 Obstacle obs2 = new Obstacle(0, 0,1, 70 );
 obstacles.add(obs2);
 Obstacle obs3 = new Obstacle(-100, -100,2, 70 );
 obstacles.add(obs3);
 Obstacle obs4 = new Obstacle(100, 100,3, 70 );
 obstacles.add(obs4);
 Obstacle obs5 = new Obstacle(180,-180, 4, 120);
 obstacles.add(obs5);
  
}

void runAStar(){
 Node currNode = start;
 open.add(0,currNode);
 while(!open.isEmpty()){
   currNode = open.get(0);
   open.remove(0);
   closed.add(currNode);
   for(int n : currNode.neighbors){
     nodes.get(n).parentId = currNode.id;
     if(nodes.get(n).id == totNodes){
       break;
     }
     else{
       float dist = sqrt(pow(nodes.get(n).x - currNode.x,2) + pow(nodes.get(n).y - currNode.y,2));
       nodes.get(n).g = currNode.g + dist;
       nodes.get(n).h = sqrt(pow(goal.x - currNode.x,2) + pow(goal.y - currNode.y,2)); // distance to goal
       nodes.get(n).f = nodes.get(n).g + nodes.get(n).h;
       nodes.get(n).parentId = currNode.id;
       open.add(nodes.get(n));
     }
     if(open.contains(nodes.get(n)) && open.get(open.indexOf(nodes.get(n))).f < nodes.get(n).f){
       // if node is in open and it has a lower f then don't add the node to open again
       continue;       
     }
     else if(closed.contains(nodes.get(n)) && closed.get(closed.indexOf(nodes.get(n))).f < nodes.get(n).f){
       // else if node is in closed with lower f then don't add the node again
       continue;
     }
     else {
       open.add(nodes.get(n));
     }
   }
   Collections.sort(open, new SortByF());
   closed.add(0,currNode);
 }
}

void runDFS(){
  //println(nodes.get(0).neighbors);
  //for(int i = 0; i < nodes.get(0).neighbors.size(); i++){
  //  println(nodes.get(0).neighbors.get(i), "Neighbors -> ", nodes.get(nodes.get(0).neighbors.get(i)).neighbors );
    
  //}
  //println("Goal -->", goal.id);
  visited[nodes.get(0).id] = true;
  queue.add(nodes.get(0).id);
  while(queue.size() > 0){
   int currNode = queue.get(0); 
   //println("Current Node id -->", currNode);
   queue.remove(0);
   if(currNode == totNodes - 1){
   // println("goal"); 
    break; // goal reached 
   }
   for(int i = 0; i < neighbors[currNode].size(); i++){
    // println(currNode.neighbors.get(i));
    int neighborNode = neighbors[currNode].get(i);
     //float dist = sqrt(pow(nodes.get(i).x - currNode.x,2) + pow(nodes.get(i).y - currNode.y,2));
     //nodes.get(i).g = currNode.g + dist;
     //nodes.get(i).h = sqrt(pow(goal.x - currNode.x,2) + pow(goal.y - currNode.y,2)); // distance to goal
     //nodes.get(i).f = nodes.get(i).g + nodes.get(i).h;
     if(!visited[neighborNode]){
       //println(neighborNode);
       //println("Visited: " + nodes.get(i).id);
       visited[neighborNode] = true;
       parent[neighborNode] = currNode;
       queue.add(neighborNode);
     }
   }
   //Collections.sort(open, new SortByF());
  }
  int prevNode = parent[parent.length - 2];
  path.add(prevNode);
  while(prevNode >= 0){
    path.add(prevNode);
    prevNode = parent[prevNode];
  }
  path.remove(0);
  Collections.reverse(path);
    
    path.add(goal.id);
  //println(path);
  }



//void update(float dt){
//  ArrayList <Boolean>collisions = new ArrayList <Boolean>();
//  PVector dir = new PVector();
//  //println("Target ID:", path.indexOf(targetNode.id));
//    //println(targetNode.id, ", ", targetNode.x, ", ", targetNode.y);
//    dir.x = (targetNode.x - currNode.x);
//    float lenX = sqrt(pow(targetNode.x,2) + pow(currNode.x,2));
//    //dirX = dirX/lenX;
//    dir.y = (targetNode.y - currNode.y);
//    float lenY = sqrt(pow(targetNode.y,2) + pow(currNode.y,2));
//    //dirY = dirY/lenY;
//    dir.normalize();
//    float dist = sqrt(pow((character.x - targetNode.x),2) + pow((character.y - targetNode.y),2));
//    //println("distance", dist);
//    if(dist >= 2){
//     character.x = character.x + ( dt *dir.x);
//     character.y = character.y + ( dt * dir.y);
//    }
//    else if (pathId < path.size() - 1){
      
//      currNode = targetNode;  // currNode = node checking collisions for
//      if(currNode.id <(totNodes - 1)){
//        for(int p: path){
//          collisions.add(hasCollision(p));
//        }
//        //println(path.indexOf(currNode.id));
//        //println(collisions);
        
//       targetNode = nodes.get(path.get(pathId)); // desired next target
//       pathId ++;
//        for(int i = pathId ; i < collisions.size() - 1; i++){
//          //println(collisions);//
//         if(collisions.get(i) == false ){
//           targetNode = nodes.get(path.get(i + 1));
//           pathId = i +1;
//         }
//        }
      
//        }
//        //println("pathId", pathId);
        
//      }
//}

//void findNextTarget(){
//  for(int i = 0; i < path.size(); i++){
//    PVector currV = new PVector();
//    currV.x = nodes.get(path.get(i)).x - character.x;
//    currV.y = nodes.get(path.get(i)).y - character.y;
//    currV.normalize();
//    character.vList.add(currV);
//  }
//  for(int j = 0; j < obstacles.size(); j++ ){
//   PVector currW = new PVector();
//   currW.x = obstacles.get(j).x - character.x;
//   currW.y = obstacles.get(j).y - character.y;
//   currW.normalize();
//   character.wList.add(currW);
//  }
//  for(PVector v : character.vList){
//   for(PVector w : character.wList){
//    float a = 1;
//    float b = -2*((v.x * w.x) + (v.y * w.y));
//    float c = (w.x * w.x) + (w.y * w.y) - (obstacles.get(character.wList.indexOf(w)).r *  obstacles.get(character.wList.indexOf(w)).r);
//    float d = b*b - (4* a*c);
//    //float lenv = sqrt(v.x * v.x + v.y*v.y);
//   }
//  }
////    if(d >= 0){
////     float t = (-b - sqrt(d)/(2*a));
////     if(t < 0 || t > lenv){
////       character.collisionList.get(character.vList.indexOf(v)) = true;  // should change to array probably
////       break;    
////    }
////    character.collisionList.add(character.vList.indexOf(v)) = false;
////   } 
////  }
////}
//}

boolean hasCollision(int id, PVector pos){
  ArrayList<PVector>wList = new ArrayList<PVector>();
  boolean col = true; // is there a collision?
  Node checkNode = nodes.get(id);
  PVector v = new PVector();
  v.x = checkNode.x - pos.x;  
  v.y = checkNode.y - pos.y;
  float lenv = sqrt(v.x * v.x + v.y*v.y);
  v.normalize();
  
  for(int j = 0; j < obstacles.size(); j++ ){
   PVector currW = new PVector();
   currW.x = obstacles.get(j).x - pos.x;
   currW.y = obstacles.get(j).y - pos.y;
   wList.add(currW);
  }
  
  for(PVector w : wList){
    float a = 1;
    float b = -2*((v.x * w.x) + (v.y * w.y));
    float c = (w.x * w.x) + (w.y * w.y) - (( obstacles.get(wList.indexOf(w)).r) *  ( obstacles.get(wList.indexOf(w)).r));
    float d = b*b - (4* a*c);
   
     if(d >= 0){
       float t = (-b - sqrt(d)/(2*a));
       if(t > 0 &&  t <  lenv){
         return col;
        }
   }
  }
  return false;
}

void keyPressed(){
 
  if(key == ENTER){
    
  float xVariability = -5 + r.nextInt(10); 
  float yVariability = -5 + r.nextInt(10); 
  Boid b = new Boid(start.x + xVariability, start.y + yVariability ); 
  crowd.addBoid(b); 
  println("added");
  }
   
 
  
}
