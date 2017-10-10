class Aphid extends Traverser{
  
  Aphid(Vine v){
    super(v, aphidSpeed, APHID);
  }
  
  void update(){
    // Aphids "eat" any spores they come across
    for(Spore s : spores){
      if(dist(s.screenCoords.x, (int)s.screenCoords.y, (int)this.screenCoords.x, (int)this.screenCoords.y) < 5)removeSpores.add(s);
    }
    
    // Delete this if outside the screen
    if(coords.x < 0 || coords.x > width || coords.y < 0 || coords.y > height)removeAphids.add(this);
    
    super.updatePos();
  }
}