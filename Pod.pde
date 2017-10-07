class Pod{
  // Grid coords
  PVector coords;
  float count;
  
  Pod(int x, int y){
    coords = new PVector(x, y);
    count = 0;
  }
  
  void update(){
    fill(0, 0, 255);
    rect(coords.x*tileSize+tileSize/2, coords.y*tileSize+tileSize/2, tileSize, tileSize);
    count++;
    if(count == puffRate){
      count = 0;
      puff();
    }
  }
  
  void puff(){
    int x = (int)coords.x;
    int y = (int)coords.y;
    
    ArrayList<Vine> cornerVines = new ArrayList<Vine>();
    
    cornerVines.add(grid[x][y]);
    cornerVines.add(grid[x+1][y]);
    cornerVines.add(grid[x][y+1]);
    cornerVines.add(grid[x+1][y+1]);
    Vine selected = cornerVines.get((int)random(cornerVines.size()));
    spores.add(new Spore(selected));
  }
  
  boolean equals(Pod p){
    return coords.equals(p.coords);
  }
}