#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <stack>
#include <algorithm>
#include <map>

std::ifstream inFile("input.txt");

struct DFA
{
	std::vector<std::pair<int, bool>> states;
	std::vector<std::string> alphabet;
	std::map<std::pair<int, std::string>, int> Dtrans;
	int initialState;
	int finalStates;
}dfa;

struct Node
{
	int nodeNumber;
	std::vector<int> vecFirstPos;
	std::vector<int> vecLastPos;
	bool bNullable;
	std::string value;
	Node* left;
	Node* right;
	Node* next;
} *regexTree;

std::map<int, std::vector<int>> followMatrix;
std::vector<std::pair<std::string, int>> alphaCharDistribution;
int nrGlobal;

void TokenizeAlphabetString(std::string strAlphabet, std::vector<std::string>& vecAlphabet)
{
	std::string token;

	std::size_t prev = 0, pos;
	while ((pos = strAlphabet.find_first_of(" ,;", prev)) != std::string::npos)
	{
		if (pos > prev)
			vecAlphabet.push_back(strAlphabet.substr(prev, pos - prev));
		prev = pos + 1;
	}
	if (prev < strAlphabet.length())
		vecAlphabet.push_back(strAlphabet.substr(prev, std::string::npos));
}

void TransformToPostfixForm(std::string& regex, std::string& postfixRegex)
{
	std::stack<char> regexElementsStack;
	std::string auxElem;
	for (int i = 0; i < regex.length(); i++)
	{
		if (regex[i] == '(')
		{
			regexElementsStack.push(regex[i]);
		}
		else if (regex[i] == ')')
		{
			while (1)
			{
				if (!regexElementsStack.empty())
				{
					auxElem = regexElementsStack.top();
					regexElementsStack.pop();
					if (auxElem.compare("(") == 0)
						break;
					postfixRegex.append(auxElem);
				}
				else
					break;
			}
		}
		else if (regex[i] == '|')
		{
			if(!regexElementsStack.empty())
				auxElem = regexElementsStack.top();
			while ((auxElem.compare("*") == 0 || auxElem.compare("|") == 0 || auxElem.compare(".") == 0) && !regexElementsStack.empty())
			{
				postfixRegex.append(auxElem);
				regexElementsStack.pop();
				auxElem = regexElementsStack.top();
			}
			regexElementsStack.push(regex[i]);
		}
		else if (regex[i] == '.')
		{
			if (!regexElementsStack.empty())
				auxElem = regexElementsStack.top();
			while ((auxElem.compare("*") == 0 || auxElem.compare(".") == 0) && !regexElementsStack.empty())
			{
				postfixRegex.append(auxElem);
				regexElementsStack.pop();
				if(!regexElementsStack.empty())
					auxElem = regexElementsStack.top();
			}
			regexElementsStack.push(regex[i]);
		}
		else if (regex[i] == '*' && !regexElementsStack.empty())
		{
			regexElementsStack.push(regex[i]);
		}
		else
		{
			auxElem = std::string(regex.begin() + i, regex.begin() + i + 1);
			postfixRegex.append(auxElem);
		}
	}

	while (!regexElementsStack.empty())
	{
		auxElem = regexElementsStack.top();
		if (auxElem.compare("(") != 0)
		{
			postfixRegex.append(auxElem);
		}
		regexElementsStack.pop();
	}

	postfixRegex.append("#");
	postfixRegex.append(".");

	std::string::iterator end_pos = std::remove(postfixRegex.begin(), postfixRegex.end(), ' ');
	postfixRegex.erase(end_pos, postfixRegex.end());
}

Node* PopNode()
{
	Node* aux;
	aux = new Node;
	aux = regexTree;
	if (regexTree->next != NULL)
		regexTree = regexTree->next;
	else
		regexTree = NULL;
	return aux;
}

void PushNode(Node* auxNode)
{
	Node* aux;
	aux = new Node;
	aux = auxNode;
	if (regexTree != NULL)
	{
		aux->next = regexTree;
	}
	else
		aux->next = NULL;
	regexTree = aux;
}

