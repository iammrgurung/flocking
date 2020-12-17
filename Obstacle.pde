class Obstacle {
   PVector pos;
   
   Obstacle (float xx, float yy) {
     pos = new PVector(xx,yy);
   }
   
   void go() {
     
   }
   
   void draw () {
     fill(255, 0, 0);
     ellipse(pos.x, pos.y, 15, 15);
   }
   
}
