**📅 작성일**: 2026-05-26

## 🔗 문제 링크

[프로그래머스 - 힌트 스테이지](https://school.programmers.co.kr/learn/courses/30/lessons/468377)

**난이도**: Level 2 (2025 카카오 하반기 2차)

---

## 🤔 접근법

n개의 스테이지와 n-1개의 힌트 번들이 주어진다.
각 번들에 대해 **구매 / 미구매** 2가지를 결정하면 최대 2^(n-1) 가지 조합 → n ≤ 10이므로 최대 512가지.

브루트포스로는 너무 많거나 복잡한 방법 없이 **DFS + 백트래킹**으로 모든 번들 조합을 탐색한다.

각 조합에서 번들 구매 비용 + 스테이지별 클리어 비용(보유 힌트 수에 따라 결정)의 합을 구하고 최솟값을 반환.

---

## 💡 정답 풀이 방법

**알고리즘**: DFS + 백트래킹 (브루트포스)

```
DFS(hintIdx, bundleCost):
  if hintIdx == n-1:  // 모든 번들 결정 완료
    totalCost = bundleCost
    for 각 스테이지 i:
      usable = min(heldHint[i+1], cost[i].size()-1)  // 범위 초과 방지
      totalCost += cost[i][usable]
    minCost = min(minCost, totalCost)
    return

  // case 1: 미구매
  DFS(hintIdx + 1, bundleCost)

  // case 2: 구매 → 해당 스테이지에 힌트 +1
  hint[hintIdx][1..] 스테이지에 heldHint++
  DFS(hintIdx + 1, bundleCost + hint[hintIdx][0])
  hint[hintIdx][1..] 스테이지에 heldHint--  // 백트래킹
```

---

## 🔑 핵심 개념

### 1️⃣ 번들 인덱스 범위 — 0 ~ n-2

```cpp
if (hintIdx == n - 1)  // n-1번째에 도달 = 모든 번들 결정 완료
```

번들은 n-1개 (hint.size() == n-1).
hintIdx가 0부터 시작해 n-2까지 결정 → n-1에 도달하면 모든 결정 완료.

### 2️⃣ 힌트 수 범위 초과 방지

```cpp
int maxHintIdx = (int)cost[i].size() - 1;
int usable     = min(heldHint[i + 1], maxHintIdx);
```

여러 번들을 구매하면 힌트가 cost 배열 크기를 초과할 수 있다.
min으로 클램핑해 out-of-bounds 방지.

### 3️⃣ 백트래킹 — 상태 복원

```cpp
for (int j = 1; j < (int)hint[hintIdx].size(); j++)
    heldHint[hint[hintIdx][j]]++;      // 구매

DFS(...);

for (int j = 1; j < (int)hint[hintIdx].size(); j++)
    heldHint[hint[hintIdx][j]]--;      // 복원
```

전역 배열 heldHint를 재귀 호출 전후로 증감해 상태를 복원.
DFS 탐색 트리의 각 경로가 독립적으로 동작.

### 4️⃣ heldHint가 1-indexed인 이유

```cpp
heldHint[hint[hintIdx][j]]  // hint[i][j] = 스테이지 번호 (1~n)
cost[i][usable]             // i = 스테이지 인덱스 (0~n-1)
                            // → heldHint[i+1]로 대응
```

hint 배열에서 스테이지 번호가 1부터 시작하므로 heldHint도 1-indexed로 사용.

---

## 📊 테스트케이스 추적

### 입력

```
cost  = [[8, 4], [6, 2], [5, 1]]
hint  = [[3, 1, 2], [5, 2, 3]]
n     = 3  →  번들 수 = n-1 = 2개
```

### 번들 구조 해석

```
hint[0] = [3, 1, 2]  →  가격: 3원  /  스테이지 1에 힌트 +1,  스테이지 2에 힌트 +1
hint[1] = [5, 2, 3]  →  가격: 5원  /  스테이지 2에 힌트 +1,  스테이지 3에 힌트 +1
```

### DFS 재귀 트리

```
DFS(hintIdx=0, bundleCost=0)   heldHint = [_, 0, 0, 0]
│
├─ [hint[0] 미구매] ─────────────────────────────────────────────────────
│   DFS(hintIdx=1, bundleCost=0)   heldHint = [_, 0, 0, 0]
│   │
│   ├─ [hint[1] 미구매] ──────────────────────────────────────────────
│   │   DFS(hintIdx=2, bundleCost=0) ← 리프 ①
│   │
│   └─ [hint[1] 구매: +5원]  heldHint[2]++, heldHint[3]++ ───────────
│       DFS(hintIdx=2, bundleCost=5) ← 리프 ②
│       (복원: heldHint[2]--, heldHint[3]--)
│
└─ [hint[0] 구매: +3원]  heldHint[1]++, heldHint[2]++ ──────────────────
    DFS(hintIdx=1, bundleCost=3)   heldHint = [_, 1, 1, 0]
    │
    ├─ [hint[1] 미구매] ──────────────────────────────────────────────
    │   DFS(hintIdx=2, bundleCost=3) ← 리프 ③
    │
    └─ [hint[1] 구매: +5원]  heldHint[2]++, heldHint[3]++ ───────────
        DFS(hintIdx=2, bundleCost=8) ← 리프 ④
        (복원: heldHint[2]--, heldHint[3]--)
    (복원: heldHint[1]--, heldHint[2]--)
```

### 리프 노드 비용 계산

> `heldHint[_]` 의 `_` 는 0번 슬롯 (사용 안 함, 1-indexed라서)

```
리프 ①  DFS(hintIdx=2, bundleCost=0)
  heldHint = [_, 0, 0, 0]
  cost[0][ min(heldHint[1], 1) ] = cost[0][ min(0,1)=0 ] = 8
  cost[1][ min(heldHint[2], 1) ] = cost[1][ min(0,1)=0 ] = 6
  cost[2][ min(heldHint[3], 1) ] = cost[2][ min(0,1)=0 ] = 5
  totalCost = 0 + (8 + 6 + 5) = 19

리프 ②  DFS(hintIdx=2, bundleCost=5)
  heldHint = [_, 0, 1, 1]
  cost[0][ min(heldHint[1], 1) ] = cost[0][ min(0,1)=0 ] = 8
  cost[1][ min(heldHint[2], 1) ] = cost[1][ min(1,1)=1 ] = 2
  cost[2][ min(heldHint[3], 1) ] = cost[2][ min(1,1)=1 ] = 1
  totalCost = 5 + (8 + 2 + 1) = 16

리프 ③  DFS(hintIdx=2, bundleCost=3)
  heldHint = [_, 1, 1, 0]
  cost[0][ min(heldHint[1], 1) ] = cost[0][ min(1,1)=1 ] = 4
  cost[1][ min(heldHint[2], 1) ] = cost[1][ min(1,1)=1 ] = 2
  cost[2][ min(heldHint[3], 1) ] = cost[2][ min(0,1)=0 ] = 5
  totalCost = 3 + (4 + 2 + 5) = 14  ← 최솟값!

리프 ④  DFS(hintIdx=2, bundleCost=8)
  heldHint = [_, 1, 2, 1]  ← heldHint[2]=2 이지만 min(2,1)=1 로 클램핑
  cost[0][ min(heldHint[1], 1) ] = cost[0][ min(1,1)=1 ] = 4
  cost[1][ min(heldHint[2], 1) ] = cost[1][ min(2,1)=1 ] = 2  ← 클램핑 발동
  cost[2][ min(heldHint[3], 1) ] = cost[2][ min(1,1)=1 ] = 1
  totalCost = 8 + (4 + 2 + 1) = 15
```

### 결과 요약

```
 조합         번들 비용   클리어 비용   총 비용
 ✗ ✗  리프①      0          19          19
 ✗ ✓  리프②      5          11          16
 ✓ ✗  리프③      3          11          14  ← 최솟값
 ✓ ✓  리프④      8           7          15

 return 14 ✅
```

---

## ⏱️ 시간복잡도

**O(2^(n-1) × n)** — n ≤ 10이므로 최대 512 × 10 = 5,120 연산
