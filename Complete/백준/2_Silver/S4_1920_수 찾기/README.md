**📅 작성일**: 2026-01-06

## 🔗 문제 링크

[백준 1920번 - 수 찾기](https://www.acmicpc.net/problem/1920)

**난이도**: Silver 4

---

## 🤔 접근법

이진 탐색, 해쉬로 해결 가능함.

간단하게 unordered_set로 품.

N개의 정수가 주어지고, M개의 정수가 N개 안에 존재하는지 확인하는 문제.

**핵심**: 빠른 검색을 위해 해시 기반 자료구조 사용!

---

## 💡 정답 풀이 방법

**알고리즘**: `unordered_set` 활용 (해시 테이블)

**핵심 아이디어**:
```
1. N개의 정수를 unordered_set에 저장 (중복 자동 제거)
2. M개의 정수마다 unordered_set에서 find() 검색
3. 존재하면 1, 없으면 0 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ unordered_set 사용

```cpp
unordered_set<int> st;

// 삽입: O(1) 평균
cin >> n;
for (int i = 0; i < n; ++i)
{
    cin >> temp;
    st.emplace(temp);  // insert()보다 빠름
}

// 검색: O(1) 평균
if (st.find(temp) != st.end())  // 존재 여부 확인
    cout << "1" << '\n';
else
    cout << "0" << '\n';
```

**✅ 핵심**:
- `emplace()`: 객체를 직접 생성하여 삽입 (move 연산 없음)
- `find()`: 해시 테이블로 평균 O(1) 검색
- 중복 자동 제거: set의 기본 특성

### 2️⃣ 입출력 최적화 필수

```cpp
ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);
```

**✅ 핵심**: M=100,000번의 출력이 있으므로 최적화 필수!
- 최적화 없으면 시간 초과 발생
- '\n' 사용 (endl보다 빠름)

---

## 📊 4가지 자료구조 비교

### ✅ map vs unordered_map vs set vs unordered_set

| 항목 | map | unordered_map | set | unordered_set |
|-----|-----|---------------|-----|---------------|
| **자료구조** | Red-Black Tree | Hash Table | Red-Black Tree | Hash Table |
| **정렬 여부** | ✅ 정렬됨 (오름차순) | ❌ 정렬 안 됨 | ✅ 정렬됨 (오름차순) | ❌ 정렬 안 됨 |
| **삽입 시간** | O(log N) | 평균 O(1), 최악 O(N) | O(log N) | 평균 O(1), 최악 O(N) |
| **검색 시간** | O(log N) | 평균 O(1), 최악 O(N) | O(log N) | 평균 O(1), 최악 O(N) |
| **Key-Value** | ✅ Key-Value 쌍 | ✅ Key-Value 쌍 | ❌ Key만 저장 | ❌ Key만 저장 |
| **중복 허용** | ❌ Key 중복 불가 | ❌ Key 중복 불가 | ❌ 중복 불가 | ❌ 중복 불가 |
| **메모리** | 적음 | 많음 (해시 테이블) | 적음 | 많음 (해시 테이블) |
| **적합한 경우** | 정렬 + Key-Value | 빠른 검색 + Key-Value | 정렬 + 중복 제거 | **빠른 검색 + 중복 제거** ⭐ |

### 🎯 이 문제에서 unordered_set을 선택한 이유

**1️⃣ 정렬이 필요 없음**
- 문제는 "존재 여부"만 확인
- 순서나 정렬은 중요하지 않음
- → Tree 기반 자료구조 불필요

**2️⃣ Key-Value가 필요 없음**
- "값이 있는지"만 확인
- Key-Value 쌍을 저장할 필요 없음
- → map, unordered_map 불필요

**3️⃣ 빠른 검색 속도가 중요**
- M=100,000번의 검색 필요
- O(1) 평균 검색 속도가 필수
- → unordered_set 최적

**4️⃣ 성능 비교 (N=100,000, M=100,000)**

| 자료구조 | N개 삽입 시간               | M개 검색 시간               | 총 시간 |
|---------|------------------------|------------------------|---------|
| `set` | O(N log N) ≈ 1,700,000 | O(M log N) ≈ 1,700,000 | **3,400,000 연산** |
| `unordered_set` | O(N) = 100,000         | O(M) = 100,000         | **200,000 연산** ⭐ |

**차이**: **약 17배 빠름!**

**실제 백준 제출 결과**:
- `set`: 76ms
- `unordered_set`: 56ms ⚡

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ 입출력 최적화 필수

```cpp
❌ // 최적화 없음 → 시간 초과!

✅ ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);
```

**이유**:
- M=100,000번의 출력 발생
- 최적화 없으면 약 2~3초 소요 → 시간 초과!

### 3️⃣ emplace vs insert

```cpp
✅ st.emplace(temp);  // 직접 생성 (권장)

⚪ st.insert(temp);   // 복사 후 삽입 (조금 느림)
```

**이유**:
- `emplace()`는 객체를 직접 생성하여 삽입
- `insert()`는 임시 객체 생성 후 복사/이동
- int는 차이가 미미하지만, 객체일 경우 차이 큼

---

## ⏱️ 시간복잡도 분석

**전체 시간복잡도**: **O(N + M)** (평균)

**상세 분석**:
```
1. N개 정수 삽입 : O(N)
   - unordered_set 삽입: 평균 O(1)

2. M개 정수 검색 : O(M)
   - unordered_set 검색: 평균 O(1)

총합 : O(N + M) = O(200,000) ≈ 20만 연산
```

**최악의 경우**: O(N² + M × N) (해시 충돌)
- 하지만 C++ STL은 충돌 관리를 잘하므로 거의 발생하지 않음

**시간 제한 체크**:
- 1초 제한 → 1억 연산 가능
- 20만 연산 < 1억 → **여유롭게 통과** ✅

---

## 💾 공간복잡도

**O(N)**
- `unordered_set<int> st` : N개의 정수 저장 (중복 제거)
- 해시 테이블 오버헤드: 약 1.5~2배 메모리 사용

---

## 🔍 다른 풀이 방법

### 방법 1: 이분 탐색 (Binary Search)

```cpp
vector<int> v(n);
for (int i = 0; i < n; i++)
    cin >> v[i];

sort(v.begin(), v.end());  // 정렬 필수!

for (int i = 0; i < m; i++)
{
    cin >> temp;
    cout << binary_search(v.begin(), v.end(), temp) << '\n';
}
```

**시간복잡도**: O(N log N + M log N)
- 정렬: O(N log N)
- M번 이분 탐색: O(M log N)
- 총 약 3,400,000 연산 (unordered_set보다 17배 느림)

### 방법 2: set 사용

```cpp
set<int> st;
// ... (코드 동일)
```

**시간복잡도**: O(N log N + M log N)
- unordered_set보다 약 17배 느림
- 하지만 안정적 (최악의 경우에도 O(log N))

---

**⏱️ 시간복잡도** : O(N + M) 평균, O(N² + M × N) 최악

**💾 공간복잡도** : O(N)
