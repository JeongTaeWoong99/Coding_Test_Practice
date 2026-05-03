**📅 작성일**: 2026-05-03

## 🔗 문제 링크

[Preprocessor Solution (전처리기 솔루션)](https://www.hackerrank.com/challenges/preprocessor-solution/problem?isFullScreen=true)

**난이도**: Easy 25점

---

## 🤔 접근법

`#define` 전처리기 매크로로 상수(`INF`, `NEG_INF`)와 함수형 매크로(`MAX`, `MIN`)를 정의하는 문제.

입력받으면서 `MIN`, `MAX` 매크로로 최솟값/최댓값을 갱신하고, 그 차이를 출력한다.

---

## 💡 정답 풀이 방법

**알고리즘** : 전처리기 매크로 + 선형 탐색

**핵심 아이디어**:
```
1. INF(10000000)으로 mn 초기화, NEG_INF(-10000000)으로 mx 초기화
2. n개 정수를 입력받으면서 MIN/MAX 매크로로 갱신
3. mx - mn 출력

예: [32, 332, -23, -154, 65]
    mn = -154, mx = 332 → 332 - (-154) = 486
```

---

## 🔑 핵심 포인트

### 1️⃣ 함수형 매크로 괄호 규칙

```cpp
// ❌ 괄호 없음 — 연산자 우선순위 오류 발생 가능
#define MAX(a,b) a > b ? a : b

// ✅ 인자마다, 전체도 괄호로 감쌈
#define MAX(a,b) ((a) > (b) ? (a) : (b))
```

**✅ 핵심**: 매크로는 텍스트 치환이므로 연산자 우선순위 문제가 생길 수 있다.
인자마다 `(a)`, `(b)` 로 감싸고 전체도 `(...)` 로 감싸야 안전하다.

### 2️⃣ INF / NEG_INF 초기값 설정

```cpp
#define INF      10000000   // mn 초기값 — 어떤 입력값보다 크게
#define NEG_INF  -10000000  // mx 초기값 — 어떤 입력값보다 작게
```

**✅ 핵심**: 비교 기준이 되는 초기값은 입력 범위보다 충분히 크거나 작아야 한다.
문제 Constraints 범위를 확인하고 INF 값을 설정한다.

### 3️⃣ HackerRank 제출 시 locked stub 대응

HackerRank의 locked stub 코드는 `foreach`, `*v_itr` 방식을 사용한다.
제출 시에는 아래 5개 매크로가 필요하다.

```cpp
#define INF          10000000
#define NEG_INF      -10000000
#define MAX(a, b)    ((a) > (b) ? (a) : (b))
#define MIN(a, b)    ((a) < (b) ? (a) : (b))
#define foreach(v,c) for (auto v = c.begin(); v != c.end(); v++)
```

---

## ⏱️ 시간복잡도

**O(N)**

**상세 분석**:
```
1. 입력 + min/max 갱신 : N번 반복 → O(N)
총합: O(N)
```

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `n`, `x`, `mn`, `mx` : 상수 개수의 변수 → O(1)
- 총 공간: O(1)
