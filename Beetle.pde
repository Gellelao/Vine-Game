class Beetle extends Traverser{
  PImage sprite;
  
  Beetle(Vine v){
    super(v, beetleSpeed, loadImage("beetle.png"));
  }
  
  void update(){
    
    // Beetles "eat" any aphids they come across
    for(Aphid a : aphids){
      if(dist(a.screenCoords.x, (int)a.screenCoords.y, (int)this.screenCoords.x, (int)this.screenCoords.y) < 5)removeAphids.add(a);
    }
    
    // Delete this if outside the screen
    if(coords.x < 0 || coords.x > width || coords.y < 0 || coords.y > height)removeBeetles.add(this);
    
    super.updatePos();
  }
}