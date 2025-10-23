#include <bits/stdc++.h>
using namespace std;

int n;

int main() 
{
    ios_base::sync_with_stdio(false);cin.tie(NULL);cout.tie(NULL);

    while (cin >> n)
    {
        int cnt = 1;
        int ret = 1;

        while (true)
        {
            if (cnt % n == 0)
            {
                cout << ret << endl;
                break;
            }
            else
            {
                cnt = ((cnt * 10) + 1) % n;
                ret++;
            }
        }
    }
    return 0;
}