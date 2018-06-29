#ifndef VERTEXFORMAT_H
#define VERTEXFORMAT_H

#include <glm/glm.hpp>
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtx/transform.hpp"
#include "glm/gtc/type_ptr.hpp"

namespace Rendering
{
	struct VertexFormat
	{
		glm::vec3 position;
		glm::vec4 color;

		VertexFormat(const glm::vec3 &iPos, const glm::vec4 &iColor)
		{
			position = iPos;
			color = iColor;
		}

		VertexFormat() {}

	};
}
#endif
