Flock flock;
Button[] button = new Button[3];

float countBoid = 50;

 void setup(){
 size(700, 500);
 button[0]= new Button(50,50,"Play",50,20,0,200,255);
 button[1] = new Button(50,100,"Pause",50,20,0,200,255);
 button[2] = new Button(50,150,"Stop",50,20,0,200,255);

  // Create a boid world
 flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < countBoid; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  
  flock.addBall(new Ball(mouseX, mouseY, 10));
}


void draw() {
  background(50);
  flock.run();
  
  for(Button b: button) {
   b.draw(); 
  }
  
  for(int i = 0; i <flock.obstacle.size(); i++) {
    Obstacle current = flock.obstacle.get(i);
    current.go();
    current.draw();
  }
}

// Add a new avoid into the System
void mousePressed() {
   
   if(button[0].isClicked() == true) {
     loop();
   } else if(button[1].isClicked() == true) {
     noLoop();
   } else if(button[2].isClicked() == true) {
     exit();
   }
   else {
     flock.addObstacle(new Obstacle(mouseX, mouseY));
   }
}
