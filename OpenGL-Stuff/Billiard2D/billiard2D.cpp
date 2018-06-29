#include <stdlib.h> // necesare pentru citirea shader-elor
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <GL/glew.h> // glew apare inainte de freeglut
#include <GL/freeglut.h> // nu trebuie uitat freeglut.h

#include "myHeader.h"

#include "glm/glm.hpp"  
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtx/transform.hpp"
#include "glm/gtc/type_ptr.hpp"

using namespace std;
  
//////////////////////////////////////

#define WHITE_BALL 16
#define INCREMENT 1

GLuint
  VaoId,
  VboId,
  ColorBufferId,
  ProgramId,
  myMatrixLocation,
  matrScaleLocation,
  matrTranslLocation,
  matrRotlLocation,
  codColLocation;
 
glm::mat4 myMatrix, resizeMatrix, matrTransl, matrScale, matrRot;

int codCol = 0;
float PI=3.141592;
int width=800, height=400;
const float DEG2RAD = 3.14159/180;
clock_t globalTime;
int lastPositionInVertices;

float cueAngle = 0.0f;

struct BallState
{
  float posX, posY;
  float tx, ty;
  float xVelocity, yVelocity;
  float angle;
  
  bool visible = true;

  bool goLeftX = false;
  bool goDownY = false;
  bool goRightX = false;
  bool goUpY = false;
};

BallState ballState[16];

void processNormalKeys(unsigned char key, int x, int y)
{
	switch (key) {
    case '+':
      cueAngle += 0.02f;
      break;
    case '-':
      cueAngle -= 0.02f;
      break;

    case 'X':
      if(ballState[WHITE_BALL].xVelocity < 1)
        ballState[WHITE_BALL].xVelocity += 0.1;
      break;
    case 'x':
      if(ballState[WHITE_BALL].xVelocity > 0)
        ballState[WHITE_BALL].xVelocity -= 0.1;
      break;
    case 'Y':
      if(ballState[WHITE_BALL].yVelocity < 1)
        ballState[WHITE_BALL].yVelocity += 0.1;
      break;
    case 'y':
      if(ballState[WHITE_BALL].yVelocity > 0)
        ballState[WHITE_BALL].yVelocity -= 0.1;
      break;

    case 'd':
      ballState[WHITE_BALL].goRightX = true;
      ballState[WHITE_BALL].goLeftX = false;
      break;
    case 'w':
      ballState[WHITE_BALL].goUpY = true;
      ballState[WHITE_BALL].goDownY = false;
      break;
    case 'a':
      ballState[WHITE_BALL].goLeftX = true;
      ballState[WHITE_BALL].goRightX = false;
      break;
    case 's':
      ballState[WHITE_BALL].goDownY = true;
      ballState[WHITE_BALL].goUpY = false;
      break;
    case 'p':
      for(int i = 1; i <= 16; i++)
      {
        printf("%f %f %f %f\n", ballState[i].posX, ballState[i].posY, ballState[i].tx, ballState[i].ty);
      }
      break;
    case 'm':
      for(int i = 1; i <= 16; i++)
      {
        ballState[i].xVelocity = 0.3;
        ballState[i].yVelocity = 0.3;
        if(i%2)
          ballState[i].goLeftX = true;
        else
          ballState[i].goRightX = true;
        if(i % 2)
          ballState[i].goUpY = true;
        else
          ballState[i].goDownY = true;
      }
      break;

	}
  if (key == 27)
    exit(0);
}
void processSpecialKeys(int key, int xx, int yy)
{
	switch (key)
  {
		case GLUT_KEY_LEFT :
			ballState[WHITE_BALL].tx -= INCREMENT * ballState[WHITE_BALL].xVelocity;
			break;
		case GLUT_KEY_RIGHT :
      ballState[WHITE_BALL].tx += INCREMENT * ballState[WHITE_BALL].xVelocity;
			break;
		case GLUT_KEY_UP :
      ballState[WHITE_BALL].ty += INCREMENT * ballState[WHITE_BALL].yVelocity;
			break;
		case GLUT_KEY_DOWN :
      ballState[WHITE_BALL].ty -= INCREMENT * ballState[WHITE_BALL].yVelocity;
			break;
	}
}

