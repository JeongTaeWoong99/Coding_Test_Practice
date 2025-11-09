**📅 작성일**: 2025-11-09

## 🔗 문제 링크

https://www.acmicpc.net/problem/16234 (백준 16234번: 인구 이동)

**난이도**: Gold 4

---

## 🤔 접근법

BFS를 활용한 시뮬레이션 문제입니다.

하지만 단순 BFS가 아니라, **하루 단위로 모든 연합을 찾고 인구를 재분배**하는 과정이 필요합니다.

처음에는 각 칸마다 독립적으로 BFS를 실행하려다가, 방문 배열 관리와 연합 처리 타이밍에서 문제가 발생했습니다.

핵심은 **하루 단위로 방문 배열을 초기화**하고, **모든 연합을 찾은 후 한 번에 이동**하는 것!

---

## 💡 핵심 아이디어

### 🔑 BFS + 시뮬레이션

**문제 조건:**
- 인접한 두 나라의 인구 차이가 L 이상 R 이하면 국경선을 연다
- 연결된 나라들을 하나의 연합으로 묶는다
- 연합의 인구수는 (연합의 총 인구) / (연합 칸 개수)로 재분배
- 더 이상 국경선을 열 수 없을 때까지 반복

**알고리즘 흐름:**
```
1. 하루 시작: 방문 배열 초기화
2. 모든 칸을 순회하며:
   - 아직 방문하지 않은 칸에서 BFS 시작
   - 인구 차이가 L 이상 R 이하인 인접 칸들을 연합으로 묶음
   - 연합의 평균 인구를 계산하여 재분배
3. 연합이 하나라도 형성되었다면 → 다음 날로 이동
4. 연합이 하나도 형성되지 않았다면 → 시뮬레이션 종료
```

**시간 복잡도**: O(D × N²)
- D = 인구 이동 일수 (최대 2,000일)
- 매일 전체 배열 탐색: O(N²)
- 각 칸마다 BFS: O(N²)

**공간 복잡도**: O(N²)
- arr 배열: O(N²)
- vit 배열: O(N²)
- currentAlliance 벡터: O(N²)
- BFS 큐: O(N²)

---

## 🔑 주요 구현 포인트

### 1️⃣ 하루 단위 방문 배열 초기화

```cpp
while (true)
{
    bool isAlliance = false;        // 연합 형성 여부
    memset(vit, 0, sizeof(vit));    // ← 핵심! 하루 시작마다 초기화

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            if (!vit[i][j])  // 아직 방문하지 않은 칸만
            {
                if (BFS(i, j)) isAlliance = true;
            }
        }
    }

    if (!isAlliance) break;  // 연합이 없으면 종료
    moveCount++;
}
```

**✅ 핵심**:
- 매일 시작할 때 방문 배열을 초기화해야 함
- 이미 방문한 칸은 건너뛰어 중복 처리 방지
- 하루 동안 형성된 모든 연합을 찾은 후 다음 날로 이동

### 2️⃣ BFS로 연합 탐색 및 인구 재분배

```cpp
bool BFS(int y, int x)
{
    bool flag = false;
    currentAlliance.clear();

    int allSum = arr[y][x];
    currentAlliance.emplace_back(y, x);

    queue<pair<int, int>> bfsQ;
    bfsQ.emplace(y, x);
    vit[y][x] = 1;

    while (!bfsQ.empty())
    {
        int cY = bfsQ.front().first;
        int cX = bfsQ.front().second;
        bfsQ.pop();

        for (int i = 0; i < 4; i++)
        {
            int nY = cY + dy[i];
            int nX = cX + dx[i];

            // 범위 체크
            if (nY < 0 || nY >= N || nX < 0 || nX >= N) continue;

            // 이미 방문
            if (vit[nY][nX]) continue;

            // 인구수 차이 범위 확인
            int diff = abs(arr[cY][cX] - arr[nY][nX]);
            if (diff < L || diff > R) continue;  // ← 핵심! 조건 체크

            vit[nY][nX] = 1;
            bfsQ.emplace(nY, nX);
            currentAlliance.emplace_back(nY, nX);
            allSum += arr[nY][nX];
        }
    }

    // 연합이 형성되었다면 인구 재분배
    if (currentAlliance.size() > 1)
    {
        flag = true;
        int averageP = allSum / currentAlliance.size();

        for (int i = 0; i < currentAlliance.size(); i++)
        {
            int y = currentAlliance[i].first;
            int x = currentAlliance[i].second;
            arr[y][x] = averageP;
        }
    }

    return flag;
}
```

