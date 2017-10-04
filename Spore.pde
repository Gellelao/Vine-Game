class Spore{
  PImage sprite;
  PVector coords;
  
  Spore(int x, int y){
    coords = new PVector(x, y);
    sprite = loadImage("spore.png");
  }
  
  void update(){
    image(sprite, coords.x-(sprite.width/2), coords.y-(sprite.height/2));
    //println("drawing");
  }
}