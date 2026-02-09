**📅 작성일**: 2026-02-09

## 🔗 문제 링크
[백준 11724번 - 연결 요소의 개수](https://www.acmicpc.net/problem/11724)

**난이도**: Silver 2

---

## 🤔 접근법

방향 없는 그래프에서 **연결 요소(Connected Component)의 개수**를 구하는 문제.

- 1번 ~ N번 정점을 순회하면서, 방문하지 않은 정점을 발견할 때마다 BFS로 연결된 모든 정점을 방문 처리.
- BFS 호출 횟수 = 연결 요소의 개수.
- 바이러스(2606번), 유기농 배추(1012번)와 동일한 Connected Component 패턴.

---

## 💡 정답 풀이 방법

**알고리즘** : BFS (Breadth-First Search) - 너비 우선 탐색

1. **그래프 입력** : 양방향 간선을 인접 리스트(`vector<int> adj[]`)로 저장
2. **전체 정점 순회** : 1번 ~ N번까지 미방문 정점 발견 시 BFS 시작
3. **BFS 탐색** : 연결된 모든 정점 방문 처리
4. **카운트** : BFS 한 번 완료 = 연결 요소 1개 → `ret++`

---

## 🔑 핵심 포인트

### 1️⃣ 연결 요소 탐색 패턴

```cpp
for (int i = 1; i <= n; i++)
{
    if (visited[i] == 1) continue;  // 이미 방문한 정점 스킵

    // BFS로 연결된 모든 정점 방문 처리
    BFS(i);
    ret++;  // 연결 요소 하나 완료
}
```

**✅ 핵심** : 미방문 정점에서 BFS를 시작할 때마다 새로운 연결 요소 발견

### 2️⃣ BFS 패턴 (바이러스 2606번과 동일)

```cpp
queue<int> q;
visited[i] = 1;
q.emplace(i);

while (!q.empty())
{
    int cur = q.front();
    q.pop();

    for (int next : adj[cur])
    {
        if (visited[next] == 1) continue;
        visited[next] = 1;
        q.emplace(next);
    }
}
```

**✅ 핵심** : 큐에 넣을 때 방문 처리하여 중복 삽입 방지

---

**⏱️ 시간복잡도**: O(N + M) - N개 정점, M개 간선 각각 1번씩 탐색

**💾 공간복잡도**: O(N + M) - 인접 리스트 + 방문 배열
