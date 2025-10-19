#include <iostream>
#include <vector>
using namespace std;

int main()
{
    int n, q;
    cin >> n >> q;                          // n: 배열 개수, q: 쿼리 개수

    vector<vector<int>> arrays(n);          // n개의 가변 배열

    // n개의 배열 입력 받기
    for(int i = 0; i < n; i++)
    {
        int k;
        cin >> k;                           // 배열 크기
        arrays[i].resize(k);

        for(int j = 0; j < k; j++)
        {
            cin >> arrays[i][j];            // 배열 원소들을 같은 줄에서 입력
        }
    }

    // q개의 쿼리 처리
    for(int i = 0; i < q; i++)
    {
        int arrayIndex, elementIndex;
        cin >> arrayIndex >> elementIndex;
        cout << arrays[arrayIndex][elementIndex] << "\n";
    }

    return 0;
}