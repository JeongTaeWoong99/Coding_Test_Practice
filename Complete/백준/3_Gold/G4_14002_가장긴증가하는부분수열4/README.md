**📅 작성일**: 2025-12-08

## 🔗 문제 링크
[백준 14002번 - 가장 긴 증가하는 부분 수열 4](https://www.acmicpc.net/problem/14002)

---

## 🤔 접근법

LIS(Longest Increasing Subsequence) 문제의 응용으로, 

단순히 길이만 구하는 것이 아니라 **실제 수열까지 출력**해야 하는 문제.

이진 탐색(lower_bound)을 활용한 O(N log N) 방식으로 LIS 길이를 구하고, **역추적(Backtracking)** 을 통해 수열을 복원.

---

## 💡 핵심 아이디어

### 🔑 LIS + 역추적 전략

**알고리즘**: 이진 탐색 + 역추적

**핵심 아이디어**:
```
1. lower_bound로 각 숫자가 들어갈 위치(pos) 찾기
2. ans 배열에 {위치, 실제 값} 저장 (역추적용)
3. LIS 길이 구하기
4. 뒤에서부터 ans 배열을 역추적하며 스택에 저장
5. 스택에서 꺼내며 출력 (오름차순)
```

**시간 복잡도**: O(N log N)
- lower_bound: O(log N) × N번 = O(N log N)
- 역추적: O(N)

**공간 복잡도**: O(N)
- lis 배열: O(N)
- ans 배열: O(N)
- 스택: O(LIS 길이)

---

## 🔑 주요 구현 포인트

### 1️⃣ 자료구조 설계
```cpp
int            lis[1004];       // LIS를 구성하는 배열 (임시)
pair<int, int> ans[1004];       // {LIS에서의 위치, 실제 값}
stack<int>     stk;             // 역추적 결과 저장
```

**✅ 핵심**: ans 배열로 각 원소의 위치 정보를 저장하여 역추적 가능하게 함

### 2️⃣ LIS 구성 + 위치 저장
```cpp
for (int i = 0; i < n; i++)
{
    cin >> num;

    // 이진 탐색으로 위치 찾기
    int pos = lower_bound(lis, lis + len, num) - lis;

    // 새 위치면 길이 증가
    if (lis[pos] == 2000) len++;

    // 값 갱신
    lis[pos] = num;

    // 역추적용 정보 저장 ⭐
    ans[i].first  = pos;   // LIS에서의 인덱스
    ans[i].second = num;   // 실제 값
}
```

**✅ 핵심**: `ans[i] = {pos, num}`으로 i번째 입력이 LIS의 어느 위치에 들어가는지 기록

### 3️⃣ 역추적 (Backtracking)
```cpp
// 뒤에서부터 LIS 복원
for(int i = n - 1; i >= 0; i--)
{
    // len - 1 = 마지막 인덱스
    if(ans[i].first == len - 1)
    {
        stk.push(ans[i].second);  // 스택에 저장
        len--;                     // 이전 위치로 이동
    }
}
```

**✅ 핵심**:
- LIS 길이가 4라면 인덱스는 0, 1, 2, 3
- 뒤에서부터 len-1(=3), len-2(=2), ... 순으로 찾아가며 복원
- 스택 사용으로 자동 정방향 정렬

### 4️⃣ 스택 출력
```cpp
while(!stk.empty())
{
    cout << stk.top() << " ";
    stk.pop();
}
```

**✅ 핵심**: 역순으로 저장했으므로 스택에서 꺼내면 오름차순

---

## ⏱️ 시간복잡도

**O(N log N)**
- lower_bound 탐색: O(log N)
- N번 반복: O(N log N)
- 역추적: O(N)

---

## 💾 공간복잡도

**O(N)**
- lis 배열: O(1004)
- ans 배열: O(1004)
- 스택: O(LIS 길이)
