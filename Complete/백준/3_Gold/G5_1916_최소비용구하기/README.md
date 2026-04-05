**📅 작성일**: 2026-04-05

## 🔗 문제 링크

https://www.acmicpc.net/problem/1916 (백준 1916번: 최소비용 구하기)

**난이도**: Gold 5

---

## 📊 다익스트라 시각화

[시각화 보기](시각화.html) — 예제 그래프에서 adj 구성 → minCost 배열 갱신 과정을 단계별로 확인할 수 있다.

---

## 🤔 접근법

N개의 도시와 M개의 단방향 버스 노선이 주어질 때, 출발 도시 A에서 도착 도시 B까지의 최소 비용을 구하는 문제이다.

**가중치가 있는 단방향 그래프에서의 최단 경로** 문제이므로 **데이크스트라 알고리즘**을 사용한다.

핵심은 **우선순위 큐(min-heap)** 로 현재까지 발견된 최소 비용 경로를 먼저 처리하고, **이미 확정된 도시는 스킵**하는 것!

---

## 💡 정답 풀이 방법

**알고리즘**: 데이크스트라 (Dijkstra) + 우선순위 큐 (Priority Queue / min-heap)

**핵심 아이디어**:
```
1. adj[u] : u에서 출발하는 {비용, 도착 도시} 목록을 저장 (인접 리스트)
2. minCost 배열을 전부 INT_MAX로 초기화, 출발 도시만 0
3. {0, startCity}를 min-heap에 push
4. 큐에서 꺼낼 때:
   - 이미 더 짧은 경로로 확정된 도시 → continue (스킵)
   - 인접 도시들을 순회하며 minCost 갱신
   - 갱신된 경우만 큐에 push
5. minCost[endCity] 출력
```

**시간 복잡도**: O((N + M) log N)
- N = 도시 수 (최대 1,000), M = 버스 수 (최대 100,000)
- 우선순위 큐 삽입/삭제: O(log N)
- 전체 간선 처리: O(M log N)

**공간 복잡도**: O(N + M)
- adj 인접 리스트: O(N + M)
- minCost 배열: O(N)
- 우선순위 큐: 최대 O(M)

---

## 🔑 핵심 포인트

### 1️⃣ adj 인접 리스트 구성 방식

```cpp
vector<pair<int,int>> adj[1001]; // adj[u] : {비용, 도착 도시}

adj[fromCity].emplace_back(weight, toCity);
```

**✅ 핵심**:
- `pair.first` = 비용, `pair.second` = 도착 도시 순서로 저장
- 우선순위 큐도 `{비용, 도시}` 순서로 맞춰서 비용 기준 자동 정렬

---

### 2️⃣ min-heap 우선순위 큐

```cpp
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq;
// greater<> → 비용(first)이 작은 것이 먼저 나옴 (오름차순)
```

**✅ 핵심**:
- 기본 priority_queue는 max-heap (큰 것이 먼저)
- `greater<>` 비교자를 쓰면 min-heap으로 동작
- 항상 현재까지 발견된 **최소 비용 경로**부터 처리

---

### 3️⃣ 중복 방문 스킵 조건

```cpp
if (curCost > minCost[curCity])
{
    continue;
}
```

**✅ 핵심**:
- 같은 도시가 큐에 여러 번 들어갈 수 있음
- 꺼낼 때 이미 더 짧은 경로가 확정됐다면 처리 불필요 → 스킵
- 이 조건 없으면 중복 처리로 시간 낭비

---

### 4️⃣ minCost 갱신 조건

```cpp
int totalCost = minCost[curCity] + edgeCost;

if (totalCost < minCost[nextCity])
{
    minCost[nextCity] = totalCost;
    pq.emplace(totalCost, nextCity);
}
```

**✅ 핵심**:
- 더 저렴한 경로가 발견됐을 때만 갱신 + 큐에 추가
- 갱신 없으면 불필요한 큐 삽입 방지

---

## 📊 예제 실행 흐름 (입력 기준)

