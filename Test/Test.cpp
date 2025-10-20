#include <bits/stdc++.h>
using namespace std;

int N, M, ret;     // N = 재료 수, M = 합 수 
int arr[15004];    // 재료 저장

int main(int argc, char* argv[])
{
    cin >> N >> M;

    sort(arr, arr + N);  // 정렬: [1, 2, 3, 4, 5, 7]

    int left = 0, right = N - 1;

    while (left < right)
    {
        int sum = arr[left] + arr[right];

        if (sum == M)
        {
            ret++;
            left++;
            right--;
        }
        else if (sum < M)
            left++;   // 합을 키워야 함
        else
            right--;  // 합을 줄여야 함
    }

    cout << ret;

    return 0;
}