void CreateVBO(void)
{
  // varfurile 
  GLfloat Vertices[100000];

  auto init = std::initializer_list<GLfloat>({
	  // varfuri pentru tabla verde
    (float)-width, (float)-height, 0.0f, 1.0f,
    (float)width, (float)-height, 0.0f, 1.0f,
    (float)width, (float)height, 0.0f, 1.0f,
    (float)-width, (float)height, 0.0f, 1.0f,
    // varfuri buzunar stanga-sus
    (float)(-width + (height/12)),(float)(height - height/12), 0.0f, 1.0f,
    // varfuri buzunar stanga-jos
    (float)(-width + height/12), (float)(-height + height/12), 0.0f, 1.0f,
    // varfuri buzunar dreapta-sus
    (float)(width - height/12), (float)(height - height/12), 0.0f, 1.0f,
    // varfuri buzunar drepata-jos
    (float)(width - height/12), (float)(-height + height/12), 0.0f, 1.0f,
    // varfuri buzunar mijloc-jos
    0.0f, (float)(-height + height/12), 0.0f, 1.0f,

    // varfuri buzunar mijloc-sus
    0.0f, (float)(height - height/12), 0.0f, 1.0f,

    // manta jos
    (float)(-width), (float)(-height), 0.0f, 1.0f,
    (float)(width), (float)(-height), 0.0f, 1.0f,
    (float)width, (float)(-height + height/6), 0.0f, 1.0f,
    (float)(-width), (float)(-height + height/6), 0.0f, 1.0f,

    // manta dreapta
     (float)width, (float)-height, 0.0f, 1.0f,
     (float)width, (float)height, 0.0f, 1.0f,
     (float)(width - height/6), (float)height, 0.0f, 1.0f,
     (float)(width - height/6), (float)-height, 0.0f, 1.0f,

    // manta stanga
     (float)-width, (float)height, 0.0f, 1.0f,
     (float)-width, (float)-height, 0.0f, 1.0f,
     (float)(-width + height/6), (float)-height, 0.0f, 1.0f,
     (float)(-width + height/6), (float)height, 0.0f, 1.0f,

    // manta sus
     (float)-width, (float)height, 0.0f, 1.0f,
     (float)width,  (float)height, 0.0f, 1.0f,
     (float)width,  (float)(height - height/6), 0.0f, 1.0f,
     (float)(-width), (float)(height - height/6), 0.0f, 1.0f,

    // manta tabla dreapta
      (float)(width - height/6), (float)(-height + height/4), 0.0f, 1.0f,
      (float)(width - height/6), (float)(height - height/4), 0.0f, 1.0f,     
      (float)(width - height/4), (float)(height - height/2.7), 0.0f, 1.0f,
      (float)(width - height/4), (float)(-height + height/2.7), 0.0f, 1.0f,

    // manta tabla stanga
     (float)(-width + height/6), (float)(-height + height/4), 0.0f, 1.0f,
     (float)(-width + height/6), (float)(height - height/4), 0.0f, 1.0f,     
     (float)(-width + height/4), (float)(height - height/2.7), 0.0f, 1.0f,
     (float)(-width + height/4), (float)(-height + height/2.7), 0.0f, 1.0f,

    // manta tabla sus
      (float)(width - height/4), (float)(height - height/6), 0.0f, 1.0f,
      (float)(width - height/2.65), (float)(height - height/4), 0.0f, 1.0f,
      
     (float)(height/9),  (float)(height - height/4), 0.0f, 1.0f,
     (float)(height/12), (float)(height - height/6), 0.0f, 1.0f,

     (float)(-height/12), (float)(height - height/6), 0.0f, 1.0f,
     (float)(-height/9), (float)(height - height/4), 0.0f, 1.0f,

     (float)(-width + height/2.65), (float)(height - height/4), 0.0f, 1.0f,
     (float)(-width + height/4), (float)(height - height/6), 0.0f, 1.0f,

    // manta tabla jos
      (float)(width - height/4), (float)(-height + height/6), 0.0f, 1.0f,
      (float)(width - height/2.65), (float)(-height + height/4), 0.0f, 1.0f,
      
      (float)(height/9), (float)(-height + height/4), 0.0f, 1.0f,
      (float)(height/12), (float)(-height + height/6), 0.0f, 1.0f,

     (float)(-height/12), (float)(-height + height/6), 0.0f, 1.0f,
     (float)(-height/9), (float)(-height + height/4), 0.0f, 1.0f,

     (float)(-width + height/2.65), (float)(-height + height/4), 0.0f, 1.0f,
     (float)(-width + height/4), (float)(-height + height/6), 0.0f, 1.0f});

  std::copy(init.begin(), init.end(), Vertices);

  // culorile varfurilor din colturi
  GLfloat Colors[] = { 
      // culori tabla
      0.0f, 0.4f, 0.0f, 1.0f,
      0.0f, 0.4f, 0.0f, 1.0f,
      0.0f, 0.4f, 0.0f, 1.0f,
      0.0f, 0.4f, 0.0f, 1.0f,

      // culori colturi
      1.0f, 1.0f, 1.0f, 1.0f,
      1.0f, 1.0f, 1.0f, 1.0f,
      1.0f, 1.0f, 1.0f, 1.0f,
      1.0f, 1.0f, 1.0f, 1.0f,
      1.0f, 1.0f, 1.0f, 1.0f,
      1.0f, 1.0f, 1.0f, 1.0f,

      // culori manta
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,

      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,

      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,

      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
      0.45f, 0.3f, 0.08f, 1.0f,
  };
  
  unsigned int curPosInVertices = 200;
  float radius = height/15;
  float pozitieX = -width/1.5;
  float pozitieY = -height/4;

  // primul rand
  for (int i=1; i<=5; i++)
  {
    for (int j=1; j <= 360; j++)
    {
      float degInRad = j*DEG2RAD;
      Vertices[curPosInVertices] = pozitieX + cos(degInRad)*radius;
      Vertices[curPosInVertices + 1] = pozitieY + sin(degInRad)*radius;
      Vertices[curPosInVertices + 2] = 0.0f;
      Vertices[curPosInVertices + 3] = 1.0f;
      curPosInVertices += 4;
    }

    ballState[i].tx = 0;
    ballState[i].ty = 0;
    ballState[i].angle = 0;

    ballState[i].posX = pozitieX;
    ballState[i].posY = pozitieY;

    pozitieY += 2*radius;
  }

  pozitieY = -height/4 + radius;
  pozitieX += 2*radius;

  // al doilea rand
  for (int i=6; i<=9; i++)
  {
    for (int j=1; j <= 360; j++)
    {
      float degInRad = j*DEG2RAD;
      Vertices[curPosInVertices] = pozitieX + cos(degInRad)*radius;
      Vertices[curPosInVertices + 1] = pozitieY + sin(degInRad)*radius;
      Vertices[curPosInVertices + 2] = 0.0f;
      Vertices[curPosInVertices + 3] = 1.0f;

      curPosInVertices += 4;
    }

    ballState[i].tx = 0;
    ballState[i].ty = 0;
    ballState[i].angle = 0;

    ballState[i].posX = pozitieX;
    ballState[i].posY = pozitieY;

    pozitieY += 2*radius;
  }

  pozitieY = -height/4 + 2*radius;
  pozitieX += 2*radius;

  // al treilea rand
  for (int i=10; i<=12; i++)
  {
    for (int j=1; j <= 360; j++)
    {
      float degInRad = j*DEG2RAD;
      Vertices[curPosInVertices] = pozitieX + cos(degInRad)*radius;
      Vertices[curPosInVertices + 1] = pozitieY + sin(degInRad)*radius;
      Vertices[curPosInVertices + 2] = 0.0f;
      Vertices[curPosInVertices + 3] = 1.0f;

      curPosInVertices += 4;
    }

    ballState[i].tx = 0;
    ballState[i].ty = 0;
    ballState[i].angle = 0;

    ballState[i].posX = pozitieX;
    ballState[i].posY = pozitieY;

    pozitieY += 2*radius;
  }

  pozitieY = -height/4 + 3*radius;
  pozitieX += 2*radius;

  // al patrulea rand
  for (int i=13; i<=14; i++)
  {
    for (int j=1; j <= 360; j++)
    {
      float degInRad = j*DEG2RAD;
      Vertices[curPosInVertices] = pozitieX + cos(degInRad)*radius;
      Vertices[curPosInVertices + 1] = pozitieY + sin(degInRad)*radius;
      Vertices[curPosInVertices + 2] = 0.0f;
      Vertices[curPosInVertices + 3] = 1.0f;
  
      curPosInVertices += 4;
    }
      
    ballState[i].tx = 0;
    ballState[i].ty = 0;
    ballState[i].angle = 0;

    ballState[i].posX = pozitieX;
    ballState[i].posY = pozitieY;

    pozitieY += 2*radius;
  }

  pozitieY = -height/4 + 4*radius;
  pozitieX += 2*radius;

  // al cincilea rand
  for (int i=15; i<=15; i++)
  {
    for (int j=1; j <= 360; j++)
    {
      float degInRad = j*DEG2RAD;
      Vertices[curPosInVertices] = pozitieX + cos(degInRad)*radius;
      Vertices[curPosInVertices + 1] = pozitieY + sin(degInRad)*radius;
      Vertices[curPosInVertices + 2] = 0.0f;
      Vertices[curPosInVertices + 3] = 1.0f;

      curPosInVertices += 4;
    }

    ballState[i].tx = 0;
    ballState[i].ty = 0;
    ballState[i].angle = 0;

    ballState[i].posX = pozitieX;
    ballState[i].posY = pozitieY; 

    pozitieY += 2*radius;
  }

  pozitieY -= 2*radius;
  pozitieX = width/1.8;

  // bila alba (200, 360)
  for(int i = 1; i<=360; i++)
  {
    float degInRad = i*DEG2RAD;
    Vertices[curPosInVertices] = pozitieX + cos(degInRad)*radius;
    Vertices[curPosInVertices + 1] = pozitieY + sin(degInRad)*radius;
    Vertices[curPosInVertices + 2] = 0.0f;
    Vertices[curPosInVertices + 3] = 1.0f;

    curPosInVertices += 4;
  }

  ballState[WHITE_BALL].tx = 0;
  ballState[WHITE_BALL].ty = 0;
  ballState[WHITE_BALL].angle = 0;

  ballState[WHITE_BALL].posX = pozitieX;
  ballState[WHITE_BALL].posY = pozitieY;

  // cue vertices
  Vertices[curPosInVertices] = ballState[WHITE_BALL].posX + radius + radius/4;
  Vertices[curPosInVertices + 1] = ballState[WHITE_BALL].posY - radius/4;
  Vertices[curPosInVertices + 2] = 0.0f;
  Vertices[curPosInVertices + 3] = 1.0f;
  curPosInVertices += 4;

  Vertices[curPosInVertices] = ballState[WHITE_BALL].posX + radius + width/3;
  Vertices[curPosInVertices + 1] = ballState[WHITE_BALL].posY - radius/4;
  Vertices[curPosInVertices + 2] = 0.0f;
  Vertices[curPosInVertices + 3] = 1.0f;
  curPosInVertices += 4;

  Vertices[curPosInVertices] = ballState[WHITE_BALL].posX + radius + width/3;
  Vertices[curPosInVertices + 1] = ballState[WHITE_BALL].posY + radius/4;
  Vertices[curPosInVertices + 2] = 0.0f;
  Vertices[curPosInVertices + 3] = 1.0f;
  curPosInVertices += 4;

  Vertices[curPosInVertices] = ballState[WHITE_BALL].posX + radius + radius/4;
  Vertices[curPosInVertices + 1] = ballState[WHITE_BALL].posY + radius/4;
  Vertices[curPosInVertices + 2] = 0.0f;
  Vertices[curPosInVertices + 3] = 1.0f;
  curPosInVertices += 4;

  // se creeaza un buffer nou
  glGenBuffers(1, &VboId);
  // este setat ca buffer curent
  glBindBuffer(GL_ARRAY_BUFFER, VboId);
  // punctele sunt "copiate" in bufferul curent

  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
  
  // se creeaza / se leaga un VAO (Vertex Array Object) - util cand se utilizeaza mai multe VBO
  glGenVertexArrays(1, &VaoId);
  glBindVertexArray(VaoId);
  // se activeaza lucrul cu atribute; atributul 0 = pozitie
  glEnableVertexAttribArray(0);
  // 
  glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);
 
  // un nou buffer, pentru culoare
  glGenBuffers(1, &ColorBufferId);
  glBindBuffer(GL_ARRAY_BUFFER, ColorBufferId);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
  // atributul 1 =  culoare
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);
}

