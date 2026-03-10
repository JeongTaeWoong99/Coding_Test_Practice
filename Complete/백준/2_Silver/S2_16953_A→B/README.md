**📅 작성일**: 2026-03-10

## 🔗 문제 링크

[백준 16953번 - A → B](https://www.acmicpc.net/problem/16953)

**난이도**: Silver 2

---

## 🤔 접근법

정수 A를 B로 바꿀 때 사용할 수 있는 연산이 두 가지이다.

- 연산 1 : 2를 곱한다.
- 연산 2 : 수의 가장 오른쪽에 1을 추가한다. (×10 + 1)

**A를 B로 바꾸는 최소 연산 횟수**를 구하는 문제.

**핵심은 BFS**로 A에서 시작해 가능한 두 연산을 적용하며, 최소 횟수로 B에 도달하는 경로를 탐색하는 것!

---

## 💡 정답 풀이 방법

**알고리즘** : BFS (Breadth-First Search) - 너비 우선 탐색

**핵심 아이디어**:
```
1. A에서 BFS 시작, visited에 A 삽입
2. 큐에서 현재 값을 꺼내 두 연산 적용 (×2, ×10+1)
3. 연산 결과가 B 이하이고 미방문이면 visited에 삽입 후 큐에 추가
4. 현재 값이 B와 같으면 연산 횟수 + 1 출력
5. 큐가 빌 때까지 B에 도달 못하면 -1 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ BFS 패턴

```cpp
queue<pair<long long, int>> bfsQ;
bfsQ.emplace(a, 0);
visited.insert(a);

while(!bfsQ.empty())
{
    auto [cur, cnt] = bfsQ.front();
    bfsQ.pop();

    if(cur == b)
    {
        cout << cnt + 1 << "\n";
        return 0;
    }

    long long nextOne = cur * 2;
    long long nextTwo = cur * 10 + 1;

    if(nextOne <= b && !visited.count(nextOne)) { ... }
    if(nextTwo <= b && !visited.count(nextTwo)) { ... }
}
```

**✅ 핵심**: BFS는 큐를 사용하여 레벨별(연산 횟수 단위)로 탐색
- 먼저 도달한 경로가 항상 최소 연산 횟수 보장
- 두 연산 모두 값을 증가시키므로 사이클 없음

### 2️⃣ unordered_set을 쓴 이유

```cpp
unordered_set<long long> visited;

if(!visited.count(nextOne))  // 미방문 확인
{
    visited.insert(nextOne);
    bfsQ.emplace(nextOne, cnt + 1);
}
```

**✅ 핵심**: `unordered_set`을 방문 체크에 사용한 이유
- B의 최대값이 10^9이므로 `bool visited[10억]` 배열은 메모리 초과
- `unordered_set`은 실제로 도달한 값만 저장하여 메모리 효율적
- 내부적으로 해시 테이블 구조라 삽입/검색이 평균 O(1)
- 배열 방식은 인덱스 기반이지만, 큰 값을 다룰 때는 set/map 계열이 적합

### 3️⃣ long long을 쓴 이유

```cpp
long long a, b;
long long nextOne = cur * 2;
long long nextTwo = cur * 10 + 1;
```

**✅ 핵심**: `long long`이 필요한 이유
- B의 최대값은 10^9로 int 범위(약 2.1×10^9) 안에 들어오지만
- BFS 탐색 중 연산 결과(`cur * 10 + 1`)가 B를 초과하기 전 순간적으로 int 범위를 넘을 수 있음
- 예 : cur = 2×10^8일 때 cur×10+1 = 2×10^9+1 → int 오버플로우
- `long long`(최대 약 9.2×10^18)으로 안전하게 처리

### 4️⃣ !visited.count()가 미방문인 이유

```cpp
if(nextOne <= b && !visited.count(nextOne))
```

**✅ 핵심**: `count()` 함수의 반환값 이해
- `unordered_set::count(x)` : x가 set 안에 있으면 **1**, 없으면 **0** 반환
- set은 중복을 허용하지 않으므로 반환값은 항상 0 또는 1
- `!visited.count(nextOne)` = `!0` = `true` → **미방문** (아직 추가 안 됨)
- `!visited.count(nextOne)` = `!1` = `false` → **이미 방문** (이미 추가됨)
- `visited.find(x) == visited.end()`와 동일한 의미지만 `count()`가 더 간결

---

## 🔍 BFS vs 그리디 선택 이유

| 접근법 | 특징 | 이 문제 적합성 |
|--------|------|--------------|
| **BFS** | 두 연산을 모두 탐색, 최솟값 보장 | ✅ 적합 |
| **역방향 그리디** | B → A로 역연산, 코드 간결 | ✅ 가능하지만 흐름이 직관적이지 않음 |

**BFS를 선택한 이유**:
```
1. 정방향(A → B)으로 흐름이 직관적
2. 두 연산 중 어느 것이 최적인지 판단 불필요 (BFS가 자동으로 최솟값 보장)
3. 연산 결과가 항상 증가하므로 탐색 범위 자동 제한 (b 초과 시 pruning)
```

---

## ⏱️ 시간복잡도

**O(B)**

**분석**:
- BFS에서 방문하는 노드 수 : 최대 B개 (visited로 중복 방문 방지)
- 각 노드에서 연산 2회 → O(2) = 상수
- unordered_set 삽입/검색 : 평균 O(1)

**실제 계산**:
```
- B ≤ 10^9
- 실제로는 두 연산이 값을 빠르게 증가시키므로
  도달 가능한 노드 수는 log 스케일로 매우 적음
- 최악 O(B) = O(10^9)이지만 실제 탐색 노드는 수십 ~ 수백 개 수준
```

**✅ 결론**: 시간 제한(2초) 내에 충분히 해결 가능

---

## 💾 공간복잡도

**O(B)**

**분석**:
- `unordered_set<long long> visited` : 최대 B개 값 저장 → O(B)
- `queue<pair<long long, int>> bfsQ` : 최대 B개 → O(B)
- 실제로는 도달 가능한 값의 수가 매우 적어 공간 사용량은 미미

**총 공간**: O(B) ≈ **O(10^9)** (이론상 최악, 실제는 훨씬 적음)
