#include <stdio.h>
#include <GL/freeglut.h>

struct Segment
{
	float CoordX1, CoordY1, CoordX2, CoordY2;
	int Color;
};

int n; // number of segments (not points)
Segment segmente[101];

bool seIntersecteaza(Segment segment1, Segment segment2)
{
    float a1Ecuatie, b1Ecuatie, c1Ecuatie;
    float a2Ecuatie, b2Ecuatie, c2Ecuatie;

    a1Ecuatie = segment1.CoordY2 - segment1.CoordY1;
    a2Ecuatie = segment2.CoordY2 - segment2.CoordY1;

    b1Ecuatie = segment1.CoordX1 - segment1.CoordX2;
    b2Ecuatie = segment2.CoordX1 - segment2.CoordX2;

    c1Ecuatie = segment1.CoordX2 * segment1.CoordY1 - segment1.CoordX1 * segment1.CoordY2;
    c2Ecuatie = segment2.CoordX2 * segment2.CoordY1 - segment2.CoordX1 * segment2.CoordY2;

    float rezultatEc1 = 0, rezultatEc2 = 0;
    bool inter1 = false, inter2 = false;

    rezultatEc1 = a1Ecuatie * segment2.CoordX1 + b1Ecuatie * segment2.CoordY1 + c1Ecuatie;
    rezultatEc2 = a1Ecuatie * segment2.CoordX2 + b1Ecuatie * segment2.CoordY2 + c1Ecuatie;

    if(rezultatEc1 * rezultatEc2 < 0)
      inter1 = true;

    printf("%f = %f  *  %f\n", rezultatEc1 * rezultatEc2, rezultatEc1, rezultatEc2);
    
    rezultatEc1 = rezultatEc2 = 0;

    rezultatEc1 = a2Ecuatie * segment1.CoordX1 + b2Ecuatie * segment1.CoordY1 + c2Ecuatie;
    rezultatEc2 = a2Ecuatie * segment1.CoordX2 + b2Ecuatie * segment1.CoordY2 + c2Ecuatie;
    
    if(rezultatEc1 * rezultatEc2 < 0)
      inter2 = true;

    printf("%f = %f  *  %f\n", rezultatEc1 * rezultatEc2, rezultatEc1, rezultatEc2);

    printf("%d %d\n\n", inter1, inter2);

    if (inter1 == true && inter2 == true)
      return true;
    return false;
}

void Initialize(void)
{
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

void RenderFunction(void)
{
  glClear(GL_COLOR_BUFFER_BIT);

  glBegin(GL_LINES);

  for(int i = 1; i <= n; i++)
  {
  	if(segmente[i].Color == 1)
  		glColor4f(1.0, 0.0, 0.0, 0.0);
  	else
  		glColor4f(0.0, 1.0, 0.0, 0.0);
  	glVertex4f(segmente[i].CoordX1, segmente[i].CoordY1, 0.0, 1.0);
  	glVertex4f(segmente[i].CoordX2, segmente[i].CoordY2, 0.0, 1.0);		
  }

  glEnd();
  glFlush();
}

int main(int argc, char* argv[])
{

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);
  glutInitWindowPosition (100,100);
  glutInitWindowSize(1000,700);
  glutCreateWindow("Linie Poligonala");
  Initialize( );

  freopen("Varfuri.txt", "r", stdin);
  scanf("%d", &n);
  for (int i = 1; i <= n; i++)
  {
      scanf("%f %f %f %f", &segmente[i].CoordX1, &segmente[i].CoordY1, &segmente[i].CoordX2, &segmente[i].CoordY2);
  }
  for (int i = 1; i < n; i++)
  {
  	for (int j = i + 1; j <= n; j++)
  	{
  		if(seIntersecteaza(segmente[i], segmente[j]))
  		{
  			segmente[i].Color = 1;
  			segmente[j].Color = 1;
  		}
  	}
  }

  glutDisplayFunc(RenderFunction);
  glutMainLoop();
  return 0;  
}