**📅 작성일**: 2025-11-01

## 🔗 문제 링크

https://www.acmicpc.net/problem/4179 (백준 4179번: 불!)

**난이도**: Gold 3

---

## 🤔 접근법

먼저 불의 이동을 기록해두고, 지훈이가 이동할 때, 값을 비교해서 해결했다.

범위 및 코드 흐름 실수가 있었지만, 해결함.

---

## 💡 핵심 아이디어

### 🔑 2단계 BFS 접근법

**문제 조건:**
- 지훈이와 불은 매 분마다 한 칸씩 이동 (상하좌우)
- 불은 4방향으로 확산
- 지훈이는 불이 도달하기 전에 가장자리로 탈출해야 함

**알고리즘 흐름:**
```
1단계: 불 멀티소스 BFS → 모든 칸에 불 도달 시간 기록
2단계: 지훈이 단일소스 BFS → 불보다 빨리 도착할 수 있는 곳만 이동
```

**시간 복잡도**: O(R × C)
- 불 BFS: O(R × C) (각 칸 최대 1번 방문)
- 지훈 BFS: O(R × C) (각 칸 최대 1번 방문)

**공간 복잡도**: O(R × C)
- arr 배열: O(R × C)
- visitedFire 배열: O(R × C)
- visitedJihoon 배열: O(R × C)
- BFS 큐: O(R × C)

---

## 🔑 주요 구현 포인트

### 1️⃣ 불 확산 시간 기록 (멀티소스 BFS)

```cpp
// 모든 불 위치를 큐에 넣고 시작
while (!fireQ.empty())
{
    int fireY = fireQ.front().first;
    int fireX = fireQ.front().second;
    fireQ.pop();

    for (int i = 0; i < 4; i++)
    {
        int nY = fireY + dY[i];
        int nX = fireX + dX[i];

        // 범위 체크 + 벽 체크
        if (nY < 0 || nY >= R || nX < 0 || nX >= C) continue;
        if (arr[nY][nX] == '#') continue;

        // 처음 방문하는 칸에만 시간 기록
        if (visitedFire[nY][nX] == 0)
        {
            visitedFire[nY][nX] = visitedFire[fireY][fireX] + 1;
            fireQ.emplace(nY, nX);
        }
    }
}
```

**✅ 핵심**:
- 여러 불 시작점을 모두 큐에 넣고 동시에 BFS 시작
- 각 칸에 불이 도달하는 최소 시간을 기록
- `visitedFire[i][j] == 0`: 불이 도달하지 않는 곳

### 2️⃣ 지훈이 탈출 경로 탐색 (단일소스 BFS)

```cpp
while (!jihoonQ.empty())
{
    int jihoonY = jihoonQ.front().first;
    int jihoonX = jihoonQ.front().second;
    jihoonQ.pop();

    // ★ 현재 위치가 가장자리면 탈출 성공!
    if (jihoonY == 0 || jihoonY == R - 1 || jihoonX == 0 || jihoonX == C - 1)
    {
        cout << visitedJihoon[jihoonY][jihoonX];
        return 0;
    }

    for (int i = 0; i < 4; i++)
    {
        int nY = jihoonY + dY[i];
        int nX = jihoonX + dX[i];

        // 범위 체크 + 벽 체크
        if (nY < 0 || nY >= R || nX < 0 || nX >= C) continue;
        if (arr[nY][nX] == '#') continue;

        // 지훈 처음 방문 && (불 도달 안함 || 지훈이 불보다 빨리 도착)
        if (visitedJihoon[nY][nX] == 0 &&
            (visitedFire[nY][nX] == 0 || visitedJihoon[jihoonY][jihoonX] + 1 < visitedFire[nY][nX]))
        {
            visitedJihoon[nY][nX] = visitedJihoon[jihoonY][jihoonX] + 1;
            jihoonQ.emplace(nY, nX);
        }
    }
}
```

**✅ 핵심**:
- **탈출 조건을 for문 밖에서 체크**: 현재 위치가 가장자리면 바로 탈출
- **불보다 빨리 도착 조건**: `visitedFire == 0` (불 안 옴) 또는 `지훈 시간 < 불 시간`

### 3️⃣ 탈출 조건의 위치가 중요!

**❌ 잘못된 방법:**
```cpp
// for문 안에서 다음 칸이 범위 밖인지 체크
if (nY < 0 || nY >= R || nX < 0 || nX >= C)
{
    cout << visitedJihoon[jihoonY][jihoonX] + 1;  // ❌ +1 해버림!
    return 0;
}
```

**문제점**: 이미 가장자리에 있는데도 +1을 해서 시간이 늘어남

**✅ 올바른 방법:**
```cpp
// for문 전에 현재 위치가 가장자리인지 체크
if (jihoonY == 0 || jihoonY == R - 1 || jihoonX == 0 || jihoonX == C - 1)
{
    cout << visitedJihoon[jihoonY][jihoonX];  // ✅ 현재 시간 그대로
    return 0;
}
```

**반례:**
```
1 1
J
```
- 지훈이가 (0, 0)에 있고, 이미 가장자리
- 바로 탈출 가능하므로 답은 **1**
- 잘못된 방법: `2` 출력 ❌
- 올바른 방법: `1` 출력 ✅

### 4️⃣ visited 배열 1-based 사용

```cpp
visitedJihoon[i][j] = 1;  // 시작점은 시간 1로 설정
```

**✅ 핵심**:
- `0`: 미방문
- `1 이상`: 방문 완료 + 도달 시간 저장
- 시작점을 1로 설정하면 출력 시 그대로 사용 가능

---

## 📊 예시 실행 흐름

**입력**:
```
4 4
####
#JF#
#..#
#..#
```

**실행 과정**:
```
1단계: 불 확산 시간 기록
┌───┬───┬───┬───┐
│ # │ # │ # │ # │
├───┼───┼───┼───┤
│ # │ 1 │ 1 │ # │  ← J(1), F(1)
├───┼───┼───┼───┤
│ # │ 2 │ 2 │ # │  ← 불 확산
├───┼───┼───┼───┤
│ # │ 3 │ 3 │ # │  ← 불 확산
└───┴───┴───┴───┘

2단계: 지훈이 이동
- (1,1) → (2,1): 시간 2
- (2,1) → (3,1): 시간 3, 가장자리 도달!
```

**출력**: `3`

---

## ⏱️ 시간복잡도

**O(R × C)**
- 불 BFS: 각 칸을 최대 1번씩만 방문
- 지훈 BFS: 각 칸을 최대 1번씩만 방문
- R, C ≤ 1000 → 최대 1,000,000번 연산

---

## 💾 공간복잡도

**O(R × C)**
- `arr[1004][1004]`: 미로 배열
- `visitedFire[1004][1004]`: 불 도달 시간
- `visitedJihoon[1004][1004]`: 지훈이 도달 시간
- BFS 큐: 최대 R × C 크기
