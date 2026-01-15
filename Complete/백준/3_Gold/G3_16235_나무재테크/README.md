**📅 작성일**: 2026-01-15

## 🔗 문제 링크

[백준 16235번 - 나무 재테크](https://www.acmicpc.net/problem/16235)

**난이도**: Gold 3

---

## 🤔 접근법

(부분 부분 나눠서 처리하면, 풀 수 있음. 문제 지문이 길어서 처리하는데 오래 걸릴 뿐...)

N×N 크기의 땅에서 나무들이 사계절을 보내며 성장하고 번식하는 시뮬레이션 문제.

**핵심 포인트**:
- 한 칸에 **여러 나무**가 존재할 수 있음 → `vector<int> tree[N][N]` 활용
- 봄에 나이 **어린 나무부터** 양분을 먹음 → 정렬 필요
- 가을에 나이가 **5의 배수**인 나무만 8방향으로 번식

---

## 💡 정답 풀이 방법

**알고리즘**: 시뮬레이션

**사계절 로직**:
```
봄: 나이 어린 나무부터 양분 섭취 → 나이+1, 양분 부족 시 죽음

여름: 죽은 나무 → 양분으로 변환 (나이/2)

가을: 나이가 5의 배수인 나무 → 8방향에 나이 1인 나무 번식

겨울: 로봇이 A[r][c]만큼 양분 추가
```

**자료구조 선택**:
```cpp
vector<int> tree[14][14];  // 각 칸마다 나무들의 나이를 저장하는 벡터
```
- 한 칸에 여러 나무가 있을 수 있음
- 각 나무의 나이를 개별적으로 관리

**💡 시각화**:
```
┌─────────────┬─────────────┬─────────────┐
│ tree[0][0]  │ tree[0][1]  │ tree[0][2]  │ ...
│ vector<int> │ vector<int> │ vector<int> │
│ {3, 5, 7}   │ {2}         │ {}          │  ← 각 칸마다 나무들의 나이
├─────────────┼─────────────┼─────────────┤
│ tree[1][0]  │ tree[1][1]  │ tree[1][2]  │ ...
│ vector<int> │ vector<int> │ vector<int> │
│ {1, 1, 1}   │ {}          │ {10}        │
└─────────────┴─────────────┴─────────────┘
```

---

## 🔑 주요 구현 포인트

### 1️⃣ 봄 + 여름 통합 처리

```cpp
void SpringSummer()
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            if (tree[i][j].empty()) continue;

            int deadTreeToYangbun = 0;
            vector<int> aliveTree;

            // 나이 어린 나무부터 양분 섭취
            sort(tree[i][j].begin(), tree[i][j].end());

            for (int age : tree[i][j])
            {
                if (remainYangbun[i][j] >= age)
                {
                    remainYangbun[i][j] -= age;
                    aliveTree.push_back(age + 1);
                }
                else
                {
                    deadTreeToYangbun += age / 2;
                }
            }

            tree[i][j] = aliveTree;
            remainYangbun[i][j] += deadTreeToYangbun;
        }
    }
}
```

**✅ 핵심**:
- 정렬 후 어린 나무부터 처리
- 살아남은 나무와 죽은 나무를 한 번에 처리
- 죽은 나무는 나이/2만큼 양분으로 변환

### 2️⃣ 가을 - 번식

```cpp
void Fall()
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            if (tree[i][j].empty()) continue;

            for (int age : tree[i][j])
            {
                if (age % 5 == 0)   // 5의 배수만 번식
                {
                    for (int d = 0; d < 8; d++)
                    {
                        int ny = i + dy[d];
                        int nx = j + dx[d];

                        if (ny < 0 || ny >= n || nx < 0 || nx >= n) continue;

                        tree[ny][nx].push_back(1);
                    }
                }
            }
        }
    }
}
```

**✅ 핵심**:
- 나이가 5의 배수인 나무만 번식
- 8방향으로 나이 1인 나무 추가
- 범위 체크 필수

### 3️⃣ 겨울 - 양분 추가

```cpp
void Winter()
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            remainYangbun[i][j] += plusYangbun[i][j];
        }
    }
}
```

**✅ 핵심**:
- 입력으로 주어진 A 배열만큼 양분 추가
- 초기 양분은 모든 칸에 5

---

## 📊 입력 형식 정리

```
N M K           → N×N 땅, M개 나무, K년 시뮬레이션
A[1][1] ~ A[1][N]   → 겨울에 추가되는 양분 (N줄)
...
A[N][1] ~ A[N][N]
x y z           → 나무 위치(x,y), 나이(z) (M줄)
```

**⚠️ 주의**:
- 초기 양분은 모든 칸에 5 (A 배열 아님!)
- A 배열은 **매년 겨울에 추가**되는 양분

---

## ⏱️ 시간복잡도

**O(K × N² × T)**
- K = 시뮬레이션 연도 (최대 1,000)
- N² = 땅 크기 (최대 100)
- T = 각 칸의 나무 수 (정렬 포함)

**시간 제한**: 0.3초 (빡빡함)
- deque 사용 시 더 최적화 가능 (정렬 없이 앞에서 추가)

---

## 💾 공간복잡도

**O(N² × T)**
- `tree[N][N]`: 각 칸마다 나무 벡터
- `plusYangbun[N][N]`: 추가 양분 배열
- `remainYangbun[N][N]`: 현재 양분 배열

---

## 🚨 주의사항

1. **초기 양분 ≠ A 배열**: 초기 양분은 5, A는 겨울에 추가되는 양분
2. **정렬 필수**: 어린 나무부터 양분을 먹어야 함
3. **1-indexed → 0-indexed**: 입력 좌표 보정 필요
4. **시간 제한 주의**: 0.3초로 빡빡함, 불필요한 연산 최소화
