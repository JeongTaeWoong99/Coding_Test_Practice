**📅 작성일**: 2025-11-29

## 🔗 문제 링크

[백준 2606번 - 바이러스](https://www.acmicpc.net/problem/2606)

**난이도**: Silver 3

---

## 🤔 접근법

1번 컴퓨터가 바이러스에 걸렸을 때, 네트워크로 연결된 모든 컴퓨터에 바이러스가 전파되는 문제.

**핵심**: 1번 컴퓨터부터 시작하여 그래프 탐색(BFS/DFS)으로 연결된 모든 노드를 방문.

---

## 💡 정답 풀이 방법

**알고리즘**: BFS (Breadth-First Search)

**핵심 아이디어**:
```
1. 인접 리스트로 양방향 그래프 구성
2. 1번 컴퓨터부터 BFS 시작
3. 방문한 컴퓨터 수를 카운트 (1번 제외)
```

---

## 🔑 핵심 개념

### 1️⃣ 양방향 그래프 구성

```cpp
vector<int> adj[104];  // 인접 리스트

for (int i = 0; i < M; i++)
{
    int a, b;
    cin >> a >> b;
    adj[a].emplace_back(b);  // a → b
    adj[b].emplace_back(a);  // b → a (양방향)
}
```

### 2️⃣ BFS 탐색

```cpp
queue<int> q;
visited[1] = 1;  // 1번 컴퓨터 시작
q.emplace(1);

while (!q.empty())
{
    int cur = q.front();
    q.pop();

    for (int next : adj[cur])
    {
        if (visited[next] == 1) continue;  // 이미 방문

        visited[next] = 1;
        q.emplace(next);
        ret++;  // 감염된 컴퓨터 증가
    }
}
```

---

## ⏱️ 시간복잡도 분석

**전체 시간복잡도**: **O(N + M)**

- **그래프 구성**: O(M) - M개 간선 입력
- **BFS 탐색**: O(N + M) - 모든 노드와 간선 탐색
- **총합**: O(M + N + M) ≈ **O(N + M)**

**시간 제한 체크**:
- N ≤ 100, M ≤ 4950 (완전 그래프)
- 약 5,000 연산 << 1억 → **여유롭게 통과** ✅

---

## 💾 공간복잡도

**O(N + M)**
- `vector<int> adj[104]`: 인접 리스트 - O(N + M)
- `int visited[104]`: 방문 체크 - O(N)
- 큐: 최대 O(N)

---

## 🎯 알고리즘 분류

- **그래프 이론**: 네트워크 연결 관계
- **BFS**: 연결된 컴포넌트 탐색