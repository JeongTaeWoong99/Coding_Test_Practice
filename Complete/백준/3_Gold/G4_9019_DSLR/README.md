**📅 작성일**: 2026-03-29

## 🔗 문제 링크

[백준 9019번 - DSLR](https://www.acmicpc.net/problem/9019)

**난이도**: Gold 4

---

## 🖥️ 시각화

[BFS 동작 시각화 (HTML)](visualization.html)

> BFS 큐 변화, prevState/prevOp 기록 과정을 단계별로 확인 가능

---

## 🤔 접근법

D, S, L, R 4가지 연산으로 A → B를 만들어야 하는 문제.

최소 명령어 수를 구해야 하므로 BFS로 접근. 경로(명령어 나열)를 복원해야 하므로 역추적 필요.

처음에 경로 자체를 string 배열에 누적하는 방법을 생각했으나, prevState/prevOp 배열로 이전 상태만 기록하면 메모리 효율이 훨씬 좋다.

---

## 💡 정답 풀이 방법

**알고리즘**: BFS (너비 우선 탐색) + 역추적 (Backtracking)

**핵심 아이디어**:
```
1. BFS로 A에서 출발하여 가능한 모든 상태 탐색
2. 각 상태에 도달할 때 사용한 연산과 이전 상태를 기록
3. B에 처음 도달하면 종료 (BFS이므로 최단 보장)
4. prevState를 역추적하여 A→B 경로 복원 후 reverse()
```

**시간 복잡도**: O(10000)
- 상태 공간: 0 ~ 9999 (10000개)
- 각 상태를 최대 1번만 방문

**공간 복잡도**: O(10000)
- visited, prevState, prevOp 배열 각각 O(10000)

---

## 🔑 주요 구현 포인트

### 1️⃣ 4가지 연산 구현

```cpp
int OpD(int n) { return (2 * n) % 10000; }               // 2배, 10000 초과 시 mod
int OpS(int n) { return n == 0 ? 9999 : n - 1; }         // -1, 0이면 9999
int OpL(int n) { return (n % 1000) * 10 + (n / 1000); }  // 왼쪽 회전
int OpR(int n) { return (n % 10) * 1000 + (n / 10); }    // 오른쪽 회전
```

**✅ L/R 연산 핵심**:
- L: `d1 d2 d3 d4` → `d2 d3 d4 d1` : `(n % 1000) * 10 + (n / 1000)`
- R: `d1 d2 d3 d4` → `d4 d1 d2 d3` : `(n % 10) * 1000 + (n / 10)`

### 2️⃣ BFS 탐색 + 기록

```cpp
int  next[4] = { OpD(cur), OpS(cur), OpL(cur), OpR(cur) };
char ops[4]  = { 'D', 'S', 'L', 'R' };

for (int i = 0; i < 4; ++i)
{
    if (!visited[next[i]])
    {
        visited[next[i]]   = true;    // 방문 처리 (재방문 방지)
        prevState[next[i]] = cur;     // 이전 상태 기록 (역추적용)
        prevOp[next[i]]    = ops[i];  // 사용한 연산 기록 (역추적용)
        bfsQ.push(next[i]);
    }
}
```

**✅ 핵심**: `prevState[next] = cur`, `prevOp[next] = ops[i]` 로
next 상태에 어떻게 도달했는지를 기록

### 3️⃣ 역추적으로 경로 복원

```cpp
string path = "";
int cur = B;

while (cur != A)            // A에 도달할 때까지 거슬러 올라감
{
    path += prevOp[cur];    // 현재 상태 도달 시 쓴 연산 추가
    cur = prevState[cur];   // 이전 상태로 이동
}

reverse(path.begin(), path.end()); // B→A 역순 → A→B 순서로 변환
```

**✅ 핵심**: B에서 A까지 prevState를 따라가며 연산을 수집 → 역순이므로 reverse() 필요

---

## 📊 예시 실행 흐름

**입력**: `A = 1234, B = 3412`

```
BFS 탐색:
  1234 → D → 2468  (prevState[2468]=1234, prevOp[2468]='D')
  1234 → S → 1233  (prevState[1233]=1234, prevOp[1233]='S')
  1234 → L → 2341  (prevState[2341]=1234, prevOp[2341]='L')  ⭐
  1234 → R → 4123  (prevState[4123]=1234, prevOp[4123]='R')
  ...
  2341 → L → 3412  (prevState[3412]=2341, prevOp[3412]='L')  🎯 목표 도달!

역추적:
  3412 → prevOp='L', prevState=2341
  2341 → prevOp='L', prevState=1234
  1234 = A → 종료

path = "LL" → reverse → "LL"
```

**출력**: `LL`

---

## ⏱️ 시간복잡도

**O(10000)**
- 상태 공간이 0~9999로 고정되어 있어 최대 10000번 처리
- 각 상태에서 4가지 연산 → 총 40000번 연산
