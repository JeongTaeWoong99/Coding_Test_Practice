#include<bits/stdc++.h>
using namespace std;

const int INF = 987654321;
const int dy[] = {-1, 0, 1, 0};
const int dx[] = {0, 1, 0, -1};

int    N;            // 동전판의 크기 (N x N)
int    arr[44];      // 각 행의 상태를 비트마스킹으로 저장 (T=1, H=0)
int    ret = INF;    // 최소 T(뒷면) 개수
string S;            // 입력받을 한 행의 문자열 

// here : 현재 확인 중인 행 번호
// 각 행을 뒤집을지 말지 결정하는 재귀 함수 (2^N 가지 경우 탐색)
void GO(int here)
{
    // 모든 행에 대한 뒤집기 결정 완료
    if(here == N + 1)
    {
        int sum = 0;  // 현재 상태에서 T(뒷면)의 최소 개수

        // 각 열(비트 위치)을 순회하면서 T 개수 확인
        // i는 비트마스크 (1, 2, 4, 8, ... 즉 2^0, 2^1, 2^2, ...)
        for(int i = 1; i <= (1 << (N - 1)); i *= 2)
        {
            int cnt = 0;  // 현재 열에서 T(1)의 개수

            // 각 행을 확인하면서 현재 열의 비트가 1인지 확인
            for(int j = 1; j <= N; j++)
            {
                if(arr[j] & i)  // j번째 행의 i번째 비트가 1(T)인지 확인
                    cnt++;
            }

            // 열을 뒤집을지 말지는 그리디하게 결정
            // T가 많으면 열을 뒤집어서 H로 만드는게 유리
            sum += min(cnt, N - cnt);
        }

        ret = min(ret, sum);  // 최소값 갱신

        return;
    }

    // here번째 행을 뒤집지 않는 경우
    GO(here + 1);

    // here번째 행을 뒤집는 경우 (NOT 연산으로 모든 비트 반전)
    arr[here] = ~arr[here];
    GO(here + 1);
}

int main()
{
    ios_base::sync_with_stdio(false);cin.tie(NULL); cout.tie(NULL);

    // 입력 처리
    cin >> N;
    for(int i = 1; i <= N; i++)
    {
        cin >> S;  // i번째 행의 동전 상태 (예 : "HHT")

        int value = 1;  // 비트 위치 (1, 2, 4, 8, ... 즉 2^0, 2^1, 2^2, ...)
        for (char j : S)
        {
            if(j == 'T')
                arr[i] |= value;  // T면 해당 비트를 1로 설정 (OR 연산)

           value *= 2;  // 다음 비트 위치로 이동 (왼쪽으로 shift)
        }
    }

    // 알고리즘 실행 : 1번 행부터 시작
    GO(1);

    // 결과 출력 : 최소 T(뒷면) 개수
    cout << ret << "\n";

    return 0;
}