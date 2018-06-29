#ifndef FRAMEBUFFERINFO_H
#define FRAMEBUFFERINFO_H

#include <GL/glew.h>
#include <GL/freeglut.h>

namespace Core
{
	struct FrameBufferInfo
	{
		unsigned int flags;
		bool msaa; // GLUT_MULTISAMPLE

		FrameBufferInfo()
		{
			flags = GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH;
			msaa = false;
		}

		FrameBufferInfo(bool color, bool depth, bool stencil, bool msaa)
		{
			flags = GLUT_DOUBLE;
			if(color)
				flags |= GLUT_RGBA | GLUT_ALPHA;
			if(depth)
				flags |= GLUT_DEPTH;
			if(stencil)
				flags |= GLUT_STENCIL;
			if(msaa)
				flags |= GLUT_MULTISAMPLE;
			this->msaa = msaa;
		}

		FrameBufferInfo(const FrameBufferInfo& frameBufferInfo)
		{
			flags = frameBufferInfo.flags;
			msaa = frameBufferInfo.msaa;
		}

		void operator=(const FrameBufferInfo& frameBufferInfo)
		{
			flags = frameBufferInfo.flags;
			msaa = frameBufferInfo.flags;
		}

	};
}

#endif