#include "Init_GLUT.h"

Core::IListener* Core::Init::Init_GLUT::listener = NULL;
Core::WindowInfo Core::Init::Init_GLUT::windowInformation;

void Core::Init::Init_GLUT::Init(const Core::WindowInfo& windowInfo, const Core::ContextInfo& contextInfo, const Core::FrameBufferInfo& frameBufferInfo)
{
	int fakeargc = 1;
	char szFake[5] = "fake";
	char *fakeargv[] = { szFake, NULL };
	glutInit(&fakeargc, fakeargv);

	if(contextInfo.core)
	{
		glutInitContextVersion(contextInfo.major_version, contextInfo.minor_version);
		glutInitContextProfile(GLUT_CORE_PROFILE);
	}
	else
	{
		glutInitContextProfile(GLUT_COMPATIBILITY_PROFILE);
	}

	glutInitDisplayMode(frameBufferInfo.flags);
	glutInitWindowPosition(windowInfo.position_x, windowInfo.position_y);
	glutInitWindowSize(windowInfo.width, windowInfo.height);

	glutCreateWindow(windowInfo.name.c_str());

	windowInformation = windowInfo;

	std::cout << "GLUT: Initialized" << std::endl;

	glutIdleFunc(IdleCallback);
	glutCloseFunc(CloseCallback);
	glutDisplayFunc(DisplayCallback);
	glutReshapeFunc(ReshapeCallback);

	Init::Init_GLEW::Init();

	glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS);

	PrintOpenGLInfo(windowInfo, contextInfo);
}

void Core::Init::Init_GLUT::Run()
{
	std::cout << "GLUT:\t Start Running" << std::endl;
	glutMainLoop();
}

void Core::Init::Init_GLUT::Close()
{
	std::cout << "GLUT:\t Finished" << std::endl;
	glutLeaveMainLoop();
}

void Core::Init::Init_GLUT::IdleCallback(void)
{
	glutPostRedisplay();
}

void Core::Init::Init_GLUT::DisplayCallback()
{
	//check for NULL
	if (listener)
	{
		listener->NotifyBeginFrame();
		listener->NotifyDisplayFrame();

		glutSwapBuffers();

		listener->NotifyEndFrame();
	}
}

void Core::Init::Init_GLUT::ReshapeCallback(int width, int height)
{
	if(windowInformation.isReshapable == true)
	{
		if(listener)
		{
			listener->NotifyReshape(width, height, windowInformation.width, windowInformation.height);
		}
		windowInformation.width = width;
		windowInformation.height = height;
	}
}

void Core::Init::Init_GLUT::CloseCallback()
{
	Close();
}

void Core::Init::Init_GLUT::EnterFullscreen()
{
	glutFullScreen();
}

void Core::Init::Init_GLUT::ExitFullscreen()
{
	glutLeaveFullScreen();
}

void Core::Init::Init_GLUT::SetListener(Core::IListener*& iListener)
{
	listener = iListener;
}

void Core::Init::Init_GLUT::PrintOpenGLInfo(const Core::WindowInfo& windowInfo, const Core::ContextInfo& contextInfo)
{
	const unsigned char* renderer = glGetString(GL_RENDERER);
	const unsigned char* vendor = glGetString(GL_VENDOR);
	const unsigned char* version = glGetString(GL_VERSION);

	std::cout << "***************************************************" << std::endl;
	std::cout << "GLUT: Initialise" << std::endl;
	std::cout << "GLUT:\tVendor : " << vendor << std::endl;
	std::cout << "GLUT:\tRenderer : " << renderer << std::endl;
	std::cout << "GLUT:\tVersion : " << version << std::endl;
}
