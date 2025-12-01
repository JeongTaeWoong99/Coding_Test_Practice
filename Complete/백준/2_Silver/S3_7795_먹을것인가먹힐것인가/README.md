**📅 작성일**: 2025-12-01

## 🔗 문제 링크

[백준 7795번 - 먹을 것인가 먹힐 것인가](https://www.acmicpc.net/problem/7795)

**난이도**: Silver 3

---

## 🤔 접근법

두 생명체 A와 B가 있을 때, A가 B보다 큰 쌍의 개수를 구하는 문제.

단순 이중 반복문으로는 O(N × M)으로 시간 초과 발생 (N, M ≤ 20,000).

(통과는 했지만, N M 범위가 작아서 가능했음. 완벽한 정답은 아님...)

**핵심**: 정렬 후 이분 탐색(Binary Search)으로 O(N log M) 최적화.

lower_bound로 쉽게 풀 수 있음.

---

## 💡 정답 풀이 방법

### 🎯 방법: 이분 탐색 (Binary Search)

1. **정렬**: A와 B 배열을 모두 오름차순으로 정렬

2. **이분 탐색**: A의 각 원소에 대해 B에서 `lower_bound` 사용

3. **개수 계산**: `lower_bound` 반환값 - 시작 위치 = 작은 원소의 개수

**시간복잡도**: O((N + M) log M) = O(N log M) (정렬) + O(N log M) (탐색)

---

## 🔑 핵심 개념: lower_bound / upper_bound

### 📚 lower_bound란?

**정의**: 정렬된 배열에서 **찾으려는 값 이상인 첫 번째 위치**를 반환하는 이분 탐색 함수

**문법**:
```cpp
auto pos = lower_bound(begin, end, value);
```

**반환값**:
- `value` 이상인 첫 번째 원소의 **반복자(iterator)**
- 모든 원소가 `value`보다 작으면 `end` 반환

<br>

### 📚 upper_bound란?

**정의**: 정렬된 배열에서 **찾으려는 값보다 큰 첫 번째 위치**를 반환하는 이분 탐색 함수

**문법**:
```cpp
auto pos = upper_bound(begin, end, value);
```

**반환값**:
- `value`보다 큰 첫 번째 원소의 **반복자(iterator)**
- 모든 원소가 `value` 이하면 `end` 반환

<br>

### 🔍 lower_bound vs upper_bound 비교

```
정렬된 배열: [1, 3, 3, 3, 6, 7]
인덱스:      0  1  2  3  4  5
```

| 찾는 값 | lower_bound | upper_bound | 차이점 |
|---------|-------------|-------------|--------|
| **3** | 인덱스 1 (첫 번째 3) | 인덱스 4 (첫 번째 6) | 3 **이상** vs 3 **초과** |
| **5** | 인덱스 4 (6) | 인덱스 4 (6) | 5가 없으면 동일 |
| **0** | 인덱스 0 (1) | 인덱스 0 (1) | 모두 크므로 시작점 |
| **10** | 인덱스 6 (end) | 인덱스 6 (end) | 모두 작으므로 끝점 |

<br>

### 💡 핵심 차이점

```cpp
// lower_bound: value 이상 (>=)
lower_bound(arr, arr + n, 3);  // 3 이상인 첫 위치

// upper_bound: value 초과 (>)
upper_bound(arr, arr + n, 3);  // 3보다 큰 첫 위치
```

---

## 🔬 lower_bound 내부 구현 원리

### 📌 이분 탐색(Binary Search) 알고리즘

**lower_bound는 내부적으로 이분 탐색을 사용합니다.**

**핵심 아이디어**:
1. 탐색 범위를 반으로 나눔
2. 중간 값과 찾는 값을 비교
3. 범위를 절반씩 줄여가며 탐색

<br>

### 💻 내부 구현 코드 (의사 코드)

```cpp
// lower_bound의 간단한 구현 예시
int lower_bound_impl(int arr[], int n, int value)
{
    int left = 0;      // 탐색 시작 위치
    int right = n;     // 탐색 끝 위치 (n, not n-1!)

    while (left < right)
    {
        int mid = left + (right - left) / 2;  // 중간 인덱스

        if (arr[mid] < value)
            left = mid + 1;   // value 이상을 찾으므로 오른쪽 탐색
        else
            right = mid;      // arr[mid] >= value이면 왼쪽 탐색
    }

    return left;  // value 이상인 첫 번째 위치
}
```

**동작 과정 시각화**:
```
배열: [1, 3, 3, 3, 6, 7]
value = 3 찾기

1단계: left=0, right=6, mid=3
       arr[3]=3 >= 3 → right=3

2단계: left=0, right=3, mid=1
       arr[1]=3 >= 3 → right=1

3단계: left=0, right=1, mid=0
       arr[0]=1 < 3 → left=1

4단계: left=1, right=1 → 종료
       결과: 인덱스 1 (첫 번째 3)
```

<br>

### ⏱️ 시간복잡도: O(log N)

**왜 log N인가?**
- 매 반복마다 탐색 범위가 **절반**으로 줄어듦
- N개 원소 → log₂N번 반복

**예시**:
```
N = 20,000일 때
log₂(20,000) ≈ 14.29 → 약 15번 비교

이중 반복문: 20,000 × 20,000 = 400,000,000 (4억)
이분 탐색: 20,000 × 15 = 300,000 (30만)

→ 약 1,300배 빠름! 🚀
```

---

## 🎯 이 문제에서의 활용

### 📊 예제 분석

**입력**:
```
2
5 3
8 1 7 3 1
3 6 1
3 4
2 13 7
103 11 290 215
```

<br>

### 📌 첫 번째 테스트 케이스

**정렬 전**:
```
A: [8, 1, 7, 3, 1]
B: [3, 6, 1]
```

**정렬 후**:
```
A: [1, 1, 3, 7, 8]
B: [1, 3, 6]
인덱스: 0  1  2
```

**lower_bound 동작 과정**:

**1️⃣ a[0] = 1 처리**:
```cpp
pos = lower_bound(b.begin(), b.end(), 1);
// 1 이상인 첫 위치 → 인덱스 0 (b[0]=1)
ret += (pos - b.begin()) = 0 - 0 = 0
```

**2️⃣ a[1] = 1 처리**:
```cpp
pos = lower_bound(b.begin(), b.end(), 1);
// 1 이상인 첫 위치 → 인덱스 0
ret += 0
```

**3️⃣ a[2] = 3 처리**:
```cpp
pos = lower_bound(b.begin(), b.end(), 3);
// 3 이상인 첫 위치 → 인덱스 1 (b[1]=3)
ret += (1 - 0) = 1
// 1보다 작은 B의 개수: b[0]=1 (1개)
```

**4️⃣ a[3] = 7 처리**:
```cpp
pos = lower_bound(b.begin(), b.end(), 7);
// 7 이상인 첫 위치 → 인덱스 3 (end, 모든 원소가 7보다 작음)
ret += (3 - 0) = 3
// 7보다 작은 B의 개수: b[0]=1, b[1]=3, b[2]=6 (3개)
```

**5️⃣ a[4] = 8 처리**:
```cpp
pos = lower_bound(b.begin(), b.end(), 8);
// 8 이상인 첫 위치 → 인덱스 3 (end)
ret += 3
// 8보다 작은 B의 개수: 3개
```

**총합**: 0 + 0 + 1 + 3 + 3 = **7** ✅

<br>

### 📌 두 번째 테스트 케이스

**정렬 후**:
```
A: [2, 7, 13]
B: [11, 103, 215, 290]
```

**lower_bound 동작**:
```
a[0]=2: lower_bound(B, 2) → 인덱스 0 → ret += 0
a[1]=7: lower_bound(B, 7) → 인덱스 0 → ret += 0
a[2]=13: lower_bound(B, 13) → 인덱스 1 → ret += 1 (11만 작음)
```

**총합**: 0 + 0 + 1 = **1** ✅

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ 정렬 필수!

```cpp
❌ 정렬 없이 lower_bound 사용 → 틀림!
✅ sort() 후 lower_bound 사용
```

**이유**:
- `lower_bound`는 **정렬된 배열에서만** 올바르게 동작
- 정렬되지 않으면 이분 탐색이 무의미함

<br>

### 2️⃣ 반복자(Iterator) 연산 ⚠️ 중요!

```cpp
✅ int count = (int)(pos - b.begin());  // 올바른 계산
❌ int count = *pos;                    // 잘못된 접근 (값이 아닌 개수를 원함)
❌ int count = (int)pos;                // 컴파일 에러! (반복자는 주소임)
```

**이유**:
- `pos - b.begin()`는 **인덱스(개수)** 반환
- `*pos`는 해당 **위치의 값** 반환
- `pos` 자체는 **메모리 주소**

<br>

### 🔍 반복자는 메모리 주소다!

**핵심 개념**: `pos`와 `b.begin()`은 **메모리 주소를 가리키는 반복자**입니다.

```cpp
vector<int> b = {1, 3, 6};

// 실제 메모리 구조 (예시)
// 주소:     0x7ffe5c20  0x7ffe5c24  0x7ffe5c28
// 값:       1           3           6
// 인덱스:   0           1           2

b.begin() → 0x7ffe5c20  (첫 번째 원소의 주소)
b.end()   → 0x7ffe5c2c  (마지막 다음 위치의 주소)
```

**lower_bound가 반환하는 것**:
```cpp
auto pos = lower_bound(b.begin(), b.end(), 7);
// pos는 "3"이 아니라 "0x7ffe5c2c"를 가리키는 반복자!
```

<br>

### 💡 왜 `b.begin()`을 빼야 하는가?

**❌ 잘못된 생각**:
```
b.begin()은 0이니까 빼도 그만 안 빼도 그만?
```

**✅ 실제**:
```cpp
b.begin()은 메모리 주소 (예: 0x7ffe5c20)
절대 0이 아님!
```

**반복자 뺄셈의 의미**:
```cpp
pos - b.begin() = (메모리 주소 차이) / sizeof(int)
                = (0x7ffe5c2c - 0x7ffe5c20) / 4
                = 12 / 4
                = 3  // 인덱스 (원소 개수)
```

<br>

### 📊 구체적인 예시

**예시 1: 정상적인 경우**
```cpp
vector<int> b = {1, 3, 6, 9, 12};
//  인덱스:     0  1  2  3   4

auto pos = lower_bound(b.begin(), b.end(), 7);
// pos는 b[3] (값 9)를 가리키는 반복자

cout << (long long)&(*b.begin()) << "\n";  // 0x7ffe5c20 (주소)
cout << (long long)&(*pos) << "\n";        // 0x7ffe5c2c (주소)
cout << (pos - b.begin()) << "\n";         // 3 (인덱스) ✅

int count = pos - b.begin();  // 3 = 7보다 작은 원소 개수
```

**예시 2: 배열에서도 동일**
```cpp
int b[5] = {1, 3, 6, 9, 12};

int* pos = lower_bound(b, b + 5, 7);
// pos는 &b[3]을 가리키는 포인터

int count = pos - b;  // 3 (포인터 뺄셈)
```

**⚠️ a.begin()도 마찬가지!**
```cpp
// 벡터 a에 대해서도 똑같은 원리
vector<int> a(n);
auto it = a.begin();  // 메모리 주소 (절대 0이 아님!)

// 만약 인덱스가 필요하면
int index = it - a.begin();  // 반복자 뺄셈으로 인덱스 계산
```

<br>

### ✅ 정리

| 표현식 | 타입 | 값 | 설명 |
|--------|------|-----|------|
| `pos` | Iterator | 0x7ffe5c2c | **메모리 주소** |
| `b.begin()` | Iterator | 0x7ffe5c20 | **메모리 주소** |
| `pos - b.begin()` | int | 3 | **인덱스 (원소 개수)** ✅ |
| `*pos` | int | 9 | 해당 위치의 **값** |
| `(int)pos` | ❌ | 컴파일 에러 | 반복자를 int로 변환 불가 |

**핵심**:
- **반복자는 주소**이므로 `b.begin()`을 빼서 **인덱스로 변환** 필요!
- `a.begin()`, `b.begin()` 모두 메모리 주소이며 절대 0이 아님!

<br>

### 3️⃣ vector vs 배열

```cpp
// vector 사용
vector<int> b(m);
auto pos = lower_bound(b.begin(), b.end(), value);
int count = pos - b.begin();

// 배열 사용
int b[20004];
auto pos = lower_bound(b, b + m, value);
int count = pos - b;
```

**주의**: 시작/끝 표현이 다름!

<br>

### 4️⃣ 초기화 위치

```cpp
✅ while (t--)
   {
       vector<int> a(n), b(m);  // 루프 내부 초기화
       int ret = 0;
   }

❌ vector<int> a(n), b(m);  // 루프 외부 (크기 변경 불가)
   while (t--)
   {
       int ret = 0;
   }
```

**이유**:
- 테스트 케이스마다 N, M이 다름
- 매번 새로운 벡터 생성 필요

---

## ⏱️ 시간복잡도 분석

### 📌 전체 시간복잡도: **O(N log M + M log M)**

**상세 분석**:
```
1. A 배열 정렬: O(N log N)
   - N개 원소를 퀵소트/머지소트로 정렬

2. B 배열 정렬: O(M log M)
   - M개 원소 정렬

3. 이분 탐색: O(N log M)
   - N번 반복
   - 각 반복마다 lower_bound: O(log M)

총합: O(N log N + M log M + N log M)
     ≈ O((N + M) log M)  (N ≈ M일 때)
```

**최악의 경우 (N = M = 20,000)**:
```
정렬: 20,000 × log(20,000) ≈ 20,000 × 14.29 ≈ 286,000
탐색: 20,000 × 14.29 ≈ 286,000

총합: 약 572,000 (57만) << 1억 → ✅ 통과!
```

<br>

### 🚀 성능 비교

| 알고리즘 | 시간복잡도 | N=M=20,000 연산 횟수 | 결과 |
|---------|-----------|---------------------|------|
| 이중 반복문 | O(N × M) | 400,000,000 (4억) | ❌ 시간 초과 |
| 정렬 + 이분 탐색 | O(N log M) | 572,000 (57만) | ✅ 통과 |

**→ 약 700배 빠름!** 🚀

---

## 💾 공간복잡도

**O(N + M)**
- `vector<int> a(n)`: N개 원소
- `vector<int> b(m)`: M개 원소
- 추가 공간: 거의 없음 (정렬은 in-place)

**최대 메모리**:
- N = M = 20,000
- 20,000 × 4 bytes × 2 = 160 KB
- 160 KB << 256 MB → ✅ 충분!

---

## 🎯 알고리즘 분류

- **정렬(Sorting)**: 이분 탐색의 전제 조건
- **이분 탐색(Binary Search)**: `lower_bound` 활용
- **두 포인터(Two Pointers)**: 다른 풀이 방법으로도 가능