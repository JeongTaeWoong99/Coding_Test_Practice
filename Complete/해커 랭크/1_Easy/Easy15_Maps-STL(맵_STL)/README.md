**📅 작성일**: 2026-04-28

## 🔗 문제 링크

[Maps-STL (맵 STL)](https://www.hackerrank.com/challenges/cpp-maps/problem?isFullScreen=true)

**난이도**: Easy 15점

---

## 🤔 접근법

Q개의 쿼리를 처리하는 문제. 각 쿼리는 타입 1(추가), 2(삭제), 3(조회) 중 하나이며, map의 기본 연산을 활용해 해결한다.

타입 1은 `map[key] += value`로 점수를 누적하고, 타입 2는 `erase`로 항목을 삭제하며, 타입 3은 `find`로 존재 여부를 확인한 뒤 없으면 0을 출력한다.

---

## 💡 정답 풀이 방법

**알고리즘** : STL `map` 기본 연산 활용

**핵심 아이디어**:
```
1. 쿼리 타입 1 → marks[name] += score  (없는 키면 0으로 자동 생성 후 누적)
2. 쿼리 타입 2 → marks.erase(name)
3. 쿼리 타입 3 → find()로 키 존재 여부 확인 → 없으면 0, 있으면 누적 점수 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ map의 operator[] — 없는 키 자동 생성

```cpp
marks[name] += score;
```

**✅ 핵심**: `map[key]`는 키가 없으면 기본값(0)으로 자동 생성 후 반환한다.
- 처음 점수 추가 시 따로 `insert` 없이 바로 누적 가능
- `marks[name] += score` 한 줄로 "생성 + 누적" 동시 처리

### 2️⃣ find()로 조회 — operator[] 사용 금지

```cpp
auto itr = marks.find(name);

if (itr == marks.end())
{
    cout << 0 << "\n";
}
else
{
    cout << itr->second << "\n";
}
```

**✅ 핵심**: 타입 3 조회에서 `marks[name]`을 직접 쓰면 없는 키가 **0으로 자동 삽입**되는 부작용이 생긴다. `find()`로 존재 여부를 먼저 확인해야 한다.

### 3️⃣ erase의 안전한 삭제

```cpp
marks.erase(name);
```

**✅ 핵심**: `erase(key)`는 키가 없으면 아무 동작도 하지 않으므로 별도 예외 처리 불필요.

---

## ⏱️ 시간복잡도

**O(Q log N)**

**상세 분석**:
```
1. 쿼리 Q번 × 각 연산([] / erase / find) → O(log N)
총합: O(Q log N)
```

**시간 제한 체크**:
- Q ≤ 10^5 기준 → 최악 약 10^5 × 17 ≈ 1.7 × 10^6 연산 → 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N)**

**분석**:
- `marks` : 삽입된 학생 수 N명 → O(N)
- `n` : O(1) (전역 변수)
- 총 공간: O(N)