**✅ 핵심**:
- BFS로 조건을 만족하는 모든 인접 칸을 연합으로 묶음
- 연합의 총 인구를 계산하고 평균을 구함
- 연합의 모든 칸에 평균 인구를 할당
- 연합이 2개 이상의 칸으로 구성되어야 true 반환

### 3️⃣ 인구 차이 조건 체크

```cpp
int diff = abs(arr[cY][cX] - arr[nY][nX]);
if (diff < L || diff > R) continue;  // L 이상 R 이하가 아니면 제외
```

**❌ 잘못된 조건 (흔한 실수)**:
```cpp
if (L < diff && diff > R) continue;  // 이 조건은 항상 false!
```

**✅ 올바른 조건**:
- `diff < L`: L 미만이면 제외
- `diff > R`: R 초과면 제외
- 즉, `L <= diff <= R`일 때만 연합 형성

### 4️⃣ 종료 조건

```cpp
if (!isAlliance) break;  // 연합이 하나도 없으면 종료
moveCount++;             // 연합이 있었다면 날짜 증가
```

**✅ 핵심**:
- 하루 동안 연합이 하나도 형성되지 않았다면 시뮬레이션 종료
- 연합이 있었다면 날짜를 증가시키고 다음 날 진행

---

## 📊 예시 실행 흐름

**입력**:
```
2 20 50
50 30
20 40
```

**실행 과정**:
```
초기 상태:
50 30
20 40

0일차 (초기 상태):
- 모든 인접 칸의 인구 차이 확인
  - |50-30| = 20 (L=20, R=50) → O
  - |50-20| = 30 (L=20, R=50) → O
  - |30-40| = 10 (L=20, R=50) → X
  - |20-40| = 20 (L=20, R=50) → O

1일차:
- BFS(0,0) 시작 → 4개 칸 모두 연합
- 평균: (50+30+20+40) / 4 = 35
- 결과:
  35 35
  35 35
- moveCount = 1

2일차:
- 모든 칸의 인구가 35로 동일
- 인구 차이가 0이므로 연합 형성 안 됨
- 시뮬레이션 종료
```

**출력**:
```
1
```

---

## 🚨 주의사항

1. **방문 배열 초기화 타이밍**: 하루 시작마다 초기화 (BFS 안에서 X)
2. **인구 차이 조건**: `diff < L || diff > R`로 체크 (NOT 연산 주의)
3. **연합 판정**: 2개 이상의 칸이 있어야 연합으로 인정
4. **종료 조건**: 연합이 하나도 없을 때만 종료
5. **인구 재분배**: 평균은 정수 나눗셈 (소수점 버림)

---

## ⏱️ 시간복잡도

**O(D × N²)**
- D = 인구 이동 일수 (최대 2,000일)
- 매일 전체 배열 탐색: O(N²)
- 각 칸마다 BFS: O(N²)
- N ≤ 50 → 최대 2,000 × 2,500 = 5,000,000번 연산

---

## 💾 공간복잡도

**O(N²)**
- `arr[54][54]`: 인구 배열
- `vit[54][54]`: 방문 체크 배열
- `currentAlliance`: 최대 N² 크기의 벡터
- BFS 큐: 최대 N² 크기
