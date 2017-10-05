class Pod{
  PVector coords;
  
  Pod(int x, int y){
    coords = new PVector(x, y);
  }
  
  void update(){
    fill(0, 0, 255);
    rect(coords.x, coords.y, tileSize, tileSize);
  }
}