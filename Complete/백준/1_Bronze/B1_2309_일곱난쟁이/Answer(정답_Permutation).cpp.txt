#include<bits/stdc++.h>
using namespace std;

int a[9]; 
int N = 9, r = 7;

void Solve()
{  
    int sum = 0; 
    for(int i = 0; i < r; i++)
    {
        sum += a[i];  
    }
    if(sum == 100)
    { 
        sort(a, a + 7);  
        for(int i = 0; i < r; i++)
            cout << a[i] << "\n"; 
    } 
}
void Print()
{
    for(int i = 0; i < r; i++)
        cout << a[i] << " "; 
    cout << '\n';
}

void Permutation(int n, int r, int depth)
{
    if(r == depth)
    { 
        Solve();
        return;
    }
    
    for(int i = depth; i < n; i++)
    {
        swap(a[i], a[depth]);
        Permutation(n, r, depth + 1);
        swap(a[i], a[depth]);
    }
    return;
}
int main()
{
    for(int i = 0; i < N; i++)
        cin >> a[i];
    
    Permutation(N, r, 0);
    
    return 0;
}