void DestroyVBO(void)
{
  glDisableVertexAttribArray(1);
  glDisableVertexAttribArray(0);

  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glDeleteBuffers(1, &ColorBufferId);
  glDeleteBuffers(1, &VboId);

  glBindVertexArray(0);
  glDeleteVertexArrays(1, &VaoId);  
}

void CreateShaders(void)
{
  ProgramId=LoadShaders("vertexShader.vert", "fragmentShader.frag");
  glUseProgram(ProgramId);
}
 
void DestroyShaders(void)
{
  glDeleteProgram(ProgramId);
}
 
void Initialize(void)
{
  glClearColor(1.0f, 1.0f, 1.0f, 0.0f); // culoarea de fond a ecranului
  
  CreateVBO();
  CreateShaders();
}

void DrawTable()
{
  resizeMatrix= glm::scale(glm::mat4(1.0f), glm::vec3(1.f/width, 1.f/height, 1.0));
  matrTransl=glm::translate(glm::mat4(1.0f), glm::vec3(0, 0, 0.0));
  matrRot=glm::rotate(glm::mat4(1.0f), 0.0f, glm::vec3(0.0, 0.0, 1.0));

  myMatrix=resizeMatrix * matrRot * matrTransl;
  
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix"); 
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
  
  // tabla joc
  glUniform1i(codColLocation, codCol);
  glDrawArrays(GL_POLYGON, 0, 4);

  // margine manta
  //dreapta
  glUniform1i(codColLocation, 4);
  glDrawArrays(GL_POLYGON, 26, 4);

  //stanga
  glUniform1i(codColLocation, 4);
  glDrawArrays(GL_POLYGON, 30, 4);

  //sus
  glUniform1i(codColLocation, 4);
  glDrawArrays(GL_POLYGON, 34, 4);
  glUniform1i(codColLocation, 4);
  glDrawArrays(GL_POLYGON, 38, 4);

  //jos
  glUniform1i(codColLocation, 4);
  glDrawArrays(GL_POLYGON, 42, 4);
  glUniform1i(codColLocation, 4);
  glDrawArrays(GL_POLYGON, 46, 4);

  // rama tabla
  glUniform1i(codColLocation, 0);
  glDrawArrays(GL_POLYGON, 10, 4);

  glUniform1i(codColLocation, 0);
  glDrawArrays(GL_POLYGON, 14, 4);

  glUniform1i(codColLocation, 0);
  glDrawArrays(GL_POLYGON, 18, 4);

  glUniform1i(codColLocation, 0);
  glDrawArrays(GL_POLYGON, 22, 4);

  // colturi tabla
  glPointSize(height/4.5);
  glUniform1i(codColLocation, 0);
  glDrawArrays(GL_POINTS, 4, 4);

  glPointSize(height/8);
  glUniform1i(codColLocation, 0);
  glDrawArrays(GL_POINTS, 8, 2);

  // buzunare
  glUniform1i(codColLocation, 5);
  glBegin(GL_POLYGON);
  float radius = height/9;
   for (int i=0; i <= 360; i++)
   {
      float degInRad = i*DEG2RAD;
      glVertex2f(width - height/6 + cos(degInRad)*radius, height - height/6 + sin(degInRad)*radius);
   }
  glEnd();

  glUniform1i(codColLocation, 5);
  glBegin(GL_POLYGON);
   for (int i=0; i <= 360; i++)
   {
      float degInRad = i*DEG2RAD;
      glVertex2f(- width + height/6 + cos(degInRad)*radius, height - height/6 + sin(degInRad)*radius);
   }
  glEnd();

  glUniform1i(codColLocation, 5); 
  glBegin(GL_POLYGON);
   for (int i=0; i <= 360; i++)
   {
      float degInRad = i*DEG2RAD;
      glVertex2f(- width + height/6 + cos(degInRad)*radius, - height + height/6 + sin(degInRad)*radius);
   }
  glEnd();

  glUniform1i(codColLocation, 5); 
  glBegin(GL_POLYGON);
   for (int i=0; i <= 360; i++)
   {
      float degInRad = i*DEG2RAD;
      glVertex2f(width - height/6 + cos(degInRad)*radius, - height + height/6 + sin(degInRad)*radius);
   }
  glEnd();

  radius = height/12;
  // buzunar mijloc sus
  glUniform1i(codColLocation, 5); 
  glBegin(GL_POLYGON);
   for (int i=0; i <= 360; i++)
   {
      float degInRad = i*DEG2RAD;
      glVertex2f(cos(degInRad)*radius, - height + height/6 + sin(degInRad)*radius);
   }
  glEnd();

  // buzunar mijloc jos
  glUniform1i(codColLocation, 5); 
  glBegin(GL_POLYGON);
   for (int i=0; i <= 360; i++)
   {
      float degInRad = i*DEG2RAD;
      glVertex2f(cos(degInRad)*radius, height - height/6 + sin(degInRad)*radius);
   }
  glEnd();
}

