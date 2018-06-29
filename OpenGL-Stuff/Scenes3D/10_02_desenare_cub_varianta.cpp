// Codul sursa este adaptat dupa OpenGLBook.com

#include <stdlib.h> // necesare pentru citirea shader-elor
#include <cstdlib> 
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <vector>


#include <GL/glew.h> // glew apare inainte de freeglut
#include <GL/freeglut.h> // nu trebuie uitat freeglut.h
#include "myHeader.h"

#include "glm/glm.hpp"  
#include "glm/gtx/transform.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"

using namespace std;
using namespace glm;


//////////////////////////////////////

GLuint
  VaoId,
  VboId,
  ColorBufferId,
  indexBufferId,
  ProgramId,
  matMVPLocation;

 
 

glm::mat4 matMVP, Model, Projection, View;

 
void CreateVBO(void)
{
  // varfurile 
GLfloat Vertices[] = {
    -1.0f,-1.0f,-1.0f,  
    1.0f,-1.0f, -1.0f,
    1.0f, 1.0f, -1.0f, 
    -1.0f,1.0f, -1.0f, 
    -1.0f,-1.0f,1.0f,  
    1.0f,-1.0f, 1.0f,
    1.0f, 1.0f, 1.0f, 
   -1.0f, 1.0f, 1.0f, 
};

 GLfloat Colors [8*3];
	  for (int v = 0; v < 8 ; v++)
	  {
		  Colors[3*v+0]=(float)(rand( )/float(RAND_MAX));
		  Colors[3*v+1]=(float)(rand( )/float(RAND_MAX));
		  Colors[3*v+2]=(float)(rand( )/float(RAND_MAX));
	  };

  GLubyte Indices[36]={
		 0, 1, 2, 2, 3, 0,
		 0, 1, 4, 4, 1, 5,
		 1, 5, 2, 2, 5, 6,
		 0, 4, 3, 3, 4, 7,
		 3, 2, 7, 7, 2, 6,  
		  4, 5, 7, 7, 5, 6
  };
 
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
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);

  // un nou buffer, pentru culoare
  glGenBuffers(1, &ColorBufferId);
  glBindBuffer(GL_ARRAY_BUFFER, ColorBufferId);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
  // atributul 1 =  culoare
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, 0); 

  // buffer pentru indici 
  glGenBuffers(1, &indexBufferId);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferId);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);


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
  ProgramId=LoadShaders("10_02_Shader.vert", "10_02_Shader.frag");
  glUseProgram(ProgramId);
}
void DestroyShaders(void)
{
  glDeleteProgram(ProgramId);
}
 
void Initialize(void)
{
	glClearColor(0.0f, 0.0f, 0.4f, 0.0f); // culoarea de fond a ecranului
}

void computeMatrices (void)
{
	// projection
  
	float width=4.0; float height=2.0;
	glm::mat4 Projection = glm::perspective(glm::radians(45.0f), (float) width / (float)height, 0.1f, 100.0f);
	
	//glm::mat4 Projection = glm::ortho(-2.0f,2.0f,-2.0f,2.0f,0.0f,100.0f);  
	glm::mat4 View = glm::lookAt(
    glm::vec3(4,3,-3), // Camera is at (4,3,3), in World Space
    glm::vec3(0,0,0), // and looks at the origin
    glm::vec3(0,1,0)  // Head is up (set to 0,-1,0 to look upside-down)
    );
	// Model 
	mat4 Model = mat4(1.0f); 
	

   matMVP = Projection * View * Model; 
 
 // glEnable(GL_DEPTH_TEST);


}
void RenderFunction(void)
{
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  CreateVBO();
  CreateShaders();
  computeMatrices( );
 // matricele de scalare si de translatie

  matMVPLocation = glGetUniformLocation(ProgramId, "matMVP"); 
  glUniformMatrix4fv(matMVPLocation, 1, GL_FALSE,  &matMVP[0][0]);
  glPointSize(10.0);
  glDrawElements(GL_TRIANGLE_STRIP, 36*sizeof(GLubyte), GL_UNSIGNED_BYTE, (void*)0);
   glEnable(GL_DEPTH_TEST);
  //glDrawArrays(GL_POINTS, 0, 8);
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
  glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);
  glutInitWindowPosition (100,100); // pozitia initiala a ferestrei
  glutInitWindowSize(600,400); //dimensiunile ferestrei
  glutCreateWindow("Desenare cub - varianta"); // titlul ferestrei
  glewInit(); // nu uitati de initializare glew; trebuie initializat inainte de a a initializa desenarea
  Initialize( );
  glutDisplayFunc(RenderFunction);
  glutCloseFunc(Cleanup);
  glutMainLoop();
  return 0;
}

