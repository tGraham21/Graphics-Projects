// 5611 Vector library

public class Vect{
 public float x;
 public float y;
 public float z;
 
 public Vect(){
 
 }
  public Vect(float x, float y, float z){
   this.x = x;
   this.y = y;
   this.z = z;
 }
 public void mult(float v){
  this.x = this.x * v;
  this.y = this.y * v;
  this.z = this.z * v;
 }
 public void add(Vect v){
  this.x = this.x +v.x;
  this.y = this.y + v.y;
  this.z = this.z + v.z;
 }
 public void sub(Vect v){
  this.x = this.x - v.x;
  this.y = this.y - v.y;
  this.z = this.z - v.z;
 }
   public float dist(PVector v) { 
    float dx = x - v.x; 
    float dy = y - v.y; 
    float dz = z - v.z; 
    return (float) Math.sqrt(dx*dx + dy*dy + dz*dz); 
  } 
 
 public float dot(Vect v){
   return (this.x * v.x) + (this.y * v.y) + (this.z + v.z);
 }
}
