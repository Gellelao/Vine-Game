class Egg {
  PVector coords;
  PVector screenCoords;
  int count;
  
  Egg(int x, int y){
    coords = new PVector(x, y);
    screenCoords = new PVector(coords.x*tileSize+tileSize/2, coords.y*tileSize+tileSize/2);
    count = 0;
  }

  void update() {
    fill(0, 200, 0);
    imageMode(CENTER);
    image(EGG, coords.x*tileSize+tileSize/2, coords.y*tileSize+tileSize/2, tileSize/2, tileSize/2);
    imageMode(CORNER);

    // Eggs absorb any spores that come near
    for (Spore s : spores) {
      if (dist(s.screenCoords.x, (int)s.screenCoords.y, (int)this.screenCoords.x, (int)this.screenCoords.y) < 5){
        removeSpores.add(s);
        count++;
      }
    }
    if(count >= 10){
      beetles.add(new Beetle(grid[(int)coords.x][(int)coords.y]));
      count = 0;
      removeEggs.add(this);
    }
  }
}