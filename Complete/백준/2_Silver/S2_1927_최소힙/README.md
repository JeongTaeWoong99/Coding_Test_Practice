**📅 작성일**: 2026-02-05

## 🔗 문제 링크

[백준 1927번 - 최소 힙](https://www.acmicpc.net/problem/1927)

**난이도**: Silver 2

---

## 🤔 접근법

배열에 자연수 x를 넣거나, 가장 작은 값을 출력하고 제거하는 연산을 지원하는 프로그램을 구현하는 문제.

**핵심**: C++ STL의 `priority_queue`를 **최소 힙**으로 설정하여 사용하면 간단하게 해결!

---

## 💡 정답 풀이 방법

**알고리즘** : 우선순위 큐 (Priority Queue) - 최소 힙

**핵심 아이디어**:
```
1. priority_queue를 최소 힙으로 선언
2. x가 자연수면 힙에 삽입
3. x가 0이면 힙에서 최솟값 출력 후 제거
4. 힙이 비어있을 때 0 입력 시 0 출력
```

---

## 🔑 핵심 개념

### 1️⃣ priority_queue 템플릿 매개변수

```cpp
priority_queue<T, Container, Compare>
```

| 순서 | 매개변수 | 의미 | 기본값 |
|------|----------|------|--------|
| 1번째 | `T` | 저장할 **데이터 타입** | (필수) |
| 2번째 | `Container` | 내부적으로 사용할 **컨테이너** | `vector<T>` |
| 3번째 | `Compare` | **비교 함수** (정렬 기준) | `less<T>` |

### 2️⃣ 최대 힙 vs 최소 힙

```cpp
// 최대 힙 (기본값)
priority_queue<int> maxHeap;
// = priority_queue<int, vector<int>, less<int>>

// 최소 힙
priority_queue<int, vector<int>, greater<int>> minHeap;
```

**비교 함수의 의미**:
- **`less<int>`** : "작은 값이 뒤로" → 큰 값이 top → **최대 힙**
- **`greater<int>`** : "큰 값이 뒤로" → 작은 값이 top → **최소 힙**

### 3️⃣ 왜 2번째 매개변수도 명시해야 할까?

```cpp
// ❌ 이렇게 쓰면 컴파일 에러!
priority_queue<int, greater<int>> pQ;

// ✅ 2번째 매개변수(Container)를 명시해야 3번째를 쓸 수 있음
priority_queue<int, vector<int>, greater<int>> pQ;
```

**이유**: C++ 템플릿은 **순서대로** 인자를 받기 때문에, 3번째 인자만 바꾸려면 2번째도 명시해야 함.

### 4️⃣ 2번째 매개변수에 다른 컨테이너를 넣으면?

`vector<int>`가 기본값인데, 다른 컨테이너도 사용할 수 있을까?

| 컨테이너 | 사용 가능 | 이유 |
|----------|----------|------|
| `vector<T>` | ✅ 가능 (기본값) | Random Access 지원 |
| `deque<T>` | ✅ 가능 | Random Access 지원 |
| `list<T>` | ❌ 컴파일 에러 | Random Access **미지원** |
| `array<T>` | ❌ 컴파일 에러 | `push_back()` 없음 |

**왜 vector와 deque만 가능할까?**

`priority_queue`는 내부적으로 **힙(Heap)** 자료구조를 사용합니다.
힙 연산에는 다음이 필요합니다:

```cpp
// 컨테이너가 반드시 지원해야 하는 것들
1. front()      // 첫 번째 요소 접근
2. push_back()  // 끝에 요소 추가
3. pop_back()   // 끝에서 요소 제거
4. Random Access Iterator  // 인덱스로 직접 접근 (arr[i])
```

**실제 테스트**:
```cpp
// ✅ vector 사용 (기본값)
priority_queue<int, vector<int>, greater<int>> pq1;

// ✅ deque 사용 (동작함!)
priority_queue<int, deque<int>, greater<int>> pq2;

// ❌ list 사용 (컴파일 에러!)
priority_queue<int, list<int>, greater<int>> pq3;
// error: no matching function for call to '__push_heap'
```

**💡 결론**: `deque`도 가능하지만, `vector`가 메모리 연속성으로 캐시 효율이 좋아서 기본값으로 사용됨. 특별한 이유 없으면 `vector` 사용!

### 5️⃣ 빈 힙 처리

```cpp
if (pQ.empty())
{
    cout << 0 << '\n';  // 빈 배열이면 0 출력
}
else
{
    cout << pQ.top() << '\n';
    pQ.pop();
}
```

**✅ 핵심**: `empty()` 체크 필수!
- 빈 힙에서 `top()` 또는 `pop()` 호출 시 **런타임 에러** 발생

---

## 🔍 priority_queue 주요 연산

| 연산 | 시간복잡도 | 설명 |
|------|-----------|------|
| `push(x)` / `emplace(x)` | O(log N) | 원소 삽입 |
| `pop()` | O(log N) | top 원소 제거 |
| `top()` | O(1) | top 원소 반환 (제거 X) |
| `empty()` | O(1) | 비어있는지 확인 |
| `size()` | O(1) | 원소 개수 반환 |

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ 최대 힙을 사용한 경우

```cpp
❌ priority_queue<int> pQ;  // 기본값은 최대 힙!

✅ priority_queue<int, vector<int>, greater<int>> pQ;  // 최소 힙
```

### 2️⃣ 빈 힙 체크 누락

```cpp
❌ cout << pQ.top() << '\n';  // 비어있으면 런타임 에러!
   pQ.pop();

✅ if (pQ.empty()) cout << 0 << '\n';
   else { cout << pQ.top() << '\n'; pQ.pop(); }
```

### 3️⃣ 데이터 타입 범위

```cpp
// x는 2^31보다 작은 자연수 또는 0
// int의 범위: -2^31 ~ 2^31-1 이므로 int로 충분
// 하지만 안전하게 long long 사용도 가능

long long temp;  // 또는 int temp;
```

---

## ⏱️ 시간복잡도

**O(N log N)**

**분석**:
- N: 연산의 개수 (최대 100,000)
- 각 연산:
  - 삽입 (`push`): O(log N)
  - 삭제 (`pop`): O(log N)
  - 조회 (`top`): O(1)
- 최악의 경우: N번의 삽입/삭제 → O(N log N)

**시간 제한 체크**:
- 100,000 × log(100,000) ≈ 100,000 × 17 ≈ **170만 연산**
- **170만** << **1억** (1초 기준) → 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N)**

**분석**:
- `priority_queue`: 최대 N개의 원소 저장 가능
- 기타 변수: O(1)

**총 공간**: O(N) ≈ **O(100,000)** (최악의 경우)

---

## 🎯 알고리즘 분류

- **자료 구조 (Data Structure)**: 힙(Heap) 기반 우선순위 큐
- **우선순위 큐 (Priority Queue)**: 최솟값/최댓값을 빠르게 찾는 자료구조
