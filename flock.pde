// Flock - a list of Boid objects
class Flock
{
   ArrayList<Boid> boids; // an ArrayList of all boids
   ArrayList<Ball> ball;
   ArrayList<Obstacle> obstacle; // an ArrayList of all obstacle
   
   Flock()
   {
     boids = new ArrayList<Boid>(); // Initilizing an ArrayList<Boids>
     ball = new ArrayList<Ball>();
     obstacle = new ArrayList<Obstacle>(); // Initilizing an ArrayList<Avoid>
   }
   
   void run()
   {
       for(Boid b : boids)
       {
         b.run(boids); // Individuallly passing all the list of boids to each boid 
       }
       
       for(Ball b: ball) {
        b. moveAndShow();
       }
   }  
   
   void addBoid(Boid b)
   {
     boids.add(b);
   }
   
   void addObstacle(Obstacle a) {
     
     obstacle.add(a);
   }
   
   void addBall(Ball b)
   {
     ball.add(b);
   }
}
