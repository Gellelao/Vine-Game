class Spore extends Traverser{
  PImage sprite;
  
  Spore(Vine v){
    super(v, sporeSpeed, loadImage("spore.png"));
  }
  
  void update(){
    // Delete this if outside the screen
    if(coords.x < 0 || coords.x > width || coords.y < 0 || coords.y > height)removeSpores.add(this);
    
    super.updatePos();
  }
}