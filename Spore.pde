class Spore{
  PImage sprite;
  // Grid coords
  PVector coords;
  // Screen coords
  PVector screenCoords;
  // horizontal, vertical
  PVector direction;
  Vine currentVine;
  
  PVector N, S, E, W;
  
  Spore(Vine v){
    coords = new PVector(v.coords.x, v.coords.y);
    sprite = loadImage("spore.png");
    currentVine = v;
    
    N = new PVector(0, -1);
    S = new PVector(0, 1);
    E = new PVector(1, 0);
    W = new PVector(-1, 0);
    pickDirection(true);
    
    screenCoords = new PVector(coords.x*tileSize+tileSize/2, coords.y*tileSize+tileSize/2);
  }
  
  void update(){
    image(sprite, screenCoords.x-(sprite.width*scale/4), screenCoords.y-(sprite.height*scale/4), sprite.width*scale/2, sprite.height*scale/2);
    screenCoords.x+=sporeSpeed*direction.x;
    screenCoords.y+=sporeSpeed*direction.y;
    
     //if(currentVine != null)currentVine.highlight(true);
     //if(screenCoords.x%tileSize == 0 || screenCoords.y%tileSize == 0){
     //  if(currentVine != null)currentVine.highlight(false);
     //  currentVine = grid[(int)coords.x+(int)direction.x][(int)coords.y+(int)direction.y];
     //}
    
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
    // if heading north or east
    Vine nextVine = null;
    if(direction.x + direction.y > 0){
      // This is necessary due to a bug where north and east were moving one too far
      nextVine = grid[(int)screenCoords.x/tileSize][(int)screenCoords.y/tileSize];
    }
    else nextVine = grid[(int)screenCoords.x/tileSize+(int)direction.x][(int)screenCoords.y/tileSize+(int)direction.y];
    if(nextVine == null || !nextVine.hasConnection(getDir(direction)))direction = inverse(direction);
    else currentVine = nextVine;
    //if(nextVine != null)nextVine.highlight(false);
  }
}