void CreateRegexTree(std::string regex)
{
	Node *auxNode;
	regexTree = NULL;
	for (int i = 0; i < regex.length(); i++)
	{
		auxNode = new Node;
		auxNode->value = regex[i];
		auxNode->left = NULL;
		auxNode->right = NULL;
		auxNode->next = NULL;

		if (regex[i] == '.' || regex[i] == '|')
		{
			auxNode->right = PopNode();
			auxNode->left = PopNode();
		}
		else if (regex[i] == '*')
		{
			auxNode->left = PopNode();
			auxNode->right = NULL;
		}
		PushNode(auxNode);
	}
}

void setLeafNodesOrderNumber(Node* t)
{
	if (t == NULL)
		return;
	if (t->left == NULL && t->right == NULL)
	{
		t->nodeNumber = nrGlobal;
		nrGlobal++;
	}
	setLeafNodesOrderNumber(t->left);
	setLeafNodesOrderNumber(t->right);
}

bool Nullable(Node* regexTree)
{
	if (regexTree != NULL)
	{
		if (regexTree->value.compare("l") == 0)
		{
			return true;
		}
		else if (regexTree->value.compare("|") == 0)
		{
			return Nullable(regexTree->left) || Nullable(regexTree->right);
		}
		else if (regexTree->value.compare(".") == 0)
		{
			return Nullable(regexTree->left) && Nullable(regexTree->right);
		}
		else if (regexTree->value.compare("*") == 0)
		{
			return true;
		}
		else // alphabet character
		{
			return false;
		}
	}
}

void CalculateFirstPos(Node* regexTree)
{
	if (regexTree != NULL)
	{
		if (regexTree->value.compare("l") == 0)
		{
			regexTree->vecFirstPos.clear();
		}
		else if (regexTree->value.compare("|") == 0)
		{
			if (regexTree->left != NULL && regexTree->right != NULL)
			{
				regexTree->vecFirstPos.reserve(regexTree->left->vecFirstPos.size() + regexTree->right->vecFirstPos.size()); // preallocate memory
				regexTree->vecFirstPos.insert(regexTree->vecFirstPos.end(), regexTree->left->vecFirstPos.begin(), regexTree->left->vecFirstPos.end());
				regexTree->vecFirstPos.insert(regexTree->vecFirstPos.end(), regexTree->right->vecFirstPos.begin(), regexTree->right->vecFirstPos.end());
			}
		}
		else if (regexTree->value.compare(".") == 0)
		{
			if (regexTree->left != NULL && regexTree->right != NULL)
			{
				if (regexTree->left->bNullable)
				{
					regexTree->vecFirstPos.reserve(regexTree->left->vecFirstPos.size() + regexTree->right->vecFirstPos.size()); // preallocate memory
					regexTree->vecFirstPos.insert(regexTree->vecFirstPos.end(), regexTree->left->vecFirstPos.begin(), regexTree->left->vecFirstPos.end());
					regexTree->vecFirstPos.insert(regexTree->vecFirstPos.end(), regexTree->right->vecFirstPos.begin(), regexTree->right->vecFirstPos.end());
				}
				else
				{
					regexTree->vecFirstPos = regexTree->left->vecFirstPos;
				}
			}
		}
		else if (regexTree->value.compare("*") == 0)
		{
			if (regexTree->left != NULL)
				regexTree->vecFirstPos = regexTree->left->vecFirstPos;
		}
		else // alphabet character
		{
			regexTree->vecFirstPos.push_back(regexTree->nodeNumber);
		}
	}
}

void CalculateLastPos(Node* regexTree)
{
	if (regexTree != NULL)
	{
		if (regexTree->value.compare("l") == 0)
		{
			regexTree->vecLastPos.clear();
		}
		else if (regexTree->value.compare("|") == 0)
		{
			if (regexTree->left != NULL && regexTree->right != NULL)
			{
				regexTree->vecLastPos.reserve(regexTree->left->vecLastPos.size() + regexTree->right->vecLastPos.size()); // preallocate memory
				regexTree->vecLastPos.insert(regexTree->vecLastPos.end(), regexTree->left->vecLastPos.begin(), regexTree->left->vecLastPos.end());
				regexTree->vecLastPos.insert(regexTree->vecLastPos.end(), regexTree->right->vecLastPos.begin(), regexTree->right->vecLastPos.end());
			}
		}
		else if (regexTree->value.compare(".") == 0)
		{
			if (regexTree->left != NULL && regexTree->right != NULL)
			{
				if (regexTree->right->bNullable)
				{
					regexTree->vecLastPos.reserve(regexTree->left->vecLastPos.size() + regexTree->right->vecLastPos.size()); // preallocate memory
					regexTree->vecLastPos.insert(regexTree->vecLastPos.end(), regexTree->left->vecLastPos.begin(), regexTree->left->vecLastPos.end());
					regexTree->vecLastPos.insert(regexTree->vecLastPos.end(), regexTree->right->vecLastPos.begin(), regexTree->right->vecLastPos.end());
				}
				else
				{
					regexTree->vecLastPos = regexTree->right->vecLastPos;
				}
			}
		}
		else if (regexTree->value.compare("*") == 0)
		{
			if (regexTree->left != NULL)
				regexTree->vecLastPos = regexTree->left->vecLastPos;
		}
		else // alphabet character
		{
			regexTree->vecLastPos.push_back(regexTree->nodeNumber);
		}
	}
}

