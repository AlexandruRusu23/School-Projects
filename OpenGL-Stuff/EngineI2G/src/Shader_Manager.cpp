#include "Shader_Manager.h"
#include <iostream>
#include <fstream>
#include <vector>

using namespace Managers;

// static std::map from Shader_Manager class;
std::map <std::string, GLuint> Shader_Manager::programs;

Shader_Manager::Shader_Manager(void) {}

Shader_Manager::~Shader_Manager(void)
{
	std::map<std::string, GLuint>::iterator i;
	for (i = programs.begin(); i != programs.end(); i++)
	{
		GLuint pr = i->second;
		glDeleteProgram(pr);
	}
	programs.clear();
}

std::string Shader_Manager::ReadShader(const std::string& filename)
{
	std::string shaderCode;
	std::ifstream file(filename.c_str(), std::ios::in);

	if(!file.good())
	{
		std::cout << "Can't read file" << filename << std::endl;
		std::terminate();
	}

	file.seekg(0, std::ios::end);
	shaderCode.resize((unsigned int)file.tellg());
	file.seekg(0, std::ios::beg);
	file.read(&shaderCode[0], shaderCode.size());
	file.close();

	return shaderCode;
}

GLuint Shader_Manager::CreateShader(GLenum shaderType, const std::string& source, const std::string& shaderName)
{
	int compileResult = 0;

	GLuint shader = glCreateShader(shaderType);
	const char *shaderCodePtr = source.c_str();
	const int shaderCodeSize = source.size();

	glShaderSource(shader, 1, &shaderCodePtr, &shaderCodeSize);
	glCompileShader(shader);
	glGetShaderiv(shader, GL_COMPILE_STATUS, &compileResult);

	if(compileResult == GL_FALSE)
	{
		int infoLogLength = 0;
		glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogLength);
		std::vector<char> shaderLog(infoLogLength);
		glGetShaderInfoLog(shader, infoLogLength, NULL, &shaderLog[0]);
		std::cout << "ERROR compiling shader: " << shaderName << std::endl << &shaderLog[0] << std::endl;
		return 0;
	}
	return shader;
}

void Shader_Manager::CreateProgram (const std::string& shaderName, const std::string& VertexShaderFilename, const std::string& FragmentShaderFilename)
{
	std::string vertexShaderCode = ReadShader(VertexShaderFilename);
	std::string fragmentShaderCode = ReadShader(FragmentShaderFilename);
	GLuint vertexShader = CreateShader(GL_VERTEX_SHADER, vertexShaderCode, (std::string ("vertex shader")).c_str());
	GLuint fragmentShader = CreateShader(GL_FRAGMENT_SHADER, fragmentShaderCode, (std::string ("fragment shader")).c_str());

	int linkResult = 0;

	GLuint program = glCreateProgram();
	glAttachShader(program, vertexShader);
	glAttachShader(program, fragmentShader);

	glLinkProgram(program);
	glGetProgramiv(program, GL_LINK_STATUS, &linkResult);

	if(linkResult == GL_FALSE)
	{
		int infoLogLength = 0;
		glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLogLength);
		std::vector<char> programLog(infoLogLength);
		glGetProgramInfoLog(program, infoLogLength, NULL, &programLog[0]);
		std::cout << "Shader Loader : LINK ERROR" << std::endl << &programLog[0] << std::endl;
		return;
	}
	// check if shaderName is already in std::map
	if(programs.find(shaderName) != programs.end())
		return;
	programs[shaderName] = program;
}

const GLuint Shader_Manager::GetShader(const std::string& shaderName)
{
	if(programs.find(shaderName) != programs.end())
		return programs.at(shaderName);
	return -1;
}
