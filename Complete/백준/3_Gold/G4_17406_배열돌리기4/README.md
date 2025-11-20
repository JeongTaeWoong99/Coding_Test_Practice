**📅 작성일**: 2025-11-20

## 🔗 문제 링크

https://www.acmicpc.net/problem/17406 (백준 17406번: 배열 돌리기 4)

**난이도**: Gold 4

---

## 🤔 접근법

배열을 회전시키는 연산이 여러 개 주어졌을 때, **연산의 순서에 따라 결과가 달라진다**.

배열의 값(각 행 합의 최솟값)을 최소화하려면 **모든 연산 순서를 시도**해봐야 한다.

핵심은 **회전 연산의 모든 순열(permutation)을 시도**하는 것!

---

## 💡 핵심 아이디어

### 🔑 브루트포스 + 시뮬레이션

**문제 조건:**
- N×M 배열 A가 주어진다
- K개의 회전 연산이 주어진다 (최대 6개)
- 각 회전 연산은 (r, c, s)로 정의되며, 해당 영역을 시계 방향으로 회전시킨다
- 회전 연산은 모두 한 번씩 사용해야 하며, 순서는 임의로 정할 수 있다
- 배열의 값 = 각 행의 합 중 최솟값

**알고리즘 흐름:**
```
1. K개의 회전 연산에 대해 모든 순열을 생성 (K! 가지)
2. 각 순열마다:
   - 원본 배열을 복사
   - 순열 순서대로 회전 연산 수행
   - 배열의 값(각 행 합의 최솟값) 계산
3. 모든 순열 중 최솟값 출력
```

**시간 복잡도**: O(K! × K × S² × N×M)
- K! = 회전 연산 순열 개수 (최대 6! = 720)
- K = 회전 연산 개수 (최대 6)
- S² = 각 회전 연산의 범위 (최대 6² = 36)
- N×M = 배열 크기 (최대 50×50 = 2,500)
- 총 연산 횟수: 720 × 6 × 36 × 2,500 ≈ 3억 (충분히 빠름)

**공간 복잡도**: O(N×M)
- origArr, copyArr 배열: O(N×M)
- visited 배열: O(N×M)
- rotatV 벡터: O(S²)

---

## 🔑 주요 구현 포인트

### 1️⃣ DFS로 회전 좌표 찾기

```cpp
// 회전할 좌표들을 DFS로 찾는 함수
void go(int y, int x, int first)
{
    // 모서리에 도달하면 방향 전환
    if(!first && y == sy && x == sx) dir++;  // 좌상단
    if(!first && y == sy && x == ex) dir++;  // 우상단
    if(!first && y == ey && x == ex) dir++;  // 우하단
    if(!first && y == ey && x == sx) dir++;  // 좌하단

    int ny = y + dy[dir];
    int nx = x + dx[dir];

    if(visited[ny][nx]) return;  // 이미 방문했으면 종료

    visited[ny][nx] = 1;
    rotatV.emplace_back(ny, nx);
    go(ny, nx, 0);
}
```

**✅ 핵심**:
- 시계 방향으로 좌표를 순회하며 rotatV에 저장
- 모서리에 도달하면 방향을 전환 (dir++)
- 시작점으로 돌아오면 자동 종료 (visited 체크)

### 2️⃣ 레이어별 회전 수행

```cpp
void rotateAll(int y, int x, int cnt)
{
    // 중심으로부터 1칸부터 cnt칸까지 각 레이어별로 회전
    for(int i = 1; i <= cnt; i++)
    {
        // 현재 레이어의 좌상단, 우하단 좌표 설정
        sy = y - (1 * i);
        sx = x - (1 * i);
        ey = y + (1 * i);
        ex = x + (1 * i);

        // 초기화
        rotatV.clear();
        dir = 0;
        memset(visited, 0, sizeof(visited));

        // 시작점 설정 및 DFS로 회전할 좌표들 찾기
        visited[sy][sx] = 1;
        rotatV.emplace_back(sy, sx);
        go(sy, sx, 1);

        // 좌표들의 값을 벡터에 저장
        vector<int> layerV;
        for(pair<int, int> c : rotatV)
            layerV.push_back(copyArr[c.first][c.second]);

        // 시계 방향으로 한 칸 회전 (역방향 반복자 사용)
        rotate(layerV.rbegin(), layerV.rbegin() + 1, layerV.rend());

        // 회전된 값을 배열에 다시 저장
        for(int i = 0; i < rotatV.size(); i++)
            copyArr[rotatV[i].first][rotatV[i].second] = layerV[i];
    }
}
```

