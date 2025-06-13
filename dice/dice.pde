float angleX = 0;
float angleY = 0;
float fallY = -150;
float velocityY = 0;
boolean rolling = false;
int rollFrameCount = 0;
int diceNumber = 1;
boolean rollEnded = true;  // 멈춘 상태 플래그

PVector[] targetAngles = new PVector[6];
PVector currentAngle = new PVector(0, 0);
PVector targetAngle = new PVector(0, 0);
float easing = 0.1;

PImage[] diceTexture = new PImage[6];


void setup() {
  size(500, 500, P3D);
  textureMode(NORMAL);
  textAlign(CENTER, CENTER);
  textSize(30);
  
  
    // 숫자 기준으로 윗면이 될 각도 설정
// 1번 (앞면 z+) → 위로
  targetAngles[0] = new PVector(-HALF_PI, 0);    
  
  // 2번 (오른쪽 x+) → 위로
  targetAngles[1] = new PVector(0, -HALF_PI);    
  
  // 3번 (뒷면 z-) → 위로
  targetAngles[2] = new PVector(HALF_PI, 0);     
  
  // 4번 (왼쪽 x-) → 위로
  targetAngles[3] = new PVector(0, HALF_PI);     
  
  // 5번 (윗면 y-) → 위로
  targetAngles[4] = new PVector(0, 0);           
  
  // 6번 (아랫면 y+) → 위로
  targetAngles[5] = new PVector(PI, 0);          
  
  for(int i = 0; i<6; i++){
    diceTexture[i] = loadImage("dice" + (i+1) + ".png");
  }
}

void draw() {
  background(230);
  ambientLight(150, 150, 150);
  directionalLight(255, 255, 255, 0, 0, -1);

  // 버튼
  camera();
  fill(255);
  rect(20, 20, 100, 50);
  fill(0);
  text("ROLL", 70, 45);

  // 위치 및 회전
  translate(width / 2, height / 2 + fallY, 0);
  
  if (rolling) {
    // 떨어짐 + 튕김 + 회전
    if (fallY < 0 || velocityY > 1) {
      velocityY += 1.0;
      fallY += velocityY;

      if (fallY > 0) {
        fallY = 0;
        velocityY *= -0.5;
        rollFrameCount--;
      }

      angleX += velocityY * 0.03;
      angleY += velocityY * 0.03;
      currentAngle =targetAngles[5];
    } else {
      rolling = false;
      rollEnded = false;

      // 주사위 결과 결정
      diceNumber = int(random(1,7));
      targetAngle = targetAngles[diceNumber - 1];
    }
  }

  // 굴림 끝났을 때 easing 회전
  if (!rolling && !rollEnded) {
    currentAngle.x += (targetAngle.x - currentAngle.x) * easing;
    currentAngle.y += (targetAngle.y - currentAngle.y) * easing;

    // 목표 각도 근접하면 고정
    if (abs(targetAngle.x - currentAngle.x) < 0.01 && abs(targetAngle.y - currentAngle.y) < 0.01) {
      currentAngle.set(targetAngle);
      rollEnded = true;
    }
  }

  rotateX(currentAngle.x);
  rotateY(currentAngle.y);
  drawTextureCube(50);
  
  println("diceNumber: ", diceNumber);
  println("targetAngle", targetAngle);
  
}

void mousePressed() {
  if (mouseX > 20 && mouseX < 120 && mouseY > 20 && mouseY < 70 && !rolling) {
    rolling = true;
    rollFrameCount = 10;
    fallY = -200;
    velocityY = 0;
    rollEnded = true;

    // 초기 회전값: 무작위 굴림
    angleX = random(PI);
    angleY = random(0);
  }
}


void drawTextureCube(float s){
 
//3: 왼쪽 0: 위
  // 앞면 (z+)
  beginShape(QUADS);
  texture(diceTexture[4]); // 
  vertex(-s, -s,  s, 0, 0);
  vertex( s, -s,  s, 1, 0);
  vertex( s,  s,  s, 1, 1);
  vertex(-s,  s,  s, 0, 1);
  endShape();

  // 뒷면 (z-)
  beginShape(QUADS);
  texture(diceTexture[5]); // 뒤
  vertex( s, -s, -s, 0, 0);
  vertex(-s, -s, -s, 1, 0);
  vertex(-s,  s, -s, 1, 1);
  vertex( s,  s, -s, 0, 1);
  endShape();

  // 오른쪽 (x+)
  beginShape(QUADS);
  texture(diceTexture[1]); // 오른쪽
  vertex( s, -s,  s, 0, 0);
  vertex( s, -s, -s, 1, 0);
  vertex( s,  s, -s, 1, 1);
  vertex( s,  s,  s, 0, 1);
  endShape();

  // 왼쪽 (x-)
  beginShape(QUADS);
  texture(diceTexture[3]); // 왼쪽
  vertex(-s, -s, -s, 0, 0);
  vertex(-s, -s,  s, 1, 0);
  vertex(-s,  s,  s, 1, 1);
  vertex(-s,  s, -s, 0, 1);
  endShape();
  
  beginShape(QUADS);
  texture(diceTexture[0]); // 위
  vertex(-s, -s, -s, 0, 0);
  vertex( s, -s, -s, 1, 0);
  vertex( s, -s,  s, 1, 1);
  vertex(-s, -s,  s, 0, 1);
  endShape();

  // 아랫면 (y+)
  beginShape(QUADS);
  texture(diceTexture[2]); // 아
  vertex(-s,  s,  s, 0, 0);
  vertex( s,  s,  s, 1, 0);
  vertex( s,  s, -s, 1, 1);
  vertex(-s,  s, -s, 0, 1);
  endShape();
}
