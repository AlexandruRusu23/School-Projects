#include "Model.h"
using namespace Rendering;
using namespace Models;

Model::Model() {}

Model::~Model()
{
  Destroy();
}

void Model::Draw()
{

}

void Model::Draw(const glm::mat4& projection_matrix, const glm::mat4& view_matrix)
{

}

void Model::Update()
{

}

void Model::SetProgram(GLuint program)
{
  this->program = program;
}

GLuint Model::GetVao() const
{
  return vao;
}

const std::vector<GLuint>& Model::GetVbos() const
{
  return vbos;
}

void Model::Destroy()
{
  glDeleteVertexArrays(1, &vao);
  glDeleteBuffers(vbos.size(), &vbos[0]);
  vbos.clear();
}
