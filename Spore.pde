class Spore{
  PImage sprite;
  PVector coords;
  double speed;
  // horizontal, vertical
  PVector directions;
  Vine currentVine;
  
  Spore(int x, int y, Vine v){
    coords = new PVector(x, y);
    sprite = loadImage("spore.png");
    speed = 0.5;
    currentVine = v;
    // Maybe randomize these
    directions = new PVector(-1, 0);
  }
  
  void update(){
    image(sprite, coords.x-(sprite.width/2), coords.y-(sprite.height/2));
    coords.x+=speed*directions.x;
    coords.y+=speed*directions.y;
    if(currentVine != null)currentVine.highlight(true);
    if(coords.x%tileSize == 0 || coords.y%tileSize == 0){
      if(currentVine != null)currentVine.highlight(false);
      currentVine = grid[(int)coords.x/tileSize+(int)directions.x][(int)coords.y/tileSize+(int)directions.y];
    }
  }
}