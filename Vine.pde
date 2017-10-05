class Vine {
  PImage sprite;
  PImage sprite1;
  //                   N  S  E  W
  int[] connections = {0, 0, 0, 0};
  
  boolean highlighted = false;

  Vine(int dir) {
    connections[invert(dir)] = 1;
    sprite = loadImage("vine.png");
    sprite1 = loadImage("vine1.png");
  }

  void update(int x, int y) {
    if(highlighted)rect(x*tileSize, y*tileSize, tileSize, tileSize);
    // North Connection
    if (connections[0] == 1) 
      image(sprite, x*tileSize, y*tileSize, tileSize, tileSize/2);
    
    // South Connection
    if (connections[1] == 1) 
      image(sprite, x*tileSize, y*tileSize+tileSize/2, tileSize, tileSize/2);

    // East Connection
    if (connections[2] == 1) 
      image(sprite1, x*tileSize+tileSize/2, y*tileSize, tileSize/2, tileSize);
      
    // West Connection
    if (connections[3] == 1) 
      image(sprite1, x*tileSize, y*tileSize, tileSize/2, tileSize);
  }

  void attemptLink(int x, int y, int dir) {
    switch(dir) {
    case 0:
      if (grid[x][max(y-1, 0)] != null) {
        grid[x][max(y-1, 0)].addConnection(invert(dir));
        addConnection(dir);
      }
      return;
    case 1:
      if (grid[x][min(y+1, gridHeight-1)] != null) {
        grid[x][min(y+1, gridHeight-1)].addConnection(invert(dir));
        addConnection(dir);
      }
      return;
    case 2:
      if (grid[min(x+1, gridWidth-1)][y] != null) {
        grid[min(x+1, gridWidth-1)][y].addConnection(invert(dir));
        addConnection(dir);
      }
      return;
    case 3:
      if (grid[max(x-1, 0)][y] != null) {
        grid[max(x-1, 0)][y].addConnection(invert(dir));
        addConnection(dir);
      }
      return;
    }
  }

  void addConnection(int dir) {
    connections[dir] = 1;
  }

  // Returns the opposite of the given direction, according to the connections above
  int invert(int dir) {
    switch(dir) {
    case 0:
      return 1;
    case 1:
      return 0;
    case 2:
      return 3;
    case 3:
      return 2;
    default:
      return -1;
    }
  }
  
  int sidesMatching(int[] match){
    if(match.length != connections.length){
      println("Error: matches() method is being passed an array of incorrect length");
      return -20;
    }
    int count = 0;
    if(connections[0] == match[0] && match[0] == 1)count++;
    if(connections[1] == match[1] && match[1] == 1)count++;
    if(connections[2] == match[2] && match[2] == 1)count++;
    if(connections[3] == match[3] && match[3] == 1)count++;
    return count;
  }
  
  int conCount(){
    int count = 0;
    for(Integer i : connections)if(i == 1)count++;
    return count;
  }
  
  void highlight(boolean g){
    highlighted  = g;
  }
}