void CalculateFollowPos(Node* regexTree)
{
	if (regexTree != NULL)
	{
		if (regexTree->value.compare(".") == 0)
		{
			if (regexTree->left != NULL && regexTree->right != NULL)
			{
				for (std::vector<int>::iterator it = regexTree->left->vecLastPos.begin(); it != regexTree->left->vecLastPos.end(); it++)
				{
					followMatrix[*it].insert(followMatrix[*it].end(), regexTree->right->vecFirstPos.begin(), regexTree->right->vecFirstPos.end());
				}
			}
		}
		else if (regexTree->value.compare("*") == 0)
		{
			if (regexTree->left != NULL)
			{
				for (std::vector<int>::iterator it = regexTree->left->vecLastPos.begin(); it != regexTree->left->vecLastPos.end(); it++)
				{
					followMatrix[*it].insert(followMatrix[*it].end(), regexTree->left->vecFirstPos.begin(), regexTree->left->vecFirstPos.end());
				}
			}
		}
	}
}

void SDR(Node* regexTree)
{
	if (regexTree != NULL)
	{
		SDR(regexTree->left);
		SDR(regexTree->right);
		regexTree->bNullable = Nullable(regexTree);
		CalculateFirstPos(regexTree);
		CalculateLastPos(regexTree);
		CalculateFollowPos(regexTree);
	}
}

void PrintFollowPosMatrix()
{
	for (std::map<int, std::vector<int>>::iterator it = followMatrix.begin(); it != followMatrix.end(); it++)
	{
		printf("Follow Pos %d : ", it->first);
		for (std::vector<int>::iterator jt = it->second.begin(); jt != it->second.end(); jt++)
		{
			printf("%d ", *jt);
		}
		printf("\n");
	}
}

void CalculateAlphabetCharacterDistribution(Node* regexTree)
{
	if (regexTree != NULL)
	{
		CalculateAlphabetCharacterDistribution(regexTree->left);
		CalculateAlphabetCharacterDistribution(regexTree->right);
		if (regexTree->nodeNumber >= 0)
			alphaCharDistribution.push_back(std::pair<std::string, int>(regexTree->value, regexTree->nodeNumber));
	}
}

int FromVectorToInt(std::vector<int> input)
{
	int output = 0;
	for (std::vector<int>::iterator it = input.begin(); it != input.end(); it++)
	{
		output = output * 10 + (*it);
	}
	return output;
}

void ReverseInt(int &input)
{
	int output = 0;
	while (input)
	{
		int aux = input % 10;
		output = output * 10 + aux;
		input /= 10;
	}
	input = output;
}

std::vector<int> FromIntToVector(int input)
{
	ReverseInt(input);
	std::vector<int> output;
	while (input)
	{
		output.push_back(input % 10);
		input /= 10;
	}
	return output;
}

int GetFirstPosOfTreeHead(Node* regexTree)
{
	if (regexTree != NULL)
	{
		return FromVectorToInt(regexTree->vecFirstPos);
	}
	return -1;
}

void GetFinalStatesFromTree(Node* regexTree)
{
	if (regexTree != NULL)
	{
		GetFinalStatesFromTree(regexTree->left);
		GetFinalStatesFromTree(regexTree->right);
		if (regexTree->value.compare("#") == 0)
		{
			dfa.finalStates = regexTree->nodeNumber;
		}
	}
}

