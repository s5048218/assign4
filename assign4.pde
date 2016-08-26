/*
author:s5048218@gmail.com
update:2016/08/25
*/
PImage bg1, bg2, en, fi, hp, tr, s1, s2, e1, e2, shoot;
PImage [] bomb = new PImage[5];
int fx=589, fy=300, x=640, enemyX=0, enemyY=floor(random(420));
int speed=3, blood=2, img=0, shot=0;
float tx=random(600), ty=random(440);//treasure(b,c)
int FRAMERATE = 100;
int enemystate = 0;
int [][] epos = new int[8][2];
boolean [] isdead = new boolean[8];
int [][] crashpos = new int[8][2];
boolean [] iscrash = new boolean[8];
int [][] shotpos = new int[5][2];
boolean [] isdisplay = new boolean[5];
boolean up=false, down=false, left=false, right=false;

final int GAME_START = 0;
final int GAME_PLAYING = 1;
final int GAME_LOSE = 2;
int gameState = 0;

void setup () {
  size(640, 480) ;
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  en = loadImage("img/enemy.png");
  fi = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  tr = loadImage("img/treasure.png");
  s1 = loadImage("img/start2.png");
  s2 = loadImage("img/start1.png");
  e1 = loadImage("img/end2.png");
  e2 = loadImage("img/end1.png");
  shoot = loadImage("img/shoot.png");
  frameRate(FRAMERATE);
  for (int a=0; a<5; a++)
    bomb[a] = loadImage("img/flame"+(a+1)+".png");
  for (int a=0; a<8; a++) {
    iscrash[a] = false;
    if (a<5)
      isdead[a] = false;
    else
      isdead[a] = true;
  }
  for (int a=0; a<5; a++)
    isdisplay[a] = false;
}

