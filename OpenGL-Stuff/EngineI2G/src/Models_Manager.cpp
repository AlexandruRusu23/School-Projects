#include "Models_Manager.h"

using namespace Managers;
using namespace Rendering;

Models_Manager::Models_Manager()
{
  Models::CubeIndex* cubeIndex = new Models::CubeIndex();
  cubeIndex->SetProgram(Shader_Manager::GetShader("colorShader"));
  cubeIndex->Create();
  gameModelList["cubeIndex"] = cubeIndex;
}

Models_Manager::~Models_Manager()
{
  for(auto model: gameModelList)
  {
    delete model.second;
  }
  gameModelList.clear();
}

void Models_Manager::DeleteModel(const std::string& gameModelName)
{
  IGameObject* model = gameModelList[gameModelName];
  model->Destroy();
  gameModelList.erase(gameModelName);
}

const IGameObject& Models_Manager::GetModel(const std::string& gameModelName) const
{
  return (*gameModelList.at(gameModelName));
}

void Models_Manager::Update()
{
  for(auto model: gameModelList)
  {
    model.second->Update();
  }
}

void Models_Manager::Draw()
{
  for(auto model: gameModelList)
  {
    model.second->Draw();
  }
}

void Models_Manager::Draw(const glm::mat4& projection_matrix, const glm::mat4& view_matrix)
{
	for (auto model : gameModelList)
	{
		model.second->Draw(projection_matrix, view_matrix);
	}
}
