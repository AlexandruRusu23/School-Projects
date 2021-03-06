#ifndef MODELS_MANAGER_H
#define MODELS_MANAGER_H

#include <iostream>
#include <map>
#include "Shader_Manager.h"
#include "IGameObject.h"
#include "CubeIndex.h"

using namespace Rendering;

namespace Managers
{
  class Models_Manager
  {
  public:
    Models_Manager();
    ~Models_Manager();

    void Draw();
    void Draw(const glm::mat4& projection_matrix, const glm::mat4& view_matrix);
    void Update();

    void DeleteModel(const std::string& gameModelName);
    const IGameObject& GetModel(const std::string& gameModelName) const;

  private:
    std::map<std::string, IGameObject*> gameModelList;
  };
}

#endif
