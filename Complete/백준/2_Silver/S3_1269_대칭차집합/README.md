**📅 작성일**: 2025-12-02

## 🔗 문제 링크

[백준 1269번 - 대칭 차집합](https://www.acmicpc.net/problem/1269)

**난이도**: Silver 3

---

## 🤔 접근법

두 집합 A와 B가 주어졌을 때, 대칭 차집합의 원소 개수를 구하는 문제.

**대칭 차집합**: (A - B) ∪ (B - A) = A와 B 중 하나에만 속하는 원소들의 집합

**핵심**: 집합 자료구조를 활용한 존재 여부 확인

---

## 💡 정답 풀이 방법

### 🎯 방법 1: map 활용 (강사 코드)

**알고리즘**: 빈도 카운팅 (Frequency Counting)

**핵심 아이디어**:
```
1. map으로 모든 원소의 등장 횟수 카운트
2. A와 B 모두에서 입력받아 같은 map에 저장
3. 등장 횟수가 1인 원소 = 한 집합에만 존재 = 대칭 차집합
```

**코드 구조**:
```cpp
map<int, int> _map;

// A, B 모두 입력받아 카운트
for A: _map[temp]++;
for B: _map[temp]++;

// 한 번만 등장한 원소 카운트
for(auto it : _map)
    if(it.second == 1) cnt++;
```

**장점**:
- ✅ 코드가 매우 짧고 간결 (핵심 로직 3줄)
- ✅ 직관적인 아이디어 (빈도 카운팅)
- ✅ 두 개의 집합을 따로 관리하지 않아도 됨

**단점**:
- ⚠️ Red-Black Tree 기반 → O(log N) 삽입/조회
- ⚠️ 불필요한 정렬 오버헤드

---

### 🎯 방법 2: unordered_set 활용 (최적화 코드)

**알고리즘**: 집합 연산 (Set Operation)

**핵심 아이디어**:
```
1. A와 B를 각각 unordered_set으로 저장
2. A의 원소 중 B에 없는 것 카운트 (A - B)
3. B의 원소 중 A에 없는 것 카운트 (B - A)
4. 두 개수의 합 = 대칭 차집합
```

**코드 구조**:
```cpp
unordered_set<int> aSet, bSet;

// A, B 각각 저장
while(n--) aSet.insert(temp);
while(m--) bSet.insert(temp);

// 대칭 차집합 계산
for(int x : aSet) cnt += !bSet.count(x);  // A - B
for(int x : bSet) cnt += !aSet.count(x);  // B - A
```

**장점**:
- ✅ Hash Table 기반 → O(1) 평균 삽입/조회
- ✅ 집합 개념을 직접 구현 (교육적)
- ✅ 대량 데이터에서 3~4배 빠름

**단점**:
- ⚠️ 코드가 약간 더 김
- ⚠️ 두 개의 set 관리 필요

---

## 📊 두 방법 비교

### ⚡ 성능 비교

| 항목 | map (강사 코드) | unordered_set (내 코드) |
|-----|----------------|----------------------|
| **자료구조** | Red-Black Tree | Hash Table           |
| **삽입/조회** | O(log N) | O(1) 평균              |
| **시간복잡도** | O((N+M) log(N+M)) | O(N + M)             |
| **코드 길이** | ⭐⭐⭐⭐⭐ (매우 짧음) | ⭐⭐⭐ (보통)             |
| **직관성** | ⭐⭐⭐⭐ (빈도 카운팅) | ⭐⭐⭐⭐⭐ (집합 연산)        |
| **실제 속도** | 기준 | 3~4배 빠름              |

### 🔍 시간복잡도 상세 분석

**방법 1 (map)**:
```
입력 A: N × O(log(N+M)) = O(N log N)
입력 B: M × O(log(N+M)) = O(M log M)
순회:   O(N + M)
───────────────────────────────────
총합:   O((N+M) log(N+M))
```

**방법 2 (unordered_set)**:
```
입력 A: N × O(1) = O(N)
입력 B: M × O(1) = O(M)
순회:   O(N) + O(M) = O(N+M)
───────────────────────────────────
총합:   O(N + M)
```

### 📈 실제 성능 차이 (예상)

| N, M | map (ms) | unordered_set (ms) | 속도 비율 |
|------|----------|-------------------|----------|
| 1,000 | ~0.2 | ~0.05 | **4배** |
| 10,000 | ~3 | ~0.8 | **3.8배** |
| 100,000 | ~50 | ~12 | **4.2배** |
| 200,000 | ~120 | ~28 | **4.3배** |

**✅ 결론** : 데이터가 클수록 `unordered_set`이 압도적으로 유리!

이 문제에서는 차이 미미함.

---

## 🔑 핵심 개념

### 1️⃣ count() 메서드 활용

```cpp
// unordered_set은 중복 불가 → count()는 0 또는 1만 반환
bSet.count(x);  // x가 있으면 1, 없으면 0

// !count(x)를 이용한 트릭
cnt += !bSet.count(x);
// x가 없으면: !0 = 1 → cnt += 1 ✅
// x가 있으면: !1 = 0 → cnt += 0
```

**💡 핵심**:
- `unordered_set`은 중복 불가 → `count()`는 **0 또는 1만 반환**
- `!count(x)` 패턴으로 "존재하지 않으면 1 증가" 간결하게 구현

### 2️⃣ 빈도 카운팅 패턴

```cpp
map<int, int> _map;

// 모든 원소 카운트
_map[x]++;  // 처음 나오면 0→1, 이미 있으면 1→2

// 한 번만 나온 원소 = 대칭 차집합
if(_map[x] == 1) cnt++;
```

**💡 핵심**:
- A와 B에서 모두 카운트
- 등장 횟수가 1 = 한 집합에만 존재
- 등장 횟수가 2 = 두 집합에 모두 존재 (교집합)

---

## 📚 STL 컨테이너 비교표

### 🔑 set vs map 핵심 차이

| 구분 | set 계열 | map 계열 |
|-----|---------|---------|
| **저장 방식** | **Key만** 저장 | **Key-Value 쌍** 저장 |
| **선언 예시** | `set<int> s;` | `map<int, string> m;` |
| **값 저장** | `s.insert(1);` | `m[1] = "one";` |
| **조회 방법** | `s.count(1)` | `m[1]` 또는 `m.count(1)` |
| **주요 용도** | 존재 확인, 중복 제거 | Key로 Value 조회, 딕셔너리 |

---

### 📊 전체 컨테이너 비교표

| 컨테이너 | 내부 구조 | 저장 방식 | 삽입/조회 | 정렬 | 중복 | 주요 용도 |
|---------|---------|----------|----------|-----|-----|---------|
| `set` | Red-Black Tree | **Key만** | O(log N) | ✅ 자동 정렬 | ❌ 불가 | 중복 제거, 정렬된 집합 |
| `unordered_set` | Hash Table | **Key만** | O(1) 평균 | ❌ 비정렬 | ❌ 불가 | 빠른 존재 확인 |
| `multiset` | Red-Black Tree | **Key만** | O(log N) | ✅ 자동 정렬 | ✅ 허용 | 정렬 + 중복 허용 |
| `unordered_multiset` | Hash Table | **Key만** | O(1) 평균 | ❌ 비정렬 | ✅ 허용 | 빠른 탐색 + 중복 |
| `map` | Red-Black Tree | **Key-Value** | O(log N) | ✅ 키 정렬 | ❌ 불가 | Key로 Value 조회 |
| `unordered_map` | Hash Table | **Key-Value** | O(1) 평균 | ❌ 비정렬 | ❌ 불가 | 빠른 딕셔너리 |
| `multimap` | Red-Black Tree | **Key-Value** | O(log N) | ✅ 키 정렬 | ✅ 허용 | 정렬 + 중복 키 |
| `unordered_multimap` | Hash Table | **Key-Value** | O(1) 평균 | ❌ 비정렬 | ✅ 허용 | 빠른 탐색 + 중복 키 |

---

### 💡 실전 예제

#### 🔸 set: Key만 저장 (집합)

```cpp
set<int> s;
s.insert(1);
s.insert(2);
s.insert(3);

// 존재 확인
if (s.count(2)) cout << "2 존재\n";

// ❌ 값 저장 불가
// s[2] = "hello";  // 컴파일 에러!
```

#### 🔸 map: Key-Value 쌍 저장 (딕셔너리)

```cpp
map<int, string> m;
m[1] = "one";
m[2] = "two";
m[3] = "three";

// Key로 Value 조회
cout << m[2] << "\n";  // "two"

// 존재 확인
if (m.count(2)) cout << "2 존재\n";
```

---

### 🎯 선택 기준

```
✅ Key만 필요한가? (집합)
   YES → set / unordered_set
   NO  → map / unordered_map

✅ 정렬이 필요한가?
   YES → set / map
   NO  → unordered_set / unordered_map

✅ 중복을 허용하는가?
   YES → multiset / multimap
   NO  → set / map

✅ 빠른 탐색이 최우선인가?
   YES → unordered_* 계열
   NO  → 안정성 우선 → set / map
```

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ find() vs count() 체크 방법

```cpp
❌ 잘못된 체크:
if (!bSet.find(x))  // find()는 iterator 반환 → 항상 유효한 포인터!

✅ 올바른 체크:
if (bSet.find(x) == bSet.end())  // iterator 비교
if (bSet.count(x) == 0)          // count() 사용 (더 직관적)
if (!bSet.count(x))              // count()를 bool처럼 사용
```

---

## ⏱️ 시간복잡도 분석

### 📌 방법 1 (map): O((N+M) log(N+M))

```
1. A 입력: N × O(log N)
2. B 입력: M × O(log M)
3. 순회:   O(N + M)
───────────────────────────────
총합: O((N+M) log(N+M))
```

### 📌 방법 2 (unordered_set): O(N + M)

```
1. A 입력: N × O(1) = O(N)
2. B 입력: M × O(1) = O(M)
3. A 순회: N × O(1) = O(N)
4. B 순회: M × O(1) = O(M)
───────────────────────────────
총합: O(N + M)
```

**시간 제한 체크** (N, M ≤ 200,000):
- map: 400,000 × log(400,000) ≈ 400,000 × 19 ≈ **760만** << 1억 ✅
- unordered_set: 400,000 ≈ **40만** << 1억 ✅✅

**✅ 결론**: 둘 다 통과하지만, `unordered_set`이 약 **19배 빠름**!

---

## 💾 공간복잡도

**방법 1 (map)**: O(N + M)
- `map<int, int>`: 최대 (N+M)개 원소 저장

**방법 2 (unordered_set)**: O(N + M)
- `aSet`: N개
- `bSet`: M개
- 총 N+M개

**✅ 공간복잡도는 동일**

---

## 🎓 교육적 가치

### 🏫 강사 코드의 장점 (학습용)
- ✅ "빈도 카운팅" 패턴 학습
- ✅ map의 자동 초기화 이해 (`_map[x]++`)
- ✅ 수학적 사고 (한 번 나온 원소 = 대칭 차집합)

### 💼 최적화 코드의 장점 (실전용)
- ✅ 집합 개념 직접 구현
- ✅ 최적 성능 (O(N+M))
- ✅ 실전 코딩테스트에 유리

---

## 🎯 문제 해결 전략

### 📋 언제 어떤 방법을 쓸까?

| 상황 | 추천 방법 | 이유 |
|-----|----------|------|
| **N, M ≤ 10,000** | map | 코드 짧음, 속도 차이 미미 |
| **N, M ≤ 200,000** | unordered_set | 3~4배 빠름, 안정적 통과 |
| **코드 짧게** | map | 핵심 로직 3줄 |
| **성능 최우선** | unordered_set | O(N+M) 최적 |
| **학습 단계** | map | 빈도 카운팅 패턴 익히기 |
| **실전 코테** | unordered_set | 시간 여유 확보 |

---

## 💡 핵심 요약

```
✅ map: 짧고 직관적, O((N+M) log N)
✅ unordered_set: 빠르고 효율적, O(N+M)
✅ 둘 다 정답, 상황에 따라 선택
✅ 대량 데이터 → unordered_set 압도적 유리
✅ count()는 0 또는 1만 반환 (중복 불가)
✅ !count(x) 트릭으로 간결한 카운팅
```