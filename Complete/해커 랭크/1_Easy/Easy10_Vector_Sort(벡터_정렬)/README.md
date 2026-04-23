**📅 작성일**: 2026-04-23

## 🔗 문제 링크

[Vector Sort (벡터 정렬)](https://www.hackerrank.com/challenges/vector-sort/problem?isFullScreen=true)

**난이도**: Easy 10점

---

## 🤔 접근법

N개의 정수를 벡터에 저장한 뒤 STL `sort`로 오름차순 정렬 후 출력하는 문제.

전역 벡터를 `resize(n)`으로 크기를 정하고, 인덱스 직접 접근으로 입력받은 뒤 `sort(v.begin(), v.end())` 한 번으로 해결.

---

## 💡 정답 풀이 방법

**알고리즘** : STL `sort` 직접 활용

**핵심 아이디어**:
```
1. n 입력 후 v.resize(n)으로 크기 확정
2. 인덱스 접근으로 n개 원소 입력
3. sort(v.begin(), v.end()) — 오름차순 정렬
4. 범위 기반 for로 공백 구분 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ resize vs 생성자 초기화

```cpp
// ✅ 전역 벡터 — resize로 런타임에 크기 결정
vector<int> v;
v.resize(n); // n 입력 후 크기 확정

// ✅ 지역 벡터 — 생성자에서 바로 크기 지정도 가능
vector<int> v(n);
```

전역 벡터는 선언 시 크기를 모르므로 `resize(n)`으로 확정한다.

### 2️⃣ sort 기본 동작 — 오름차순

```cpp
sort(v.begin(), v.end()); // 기본값 : 오름차순 (less<int>)
```

**✅ 핵심**: `sort`의 세 번째 인자를 생략하면 `operator<` 기준 오름차순 정렬.

---

## ⏱️ 시간복잡도

**O(N log N)**

**상세 분석**:
```
1. 입력   : N개 원소 → O(N)
2. 정렬   : sort (intro sort 기반) → O(N log N)
3. 출력   : N개 원소 → O(N)
총합: O(N log N)
```

---

## 💾 공간복잡도

**O(N)**

**분석**:
- `v` : N개 원소 벡터 → O(N)
- `n` : O(1) (전역 변수)
- 총 공간: O(N)