### 📋 입력
```
5개 도시, 8개 버스
1→2(2), 1→3(3), 1→4(1), 1→5(10)
2→4(2), 3→4(1), 3→5(1), 4→5(3)
출발: 1, 도착: 5
```

### 🔄 adj 구성 결과
```
adj[1] = {(2,2), (3,3), (1,4), (10,5)}
adj[2] = {(2,4)}
adj[3] = {(1,4), (1,5)}
adj[4] = {(3,5)}
```

### 🔄 minCost 배열 변화
```
초기:     [∞, 0, ∞, ∞, ∞, ∞]  ← 1번 도시 = 0
Step 1:   [∞, 0, 2, 3, 1, 10] ← 1번 확정, 인접 도시 갱신
Step 2:   [∞, 0, 2, 3, 1,  4] ← 4번 확정 (비용1), 5번 갱신 (1+3=4)
Step 3:   [∞, 0, 2, 3, 1,  4] ← 2번 확정 (비용2), 변화 없음
Step 4:   [∞, 0, 2, 3, 1,  4] ← 3번 확정 (비용3), 5번(3+1=4) 같음
Step 5:   [∞, 0, 2, 3, 1,  4] ← 5번 확정 → 도착! 출력: 4
```

**최단 경로**: 1 → 4 → 5 또는 1 → 3 → 5 (둘 다 비용 4)

---

## ⏱️ 시간복잡도

**O(M log N)**

### 🔍 왜 M log N인가?

**① for문이 전체 M번 실행됨**

```
while (!pq.empty())                                     ← 큐에서 꺼낼 때마다
    for (int i = 0; i < (int)adj[curCity].size(); ++i)  ← 해당 도시의 간선들 처리
```

모든 도시의 간선 합 = M (각 간선은 딱 한 번씩만 처리됨)
→ for문 전체 실행 횟수 = **O(M)**

**② pq.emplace가 O(log(PQ 크기))**

```cpp
pq.emplace(totalCost, nextCity);  // ← 이 비용이 O(log(PQ 크기))
```

PQ에는 최대 M개의 원소가 들어갈 수 있음 (간선마다 1번씩 push)
→ PQ 크기 ≤ M ≤ N² 이므로 log M ≤ 2 log N = **O(log N)**

따라서 전체: **O(M) × O(log N) = O(M log N)**

---

### 💡 continue 스킵이 실제 성능에 미치는 영향

```cpp
if (curCost > minCost[curCity])
{
    continue;  // ← 인접 리스트 순회 자체를 건너뜀
}
```

- PQ에서 꺼낼 때 PQ 크기가 N이 아님 — 초반엔 수 개, 후반에 늘어남
- continue로 스킵된 노드는 log(PQ 크기) 비용만 쓰고 즉시 폐기
- 실제 간선 순회(for문)는 **각 도시가 "처음 확정될 때" 딱 한 번**만 실행

이론상 O(M log N)이지만 실제로는 그보다 빠름:
- PQ 크기가 항상 최대치(M)가 아니기 때문에 log 값이 더 작음
- continue 스킵으로 불필요한 for 순회 자체를 차단

---

### 📊 SPFA(일반 큐)와 비교

| | Dijkstra (PQ) | SPFA (일반 큐) |
|---|---|---|
| 시간복잡도 | **O(M log N)** | 평균 O(kM), 최악 O(NM) |
| continue 가능 | ✅ (꺼낸 순간 최소 비용 확정) | ❌ (FIFO라 확정 불가) |
| 실제 속도 | O(M log N)보다 빠름 | 그래프에 따라 차이 큼 |

전체: O(M log N) ≈ 100,000 × 10 = 1,000,000 (0.5초 충분히 통과)

---

## 💾 공간복잡도

**O(N + M)**
- `adj[1001]`: 인접 리스트, 총 M개의 원소
- `minCost[1001]`: 최소 비용 배열
- 우선순위 큐: 최대 M개 원소
