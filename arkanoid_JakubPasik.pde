int paddleWidth = 100;
int paddleHeight = 20; 
int paddleSpeed = 8; 
float paddleX;


int ballSize = 20; 
float ballSpeedX = 5; 
float ballSpeedY = 5; 
float ballX;
float ballY;

int brickRows = 5; 
int brickColumns = 10; 
int brickWidth = 75; 
int brickHeight = 20; 
int brickSpacing = 10; 
boolean[][] bricks; 

boolean gameOver = false; 
long gameOverTimer; 


void setup() {
  size(800, 600);
  resetGame();
}

void resetGame() {
  bricks = new boolean[brickColumns][brickRows];
  for (int i = 0; i < brickColumns; i++) {
    for (int j = 0; j < brickRows; j++) {
      bricks[i][j] = true;
    }
  }
  

  paddleX = width / 2 - paddleWidth / 2;
  
  ballX = paddleX + paddleWidth / 2;
  ballY = height - paddleHeight - ballSize;
  ballSpeedX = random(-2, 2);
  ballSpeedY = -5;
  
  gameOver = false;
}

void draw() {
  background(0);
  
  if (!gameOver) {
    movePaddle();
    moveBall();
    checkCollision();
  }
  
  displayBricks();
  rect(paddleX, height - paddleHeight, paddleWidth, paddleHeight);
  ellipse(ballX, ballY, ballSize, ballSize);
  
  if (gameOver) {
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text("Koniec gry", width / 2, height / 2);
    
    if (millis() - gameOverTimer > 1000) {
      exit(); 
    }
  }
  
  textAlign(LEFT, TOP);
  textSize(20);
  fill(255);
}


void movePaddle() {
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      paddleX -= paddleSpeed;
    } else if (key == 'd' || key == 'D') {
      paddleX += paddleSpeed;
    }
  }
  
  paddleX = constrain(paddleX, 0, width - paddleWidth);
}


void moveBall() {
  
  ballX += ballSpeedX;
  ballY += ballSpeedY;
 
  if (ballX < 0 || ballX > width - ballSize) {
    ballSpeedX *= -1;
  }
  if (ballY < 0) {
    ballSpeedY *= -1;
  }
  
  if (ballY + ballSize >= height - paddleHeight && ballX + ballSize >= paddleX && ballX <= paddleX + paddleWidth) {
    ballSpeedY *= -1;
  }
  
  if (ballY > height) {
    gameOver = true;
    gameOverTimer = millis();
  }
}


void displayBricks() {
  for (int i = 0; i < brickColumns; i++) {
    for (int j = 0; j < brickRows; j++) {
      if (bricks[i][j]) {
        float brickX = i * (brickWidth + brickSpacing);
        float brickY = j * (brickHeight + brickSpacing);
        rect(brickX, brickY, brickWidth, brickHeight);
      }
    }
  }
}

void checkCollision() {
  int ballColumn = int(ballX / (brickWidth + brickSpacing));
  int ballRow = int(ballY / (brickHeight + brickSpacing));
  
  if (ballColumn >= 0 && ballColumn < brickColumns && ballRow >= 0 && ballRow < brickRows) {
    if (bricks[ballColumn][ballRow]) {
      bricks[ballColumn][ballRow] = false;
      ballSpeedY *= -1;
      
      boolean allBricksDestroyed = true;
      for (int i = 0; i < brickColumns; i++) {
        for (int j = 0; j < brickRows; j++) {
          if (bricks[i][j]) {
            allBricksDestroyed = false;
            break;
          }
        }
      }
      if (allBricksDestroyed) {
        gameOver = true;
        gameOverTimer = millis();
      }
    }
  }
  
  if (ballY + ballSize >= height - paddleHeight && ballX + ballSize >= paddleX && ballX < paddleX + paddleWidth / 2) {
    ballSpeedX = -abs(ballSpeedX);
  }
  else if (ballY + ballSize >= height - paddleHeight && ballX <= paddleX + paddleWidth && ballX > paddleX + paddleWidth / 2) {
    ballSpeedX = abs(ballSpeedX);
  }
}
