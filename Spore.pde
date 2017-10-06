class Spore{
  PImage sprite;
  PVector coords;
  double speed;
  // horizontal, vertical
  PVector direction;
  Vine currentVine;
  
  PVector N, S, E, W;
  
  Spore(int x, int y, Vine v){
    coords = new PVector(x, y);
    sprite = loadImage("spore.png");
    speed = 1;//0.5;
    currentVine = v;
    
    N = new PVector(0, -1);
    S = new PVector(0, 1);
    E = new PVector(1, 0);
    W = new PVector(-1, 0);
    // Maybe randomize these
    direction = W;
  }
  
  void update(){
    println(inverse(new PVector(0, -1)));
    image(sprite, coords.x-(sprite.width/2), coords.y-(sprite.height/2));
    coords.x+=speed*direction.x;
    coords.y+=speed*direction.y;
    
    //\\\\\\\\\\\\\\
    // Reached edge \===============================================================
    if(coords.x%tileSize == 0 || coords.y%tileSize == 0){
      shiftVine();
    }//=============================================================================
    
    //\\\\\\\\\\\\\\\\
    // Reached center \=============================================================
    if(coords.x%tileSize == tileSize/2 && coords.y%tileSize == tileSize/2){
      
      // Array defining which branches/connections the current vine has
      int[] branches = currentVine.connections;
      
      // List of PVectors representing the directions that could be taken from here
      ArrayList<PVector> options = new ArrayList<PVector>();
      
      // For all the valid connections, create the corresponding PVector using
      // getVector(), and add that to the list
      for(int i = 0; i < branches.length; i++){
        if(branches[i] == 1)options.add(getVector(i));
      }
      // Make sure it doesn't go back the way it came
      if(options.size() == 1 && options.get(0).equals(inverse(direction))){
        direction = inverse(direction);
      }
      else{
        options.remove(inverse(direction));
        direction = options.get((int)random(options.size()));
      }
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
  
  void shiftVine(){
    // if heading north or east
    Vine nextVine = null;
    if(direction.x + direction.y > 0)
      // This is necessary due to a bug where north and east were moving one too far
      nextVine = grid[(int)coords.x/tileSize][(int)coords.y/tileSize];
    else
      nextVine = grid[(int)coords.x/tileSize+(int)direction.x][(int)coords.y/tileSize+(int)direction.y];
    if(nextVine == null || !nextVine.hasConnection(getDir(direction)))direction = inverse(direction);
    else currentVine = nextVine;
  }
}