void draw() {
  switch(gameState) {
  case GAME_START :
    image(s1, 0, 0);
    if (mouseY>=380 && mouseY<=415) {
      if (mouseX>=210 &&mouseX<=455) {
        image(s2, 0, 0);
        if (mousePressed)
          gameState = GAME_PLAYING;
      }
    }
    break;

  case GAME_PLAYING :
    image(bg1, x%1280-640, 0);
    image(bg2, (x-640)%1280-640, 0);
    x++;

    image(fi, fx, fy);
    if (up)
      fy -= speed;
    if (down)
      fy += speed;
    if (left)
      fx -= speed;
    if (right)
      fx += speed;

    for (int a=0; a<5; a++) {     
      if (isdisplay[a]) {
        image(shoot, shotpos[a][0], shotpos[a][1]);
        shotpos[a][0] -= 5;
        if (shotpos[a][0]<=-31) 
          isdisplay[a] = false;
        for (int b=0; b<8; b++) {
          if (!isdead[b]) {
            if (shotpos[a][0]+30>epos[b][0] && shotpos[a][1]+27>epos[b][1] && shotpos[a][0]<epos[b][0]+60 && shotpos[a][1]<epos[b][1]+60) {
              iscrash[b] = true;
              crashpos[b][0] = epos[b][0];
              crashpos[b][1] = epos[b][1];
              isdead[b] = true;
              isdisplay[a] = false;
            }
          }
        }
      }
    }
    if (fx<=0)
      fx = 0;
    if (fx>=589)
      fx = 589;
    if (fy<=0)
      fy = 0;
    if (fy>=429)
      fy = 429;

    image(tr, tx, ty);
    if (fx+50>tx && fy+50>ty && fx<tx+40 && fy<ty+40) {
      if (blood<10)
        blood += 1;
      tx = random(600);
      ty = random(440);
    }
    
    enemyX = (enemyX+3)%(940+500);
    epos[0][0] = enemyX-60;
    if (enemyX==0) {
      enemystate = (enemystate+1)%3;
      for (int a=0; a<8; a++)
        isdead[a] = false;
      if (enemystate==0) {
        enemyY = floor(random(420));
        for (int a=5; a<8; a++)
          isdead[a] = true;
      }
      if (enemystate==1) {
        enemyY = floor(random(260));
        for (int a=5; a<8; a++)
          isdead[a] = true;
      }
      if (enemystate==2) {
        enemyY = floor(random(80, 340));
      }
      epos[0][1] = enemyY;
    }

    switch(enemystate) {
    case 0:
      for (int a=1; a<5; a++) {
        epos[a][0] = epos[0][0]-a*60;
        epos[a][1] = epos[0][1];
      }
      break;
    case 1:
      for (int a=1; a<5; a++) {
        epos[a][0] = epos[0][0]-a*60;
        epos[a][1] = epos[0][1]+a*40;
      }
      break;
    case 2:
      epos[1][0] = epos[0][0]-60;
      epos[1][1] = epos[0][1]-40;
      epos[2][0] = epos[0][0]-60;
      epos[2][1] = epos[0][1]+40;
      epos[3][0] = epos[0][0]-120;
      epos[3][1] = epos[0][1]-80;
      epos[4][0] = epos[0][0]-120;
      epos[4][1] = epos[0][1]+80;
      epos[5][0] = epos[0][0]-180;
      epos[5][1] = epos[0][1]-40;
      epos[6][0] = epos[0][0]-180;
      epos[6][1] = epos[0][1]+40;
      epos[7][0] = epos[0][0]-240;
      epos[7][1] = epos[0][1];
      break;
    }
    for (int a=0; a<8; a++) {
      if (!isdead[a]) {
        if (fx+50>epos[a][0] && fy+50>epos[a][1] && fx<epos[a][0]+60 && fy<epos[a][1]+60) {
          iscrash[a] = true;
          crashpos[a][0] = epos[a][0];
          crashpos[a][1] = epos[a][1];
          isdead[a] = true;
          blood -= 2;
          if (blood<=0)
            gameState = GAME_LOSE;
        }
      }
    }
    for (int a=0; a<8; a++) {
      if (iscrash[a]) {
        image(bomb[img], crashpos[a][0], crashpos[a][1]);
        if (frameCount%(FRAMERATE/10)==0) {
          img++;
          if (img==5) {
            img = 0;
            iscrash[a] = false;
          }
        }
      }
    }
    for (int a=0; a<8; a++) {
      if (!isdead[a])
        image(en, epos[a][0], epos[a][1]);
    }
    noStroke();
    fill(255, 0, 0);
    if (blood>=0 && blood<=10)
      rect(26, 22, 20*blood, 25);
    image(hp, 20, 20);
    break;

  case GAME_LOSE :
    image(e1, 0, 0);
    if (mouseY>=315 && mouseY<=350) {
      if (mouseX>=210 &&mouseX<=436) {
        image(e2, 0, 0);
        if (mousePressed) {

          blood = 2;
          fx=589;
          fy=300;
          enemyY=floor(random(420));
          enemyX=0;
          tx=random(600);
          ty=random(440);
          gameState = GAME_PLAYING;
          enemystate = 0;
          shot = 0;
          for (int a=0; a<5; a++)
            isdisplay[a] = false;
          for (int a=0; a<8; a++) {
            iscrash[a] = false;
            if (a<5)
              isdead[a] = false;
            else
              isdead[a] = true;
          }
        }
      }
    }
    break;
  }
}

void keyPressed() {
  int shotcount = 0;
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      up = true;
      break;
    case DOWN:
      down = true;
      break;
    case LEFT:
      left = true;
      break;
    case RIGHT:
      right = true;
      break;
    }
  } else if ( key==' ') {
    for (int a=0; a<5; a++)
      if (isdisplay[a])
        shotcount++;
    if (shotcount<5) {
      isdisplay[shot] = true;
      shotpos[shot][0] = fx;
      shotpos[shot][1] = fy+12;
      shot=(shot+1)%5;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      up = false;
      break;
    case DOWN:
      down = false;
      break;
    case LEFT:
      left = false;
      break;
    case RIGHT:
      right = false;
      break;
    }
  }
}
