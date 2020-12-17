class Boid {
    PVector position;
    PVector velocity;
    PVector acceleration;
    float r;
    float maxforce; //Max sterring force
    float maxspeed; // Max speed
    color col;
    
    Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }

    
    void run(ArrayList<Boid> boids)
    {
       flock(boids);
       update();
       borders();
       draw();
    }
    
    void applyforce(PVector force)
    {
        acceleration.add(force);
    }
    
    // We accumulate a new acceleration each time based on three rules
    void flock(ArrayList<Boid> boids)
  {
      PVector sep = separate(boids); // Separation
      PVector ali = align(boids); // Alignment
      PVector coh = cohesion(boids); // Cohesion
      PVector avoidObjects = getAvoidAvoids();
      PVector avoid = getAvoid();
      
      // Arbitrarily weight these forces
      sep.mult(1.5);
      ali.mult(1.0);
      coh.mult(1.0);
      avoidObjects.mult(3);
      avoid.mult(3);
      
      // Add the force vectors to acceleration
      applyforce(sep);
      applyforce(ali);
      applyforce(coh);
      applyforce(avoidObjects);
      applyforce(avoid);
  }
  
  // Method to update position
 void update()
 {
   // Update velocity
    velocity.add(acceleration); 
     // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
 }
  
  // A method that calculates and applies a steering force towards a target
  // STEER = Desired MINUS VELOCITY
  PVector seek(PVector target)
  {
    
     PVector desired = PVector.sub(target, position); // A vector pointing from the position to the target
    // Scale to maximum speed
     desired.setMag(maxspeed);

    // Steering = desired minus Velocity
     PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  void draw() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(250, 150);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }
  
  // Wrap around
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float seperationRadius = 27.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < seperationRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {

      // Implement Reynolds: Steering = Desired - Velocity
      steer.setMag(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbords = 55;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbords)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbords = 55;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbords)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  //Avoid Obstacle
  // Method checks for nearby obstacle and steer away
 PVector getAvoidAvoids() {
    float avoidRaduis = 40.0f;
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Obstacle other : flock.obstacle) {
      float d = PVector.dist(position, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRaduis)) {
        // Calculate vector pointing away from neighbords
        PVector diff = PVector.sub(position, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }
  
  // Avoid hunter
    PVector getAvoid() {
    float avoidRaduis = 70.0f;
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Ball other : flock.ball) {
      float d = PVector.dist(position, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRaduis)) {
        // Calculate vector pointing away from neighbords
        PVector diff = PVector.sub(position, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }
}
