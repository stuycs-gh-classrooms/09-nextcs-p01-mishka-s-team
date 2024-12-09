class Ball {
  PVector center;
  float size;
  float xspeed = 0;
  float yspeed = 0;
  
  Ball(PVector center, float size) {
    this.center = center;
    this.size = size;
  }
  
  void move() {
    center.x += xspeed;
    center.y += yspeed;
  }
  
  void display() {
    fill(0, 150, 255);
    ellipse(center.x, center.y, size, size);
  }
  
  boolean collidesWith(Ball other) {
    float distance = dist(center.x, center.y, other.center.x, other.center.y);
    return distance < (size + other.size) / 2;
  }
}

class Paddle {
  float x, y;
  float w, h;
  
  Paddle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display() {
    fill(0, 0, 0);
    rect(x, y, w, h);
  }
  
  void move(float newX) {
    x = constrain(newX - w/2, 0, width - w);
  }
  
  boolean ballCollides(Ball ball) {
    return (ball.center.x > x && ball.center.x < x + w &&
            ball.center.y + ball.size/2 >= y && ball.center.y + ball.size/2 <= y + h);
  }
}

class Brick {
  PVector position;
  float w, h;
  boolean isDestroyed = false;
  color brickColor;
  
  Brick(float x, float y, float w, float h) {
    this.position = new PVector(x, y);
    this.w = w;
    this.h = h;
    this.brickColor = color(random(50, 255), random(50, 255), random(50, 255));
  }
  
  void display() {
    if (!isDestroyed) {
      fill(brickColor);
      rect(position.x, position.y, w, h);
    }
  }
  
  boolean ballCollides(Ball ball) {
    return !isDestroyed && 
           ball.center.x > position.x && 
           ball.center.x < position.x + w &&
           ball.center.y - ball.size/2 <= position.y + h && 
           ball.center.y + ball.size/2 >= position.y;
  }
}