void DrawBalls()
{
  int posStartDrawBall = 50;

  for(int i = 1; i <= 16; i++)
  {
    resizeMatrix = glm::scale(glm::mat4(1.0f), glm::vec3(1.f/width, 1.f/height, 1.0));
    matrTransl=glm::translate(glm::mat4(1.0f), glm::vec3(ballState[i].tx, ballState[i].ty, 0.0));
    matrRot=glm::rotate(glm::mat4(1.0f), ballState[i].angle, glm::vec3(0.0, 0.0, 1.0));

    myMatrix=resizeMatrix * matrRot * matrTransl;
  
    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix"); 
    glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);

    glUniform1i(codColLocation, i);
    glDrawArrays(GL_POLYGON, posStartDrawBall, 360);
    posStartDrawBall += 360;
  }

  lastPositionInVertices = posStartDrawBall;
}

void DrawCue()
{
    resizeMatrix = glm::scale(glm::mat4(1.0f), glm::vec3(1.f/width, 1.f/height, 1.0f));
    matrTransl=glm::translate(glm::mat4(1.0f), glm::vec3(ballState[WHITE_BALL].tx, ballState[WHITE_BALL].ty, 0.0f));
    matrRot=glm::rotate(glm::mat4(1.0f), cueAngle, glm::vec3(0.0f, 0.0f, 1.0f));

    myMatrix=resizeMatrix * matrRot * matrTransl;

    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
    glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);

    glUniform1i(codColLocation, 2);
    glDrawArrays(GL_POLYGON, lastPositionInVertices, 4);
}

