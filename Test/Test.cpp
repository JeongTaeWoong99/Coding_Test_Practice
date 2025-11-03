#include<bits/stdc++.h>
using namespace std; 

const int dy[] = {-1, 1, 0, 0}; 
const int dx[] = {0, 0, 1, -1}; 

int  n, m, mx;             
char arr[54][54];      
int  visited[54][54];

void BFS(int y, int x)
{
    // 모든 L자리 마다 체크해야 하기 때문에, 매번 초기화
    memset(visited, 0, sizeof(visited)); 
    
    visited[y][x] = 1; 
    queue<pair<int, int>> bfsQ; 
    bfsQ.emplace(y, x); 
    
    while(!bfsQ.empty())
    {
        int nY, nX;
        tie(nY, nX) = bfsQ.front(); 
        bfsQ.pop();                       
        
        for(int i = 0; i < 4; i++)
        {
            int ny = nY + dy[i]; 
            int nx = nX + dx[i]; 
            
            if(ny < 0 || ny >= n || nx < 0 || nx >= m) continue;
            
            if(visited[ny][nx]) continue;
            
            if(arr[ny][nx] == 'W') continue;
            
            visited[ny][nx] = visited[nY][nX] + 1;
            bfsQ.emplace(ny, nx);
            mx = max(mx, visited[ny][nx]);
        }
    }
    return;
}

int main()
{
    cin >> n >> m; 
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
        {
            cin >> arr[i][j]; 
        }
    }
    
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < m; j++)
        {
            if(arr[i][j] == 'L')
                BFS(i, j); 
        }
    }
    
    cout << mx - 1 << "\n";
}