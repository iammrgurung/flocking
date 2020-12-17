class Ball {
  // member variables
  PVector pos, v;
  int dia;
  PVector acceleration;
  
  // constructor
   Ball (int x, int y, int d) { 
    pos = new PVector(width/2,height/2);
    v = new PVector(1, 1);
    dia = d;
  } 
    
   // methods
  void moveAndShow() { 
    fill(0, 100, 255);
    ellipse(pos.x, pos.y, dia, dia);
    pos.x = pos.x + v.x;
    pos.y = pos.y + v.y;
    if((pos.x >= width) || (pos.x <= 0)) {v.x = -v.x;}
    if((pos.y >= height) || (pos.y <= 0)) {v.y = -v.y;}
  } 
  
   void draw () {
     fill(255, 0, 0);
     ellipse(pos.x, pos.y, 10, 10);
   }
  
}
