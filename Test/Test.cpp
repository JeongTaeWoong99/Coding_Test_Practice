#include <bits/stdc++.h>
using namespace std;

const int dY[4] = {0,-1,0,1};
const int dX[4] = {0,1,0,-1};

int R, C, isPossible;
int arr[1004][1004];
int vsitiedFire[1004][1004];
int vsitiedJihoon[1004][1004];
queue<pair<int, int>> fireQ;
queue<pair<int, int>> jihoonQ;

int main(int argc, char* argv[])
{
    ios_base::sync_with_stdio(false);cin.tie(NULL);cout.tie(NULL);

    cin >> R >> C;

    for (int i = 0; i < R; i++)
    {
        string temp;
        cin >> temp;
        
        for (int j = 0; j < C; j++)
        {
            arr[i][j] = temp[j];

            if (arr[i][j] == 'J')
            {
                jihoonQ.emplace(i, j);
            }
            else if (arr[i][j] == 'F')
            {
                fireQ.emplace(i, j);
            }
        }
    }

    // 불 먼저 기록
    while (!fireQ.empty())
    {
        int fireY = fireQ.front().first;
        int fireX = fireQ.front().second;
        fireQ.pop();

        for (int i = 0; i < 4; i++)
        {
            int nY = fireY + dY[i];
            int nX = fireX + dX[i];

            // 범위 체크
            if (nY < 0 || nY >= R || nX < 0 || nX >= C) continue;

            // 벽 체크
            if (arr[nY][nX] == '#') continue;
            
            // 처음 방문
            if (vsitiedFire[nY][nX] == 0)
            {
                vsitiedFire[nY][nX] = vsitiedFire[fireY][fireX] + 1; // 누적   
                fireQ.emplace(nY, nX);
            }
        }
    }

    // 지훈 체크
    while (!jihoonQ.empty())
    {
        int jihoonY = jihoonQ.front().first;
        int jihoonX = jihoonQ.front().second;
        jihoonQ.pop();

        for (int i = 0; i < 4; i++)
        {
            int nY = jihoonY + dY[i];
            int nX = jihoonX + dX[i];

            // 범위 체크 = 지훈이가 범위를 나가는 것은 탈출을 의미!
            if (nY < 0 || nY >= R || nX < 0 || nX >= C)
            {
                isPossible = 1;
                cout << (vsitiedJihoon[jihoonY][jihoonX] + 1);
                break;
            }

            // 벽 체크
            if (arr[nY][nX] == '#') continue;
            
            // 처음 방문 && 도착값이 불 도착 시간보다 작을 때, 기록
            if (vsitiedJihoon[nY][nX] == 0 && (vsitiedJihoon[jihoonY][jihoonX] + 1) < vsitiedFire[nY][nX])
            {
                vsitiedJihoon[nY][nX] = vsitiedJihoon[jihoonY][jihoonX] + 1; // 누적   
                jihoonQ.emplace(nY, nX);
            }
        }
    }

    if (isPossible == 0) cout << "IMPOSSIBLE";

    return 0;
}