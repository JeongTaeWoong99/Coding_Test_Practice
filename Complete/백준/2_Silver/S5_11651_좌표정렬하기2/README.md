**📅 작성일**: 2026-01-03

## 🔗 문제 링크

[백준 11651번 - 좌표 정렬하기 2](https://www.acmicpc.net/problem/11651)

**난이도**: Silver 5

---

## 🤔 접근법

2차원 평면 위의 N개 좌표를 특정 조건에 따라 정렬하는 문제.

정렬 조건:
1. **y좌표가 증가하는 순**으로 정렬
2. **y좌표가 같으면 x좌표가 증가하는 순**으로 정렬

**핵심**: 두 가지 방법으로 해결 가능
1. **커스텀 비교 함수**: 직관적이지만 함수 호출 오버헤드 존재
2. **pair 순서 변경**: pair의 기본 비교를 활용하여 함수 호출 제거

---

## 💡 풀이 방법 비교

### 📊 두 가지 풀이 방법

| 방법 | 알고리즘 | 메모리 | 시간 | 장점 | 단점 |
|------|---------|--------|------|------|------|
| **커스텀 비교 함수** | sort + CMP | 3572KB | 104ms | 직관적, 이해하기 쉬움 | 함수 호출 오버헤드 |
| **pair 순서 변경** | sort (기본) | 3684KB | 44ms | 매우 빠름, 간결 | 저장/출력 시 순서 주의 |

**성능 차이**:
- **시간**: pair 순서 변경이 **2.36배 빠름** (44ms vs 104ms)
- **메모리**: 거의 동일 (약 3.1% 차이)

---

## 🔑 핵심 포인트

### 1️⃣ 방법 1: 커스텀 비교 함수 (Answer(성공_비효율적).cpp.txt)

**핵심 코드**:
```cpp
int n, y, x;
vector<pair<int,int>> v;

bool CMP(pair<int,int> a, pair<int,int> b)
{
    // Y 먼저 비교
    if (a.second == b.second)
        return a.first < b.first;  // Y가 같으면 X 비교

    return a.second < b.second;    // Y 우선
}

int main()
{
    ios_base::sync_with_stdio(false);cin.tie(0);cout.tie(0);

    cin >> n;

    for (int i = 0; i < n; ++i)
    {
        cin >> x >> y;
        v.emplace_back(x, y);  // (x, y) 순서
    }

    sort(v.begin(), v.end(), CMP);  // 커스텀 비교 함수

    for (auto value : v)
        cout << value.first << " " << value.second << '\n';

    return 0;
}
```

**✅ 장점**:
- 직관적이고 이해하기 쉬움
- 정렬 조건이 명확하게 보임

**❌ 단점**:
- CMP 함수 호출마다 오버헤드 발생
- N log N번의 함수 호출 (N=100,000일 때 약 170만 번)

---

### 2️⃣ 방법 2: pair 순서 변경 (Answer(정답_효율적).cpp.txt) ⭐

**핵심 아이디어**:
```
pair<int,int>는 기본적으로 first 우선, first가 같으면 second로 비교한다.
따라서 (y, x) 순서로 저장하면 자동으로 y좌표 우선 정렬이 된다!
```

**핵심 코드**:
```cpp
// 정렬
// Y좌표 오름차순
// Y좌표 == Y좌표하면, X좌표가 증가하는 순으로
#include <bits/stdc++.h>
using namespace std;

int n, x, y;
vector<pair<int,int>> v;

int main()
{
    ios_base::sync_with_stdio(false);cin.tie(0);cout.tie(0);

    cin >> n;

    for (int i = 0; i < n; ++i)
    {
        cin >> x >> y;
        v.emplace_back(y, x);  // y, x 순서로 저장!
    }

    sort(v.begin(), v.end());  // 기본 sort를 사용해도 됨(first(y)를 먼저 비교하고, first가 같다면, second(x)를 비교함)

    for (auto value : v)
        cout << value.second << " " << value.first << '\n';  // 출력 시 순서 주의!

    return 0;
}

```

**✅ 장점**:
- 함수 호출 오버헤드 제거 → **2.36배 빠름**
- 코드가 더 간결함 (CMP 함수 불필요)
- pair의 기본 비교 연산자 활용

**⚠️ 주의사항**:
- 저장: `emplace_back(y, x)` → y를 first에
- 출력: `value.second, value.first` → x를 먼저 출력

**🔍 작동 원리**:
```
입력: (x=3, y=2), (x=1, y=2), (x=5, y=1)

저장: v = [(2,3), (2,1), (1,5)]
                ↑
         pair<y, x> 형태로 저장

기본 sort 후: [(1,5), (2,1), (2,3)]
               ↑      ↑      ↑
          y=1    y=2,x=1  y=2,x=3

출력 (x y 순서):
5 1  → value.second=5, value.first=1
1 2  → value.second=1, value.first=2
3 2  → value.second=3, value.first=2
```

---

## 📊 시간복잡도 분석

**두 방법 모두**: **O(N log N)**

```
1. 입력 처리: O(N)
2. 정렬: O(N log N)
   - 방법 1: sort + CMP 함수 호출 (함수 오버헤드)
   - 방법 2: sort 기본 비교 (인라인 최적화)
3. 출력: O(N)

총합: O(N log N)
```

**실제 연산 횟수** (N=100,000):
```
방법 1 (커스텀 비교):
  정렬 비교 횟수: 약 1,700,000번 (CMP 함수 호출)
  실행 시간: 104ms

방법 2 (기본 비교):
  정렬 비교 횟수: 약 1,700,000번 (인라인 비교)
  실행 시간: 44ms (2.36배 빠름!)
```

**⚡ 속도 차이 원인**:
- 커스텀 함수는 호출마다 스택 프레임 생성/해제
- 기본 비교는 컴파일러가 인라인 최적화
- pair의 기본 비교는 STL에서 고도로 최적화됨

---

## 💾 공간복잡도

**두 방법 모두**: **O(N)**
- `vector<pair<int,int>>`: N개의 pair 저장
- 실제 메모리: 약 3.6MB (거의 동일)

---

## 🎯 알고리즘 분류

- **정렬(Sorting)**: pair의 기본 비교 연산자 활용
- **최적화**: 함수 호출 오버헤드 제거

---

## 🎓 학습 포인트

### 1️⃣ pair의 기본 비교 순서 이해

```cpp
pair<int,int> a = {1, 2};
pair<int,int> b = {1, 3};

a < b  // true (first가 같으면 second 비교)

pair 비교 우선순위:
  1순위: first
  2순위: second (first가 같을 때)
```

### 2️⃣ 커스텀 비교 함수 vs 자료구조 활용

| 방식 | 언제 사용? | 예시 |
|------|-----------|------|
| **커스텀 비교 함수** | 복잡한 정렬 조건 | 3개 이상 키, 특수 조건 |
| **자료구조 활용** | 단순 우선순위 | pair 순서 변경, 음수 곱셈 |

**💡 팁**: 단순한 경우 자료구조를 활용하면 더 빠르다!

### 3️⃣ 최적화 체크리스트

```
✅ 입출력 최적화 (ios_base) - 두 방법 모두 적용
✅ 불필요한 함수 호출 제거 - 방법 2만 적용 (2.36배 개선)
✅ STL 기본 기능 활용 - pair 비교 연산자
```

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ pair 순서 변경 시 출력 주의

```cpp
❌ 잘못된 출력:
   v.emplace_back(y, x);
   cout << value.first << " " << value.second;  // y x로 출력됨!

✅ 올바른 출력:
   v.emplace_back(y, x);
   cout << value.second << " " << value.first;  // x y로 출력
```

### 2️⃣ 커스텀 비교 함수 우선순위

```cpp
❌ 잘못된 우선순위:
   if (a.first == b.first)  // x 먼저 비교
       return a.second < b.second;
   return a.first < b.first;

✅ 올바른 우선순위:
   if (a.second == b.second)  // y 먼저 비교
       return a.first < b.first;
   return a.second < b.second;
```

**문제 요구**: y좌표 우선, y가 같으면 x로 정렬!
