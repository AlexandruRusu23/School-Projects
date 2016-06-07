#include <Windows.h>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>    
using namespace std;

void FindFile(const wstring &directory, wstring mask, ofstream &out, string search)
{
	wstring tmp = directory + L"\\*";
	WIN32_FIND_DATAW file;
	HANDLE search_handle = FindFirstFileW(tmp.c_str(), &file);
	if (search_handle != INVALID_HANDLE_VALUE)
	{
		vector<wstring> directories;

		do
		{
			if (file.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			{
				if ((!lstrcmpW(file.cFileName, L".")) || (!lstrcmpW(file.cFileName, L"..")))
					continue;
			}

			tmp = directory + L"\\" + wstring(file.cFileName);
			wstring wide(file.cFileName);
			string aux(wide.begin(), wide.end());
			istringstream aux_ss(aux);
			string token;
			while (getline(aux_ss, token, '.')){}
			string compare_to_token(mask.begin(), mask.end());
			if (token.compare(compare_to_token)==0)
			{
				string file_to_search(tmp.begin(), tmp.end());

				ifstream f; f.open(file_to_search);

				for (string line; getline(f, line);)
				{
					if (line.find(search) != string::npos)
					{
						out << file_to_search << " : " << line << endl;
					}
				}

				f.close();
			}

			if (file.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
				directories.push_back(tmp);

		} while (FindNextFileW(search_handle, &file));

		FindClose(search_handle);

		for (vector<wstring>::iterator iter = directories.begin(), end = directories.end(); iter != end; ++iter)
			FindFile(*iter, mask, out, search);
	}
}

int main()
{
	string str1, str2, str3, str4;
	cout << "Directory path: "; getline(cin, str1);
	cout << "File mask: "; getline(cin, str2);
	cout << "String to search for: "; getline(cin, str3);
	cout << "Output file full path: "; getline(cin, str4);

	wstring directory_path(str1.begin(), str1.end()), file_mask(str2.begin(), str2.end());

	vector<wstring> files;
	vector<wstring> files_mask;
	ofstream output;
	output.open(str4);
	if (!output)
	{
		return 0;
	}

	istringstream str2_ss(str2);
	string token;
	while (getline(str2_ss, token, ';'))
	{
		wstring aux(token.begin(), token.end());
		files_mask.push_back(aux);
	}

	for (vector <wstring>::iterator it = files_mask.begin(); it != files_mask.end(); it++)
	{
		FindFile(directory_path, *it, output, str3 );
	}

	output.close();
	system("pause");
}