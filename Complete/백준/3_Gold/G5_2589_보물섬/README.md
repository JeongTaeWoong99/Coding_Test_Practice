**📅 작성일**: 2025-11-03

## 🔗 문제 링크

https://www.acmicpc.net/problem/2589 (백준 2589번: 보물섬)

**난이도**: Gold 5

---

## 🤔 접근법

보물은 서로 간에 최단 거리로 이동하는데 있어 **가장 긴 시간이 걸리는 육지 두 곳**에 묻혀있다.

따라서 **모든 육지(L) 위치**에서 BFS를 수행하여 각각의 최단 거리를 구하고, 그 중 **최댓값**을 찾으면 된다.

범위가 작아서 (최대 50×50) 브루트포스로 해결 가능하다.

---

## 💡 핵심 아이디어

### 🔑 멀티소스 BFS (모든 육지에서 탐색)

**문제 조건:**
- 육지(L)에서만 이동 가능
- 상하좌우로 인접한 칸으로 이동
- 한 칸 이동 = 한 시간
- 보물은 최단 거리가 가장 긴 두 육지에 위치

**알고리즘 흐름:**
```
1. 모든 칸을 순회하며 육지(L)를 찾음
2. 각 육지에서 BFS를 수행:
   - visited 배열 초기화
   - BFS로 해당 육지에서 도달 가능한 모든 육지까지의 거리 계산
   - 최대 거리 갱신
3. 모든 육지에서 BFS를 마친 후 최댓값 출력
```

**시간 복잡도**: O(L × N × M)
- L = 육지의 개수 (최대 N × M)
- 각 육지마다 BFS: O(N × M)
- 최악의 경우: O((N×M)²) = 50² × 50² = 6,250,000 (충분히 통과)

**공간 복잡도**: O(N × M)
- arr 배열: O(N × M)
- visited 배열: O(N × M)
- BFS 큐: O(N × M)

---

## 🔑 주요 구현 포인트

### 1️⃣ 모든 육지에서 BFS 수행

```cpp
// 모든 육지(L) 위치에서 BFS 수행
for(int i = 0; i < n; i++)
{
    for(int j = 0; j < m; j++)
    {
        if(arr[i][j] == 'L')
            BFS(i, j);  // 각 육지에서 BFS 시작
    }
}
```

**✅ 핵심**:
- 모든 육지를 시작점으로 BFS 수행
- 각 BFS에서 구한 최장 거리 중 최댓값이 답

### 2️⃣ BFS로 최단 거리 계산

```cpp
void BFS(int y, int x)
{
    // 매번 visited 배열 초기화 (각 육지에서 새로 시작)
    memset(visited, 0, sizeof(visited));

    visited[y][x] = 1;  // 시작점은 거리 1
    queue<pair<int, int>> bfsQ;
    bfsQ.emplace(y, x);

    while(!bfsQ.empty())
    {
        int nY, nX;
        tie(nY, nX) = bfsQ.front();
        bfsQ.pop();

        for(int i = 0; i < 4; i++)
        {
            int ny = nY + dy[i];
            int nx = nX + dx[i];

            // 범위 + 방문 + 바다(W) 체크
            if(ny < 0 || ny >= n || nx < 0 || nx >= m) continue;
            if(visited[ny][nx]) continue;
            if(arr[ny][nx] == 'W') continue;

            // 거리 갱신 (이전 칸 + 1)
            visited[ny][nx] = visited[nY][nX] + 1;
            bfsQ.emplace(ny, nx);

            // 최대 거리 갱신 ⭐
            mx = max(mx, visited[ny][nx]);
        }
    }
}
```

**✅ 핵심**:
- visited 배열을 거리 저장용으로 사용 (1-based)
- 바다(W)는 이동 불가하므로 continue
- 각 칸을 방문할 때마다 최대 거리 갱신

### 3️⃣ visited 배열 1-based 사용

```cpp
visited[y][x] = 1;  // 시작점은 거리 1
```

**✅ 핵심**:
- `0`: 미방문
- `1 이상`: 시작점으로부터의 거리
- 시작점을 1로 설정하면 출력 시 `-1` 필요
- 이유: 문제에서 시간은 0부터 시작하므로 (거리 - 1) 출력

### 4️⃣ memset으로 배열 초기화

```cpp
memset(visited, 0, sizeof(visited));
```

**✅ 핵심**:
- 각 육지에서 새로운 BFS를 시작하므로 매번 초기화 필요
- memset은 이중 for문보다 빠름
- `sizeof(visited)`로 전체 배열 크기 지정

---

## 📊 예시 실행 흐름

**입력**:
```
5 7
WLLWWWL
LLLWLLL
LWLWLWW
LWLWLLL
WLLWLWW
```

**실행 과정**:
```
1. (0,1) 'L'에서 BFS:
   - 최장 거리: 6

2. (0,2) 'L'에서 BFS:
   - 최장 거리: 7

3. (0,6) 'L'에서 BFS:
   - 최장 거리: 9 (최댓값 갱신)

... (모든 육지에서 BFS 수행)

최종: mx = 9 (거리 기준)
출력: 9 - 1 = 8 (시간 기준)
```

**출력**: `8`

---

## ⏱️ 시간복잡도

**O(L × N × M)**
- L = 육지의 개수 (최대 N × M = 2,500)
- 각 육지마다 BFS: O(N × M)
- 최악의 경우: O(2,500 × 2,500) = 6,250,000 (충분히 통과)

**최적화 불필요한 이유:**
- N, M ≤ 50 (작은 범위)
- 브루트포스로 충분히 해결 가능

---

## 💾 공간복잡도

**O(N × M)**
- `arr[54][54]`: 보물섬 지도
- `visited[54][54]`: 방문 및 거리 배열
- BFS 큐: 최대 N × M 크기
- 재귀가 아니므로 스택 오버플로우 없음