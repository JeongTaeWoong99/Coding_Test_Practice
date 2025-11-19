**📅 작성일**: 2025-11-19

## 🔗 문제 링크

[백준 3190번 - 뱀](https://www.acmicpc.net/problem/3190)

**난이도**: GOLD 4

---

## 🤔 접근법

N×N 정사각 보드에서 뱀이 이동하며 사과를 먹는 시뮬레이션 게임.

뱀은 매 초마다 이동하며, **벽이나 자기 자신의 몸과 부딪히면 게임이 종료**된다.

- 뱀은 머리를 늘려 다음 칸으로 이동
- 사과가 있으면 꼬리는 그대로 두고 길이 증가
- 사과가 없으면 꼬리를 줄여서 길이 유지
- 특정 시간에 방향 전환 (왼쪽 90도 또는 오른쪽 90도)

**핵심은 Deque로 뱀의 몸통을 관리**하고, Queue로 방향 전환 정보를 순차 처리하는 것!

---

## 💡 정답 풀이 방법

**알고리즘** : 시뮬레이션 + Deque + Queue

**핵심 아이디어**:
```
1. Deque로 뱀의 몸통 관리 (front: 머리, back: 꼬리)
2. Queue로 방향 전환 정보 관리 (시간 순서대로 처리)
3. 매 초마다 현재 방향으로 머리를 이동
4. 벽/몸통 충돌 체크 → 게임 종료
5. 사과 없으면 꼬리 제거 (pop_back), 있으면 사과만 제거
6. 머리 위치를 Deque 앞에 추가 (push_front)
7. 방향 전환 시간이 되면 Queue에서 꺼내 방향 변경
```

---

## 🔑 핵심 포인트

### 1️⃣ Deque로 뱀의 몸통 관리

```cpp
deque<pair<int, int>> snakeDQ;  // front: 머리, back: 꼬리

// 초기화: 뱀은 (0, 0)에서 시작
snakeDQ.emplace_back(0, 0);
vit[0][0] = 1;

// 게임 진행 중
while(!snakeDQ.empty())
{
    currentSec++;

    // 다음 머리 위치 계산
    int ny = y + dy[currentDir];
    int nx = x + dx[currentDir];

    // 충돌 체크
    if(ny >= n || ny < 0 || nx >= n || nx < 0) break;  // 벽
    if(vit[ny][nx]) break;                              // 자기 몸

    // 꼬리 처리
    if(!arr[ny][nx])  // 사과가 없으면
    {
        vit[snakeDQ.back().first][snakeDQ.back().second] = 0;
        snakeDQ.pop_back();  // 꼬리 제거
    }
    else arr[ny][nx] = 0;  // 사과 제거

    // 머리 추가
    vit[ny][nx] = 1;
    snakeDQ.emplace_front(ny, nx);  // 새로운 머리
}
```

**✅ 핵심**: Deque는 양쪽에서 삽입/삭제 가능
- `push_front(ny, nx)`: 머리를 앞에 추가 (O(1))
- `pop_back()`: 꼬리를 뒤에서 제거 (O(1))
- 뱀의 이동을 효율적으로 구현

### 2️⃣ Queue로 방향 전환 관리

```cpp
queue<pair<int, int>> directionQ;  // (시각, 회전값)

// 입력 처리
for(int i = 0; i < l; i++)
{
    cin >> t >> c;

    if(c == 'D') directionQ.emplace(t, 1);  // 우회전: +1
    else         directionQ.emplace(t, 3);  // 좌회전: +3 (= -1 mod 4)
}

// 방향 전환 체크
if(!directionQ.empty() && currentSec == directionQ.front().first)
{
    currentDir = (currentDir + directionQ.front().second) % 4;
    directionQ.pop();
}
```

**✅ 핵심**: Queue로 순차 처리
- 문제 조건: 방향 전환 정보는 시간 순서대로 주어짐
- Queue는 FIFO 특성으로 순차 처리에 최적
- `idx` 변수 없이 `empty()`, `front()`, `pop()`만으로 관리

### 3️⃣ 방향 벡터 활용

```cpp
// 방향 벡터 (상, 우, 하, 좌)
const int dy[] = {-1, 0, 1, 0};
const int dx[] = { 0, 1, 0,-1};

int currentDir = 1;  // 초기 방향: 오른쪽

// 우회전: (dir + 1) % 4
// 좌회전: (dir + 3) % 4  (= dir - 1, 음수 방지)
currentDir = (currentDir + directionQ.front().second) % 4;
```

**✅ 핵심**: 방향 인덱스로 회전 구현
- 0(상) → 1(우) → 2(하) → 3(좌) → 0(상) 순환
- 우회전: +1
- 좌회전: +3 (= -1 mod 4)
- 나머지 연산으로 0~3 범위 유지

### 4️⃣ 좌표 변환

```cpp
// 입력: 1-indexed (1, 1)부터 시작
cin >> y >> x;
arr[--y][--x] = 1;  // 0-indexed로 변환

// 뱀 시작 위치: 문제의 (1, 1) = 코드의 (0, 0)
snakeQ.emplace_back(0, 0);
```

**✅ 핵심**: 입력은 1-indexed, 배열은 0-indexed
- 사과 위치 입력 시 -1 처리
- 뱀은 (0, 0)에서 시작

### 5️⃣ 충돌 체크

```cpp
// 벽 충돌
if(ny >= n || ny < 0 || nx >= n || nx < 0) break;

// 자기 몸 충돌
if(vit[ny][nx]) break;
```

**✅ 핵심**: 두 가지 종료 조건
1. **벽 충돌**: 보드 범위를 벗어남
2. **자기 몸 충돌**: 이미 방문한 칸 (vit 배열)

---

## 🔍 자료구조 선택 이유

### Deque vs Vector

| 자료구조 | push_front | pop_back | 이 문제 적합성 |
|---------|-----------|----------|---------------|
| **Deque** | O(1) | O(1) | ✅ 완벽 |
| **Vector** | O(N) | O(1) | ❌ 비효율적 |

**Deque를 선택한 이유**:
- 머리 추가 (`push_front`): O(1)
- 꼬리 제거 (`pop_back`): O(1)
- 양쪽 작업이 빈번하므로 Deque 필수

---

## ⏱️ 시간복잡도

**O(게임 시간) ≈ O(N × L)**

**분석**:
- 매 초마다 O(1) 연산 (충돌 체크, 이동, 방향 전환)
- 게임 시간은 최악의 경우:
  - 뱀이 보드 전체를 채움: O(N²)
  - 하지만 실제로는 훨씬 적음

**실제 계산**:
```
- N ≤ 100, L ≤ 100
- 각 초마다 상수 시간 연산
- 최악의 경우: 약 10,000초 (뱀이 보드를 채우는 경우)
- 10,000 × O(1) = O(10^4) << 10^8 (1초 기준)
```

**✅ 결론**: 충분히 시간 제한(1초) 내에 해결 가능

---

## 💾 공간복잡도

**O(N²)**

**분석**:
- `arr[104][104]`: 사과 위치 배열 → O(N²)
- `vit[104][104]`: 뱀의 몸통 위치 배열 → O(N²)
- `deque<pair<int, int>> snakeDQ`: 최대 N² 크기 → O(N²)
- `queue<pair<int, int>> directionQ`: 최대 L 크기 → O(L)
- `dy[4]`, `dx[4]`: 방향 배열 → O(1) (상수)

**총 공간**: O(N²) ≈ **O(10,000)** (N=100일 때)
