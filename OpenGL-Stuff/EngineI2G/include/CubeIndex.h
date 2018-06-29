#ifndef CUBEINDEX_H
#define CUBEINDEX_H

#include "Model.h"
#include <time.h>
#include <stdarg.h>

namespace Rendering
{
  namespace Models
  {
    class CubeIndex : public Model
    {
    public:
      CubeIndex();
      ~CubeIndex();

      void Create();
      virtual void Draw(const glm::mat4& projection_matrix, const glm::mat4& view_matrix) override final;

      virtual void Update() override final;

    private:
      glm::vec3 rotation, rotation_speed;
      glm::vec3 translate;
      glm::mat4 translate_matrix;
      time_t timer;
    };
  }
}

#endif
