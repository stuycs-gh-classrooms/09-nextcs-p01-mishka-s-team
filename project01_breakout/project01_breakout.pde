// Game variables
Ball ball;
Paddle paddle;
Brick[][] bricks;
int score = 0;
int lives = 3;
boolean gameOver = false;

void setup() {
  size(600, 800);
  resetGame();
}

void resetGame() {
  // Create ball
  ball = new Ball(new PVector(width/2, height - 150), 15);
  ball.xspeed = random(-3, 3);
  ball.yspeed = -5;
  
  // Create paddle
  paddle = new Paddle(width/2 - 50, height - 100, 100, 20);
  
  // Create bricks
  bricks = new Brick[5][10];
  float brickWidth = width / 10;
  float brickHeight = 30;
  
  for (int row = 0; row < 5; row++) {
    for (int col = 0; col < 10; col++) {
      bricks[row][col] = new Brick(
        col * brickWidth, 
        50 + row * brickHeight, 
        brickWidth - 2, 
        brickHeight - 2
      );
    }
  }
  
  score = 0;
  lives = 3;
  gameOver = false;
}

void draw() {
  background(220);
  
  if (gameOver) {
    displayGameOver();
    return;
  }
  
  // Move ball
  ball.move();
  
  // Wall collisions
  if (ball.center.x - ball.size/2 <= 0 || ball.center.x + ball.size/2 >= width) {
    ball.xspeed *= -1;
  }
  
  // Top wall collision
  if (ball.center.y - ball.size/2 <= 0) {
    ball.yspeed *= -1;
  }
  
  // Bottom (lose life)
  if (ball.center.y + ball.size/2 >= height) {
    lives--;
    if (lives <= 0) {
      gameOver = true;
    } else {
      ball = new Ball(new PVector(width/2, height - 150), 15);
      ball.xspeed = random(-3, 3);
      ball.yspeed = -5;
    }
  }
  
  // Paddle collision
  if (paddle.ballCollides(ball)) {
    ball.yspeed *= -1;
    // Add some horizontal movement based on where ball hits paddle
    float hitPosition = (ball.center.x - paddle.x) / paddle.w;
    ball.xspeed = map(hitPosition, 0, 1, -5, 5);
  }
  
  // Brick collisions
  for (int row = 0; row < bricks.length; row++) {
    for (int col = 0; col < bricks[row].length; col++) {
      Brick brick = bricks[row][col];
      if (brick.ballCollides(ball) && !brick.isDestroyed) {
        brick.isDestroyed = true;
        ball.yspeed *= -1;
        score += 10;
      }
    }
  }
  
  // Check if all bricks are destroyed
  boolean allBricksDestroyed = true;
  for (int row = 0; row < bricks.length; row++) {
    for (int col = 0; col < bricks[row].length; col++) {
      if (!bricks[row][col].isDestroyed) {
        allBricksDestroyed = false;
        break;
      }
    }
    if (!allBricksDestroyed) break;
  }
  
  if (allBricksDestroyed) {
    gameOver = true;
  }
  
  // Display game elements
  paddle.display();
  ball.display();
  
  // Draw bricks
  for (int row = 0; row < bricks.length; row++) {
    for (int col = 0; col < bricks[row].length; col++) {
      bricks[row][col].display();
    }
  }
  
  // Display score and lives
  fill(0);
  textSize(20);
  text("Score: " + score, 10, 30);
  text("Lives: " + lives, width - 100, 30);
}

void mouseMoved() {
  paddle.move(mouseX);
}

void mousePressed() {
  if (gameOver) {
    resetGame();
  }
}

void displayGameOver() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(48);
  
  if (lives <= 0) {
    text("GAME OVER", width/2, height/2 - 50);
  } else {
    text("YOU WON!", width/2, height/2 - 50);
  }
  
  textSize(24);
  text("Score: " + score, width/2, height/2 + 50);
  text("Click to restart", width/2, height/2 + 100);
}