void CollisionManager()
{
  for(int i = 1; i <= 16; i++)
  {
    for(int j = 1; j <= 16; j++)
    {
      if(i == j)
        continue;
      // don't get out of the table
      if(ballState[i].posX + ballState[i].tx + height/15 > width - height/4)
      {
        ballState[i].goLeftX = true;
        ballState[i].goRightX = false;
      }
      if(ballState[i].posY + ballState[i].ty - height/15 < -height + height/4)
      {
        ballState[i].goUpY = true;
        ballState[i].goDownY = false;
      }
      if(ballState[i].posX + ballState[i].tx - height/15 < -width + height/4)
      {
        ballState[i].goRightX = true;
        ballState[i].goLeftX = false;
      }
      if(ballState[i].posY + ballState[i].ty + height/15 > height - height/4)
      {
        ballState[i].goDownY = true;
        ballState[i].goUpY = false;
      }

      float xPosA = ballState[i].posX + ballState[i].tx;
      float yPosA = ballState[i].posY + ballState[i].ty;

      float xPosB = ballState[j].posX + ballState[j].tx;
      float yPosB = ballState[j].posY + ballState[j].ty;

      float distance = sqrt((xPosB - xPosA)*(xPosB - xPosA) + (yPosB - yPosA)*(yPosB - yPosA));

      // don't hover other balls
      if(distance < 2*height/15)
      {
          bool xVeloIncrease = false;
          bool yVeloIncrease = false;
          // enemy is on right side
          if( (ballState[j].posX + ballState[j].tx) > (ballState[i].posX + ballState[i].tx) )
          {
                if(ballState[i].goRightX == true)
                {
                  ballState[i].goLeftX = true;
                  ballState[i].goRightX = false;
                  ballState[j].goRightX = true;
                  ballState[j].goLeftX = false;
                }
                xVeloIncrease = true;
          }

          // enemy is on left side
          if( (ballState[j].posX + ballState[j].tx) < (ballState[i].posX + ballState[i].tx) )
          {
                if(ballState[i].goLeftX == true)
                {
                  ballState[i].goRightX = true;
                  ballState[i].goLeftX = false;
                  ballState[j].goLeftX = true;
                  ballState[j].goRightX = false;
                }
                xVeloIncrease = true;
          }

          // enemy is above
          if( (ballState[j].posY + ballState[j].ty) > (ballState[i].posY + ballState[i].ty) )
          {
                if(ballState[i].goUpY == true)
                {
                  ballState[i].goDownY = true;
                  ballState[i].goUpY = false;
                  ballState[j].goUpY = true;
                  ballState[j].goDownY = false;
                }
                yVeloIncrease = true;
          }

          // enemy is below
          if( (ballState[j].posY + ballState[j].ty) < (ballState[i].posY + ballState[i].ty) )
          {
                if(ballState[i].goDownY == true)
                {
                  ballState[i].goUpY = true;
                  ballState[i].goDownY = false;
                  ballState[j].goDownY = true;
                  ballState[j].goUpY = false;
                }
                yVeloIncrease = true;
          }
          if(xVeloIncrease)
          {
            ballState[i].xVelocity -= 0.2;
            ballState[j].xVelocity += 0.2;
          }
          if(yVeloIncrease)
          {
            ballState[i].yVelocity -= 0.2;
            ballState[j].yVelocity += 0.2;
          }
      }
    }
  }  
}

