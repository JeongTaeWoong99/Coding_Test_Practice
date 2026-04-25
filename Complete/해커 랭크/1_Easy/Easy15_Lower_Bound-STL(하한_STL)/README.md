**📅 작성일**: 2026-04-25

## 🔗 문제 링크

[Lower Bound-STL (하한 탐색 STL)](https://www.hackerrank.com/challenges/cpp-lower-bound/problem?isFullScreen=true)

**난이도**: Easy 15점

---

## 🤔 접근법

정렬된 N개의 정수 배열에 대해 Q개의 쿼리를 처리하는 문제. 각 쿼리마다 찾는 값이 **배열에 있으면** `Yes + 인덱스`, **없으면** `No + 다음으로 큰 수의 인덱스`를 출력한다.

`lower_bound`로 찾는 값 이상인 첫 번째 원소의 이터레이터를 구한 뒤, 그 위치의 값이 쿼리 값과 **일치하면** 존재, **불일치하면** 부재로 판단한다.

---

## 💡 정답 풀이 방법

**알고리즘** : STL `lower_bound` 활용

**핵심 아이디어**:
```
1. v.resize(n) 후 n개 원소 입력
2. 쿼리마다 lower_bound(v.begin(), v.end(), findNum) 호출
3. *it == findNum → "Yes " + 1-based 인덱스
4. *it != findNum → "No " + 1-based 인덱스 (다음으로 큰 수의 위치)
```

---

## 🔑 핵심 포인트

### 1️⃣ lower_bound 반환값과 존재 여부 판단

```cpp
auto it = lower_bound(v.begin(), v.end(), findNum);

if (*it == findNum) // 배열에 findNum이 존재하면
{
    cout << "Yes " << idx << "\n";
}
else // 존재하지 않으면, 다음으로 큰 수의 인덱스 출력
{
    cout << "No " << idx << "\n";
}
```

**✅ 핵심**: `lower_bound`는 `findNum` **이상인** 첫 번째 원소를 가리킨다.
- `*it == findNum` → 그 값이 정확히 일치 → 배열에 존재
- `*it != findNum` → 그 값이 더 큼 → 배열에 없고, 바로 위의 큰 수를 가리킴

### 2️⃣ 이터레이터 → 1-based 인덱스 변환

```cpp
int idx = (int)(it - v.begin()) + 1; // 1-based 인덱스
```

**✅ 핵심**: `it - v.begin()`은 `ptrdiff_t` (`long long`) 타입이므로 `(int)` 캐스팅 필수.
0-based 오프셋에 `+1`을 더해 1-based 인덱스로 변환한다.

### 3️⃣ 출력 형식 주의사항

```
Yes 1   ← 쿼리 값이 배열 1번 인덱스에 존재
No 5    ← 쿼리 값 없음, 다음으로 큰 수가 5번 인덱스에 있음
```

**⚠️ 주의**: `Yes/No` 뒤에 **인덱스**를 붙이는 것이지, 값 자체를 붙이는 게 아님.
- `Yes N` = 찾는 값이 N번째 위치에 있음
- `No N` = 찾는 값이 없고, 다음으로 큰 수가 N번째 위치에 있음

---

## ⏱️ 시간복잡도

**O(N + Q log N)**

**상세 분석**:
```
1. 입력   : N개 원소 → O(N)
2. 쿼리   : Q번 × lower_bound → O(Q log N)
총합: O(N + Q log N)
```

**시간 제한 체크**:
- N, Q ≤ 10^5 기준 → 최악 약 10^5 + 10^5 × 17 ≈ 1.8 × 10^6 연산 → 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N)**

**분석**:
- `v` : N개 원소 벡터 → O(N)
- `n`, `m` : O(1) (전역 변수)
- 총 공간: O(N)
