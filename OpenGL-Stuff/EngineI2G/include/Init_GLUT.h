#ifndef INIT_GLUT_H
#define INIT_GLUT_H

#include <iostream>

#include "ContextInfo.h"
#include "FrameBufferInfo.h"
#include "WindowInfo.h"
#include "IListener.h"
#include "Init_GLEW.h"

namespace Core
{
	namespace Init
	{
		class Init_GLUT
		{
		public:
			static void Init(const Core::WindowInfo& windowInfo, const Core::ContextInfo& contextInfo, const Core::FrameBufferInfo& framebufferInfo);
		public:
			static void SetListener(Core::IListener*& iListener);

			static void Run();
			static void Close();

			void EnterFullscreen();
			void ExitFullscreen();

			static void PrintOpenGLInfo(const Core::WindowInfo& windowInfo, const Core::ContextInfo& context);
		private:
			static Core::IListener* listener;
			static Core::WindowInfo windowInformation;

			static void IdleCallback(void);
			static void DisplayCallback(void);
			static void ReshapeCallback(int width, int height);
			static void CloseCallback();
		};
	}
}

#endif
