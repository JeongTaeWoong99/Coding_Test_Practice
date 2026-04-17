**📅 작성일**: 2026-04-17

## 🔗 문제 링크

[Vector Erase (벡터 삭제)](https://www.hackerrank.com/challenges/vector-erase/problem?isFullScreen=true)

**난이도**: Easy 10점

---

## 🤔 접근법

벡터에서 두 가지 erase 연산을 수행하는 문제.

1. 1-indexed 위치 `p`의 단일 원소 삭제
2. 1-indexed 범위 `[a, b)` 의 원소들 삭제 (b는 exclusive)

`vector::erase(pos)` 와 `vector::erase(first, last)` 를 활용하며, **1-indexed 입력을 0-indexed 이터레이터로 변환**하는 것이 핵심이다.

---

## 💡 정답 풀이 방법

**알고리즘** : `vector::erase` 직접 활용

**핵심 아이디어**:
```
1. n개 원소를 벡터에 입력
2. 위치 p (1-indexed) → v.erase(v.begin() + p - 1) 으로 단일 삭제
3. 범위 [a, b) (1-indexed) → v.erase(v.begin() + a - 1, v.begin() + b - 1) 으로 범위 삭제
4. 결과 벡터의 크기와 원소 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ 단일 원소 삭제 — 1-indexed 변환

```cpp
v.erase(v.begin() + p - 1); // 1-indexed p → 0-indexed (p - 1)
```

**✅ 핵심**: `erase(pos)` 는 이터레이터를 인수로 받으므로 `v.begin() + (p - 1)` 로 변환.

### 2️⃣ 범위 삭제 — [first, last) exclusive 주의

```cpp
v.erase(v.begin() + a - 1, v.begin() + b - 1); // [a, b) — b는 exclusive (1-indexed)
```

**✅ 핵심**: `erase(first, last)` 는 `[first, last)` 범위이므로 `last` 는 포함되지 않는다.
1-indexed `a` 와 `b` 가 `[a, b)` 범위로 주어지므로 각각 `-1` 하여 0-indexed로 변환.

**⚠️ 흔한 실수**: `b` 를 inclusive로 착각하여 `v.begin() + b` 로 쓰면 한 칸 더 삭제됨.

---

## ⏱️ 시간복잡도

**O(N)**

**상세 분석**:
```
1. 입력   : N개 원소 → O(N)
2. 단일 삭제 : 삭제 후 뒤 원소 이동 → O(N)
3. 범위 삭제 : 삭제 후 뒤 원소 이동 → O(N)
총합: O(N)
```

---

## 💾 공간복잡도

**O(N)**

**분석**:
- `v` : N개 원소 벡터 → O(N)
- `n, p, a, b` : O(1) (전역 변수)
- 총 공간: O(N)
