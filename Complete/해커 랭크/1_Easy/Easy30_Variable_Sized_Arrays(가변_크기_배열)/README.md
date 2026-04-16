**📅 작성일**: 2025-10-03

## 🔗 문제 링크

[Variable Sized Arrays (가변 크기 배열)](https://www.hackerrank.com/challenges/variable-sized-arrays/problem?isFullScreen=true)

**난이도**: Easy 30점

---

## 🤔 접근법

n개의 가변 크기 배열을 생성하고, q개의 쿼리로 `arrays[i][j]` 위치의 값을 출력하는 문제.

각 배열의 크기가 서로 달라 고정 2D 배열 사용 불가. **`vector<vector<int>>`** 로 각 배열의 크기를 독립적으로 관리하는 것이 핵심이다.

---

## 💡 정답 풀이 방법

**알고리즘** : `vector<vector<int>>` 가변 2D 배열

**핵심 아이디어**:
```
1. vector<vector<int>> arrays(n) 으로 n개의 빈 배열 생성
2. 각 배열마다 크기 k 입력 → resize(k) 로 크기 설정 후 원소 입력
3. 쿼리 i, j 입력 → arrays[i][j] 로 O(1) 접근 후 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ `vector<vector<int>>` 로 가변 크기 2D 배열 구성

```cpp
vector<vector<int>> arrays(n); // n개의 빈 벡터

for (int i = 0; i < n; i++)
{
    int k;
    cin >> k;           // 배열 크기
    arrays[i].resize(k);

    for (int j = 0; j < k; j++)
    {
        cin >> arrays[i][j];
    }
}
```

**✅ 핵심**: 각 배열의 크기 k가 다를 수 있으므로 `resize(k)` 후 원소 입력. `push_back` 대신 `resize` + 인덱스 접근으로 구현.

### 2️⃣ O(1) 쿼리 처리

```cpp
for (int i = 0; i < q; i++)
{
    int arrayIndex, elementIndex;
    cin >> arrayIndex >> elementIndex;
    cout << arrays[arrayIndex][elementIndex] << "\n";
}
```

**✅ 핵심**: `vector<vector<int>>` 는 인덱스 접근이 O(1). 쿼리마다 즉시 접근 가능.

### 3️⃣ 왜 고정 2D 배열이 아닌가?

```cpp
// ❌ 고정 크기 배열 — 각 행의 크기가 다를 수 없음
int arr[100001][100001]; // 메모리 낭비 + 크기 가변 불가

// ✅ vector<vector<int>> — 각 행 크기 독립적으로 관리
vector<vector<int>> arrays(n);
arrays[0].resize(3);  // 크기 3
arrays[1].resize(7);  // 크기 7
```

**✅ 핵심**: 각 배열의 크기 k가 입력으로 주어지므로 런타임에 크기를 결정해야 함. `vector<vector<int>>` 필수.

---

## ⏱️ 시간복잡도

**O(N × K + Q)**

**상세 분석**:
```
1. 입력: N개 배열, 각 배열 평균 K개 원소 → O(N × K)
2. 쿼리: Q번 → 각 O(1) → O(Q)
총합: O(N × K + Q)
```

**시간 제한 체크**:
- N, K, Q ≤ 10^5 기준 → 최악 약 2 × 10^5 연산 → 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N × K)**

**분석**:
- `arrays` : N개 벡터, 총 원소 수 = N × K → O(N × K)
- `arrayIndex`, `elementIndex` : O(1)
- 총 공간: O(N × K)
