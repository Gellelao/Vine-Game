Vine[][] grid;
int gridWidth;
int gridHeight;
int tileSize;
ArrayList<Spore> spores;
ArrayList<Pod> pods;
ArrayList<PVector> validVines;

//          N  S  E  W
int[] NW = {0, 1, 1, 0};
int[] NE = {0, 1, 0, 1};
int[] SW = {1, 0, 1, 0};
int[] SE = {1, 0, 0, 1};

int scale = 2;

// Note that cursorCoords represent tile coordinates
PVector cursorCoords;

void setup(){
  size(960, 960);
  //frameRate(1);
  rectMode(CORNER);
  noSmooth();
  noStroke();
  fill(27, 160, 33);
  gridWidth  = 30;
  gridHeight = 30;
  tileSize   = 32*scale;
  
  spores = new ArrayList<Spore>();
  pods = new ArrayList<Pod>();
  validVines = new ArrayList<PVector>();
  cursorCoords = new PVector(13/scale, 13/scale);
  
  grid = new Vine[gridWidth][gridHeight];
}

void draw(){
  // Background on bottom layer
  background(255);
  
  // check to see if any pods should be created
  scan();
  // Draw the pods on second layer
  for(Pod p : pods){p.update();}
  
  // Then cursor
  fill(27, 160, 33);
  ellipse(min(29, cursorCoords.x)*tileSize+tileSize/2, min(29, cursorCoords.y)*tileSize+tileSize/2, tileSize, tileSize);
  
  // Then vines
  //______________________________________________________________
  for (int row = 0; row < gridWidth; row++) {
    for (int col = 0; col < gridHeight; col++) {
      if (grid[row][col] != null) grid[row][col].update(row, col);
    }
  }//           Draws all the vines
  //--------------------------------------------------------------
  
  //On the top layer draw spores
  for(Spore s : spores){s.update();}
}

void keyPressed() {
  
  int dir = -1;
  int x = constrain((int)cursorCoords.x, 0, gridWidth-1);
  int y = constrain((int)cursorCoords.y, 0, gridHeight-1);
  
  if ((key == 'W') || (key == 'w')) {
    dir = 0;
    add(grid[x][y], dir);
    if(cursorCoords.y > 0)cursorCoords.y--;
  }
  if((key == 'A') || (key == 'a')) {
    dir = 3;
    add(grid[x][y], dir);
    if(cursorCoords.x > 0)cursorCoords.x--;
  }
  if((key == 'D') || (key == 'd')) {
    dir = 2;
    add(grid[x][y], dir);
    if(cursorCoords.x < gridWidth)cursorCoords.x++;
  }
  if((key == 'S') || (key == 's')) {
    dir = 1;
    add(grid[x][y], dir);
    if(cursorCoords.y < gridHeight)cursorCoords.y++;
  }
  
  if (keyCode == UP) { 
    grid[x][y].attemptLink(x, y, 0);
  }
  if(keyCode == DOWN) {
    grid[x][y].attemptLink(x, y, 1);
  }
  if(keyCode == RIGHT) {
    grid[x][y].attemptLink(x, y, 2);
  }
  if(keyCode == LEFT) {
    grid[x][y].attemptLink(x, y, 3);
  }
  
  if(key == ' ') {
    spores.add(new Spore(x*tileSize+tileSize/2, y*tileSize+tileSize/2));
  }
  
  x = constrain((int)cursorCoords.x, 0, gridWidth-1);
  y = constrain((int)cursorCoords.y, 0, gridHeight-1);

  if(dir >= 0){
    if(grid[x][y] == null) grid[x][y] = new Vine(dir);
    if(x < gridWidth-1 && y < gridHeight-1)
      validVines.add(new PVector(x, y));
      
    //println(validVines);
    //scan();
    //println("__________________");
  }
}

void add(Vine v, int dir){
  if(v != null)v.addConnection(dir);
}

//boolean isCorner(int x, int y, int[] corner){
//  if(grid[x][y] == null)return false;
//  return(grid[x][y].matches(corner));
//}

void scan(){
  //ArrayList<PVector> toRemove = new ArrayList<PVector>();
  int x, y;
  for(PVector p : validVines){
    // corners counts the number of valid corners in the current check
    int corners = 0;
    // sides counts the number of connections that these four vines hold collectively
    int sides = 0;
    //println("Checking " + p);
    x = (int)p.x;
    y = (int)p.y;
    
    Vine v = grid[x][y];
    if(v != null){
      corners+=v.sidesMatching(NW);
      sides += v.conCount();
    }
    v = grid[x+1][y];
    if(v != null){
      corners+=v.sidesMatching(NE);
      sides += v.conCount();
    }
    v = grid[x][y+1];
    if(v != null){
      corners+=v.sidesMatching(SW);
      sides += v.conCount();
    }
    v = grid[x+1][y+1];
    if(v != null){
      corners+=v.sidesMatching(SE);
      sides += v.conCount();
    }
    
    
    //if(v != null){
    //  if(v.matches(NW))corners++;
    //  sides += v.conCount();
    //}
    //v = grid[x+1][y];
    //if(v != null){
    //  if(v.matches(NE))corners++;
    //  sides += v.conCount();
    //}
    //v = grid[x][y+1];
    //if(v != null){
    //  if(v.matches(SW))corners++;
    //  sides += v.conCount();
    //}
    //v = grid[x+1][y+1];
    //if(v != null){
    //  if(v.matches(SE))corners++;
    //  sides += v.conCount();
    //}
    
    println(corners);
    println(sides);
    println("");
    //if(corners >= 2 && sides >= 8){
    //if(corners+count==12 && corners >= 3){
      
      // Work on some better rules for this
    if(corners >= 8 && sides <= 10){
       pods.add(new Pod(x*tileSize+tileSize/2, y*tileSize+tileSize/2));
    }
      //else toRemove.add(p);
    }
    println("__________________");
  //validVines.removeAll(toRemove);
}