#ifndef SCENE_MANAGER_H
#define SCENE_MANAGER_H
#include "Shader_Manager.h"
#include "Models_Manager.h"
#include "IListener.h"

namespace Managers
{
  class Scene_Manager : public Core::IListener
  {
  public:
    Scene_Manager();
    ~Scene_Manager();

    virtual void NotifyBeginFrame();
    virtual void NotifyDisplayFrame();
    virtual void NotifyEndFrame();
    virtual void NotifyReshape(int width, int height, int previous_width, int previous_height);

  private:
    Managers::Shader_Manager* shader_manager;
    Managers::Models_Manager* models_manager;
    glm::mat4 projection_matrix;
		glm::mat4 view_matrix;
  };
}

#endif
