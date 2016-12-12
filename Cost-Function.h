#include <fstream>
#include <iomanip>
#include <string>
#include <iostream>
#include <vector>
#include <sstream>
#include "Solution.h"

using namespace std;


//global variables
int lines; //first line of telling how many nodes are in text 

struct NodeInfo
{
	int NodeNum;
	int CL_Software;
	int CL_Hardware;
	int CI_Flash;		
	vector<int> NodeEdges;
};

/*void operator=(NodeInfo& ptr, NodeInfo& ptr1)
{
	ptr.NodeNum = ptr1.NodeNum;
	ptr.CL_Software = ptr1.CL_Software;
	ptr.CL_Hardware = ptr1.CL_Hardware;
	ptr.CI_Flash = ptr1.CI_Flash;
	ptr1.NodeEdges.clear();
	for(int i=0;i<ptr.NodeEdges.size();i++)
	{
		ptr1.NodeEdges.push_back(ptr.NodeEdges[i]);
	}
}
*/
NodeInfo *Curr_Solution;
NodeInfo *New_Solution;

void GetData()
{
	string line;
	ifstream f;
	f.open("test.txt", ios::in);
	f.seekg(0);
	getline(f, line);
	string::size_type sz;	
	lines = stoi(line, &sz);
	Curr_Solution = new NodeInfo[lines];
	for (int i = 0; i < lines; i++)
	{
		getline(f, line);
		istringstream iss(line);
		string word;
		iss>>word;
		Curr_Solution[i].NodeNum = stoi(word, &sz);
		software_nodes.push_back(Curr_Solution[i].NodeNum);
		iss>>word;
		Curr_Solution[i].CL_Software = stoi(word, &sz);
		iss>>word;
		Curr_Solution[i].CL_Hardware = stoi(word, &sz);
		iss>>word;
		Curr_Solution[i].CI_Flash = stoi(word, &sz);
		while(iss>>word)
		{
			int edges;
			edges = stoi(word);
			Curr_Solution[i].NodeEdges.push_back(edges);
		}
	}
	f.close();
}

void displayOutput(int lines)
{
	//display all names in formatted output
	cout<<endl;
	for (int i = 0; i < lines; i++) {
		cout << " Node Number:" << Curr_Solution[i].NodeNum <<endl;
		cout << " CL_Software:" << Curr_Solution[i].CL_Software<<endl;
		cout << " CL_Hardware:" << Curr_Solution[i].CL_Hardware<<endl;
		cout << " CI_Flash :" << Curr_Solution[i].CI_Flash<<endl;
		cout << " NodeEdges:";
		for(int k=0;k<Curr_Solution[i].NodeEdges.size();k++)
		{
			cout<<" ("<<Curr_Solution[i].NodeNum<<", "<<Curr_Solution[i].NodeEdges[k]<<")";
		}
		cout<<"\n\n";
	}
}

int CalculateCostFunct(int lines)
{
    int Q1 = 1, Q2 = 1, Q3 = 1;
    int wd_mac = 1, ci_mac = 1;
    int wd_flash = 1, ci_flash = 1, flash_lim = 1;
    int k = 0, j = 0, l = 0, m=0, n=0;
    int total_mac = 0, total_flash = 0;
    int cost = 0;
    int CL_Hardware_sum = 0, CL_Software_sum = 0;

    //mac
    //lines has to change here
    //1/mac has to be verrified 
    for (k = 0; k < lines; k++) {
        total_mac += wd_mac * (1/ci_mac);
        //cout << total_mac << endl; //debug
    }

    //loop used to obtain flash sum limit
    for (n = 0; n < lines; n++) {
        if (Curr_Solution[n].CI_Flash != 0) {
            flash_lim++;
        }
    }

    //flash
    for (j = 0; j < flash_lim; j++) {
        total_flash += wd_flash * Curr_Solution[j].CI_Flash;
        //cout << total_flash << endl; //debug
    }
    int hw_loop_limit = hardware_nodes.size();
    int sw_loop_limit = software_nodes.size();
    //HW nodes
    for (l = 0; l < hw_loop_limit; l++) {
        CL_Hardware_sum += Curr_Solution[hardware_nodes[l]].CL_Hardware;
        //cout << " CL_Hardware_sumALEX:" << CL_Hardware_sum << endl; //debug
    }

    //SW nodes
    for (m = 0; m < sw_loop_limit; m++) {
        CL_Software_sum += Curr_Solution[software_nodes[m]].CL_Software;
        //cout << " CL_Software_sumALEX:" << CL_Software_sum << endl; //debug
    }
    /*
    cout << " total_mac" << total_mac << endl; //debug
    cout << " flash_lim" << flash_lim << endl; //debug
    cout << " total_flash:" << total_flash << endl; //debug
    cout << " CL_Software_sum:" << CL_Software_sum << endl; //debug
    cout << " CL_Hardware_sum:" << CL_Hardware_sum << endl; //debug
    */

    //cost = /*(Q1 * total_mac) + (Q1 * total_flash) */- (Q3 * (CL_Hardware_sum - CL_Software_sum));//debug
    cost = (Q1 * total_mac) + (Q1 * total_flash) - (Q3 * (CL_Hardware_sum - CL_Software_sum));

    cout << " COST:" << cost << "\n\n"; //debug
                                        //cost = total_mac;

    return cost;

}


