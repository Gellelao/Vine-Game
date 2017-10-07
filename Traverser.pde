abstract class Traverser{
  PImage sprite;
  // Grid coords
  PVector coords;
  // Screen coords
  PVector screenCoords;
  // horizontal, vertical
  float speed;
  PVector direction;
  Vine currentVine;
  
  PVector N, S, E, W;
  
  Traverser(Vine v, float speed, PImage sprite){
    coords = new PVector(v.coords.x, v.coords.y);
    this.sprite = sprite;
    this.speed = speed;
    currentVine = v;
    
    N = new PVector(0, -1);
    S = new PVector(0, 1);
    E = new PVector(1, 0);
    W = new PVector(-1, 0);
    pickDirection(true);
    
    screenCoords = new PVector(coords.x*tileSize+tileSize/2, coords.y*tileSize+tileSize/2);
  }
  
  abstract void update();
  
  void updatePos(){
    image(sprite, screenCoords.x-(sprite.width*scale/4), screenCoords.y-(sprite.height*scale/4), sprite.width, sprite.height);
    
    screenCoords.x+=speed*direction.x;
    screenCoords.y+=speed*direction.y;
    
    //\\\\\\\\\\\\\\\
    // Reached edge \\==============================================================
    if(screenCoords.x%tileSize == 0 || screenCoords.y%tileSize == 0){
      shiftVine();
    }//=============================================================================
    
    //\\\\\\\\\\\\\\\\\
    // Reached center \\============================================================
    if(screenCoords.x%tileSize == tileSize/2 && screenCoords.y%tileSize == tileSize/2){
      pickDirection(false);
    }//=============================================================================
  }
  
  PVector inverse(PVector p){
    if(p.equals(N))return S;
    if(p.equals(S))return N;
    if(p.equals(E))return W;
    if(p.equals(W))return E;
    return null;
  }
  
  PVector getVector(int i ){
    if(i == 0)return N;
    else if(i == 1)return S;
    else if(i == 2)return E;
    else if(i == 3)return W;
    else {
      println("unexpected value provided to getVector");
      return new PVector(3, 2);
    }
  }
  
  int getDir(PVector p){
    if(p.equals(N))return 0;
    else if(p.equals(S))return 1;
    else if(p.equals(E))return 2;
    else if(p.equals(W))return 3;
    else return -20;
  }
  
  void pickDirection(boolean spawn){
    // Array defining which branches/connections the current vine has
    int[] branches = currentVine.connections;
    
    // List of PVectors representing the directions that could be taken from here
    ArrayList<PVector> options = new ArrayList<PVector>();
    
    // For all the valid connections, create the corresponding PVector using
    // getVector(), and add that to the list
    for(int i = 0; i < branches.length; i++){
      if(branches[i] == 1)options.add(getVector(i));
    }
    
    if(spawn){
      direction = options.get((int)random(options.size()));
    }
    else{
      // If at a dead end, reverse
      if(options.size() == 1 && options.get(0).equals(inverse(direction))){
        direction = inverse(direction);
      }
      // Otherwise choose a direction out of the options
      else{
        options.remove(inverse(direction));
        direction = options.get((int)random(options.size()));
      }
    }
  }
  
  void shiftVine(){
    Vine nextVine = null;
    int x = constrain((int)screenCoords.x/tileSize, 0, gridWidth-1);
    int y = constrain((int)screenCoords.y/tileSize, 0, gridHeight-1);
    
    // if heading north or east
    if(direction.x + direction.y > 0){
      // This is necessary due to a bug where north and east were moving one too far
      nextVine = grid[x][y];
    }
    else nextVine = grid[constrain(x+(int)direction.x, 0, gridWidth-1)][constrain(y+(int)direction.y, 0, gridHeight-1)];
    
    if(nextVine == null || !nextVine.hasConnection(getDir(direction)))direction = inverse(direction);
    else currentVine = nextVine;
  }
}