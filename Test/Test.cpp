#include <bits/stdc++.h>
using namespace std;

int N,temp, root, removeN;
vector<int> adj[54];

int DFS(int here)
{
    int reef  = 0;
    int child = 0;

    for (int current : adj[here])
    {
        if (current == removeN) continue;

        reef += DFS(current);
        child++;
    }

    if (child == 0) return 1;

    return reef;
}

int main(int argc, char* argv[])
{
    cin >> N;
    
    for (int i = 0; i < N; i++)
    {
        cin >> temp;

        if (temp == -1) root = i;
        else            adj[temp].emplace_back(i);
    }

    cin >> removeN;

    if (removeN == root)
    {
        cout << "0" << endl;
        return 0;
    }

    cout << DFS(root) << endl;
}
