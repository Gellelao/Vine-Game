Vine[][] grid;
int gridWidth;
int gridHeight;
int tileSize;
Vine origin;
ArrayList<Spore> spores;
ArrayList<Spore> removeSpores;
ArrayList<Aphid> aphids;
ArrayList<Aphid> removeAphids;
ArrayList<Beetle> beetles;
ArrayList<Beetle> removeBeetles;
ArrayList<Egg> eggs;
ArrayList<Egg> removeEggs;
ArrayList<Pod> pods;
ArrayList<PVector> validVines;

// Sprites
PImage APHID;
PImage BEETLE;
PImage EGG;
PImage POD;
PImage SPORE;
// Should do vines once I figure out rotations

//          N  S  E  W
int[] NW = {0, 1, 1, 0};
int[] NE = {0, 1, 0, 1};
int[] SW = {1, 0, 1, 0};
int[] SE = {1, 0, 0, 1};

int scale = 2;
float sporeSpeed = 0.5;// should be scale/4;
float aphidSpeed = 2;
float beetleSpeed = 8;
int puffRate = (int)(256*sporeSpeed);

int aphidTimer;
int aphidTimerMax = 1000;

// Note that cursorCoords represent tile coordinates
PVector cursorCoords;

// Beetles eat Aphids which eat Spores
// When a Beetle destroys and Aphid it lays eggs there
// Supplying the egg with spores will create another beetle

void setup(){
  size(960, 960);
  frameRate(60);
  noSmooth();
  noStroke();
  fill(27, 160, 33);
  gridWidth  = 30;
  gridHeight = 30;
  tileSize   = 32*scale;
  
  spores = new ArrayList<Spore>();
  removeSpores = new ArrayList<Spore>();
  aphids = new ArrayList<Aphid>();
  removeAphids = new ArrayList<Aphid>();
  beetles = new ArrayList<Beetle>();
  removeBeetles = new ArrayList<Beetle>();
  eggs = new ArrayList<Egg>();
  removeEggs = new ArrayList<Egg>();
  pods = new ArrayList<Pod>();
  validVines = new ArrayList<PVector>();
  cursorCoords = new PVector(13/scale, 13/scale);
  
  // Load in sprites
  APHID = loadImage("aphid.png");
  BEETLE = loadImage("beetle.png");
  EGG = loadImage("egg.png");
  POD = loadImage("pod.png");
  SPORE = loadImage("spore.png");
  
  aphidTimer = 0;
  
  grid = new Vine[gridWidth][gridHeight];
  
  int x = (int)cursorCoords.x;
  int y = (int)cursorCoords.y;
  origin = new Vine(x, y, 0);
  grid[x][x] = origin;   // This looks like a bug... but I think it doesn't matter
  validVines.add(new PVector(x, y));
  
  eggs.add(new Egg(4, 4));
}

void draw(){
  println(frameRate);
  
  // Background on bottom layer
  background(255);
  
  // check to see if any pods should be created
  scan();
  
  // Draw the pods on second layer
  for(Pod p : pods){p.update();}
  
  // Then cursor
  fill(27, 160, 33);
  ellipse(min(29, cursorCoords.x)*tileSize+tileSize/2, min(29, cursorCoords.y)*tileSize+tileSize/2, tileSize/2, tileSize/2);
  
  // Then vines
  //______________________________________________________________
  for (int row = 0; row < gridWidth; row++) {
    for (int col = 0; col < gridHeight; col++) {
      if (grid[row][col] != null) grid[row][col].update();
    }
  }//           Draws all the vines
  //--------------------------------------------------------------
  
  aphidTimer++;
  // Create an aphid if the timer is ready
  if(aphidTimer >= aphidTimerMax){
    aphids.add(new Aphid(origin));
    aphidTimer = 0;
  }
  
  // Delete unnecessary spores
  spores.removeAll(removeSpores);
  
  // Then draw remaining spores
  for(Spore s : spores){s.update();}
  
  // Delete unnecessary aphids
  aphids.removeAll(removeAphids);
  
  // Then draw remaining aphids
  for(Aphid a : aphids){a.update();}
  
  // Delete unnecessary beetles
  beetles.removeAll(removeBeetles);
  
  // Then draw remaining beetles
  for(Beetle b : beetles){b.update();}
  
  // Delete unnecessary eggs
  eggs.removeAll(removeEggs);
  
  // Then draw remaining eggs on the top layer
  for(Egg e : eggs){e.update();}
}

void keyPressed() {
  int dir = -1;
  int x = constrain((int)cursorCoords.x, 0, gridWidth-1);
  int y = constrain((int)cursorCoords.y, 0, gridHeight-1);
  
  // WASD keys set a direction to create a vine from, and move the cursor
  //
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
  
  // The arrow keys allow you make short connections to adjacent vines without moving your cursor there
  //
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
    //for(Pod p : pods)p.puff();
    spores.add(new Spore(grid[x][y]));
    beetles.add(new Beetle(grid[x][y]));
  }
  
  // Ensure we stay within the bounds
  x = constrain((int)cursorCoords.x, 0, gridWidth-1);
  y = constrain((int)cursorCoords.y, 0, gridHeight-1);

  // If a proper key has been pressed, create a vine and add it's location to validVines
  if(dir >= 0){
    if(grid[x][y] == null) grid[x][y] = new Vine(x, y, dir);
    if(x < gridWidth-1 && y < gridHeight-1)
      validVines.add(new PVector(x, y));
  }
}

void add(Vine v, int dir){
  if(v != null)v.addConnection(dir);
}

void scan(){
  // scan loops through each vine(V), and checks the "box" that that vine and the three vines(v) to it's south-east make up
  // it counts the connections (possible connections are shown by the lines below) and creates a Pod if conditions are right
  
  //   |  |
  // --V--v--
  //   |  |
  // --v--v--
  //   |  |
  
  int x, y;
  for(PVector p : validVines){
    // sides counts the number of sides surrounding the current "box"
    int sides = 0;
    // totalConnections counts the number of connections that these four vines hold collectively
    int totalConnections = 0;
    
    x = (int)p.x;
    y = (int)p.y;
    
    // Count up info about this current "box"
    Vine v = grid[x][y];
    if(v != null){
      sides+=v.sidesMatching(NW);
      totalConnections += v.conCount();
    }
    v = grid[x+1][y];
    if(v != null){
      sides+=v.sidesMatching(NE);
      totalConnections += v.conCount();
    }
    v = grid[x][y+1];
    if(v != null){
      sides+=v.sidesMatching(SW);
      totalConnections += v.conCount();
    }
    v = grid[x+1][y+1];
    if(v != null){
      sides+=v.sidesMatching(SE);
      totalConnections += v.conCount();
    }

    // To summon a pod, the box must be fully enclosed and have only two "extra" connections
    if(sides >= 8 && totalConnections <= 10){
       Pod toAdd = new Pod(x, y);
       boolean dupe = false;
       
       // Only add if one has not been previously added here
       for(Pod pod : pods){
         if(pod.equals(toAdd))dupe = true;
       }
       if(!dupe)pods.add(toAdd);
    }
  }
}