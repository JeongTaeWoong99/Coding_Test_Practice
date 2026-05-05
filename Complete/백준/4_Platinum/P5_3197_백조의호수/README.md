**📅 작성일**: 2025-10-09

## 🔗 문제 링크
[백준 3197번 - 백조의 호수](https://www.acmicpc.net/problem/3197)

---

## 🤔 접근법

두 마리의 백조가 빙판이 녹아서 만날 수 있는 최소 일수를 구하는 문제.

접근 방법은 알맞았으나, 구현에서 어려움을 겪음.

세부 코드 구현에서 막히는 부분이 있었음. 나중에 다시 풀어볼 예정.

핵심은 **두 개의 BFS를 동시에 진행**하는 것!

1. **백조 BFS** : 백조가 물을 따라 다른 백조를 찾아감
2. **물 BFS** : 빙판이 녹아서 물 영역이 확장됨

매일 두 BFS를 번갈아 실행하면서, 백조가 만날 때까지 반복.

---

## 💡 정답 풀이 방법

**알고리즘**: 이중 BFS (백조 탐색 + 물 확장)

**핵심 아이디어**:
```
1. 백조 BFS와 물 BFS를 각각 별도의 큐로 관리
2. 백조는 물을 따라 이동하다가 빙판을 만나면 "다음 날 탐색 큐"에 저장
3. 물은 인접한 빙판을 녹이면서 확장
4. 매일 두 BFS를 실행하고, 백조가 만나면 종료
```

**시간 복잡도**: O(R × C × 날짜)
- 각 칸을 최대 한 번씩 방문
- R, C ≤ 1500이므로 최대 2,250,000번 연산
- 최악의 경우에도 빙판이 모두 녹는 시간 내에 해결

**공간 복잡도**: O(R × C)
- a[1504][1504]: 맵 정보
- visitedSwan[1504][1504]: 백조 방문 체크
- visitedWater[1504][1504]: 물 방문 체크

---

## 🔑 주요 구현 포인트

### 1️⃣ 이중 BFS 구조

```cpp
// 백조 탐색용 큐 (현재 날 + 다음 날)
queue<pair<int,int>> swanQ, swanTempQ;

// 물 확장용 큐 (현재 날 + 다음 날)
queue<pair<int,int>> waterQ, waterTempQ;
```

**왜 큐를 2개씩 사용하는가?**
- 현재 날짜에 탐색할 위치: `swanQ`, `waterQ`
- 다음 날짜에 탐색할 위치: `swanTempQ`, `waterTempQ`
- 매일 종료 시 `swanQ = swanTempQ` 교체

### 2️⃣ 백조 BFS - 물을 따라 이동

```cpp
bool Move()
{
    while (!swanQ.empty())
    {
        int y = swanQ.front().first;
        int x = swanQ.front().second;
        swanQ.pop();

        for (int i = 0; i < 4; i++)
        {
            int ny = y + dy[i];
            int nx = x + dx[i];

            if (ny < 0 || ny >= R || nx < 0 || nx >= C || visitedSwan[ny][nx]) continue;
            visitedSwan[ny][nx] = 1;

            // 물인 경우 => 계속 탐색
            if (a[ny][nx] == '.')
            {
                swanQ.emplace(ny, nx);
            }
            // 빙판인 경우 => 다음 날 탐색 위치로 저장
            else if (a[ny][nx] == 'X')
            {
                swanTempQ.emplace(ny, nx);
            }
            // 다른 백조 발견!
            else if (a[ny][nx] == 'L')
            {
                return true;
            }
        }
    }
    return false;
}
```

**핵심 로직:**
- **물(`.`)**: 같은 날 계속 탐색 → `swanQ`에 추가
- **빙판(`X`)**: 다음 날 탐색 예약 → `swanTempQ`에 추가
- **백조(`L`)**: 발견 즉시 `true` 반환

### 3️⃣ 물 BFS - 빙판 녹이기

```cpp
void WaterMelting()
{
    while (!waterQ.empty())
    {
        int y = waterQ.front().first;
        int x = waterQ.front().second;
        waterQ.pop();

        for (int i = 0; i < 4; i++)
        {
            int ny = y + dy[i];
            int nx = x + dx[i];

            if (ny < 0 || ny >= R || nx < 0 || nx >= C || visitedWater[ny][nx]) continue;

            // 빙판을 만나면 녹여서 물로 만듦
            if (a[ny][nx] == 'X')
            {
                visitedWater[ny][nx] = 1;
                waterTempQ.emplace(ny, nx);
                a[ny][nx] = '.';  // 빙판을 물로 변경!
            }
        }
    }
}
```

**핵심 로직:**
- 물에 인접한 **빙판(`X`)만** 녹임
- 녹은 위치는 **다음 날 물 확장의 시작점**이 됨 → `waterTempQ`에 추가
- 빙판을 물(`.`)로 직접 변경

### 4️⃣ 매일 반복하는 메인 루프

```cpp
while (true)
{
    // 1. 백조 BFS로 다른 백조 찾기
    if (Move()) break;

    // 2. 물에 인접한 빙판 녹이기
    WaterMelting();

    // 3. 다음 날 탐색 준비
    waterQ = waterTempQ;
    swanQ  = swanTempQ;
    ClearQ(waterTempQ);
    ClearQ(swanTempQ);

    // 날짜 증가
    day++;
}
```

**왜 이 순서인가?**
1. **백조 탐색 먼저**: 현재 물 영역에서 만날 수 있는지 확인
2. **빙판 녹이기**: 다음 날 물 영역 확장
3. **큐 교체**: 다음 날 준비

---

## 📊 예시 실행 흐름

**입력**:
```
8 17
...XXXXXX..XX.XXX
....XXXXXXXXX.XXX
...XXXXXXXXXXXX..
..XXXXX.LXXXXXX..
.XXXXXX..XXXXXX..
XXXXXXX...XXXX...
..XXXXX...XXX....
....XXXXX.XXXL...
```

**실행 과정**:

```
[Day 0]
백조 위치: (3, 7), (7, 14)
백조 BFS: 물을 따라 이동하다가 빙판 만남 → swanTempQ 저장
물 BFS: 인접 빙판 녹임 → waterTempQ 저장

[Day 1]
백조 BFS: 어제 빙판이었던 곳(이제는 물)부터 탐색 시작
물 BFS: 또 다른 빙판 녹임

[Day 2]
백조 BFS: 다른 백조 발견! ✅
출력: 2
```

---

## 🚨 주의사항

1. **visitedSwan과 visitedWater 분리**: 백조와 물의 방문 체크는 별도로 관리
2. **큐 초기화 필수**: 다음 날 큐를 비워야 중복 탐색 방지
3. **빙판 직접 수정**: `a[ny][nx] = '.'`로 빙판을 물로 변경
4. **초기 물 위치 설정**: 모든 물(`.`)과 백조(`L`) 위치를 `waterQ`에 미리 추가

---

## 💡 핵심 요약

**이 문제의 핵심은 3가지:**

1️⃣ **이중 BFS 구조**: 백조 탐색 + 물 확장을 별도로 관리

2️⃣ **다음 날 큐 활용**: 빙판을 만나면 다음 날 탐색 큐에 저장

3️⃣ **효율적인 탐색**: 각 위치를 최대 1번씩만 방문하여 시간 절약

**단순 BFS로는 시간 초과, 이중 BFS로 최적화!**