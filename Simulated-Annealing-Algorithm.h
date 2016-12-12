#include <iostream>
#include <vector>
#include <cstdlib>
#include <time.h>
#include <algorithm>
#include <math.h>
#include "Cost-Function.h"

using namespace std;

float ti = 400;		//Step 2
float tl = 90;
float alpha = 0.96;
	
int random_number;
int curr_cost, new_cost, cost_difference, best_cost, worst_cost=0;
	
void SA_Algorithm()
{
	for(int i=0;i<software_nodes.size();i++)		//Printing out
	{
		cout<<"Software node: "<<software_nodes[i]<<endl;
	}
	for(int i=0;i<hardware_nodes.size();i++)
	{
		cout<<"Hardware node: "<<hardware_nodes[i]<<endl;
	}
	cout<<endl;
	float t=ti;
	vector<int>::iterator it;
	curr_cost = CalculateCostFunct(lines);
	best_cost = curr_cost;
	worst_cost = curr_cost;
	float q, equ;
	int flag, stopping_criteria_count=0;
	srand(time(NULL));
	while(t>tl)		
	{
		random_number = rand() % lines;		//Inner step in 3.1.1
//		cout<<"\n\n"<<random_number<<"\n\n";
		it = find(software_nodes.begin(), software_nodes.end(), random_number);
		if(it == software_nodes.end())		//if random number is not in software_nodes because it = software.end()
		{
			software_nodes.push_back(random_number);
			hardware_nodes.erase(remove(hardware_nodes.begin(), hardware_nodes.end(), random_number), hardware_nodes.end());
			flag = 1;		//
		}
		else
		{
			hardware_nodes.push_back(random_number);
			software_nodes.erase(remove(software_nodes.begin(), software_nodes.end(), random_number), software_nodes.end());
		}
		
		new_cost = CalculateCostFunct(lines);
		//cout<<"New cost: "<<new_cost<<"\n\n";
		cost_difference = new_cost - curr_cost;		//Inner step 3.1.2
		if(new_cost < best_cost)
			best_cost = new_cost;	
		
		if(new_cost > worst_cost)
			worst_cost = new_cost;
		
		if(cost_difference > 0)			//Inner step 3.1.3
		{
			q = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
			equ = exp(-cost_difference/t);
			if(q>=equ)		//Inner step 3.1.4
			{
				if(flag == 0)
				{
					software_nodes.push_back(random_number);
					hardware_nodes.erase(remove(hardware_nodes.begin(), hardware_nodes.end(), random_number), hardware_nodes.end());
				}
				else
				{
					hardware_nodes.push_back(random_number);
					software_nodes.erase(remove(software_nodes.begin(), software_nodes.end(), random_number), software_nodes.end());
				}
			}
		}
		else
			curr_cost = new_cost;
		for(int i=0;i<software_nodes.size();i++)		//Printing out
		{
			cout<<"Software node: "<<software_nodes[i]<<endl;
		}	
		cout<<endl;
		for(int i=0;i<hardware_nodes.size();i++)
		{
			cout<<"Hardware node: "<<hardware_nodes[i]<<endl;
		}
		t = alpha * t;		//Step 3.2
	//	if(stopping_criteria_count == 3 && 		//Step 4 left to code
		
	}
	cout<<endl<<"Best cost: "<<best_cost<<endl;
	cout<<endl<<"Worst cost: "<<worst_cost<<endl;
}