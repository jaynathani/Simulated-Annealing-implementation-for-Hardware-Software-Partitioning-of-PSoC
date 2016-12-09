#include <fstream>
#include <iomanip>
#include <string>
#include <iostream>
#include <fstream>
using namespace std;
//const int NumOfNodes = 5;

//global variables
int lines; //first line of telling how many nodes are in text 

struct NodeInfo
{
	int NodeNum;
	int CL;
	int Flshtrns;
	int macen;
	char NodeEdges[100];
};

NodeInfo *ptr;

int GetData(){

	ifstream f("test.txt");
	f >> lines;
	ptr = new NodeInfo[lines];

	for (int i = 0; i < lines; i++)
	{
		f >> ptr[i].NodeNum;
		f >> ptr[i].CL;
		f >> ptr[i].Flshtrns;
		f >> ptr[i].macen;
		f.getline(ptr[i].NodeEdges, 100, '\n');
	}
	f.close();
	return lines;
}

void displayOutput(int lines)
{
	//display all names in formatted output
	for (int i = 0; i < lines; i++) {
		cout << " NodeNum:" << ptr[i].NodeNum ;
		cout << " CL:" << ptr[i].CL;
		cout << " Flshtrns:" << ptr[i].Flshtrns;
		cout << " macen:" << ptr[i].macen;
		cout << " NodeEdges:" << ptr[i].NodeEdges << endl;
	}
}

int CalculateCostFunct(int lines)
{
	int Q1 = 1;
	int Q2 = 2;
	int Q3 = 3;
	int wd_mac = 1;
	int ci_mac = 1;
	int wd_flash = 1;
	int ci_flash = 1;
	int k = 0;
	int j = 0;
	int total_mac = 0;
	int total_flash = 0;
	int cost = 0;
	
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

	return cost;
}

int main()
{

	GetData();
	displayOutput(lines);
	CalculateCostFunct(lines);
	return 0;
}

