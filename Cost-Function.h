#include <fstream>
#include <iomanip>
#include <string>
#include <iostream>
#include <vector>
#include <string>
#include <sstream>

using namespace std;

//const int NumOfNodes = 5;

//global variables
int lines; //first line of telling how many nodes are in text 

struct NodeInfo
{
	int NodeNum;
	int CL;
	int Flshtrns;	//?????
	int macen;		//?????
	vector<int> NodeEdges;
};

NodeInfo *ptr;

void GetData()
{
	string line;
	ifstream f;
	f.open("test.txt", ios::in);
	f.seekg(0);
	getline(f, line);
	string::size_type sz;	
	lines = stoi(line, &sz);
	ptr = new NodeInfo[lines];
	for (int i = 0; i < lines; i++)
	{
		getline(f, line);
		istringstream iss(line);
		string word;
		iss>>word;
		string::size_type sz1;
		ptr[i].NodeNum = stoi(word, &sz1);
		iss>>word;
		string::size_type sz2;
		ptr[i].CL = stoi(word, &sz2);
		iss>>word;
		string::size_type sz3;
		ptr[i].Flshtrns = stoi(word, &sz3);
		iss>>word;
		string::size_type sz4;
		ptr[i].macen = stoi(word, &sz4);
		while(iss>>word)
		{
			int edges;
			edges = stoi(word);
			ptr[i].NodeEdges.push_back(edges);
		}
	}
	f.close();
}

void displayOutput(int lines)
{
	//display all names in formatted output
	cout<<endl;
	for (int i = 0; i < lines; i++) {
		cout << " NodeNum:" << ptr[i].NodeNum <<endl;
		cout << " CL:" << ptr[i].CL<<endl;
		cout << " Flshtrns:" << ptr[i].Flshtrns<<endl;
		cout << " macen:" << ptr[i].macen<<endl;
		cout << " NodeEdges:";
		for(int k=0;k<ptr[i].NodeEdges.size();k++)
		{
			cout<<" ("<<ptr[i].NodeNum<<", "<<ptr[i].NodeEdges[k]<<")";
		}
		cout<<"\n\n";
	}
}
/*
int CalculateCostFunct(int lines)
{
	int Q1 = 1, Q2 = 2, Q3 = 3;
	int wd_mac = 1, ci_mac = 1;
	int wd_flash = 1, ci_flash = 1;
	int k = 0, j = 0;
	int total_mac = 0, total_flash = 0;
	int cost_val = 0;
	for (k = 0; k < lines; k++) {
		total_mac += wd_mac * ci_mac;
		//cout << total_mac << endl; //debug
	}

	for (j = 0; j < lines; j++) {
		total_flash += wd_flash * ci_flash;
		//cout << total_flash << endl; //debug
	}

	cost = (Q1 * total_mac) + (Q1 * total_flash);
	cout << "COST:" << cost << endl; //debug
									 //cost = total_mac;

	return cost_val;
	
}

*/
