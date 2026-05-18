**📅 작성일**: 2026-05-18

## 🔗 문제 링크

[프로그래머스 - 공원 산책](https://school.programmers.co.kr/learn/courses/30/lessons/172928)

**난이도**: Level 1

---

## 🤔 접근법

park 그리드에서 `'S'` 시작점을 찾아 routes의 각 이동 명령을 적용하는 시뮬레이션 문제.

이동 방향(N/S/E/W)과 칸 수가 주어지면, 이동 경로를 한 칸씩 검사하며 범위 밖 or `'X'` 장애물이면 해당 route 전체를 취소한다.

**핵심**: 최종 위치만 검사하면 안 되고, **경로 중간의 모든 칸**도 유효성을 검사해야 함.

---

## 💡 정답 풀이 방법

**알고리즘**: 시뮬레이션

```
1. park 전체 순회 → 'S' 위치를 curY, curX로 저장
2. 각 route 처리:
   a. dir = route[0] (방향 문자), step = route[2] - '0' (이동 칸 수)
   b. 방향 인덱스 idx 설정 → dy[idx], dx[idx]로 이동 벡터 결정
   c. step만큼 한 칸씩 이동하며 유효성 검사:
      - 세로 범위 밖 → valid = false, break
      - 가로 범위 밖 → valid = false, break
      - 'X' 장애물   → valid = false, break
   d. valid이면 curY, curX 갱신
3. {curY, curX} 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 방향 배열과 인덱스 매핑

```cpp
int dy[] = {-1, 1, 0,  0}; // N S E W 순서
int dx[] = { 0, 0, 1, -1};

int idx;
if      (dir == 'N') { idx = 0; }
else if (dir == 'S') { idx = 1; }
else if (dir == 'E') { idx = 2; }
else                 { idx = 3; } // W
```

map 없이 if-else로 인덱스만 결정하고, 실제 이동은 전역 배열에서 꺼낸다.

### 2️⃣ route 파싱

```cpp
char dir  = route[0];       // 방향 문자 (N/S/E/W)
int  step = route[2] - '0'; // 이동 칸 수 (문제 조건: 1~9 한 자리 보장)
```

`route[2]`는 char이므로 `- '0'`으로 int 변환. `stoi(route.substr(2))`보다 단순.

### 3️⃣ 유효성 검사 — 경로 전체를 한 칸씩

```cpp
for (int i = 0; i < step; i++)
{
    tempY += dy[idx];
    tempX += dx[idx];

    if (tempY < 0 || tempY >= rows) { valid = false; break; }
    if (tempX < 0 || tempX >= cols) { valid = false; break; }
    if (park[tempY][tempX] == 'X')  { valid = false; break; }
}
```

세로 범위 / 가로 범위 / 장애물 조건을 분리해 가독성 향상.  
범위 체크 후 `park[tempY][tempX]`에 접근해야 인덱스 범위 초과를 방지할 수 있다.

---

## ⏱️ 시간복잡도

**O(rows × cols + routes × step)**
- `'S'` 탐색: O(rows × cols), 최대 50 × 50 = 2,500
- 각 route 처리: O(step), step ≤ max(rows, cols) ≤ 50