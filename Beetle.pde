class Beetle extends Traverser{
  
  Beetle(Vine v){
    super(v, beetleSpeed, BEETLE);
  }
  
  void update(){
    
    // Beetles "eat" any aphids they come across
    for(Aphid a : aphids){
      if(dist(a.screenCoords.x, (int)a.screenCoords.y, (int)this.screenCoords.x, (int)this.screenCoords.y) < 5){
        removeAphids.add(a);
        eggs.add(new Egg((int)currentVine.coords.x, (int)currentVine.coords.y));
        removeBeetles.add(this);
      }
    }
    
    // Delete this if outside the screen
    if(coords.x < 0 || coords.x > width || coords.y < 0 || coords.y > height)removeBeetles.add(this);
    
    super.updatePos();
  }
}