void CleanForCurrentCharacter(std::vector<int>& indices, std::string character)
{
	std::vector<int> output;
	for (std::vector<int>::iterator it = indices.begin(); it != indices.end(); it++)
	{
		if (std::find(alphaCharDistribution.begin(), alphaCharDistribution.end(), std::pair<std::string, int>(character, *it)) != alphaCharDistribution.end())
		{
			output.push_back(*it);
		}
	}
	indices.clear();
	indices = output;
}

void CreateDFA(std::vector<std::string> alphabet)
{
	dfa.alphabet = alphabet;

	CalculateAlphabetCharacterDistribution(regexTree);

	dfa.initialState = GetFirstPosOfTreeHead(regexTree);

	if (dfa.initialState == -1)
		return;

	GetFinalStatesFromTree(regexTree);

	dfa.states.push_back(std::pair<int, bool>(dfa.initialState, false)); // not checked

	for (std::vector<std::pair<int, bool>>::iterator it = dfa.states.begin(); it != dfa.states.end(); it++)
	{
		if (it->second == false)
		{
			it->second = true;

			for (std::vector<std::string>::iterator jt = dfa.alphabet.begin(); jt != dfa.alphabet.end(); jt++)
			{
				std::vector<int> xIndices;
				xIndices = FromIntToVector(it->first);
				CleanForCurrentCharacter(xIndices, (*jt));
				std::vector<int> y;
				for (std::vector<int>::iterator kt = xIndices.begin(); kt != xIndices.end(); kt++)
				{
					y.insert(y.end(), followMatrix[*kt].begin(), followMatrix[*kt].end());
				}

				sort(y.begin(), y.end());
				y.erase(unique(y.begin(), y.end()), y.end());

				dfa.Dtrans[std::pair<int, std::string>(it->first, *jt)] = FromVectorToInt(y);
				if (std::find(y.begin(), y.end(), dfa.finalStates) != y.end())
				{
					dfa.finalStates = FromVectorToInt(y);
				}

				if (FromVectorToInt(y) != 0)
				{
					int ok = 1;
					for (std::vector<std::pair<int, bool>>::iterator kt = dfa.states.begin(); kt != dfa.states.end(); kt++)
					{
						if (FromVectorToInt(y) == kt->first)
							ok = 0;
					}
					if (ok)
					{
						dfa.states.push_back(std::pair<int, bool>(FromVectorToInt(y), false));
						it = dfa.states.begin();
					}
				}
			}
		}
	}

	for (std::map<std::pair<int, std::string>, int>::iterator it = dfa.Dtrans.begin(); it != dfa.Dtrans.end();)
	{
		if ((it->second) == 0)
		{
			it = dfa.Dtrans.erase(it);
		}
		else
		{
			it++;
		}
	}
}

void PrintDFA()
{
	printf("\nDFA States: ");
	for (std::vector<std::pair<int, bool>>::iterator it = dfa.states.begin(); it != dfa.states.end(); it++)
	{
		printf("%d ", it->first);
	}
	printf("\n\nDFA Alphabet: ");
	for (std::vector<std::string>::iterator it = dfa.alphabet.begin(); it != dfa.alphabet.end(); it++)
	{
		printf("%s ", (*it).c_str());
	}
	printf("\n\nDFA Transitions:\n");
	for (std::map<std::pair<int, std::string>, int>::iterator it = dfa.Dtrans.begin(); it != dfa.Dtrans.end(); it++)
	{
		printf("    (%d, %s) -> %d\n", it->first.first, it->first.second.c_str(), it->second);
	}
	printf("\nDFA initial state: %d\n", dfa.initialState);
	printf("DFA final state: %d\n", dfa.finalStates);
}

// (((a.a)|(b.b))*).c.((a|b)*)
// (a | b)*.a.b.b

int main()
{
	std::string strAlphabet;
	std::string strRegex;
	std::string strPostfixRegex;
	std::vector<std::string> vecAlphabet;

	regexTree = NULL;

	// read the alphabet
	getline(inFile, strAlphabet);
	TokenizeAlphabetString(strAlphabet, vecAlphabet);

	// read the Regex
	getline(inFile, strRegex);
	TransformToPostfixForm(strRegex, strPostfixRegex);

	vecAlphabet.push_back("#");

	CreateRegexTree(strPostfixRegex);

	nrGlobal = 0;
	setLeafNodesOrderNumber(regexTree);

	SDR(regexTree);

	PrintFollowPosMatrix();

	CreateDFA(vecAlphabet);

	PrintDFA();

	system("pause");
}