void UpdateScene()
{
  for(int i = 1; i<=16; i++)
  {
    // Move balls that have to move
    if(ballState[i].goRightX)
    {
      ballState[i].tx += INCREMENT * ballState[i].xVelocity;
    }
    if(ballState[i].goUpY)
    {
      ballState[i].ty += INCREMENT * ballState[i].yVelocity;
    }
    if(ballState[i].goLeftX)
    {
      ballState[i].tx -= INCREMENT * ballState[i].xVelocity;
    }
    if(ballState[i].goDownY)
    {
      ballState[i].ty -= INCREMENT * ballState[WHITE_BALL].yVelocity;
    }

    // decrement velocity while passing the time
    if(ballState[i].xVelocity > 0)
      ballState[i].xVelocity -= 0.00005;
    else
      ballState[i].xVelocity = 0;

    if(ballState[i].yVelocity > 0)
      ballState[i].yVelocity -= 0.00005;
    else
      ballState[i].yVelocity = 0;
  }

  CollisionManager();
}

void RenderFunction(void)
{
  glClear(GL_COLOR_BUFFER_BIT);

  UpdateScene();

  DrawTable();  

  DrawBalls();

  //DrawCue();

  glutSwapBuffers();
  glFlush ( );
}

void Cleanup(void)
{
  DestroyShaders();
  DestroyVBO();
}

int main(int argc, char* argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGB);
  glutInitWindowPosition (100,100); 
  glutInitWindowSize(1200,600); 
  glutCreateWindow("Billiard 2D"); 
  glewInit(); 
  Initialize( );  
  glutIdleFunc(RenderFunction);
  glutKeyboardFunc(processNormalKeys);
  glutSpecialFunc(processSpecialKeys);
  glutCloseFunc(Cleanup);

  glutMainLoop(); 
}