**✅ 핵심**:
- 회전 영역은 여러 레이어로 구성됨 (cnt개)
- 각 레이어마다 독립적으로 회전 수행
- STL `rotate` 함수로 벡터를 시계 방향으로 회전

### 3️⃣ STL rotate 함수 활용

```cpp
rotate(layerV.rbegin(), layerV.rbegin() + 1, layerV.rend());
```

**✅ 핵심**:
- 역방향 반복자(rbegin)를 사용하여 시계 방향 회전 구현
- `rotate(first, middle, last)`: middle 원소를 first 위치로 이동
- 역방향이므로 마지막 원소가 첫 번째로 이동 (시계 방향)

### 4️⃣ next_permutation으로 모든 순열 시도

```cpp
// 회전 연산의 모든 순열을 시도하여 최솟값 찾기
do
{
    memcpy(copyArr, origArr, sizeof(copyArr)); // 원본 배열 복사
    ret = min(ret, solve());              // 현재 순열로 회전 수행 및 결과 계산
}
while(next_permutation(permuV.begin(), permuV.end()));
```

**✅ 핵심**:
- `next_permutation`으로 모든 순열 자동 생성
- 각 순열마다 원본 배열을 복사하여 독립적으로 회전 수행
- 모든 순열의 결과 중 최솟값을 ret에 저장

---

## 📊 예시 실행 흐름

**입력**:
```
5 6 2
1 2 3 2 5 6
3 8 7 2 1 3
8 2 3 1 4 5
3 4 5 1 1 1
9 3 2 1 4 3
3 4 2
4 2 1
```

**실행 과정**:
```
순열 1: (3, 4, 2) → (4, 2, 1)
- 첫 번째 회전: (3, 4, 2) 연산 수행
- 두 번째 회전: (4, 2, 1) 연산 수행
- 배열의 값: 12

순열 2: (4, 2, 1) → (3, 4, 2)
- 첫 번째 회전: (4, 2, 1) 연산 수행
- 두 번째 회전: (3, 4, 2) 연산 수행
- 배열의 값: 15

최솟값: min(12, 15) = 12
```

**출력**:
```
12
```

---

## 🚨 주의사항

1. **1-indexed → 0-indexed 변환**: 입력받은 r, c를 `r--`, `c--`로 보정
2. **원본 배열 보존**: 각 순열마다 `memcpy`로 원본 배열 복사
3. **레이어별 초기화**: 각 레이어마다 visited와 rotatV 초기화
4. **시계 방향 회전**: 역방향 반복자 사용하여 구현
5. **연산 순서 중요**: 같은 회전 연산도 순서에 따라 결과가 다름

---

## ⏱️ 시간복잡도

**O(K! × K × S² × N×M)**
- K! = 회전 연산 순열 개수 (최대 6! = 720)
- K = 회전 연산 개수 (최대 6)
- S² = 각 회전 연산의 범위 (최대 6² = 36)
- N×M = 배열 크기 (최대 50×50 = 2,500)
- K ≤ 6이므로 충분히 빠름

---

## 💾 공간복잡도

**O(N×M)**
- `origArr[104][104]`: 원본 배열
- `copyArr[104][104]`: 작업용 배열
- `visited[104][104]`: 방문 체크 배열
- `rotatV`: 최대 4×(2S)² 크기 (각 레이어 둘레)
