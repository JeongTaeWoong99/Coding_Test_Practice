**📅 작성일**: 2025-11-07

## 🔗 문제 링크

[백준 1325번 - 효율적인 해킹](https://www.acmicpc.net/problem/1325)

**난이도**: Silver 1

---

## 🤔 접근법

해커가 한 번의 해킹으로 최대한 많은 컴퓨터를 해킹하려고 하는데, 컴퓨터들 사이의 신뢰 관계가 주어진다.

- **A가 B를 신뢰** → **B를 해킹하면 A도 해킹됨**
- 각 컴퓨터를 해킹했을 때 해킹 가능한 총 컴퓨터 수를 구해야 함
- 최대 개수를 해킹할 수 있는 컴퓨터 번호를 **오름차순**으로 출력

**핵심**: 역방향 그래프를 만들어서 각 컴퓨터마다 BFS로 도달 가능한 컴퓨터 수를 세는 **그래프 탐색** 문제!

---

## 💡 정답 풀이 방법

**알고리즘**: BFS (Breadth-First Search) + 그래프 이론

**핵심 아이디어**:
```
1. 역방향 그래프 구축: A가 B를 신뢰 → vec[B]에 A 추가
2. 각 컴퓨터(1~N)를 시작점으로 BFS 수행
3. BFS로 도달 가능한 모든 컴퓨터 개수 카운트
4. 최대 개수를 기록하고, 동일한 최대값을 가진 컴퓨터 번호들 저장
5. 오름차순으로 출력 (1~N 순서로 탐색하므로 자동 정렬)
```

---

## 🔑 핵심 포인트

### 1️⃣ 역방향 그래프 구축

```cpp
// 입력: A B (A가 B를 신뢰)
// 의미: B를 해킹하면 A도 해킹됨
// 구현: vec[B]에 A 추가 (역방향)

for (int i = 0; i < M; i++)
{
    int a, b;
    cin >> a >> b;
    vec[b].push_back(a);  // 역방향 간선
}
```

**✅ 핵심**: 신뢰 관계를 **역방향**으로 저장
- 일반: A → B (A가 B를 가리킴)
- 역방향: B → A (B를 해킹하면 A 도달)
- B를 시작점으로 BFS하면 A, C, D... 등 해킹 가능한 모든 컴퓨터 탐색 가능

### 2️⃣ BFS로 해킹 가능한 컴퓨터 개수 계산

```cpp
// 각 컴퓨터를 시작점으로 BFS
for (int i = 1; i <= N; i++)
{
    memset(vit, 0, sizeof(vit));  // 방문 배열 초기화
    int comCount = 1;              // 자기 자신 포함
    vit[i] = 1;

    queue<int> bfsQ;
    bfsQ.emplace(i);

    while (!bfsQ.empty())
    {
        int cur = bfsQ.front();
        bfsQ.pop();

        for (int next : vec[cur])
        {
            if (vit[next] == 1) continue;

            comCount++;           // 해킹 가능한 컴퓨터 개수 증가
            vit[next] = 1;
            bfsQ.emplace(next);
        }
    }
}
```

**✅ 핵심**: 각 컴퓨터마다 독립적으로 BFS 수행
- N번 BFS 반복 (모든 컴퓨터를 시작점으로 시도)
- 매번 방문 배열 초기화 필수
- 도달 가능한 모든 컴퓨터를 카운트

### 3️⃣ 최대값 갱신 및 결과 저장

```cpp
// 최대값 갱신 및 컴퓨터 번호 저장
if (comCount > maxRet)
{
    maxRet = comCount;              // 새로운 최대값 발견
    maxComputersNum.clear();        // 이전 컴퓨터들 삭제
    maxComputersNum.emplace_back(i); // 현재 컴퓨터 추가
}
else if (comCount == maxRet)
{
    maxComputersNum.emplace_back(i); // 동일한 최대값이면 추가
}
```

**✅ 핵심**: 최대값 갱신 시 주의사항
- **새로운 최대값 발견**: 이전 결과를 `clear()`하고 새로 시작
- **동일한 최대값**: 기존 벡터에 추가
- **❌ 실수 방지**: `clear()` 없이 계속 추가하면 이전 컴퓨터들도 포함되어 틀림!

### 4️⃣ 예제 동작 과정

**입력**:
```
5 4
3 1
3 2
4 3
5 3
```

**역방향 그래프**:
```
vec[1] = [3]     // 3이 1을 신뢰 → 1을 해킹하면 3 해킹
vec[2] = [3]     // 3이 2를 신뢰 → 2를 해킹하면 3 해킹
vec[3] = [4, 5]  // 4, 5가 3을 신뢰 → 3을 해킹하면 4, 5 해킹
vec[4] = []
vec[5] = []
```

**BFS 수행 결과**:
```
1번 시작: 1 → 3 → 4, 5  ⇒ 4개 해킹 ✅
2번 시작: 2 → 3 → 4, 5  ⇒ 4개 해킹 ✅
3번 시작: 3 → 4, 5      ⇒ 3개 해킹
4번 시작: 4             ⇒ 1개 해킹
5번 시작: 5             ⇒ 1개 해킹
```

**답**: `1 2` (최대 4개를 해킹할 수 있는 컴퓨터)

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ 역방향 간선 구축

```cpp
❌ vec[a].push_back(b);  // 일반 방향 (틀림!)
✅ vec[b].push_back(a);  // 역방향 (정답!)
```

**이유:**
- A가 B를 신뢰 = B를 해킹하면 A 해킹
- B에서 시작해서 A로 가야 함 → 역방향 간선 필요

### 2️⃣ 최대값 갱신 시 clear() 필수

```cpp
❌ if (maxRet == comCount)
   {
       maxComputersNum.emplace_back(i);  // clear 없이 계속 추가
   }

✅ if (comCount > maxRet)
   {
       maxRet = comCount;
       maxComputersNum.clear();          // 반드시 초기화!
       maxComputersNum.emplace_back(i);
   }
   else if (comCount == maxRet)
   {
       maxComputersNum.emplace_back(i);
   }
```

**반례**:
```
컴 1: 5개 → maxComputersNum = [1]
컴 2: 7개 → clear() 없으면 [1, 2] (틀림!)
컴 2: 7개 → clear() 있으면 [2]   (정답!)
```

### 3️⃣ 매 BFS마다 방문 배열 초기화

```cpp
❌ memset을 BFS 시작 전에 한 번만 호출
✅ for 루프 안에서 매번 memset(vit, 0, sizeof(vit));
```

**이유:**
- 각 컴퓨터마다 독립적인 BFS 수행
- 이전 BFS의 방문 기록이 남아있으면 오답

### 4️⃣ 입출력 최적화

```cpp
✅ ios_base::sync_with_stdio(false);cin.tie(0);cout.tie(0);
```

**이유:**
- N ≤ 10,000, M ≤ 100,000
- N개 컴퓨터마다 BFS → 시간 초과 가능성
- 입출력 최적화 필수

---

## ⏱️ 시간복잡도

**O(N × (N + M))**

**분석**:
```
1. 역방향 그래프 구축: O(M)
   - M개의 간선 입력

2. N번의 BFS 수행: O(N × (N + M))
   - 각 컴퓨터마다 BFS 1번씩
   - 각 BFS: O(N + M) (정점 N개, 간선 M개)

총합: O(M) + O(N × (N + M)) = O(N² + NM)
```

**실제 계산**:
```
- N ≤ 10,000, M ≤ 100,000
- 최악의 경우: 10,000 × (10,000 + 100,000) = 1,100,000,000 ≈ 10^9
- 시간 제한: 5초
- C++ 기준 1초에 약 10^8~10^9 연산 가능
- ✅ 입출력 최적화 + BFS 효율적 구현으로 통과 가능
```

---

## 💾 공간복잡도

**O(N + M)**

**분석**:
- `vector<int> vec[10004]`: 역방향 그래프 → O(N + M)
- `int vit[10004]`: 방문 배열 → O(N)
- `vector<int> maxComputersNum`: 결과 저장 → O(N) (최악의 경우)
- `queue<int> bfsQ`: BFS 큐 → O(N)

**총합**: O(N + M)

---

## 🎯 알고리즘 분류

- **그래프 이론**: 신뢰 관계를 방향 그래프로 모델링
- **그래프 탐색**: BFS로 도달 가능한 노드 탐색
- **너비 우선 탐색 (BFS)**: 각 컴퓨터에서 해킹 가능한 모든 컴퓨터 탐색
