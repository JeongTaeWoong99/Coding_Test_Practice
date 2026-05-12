**📅 작성일**: 2026-05-12

## 🔗 문제 링크

[프로그래머스 - 가장 많이 받은 선물](https://school.programmers.co.kr/learn/courses/30/lessons/258712)

**난이도**: Level 1 (2024 KAKAO WINTER INTERNSHIP)

---

## 🤔 접근법

친구들 간의 선물 교환 기록을 바탕으로 **다음 달 가장 많이 받을 선물 수**를 구하는 시뮬레이션 문제.

**핵심 규칙**:
- A가 B에게 더 많이 줬으면 → A가 B로부터 선물 1개 받음
- 주고받은 수가 같으면 → 선물 지수(준 것 합 − 받은 것 합)가 높은 쪽이 받음
- 선물 지수도 같으면 → 아무것도 받지 않음

모든 쌍 `(i, j)`를 비교하면 최대 50명 기준 `50 × 49 / 2 = 1225`쌍으로 완전 탐색이 충분히 가능하다.

---

## 💡 정답 풀이 방법

**알고리즘**: 브루트포스 시뮬레이션

```
1. 이름 → 인덱스 map 구성
2. give[i][j] 2D 배열로 선물 교환 기록 집계
3. giftIdx[i] = Σ give[i][*] - Σ give[*][i] (선물 지수)
4. 모든 쌍 (i, j), i < j 순회:
   a. give[i][j] > give[j][i] → nextGifts[i]++
   b. give[i][j] < give[j][i] → nextGifts[j]++
   c. 동률이면 giftIdx 비교 → 높은 쪽 ++
5. max_element(nextGifts) 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 이름 → 인덱스 매핑

문자열 비교 대신 정수 인덱스로 2D 배열을 사용해 O(1) 접근.

```cpp
map<string, int> nameIdx;
for (int i = 0; i < n; i++)
    nameIdx[friends[i]] = i;
```

### 2️⃣ 선물 지수 계산

`giftIdx[i]`는 i가 모든 사람에게 준 것과 받은 것의 차이.

```cpp
for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
        giftIdx[i] += give[i][j] - give[j][i];
```

i == j일 때는 `give[i][i] = 0`이므로 자기 자신은 영향 없음.

### 3️⃣ 문자열 파싱 (stringstream)

`"muzi frodo"` → `a = "muzi"`, `b = "frodo"` 분리.

```cpp
stringstream ss(g);
string a, b;
ss >> a >> b;
```

---

## ⏱️ 시간복잡도

**O(n² + k)**
- n: 친구 수 (최대 50) → 쌍 탐색 O(n²) = O(2500)
- k: 선물 기록 수 (최대 10,000) → 파싱 O(k)
