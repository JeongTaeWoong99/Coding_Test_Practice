**📅 작성일**: 2025-10-19

## 🔗 문제 링크

[백준 14502번 - 연구소](https://www.acmicpc.net/problem/14502)

**난이도**: Gold 4

---

## 🤔 접근법

N×M 크기의 연구소에 빈 칸 중 3개를 선택해서 벽을 세우고, 바이러스가 확산될 때 안전 영역의 최대 크기를 구하는 문제이다.

범위가 작아서 (3 ≤ N, M ≤ 8) 브루트포스로 해결 가능하다.

핵심은 **빈 칸 중 3개를 선택하는 모든 조합을 시도**하고, 각 경우마다 바이러스를 확산시켜서 안전 영역을 계산하는 것!

---

## 💡 정답 풀이 방법

**알고리즘**: 브루트포스(완전탐색) + DFS

**핵심 아이디어**:
```
1. 입력을 받으면서 빈 칸(0)과 바이러스(2) 위치를 각각 리스트에 저장
2. 빈 칸 중 3개를 선택하는 모든 조합 생성
3. 각 조합마다:
   - 선택한 3칸을 벽(1)으로 변경
   - 모든 바이러스 위치에서 DFS로 확산 시뮬레이션
   - 안전 영역(0이면서 방문 안 된 칸) 개수 카운트
   - 최댓값 갱신
   - 벽을 다시 빈 칸(0)으로 복구
4. 최댓값 출력
```

**시간 복잡도**: O(C(E,3) × N×M)
- E = 빈 칸 개수 (최대 64개)
- C(E,3) = 빈 칸 중 3개를 선택하는 조합의 수 (최대 약 41,000)
- 각 조합마다 DFS로 전체 맵 탐색: O(N×M)
- 전체: 약 41,000 × 64 = 2,624,000 (충분히 통과)

**공간 복잡도**: O(N×M)
- arr 배열: O(N×M)
- visited 배열: O(N×M)
- emptyList, virusList: O(N×M)

---

## 🔑 핵심 포인트

### 1️⃣ 조합 구현 방식 비교

이 문제는 **2가지 방식**으로 조합을 구현할 수 있다:

#### 방법 1: 3중 for문 (Answer(3중 for문 조합 정답).cpp.txt)
```cpp
for(int i = 0; i < emptyList.size(); i++)
{
    for(int j = 0; j < i; j++)
    {
        for(int k = 0; k < j; k++)
        {
            // i, j, k 인덱스 사용
            arr[emptyList[i].first][emptyList[i].second] = 1;
            arr[emptyList[j].first][emptyList[j].second] = 1;
            arr[emptyList[k].first][emptyList[k].second] = 1;

            ret = max(ret, Check());

            // 원복
            arr[emptyList[i].first][emptyList[i].second] = 0;
            arr[emptyList[j].first][emptyList[j].second] = 0;
            arr[emptyList[k].first][emptyList[k].second] = 0;
        }
    }
}
```

**✅ 장점**:
- 코드가 짧고 직관적
- 메모리 오버헤드 없음
- 약간 더 빠름 (캐시 효율 좋음)
- **이 문제의 최적해!**

**⚠️ 단점**:
- 4개 이상 뽑을 때는 코드 수정 필요

#### 방법 2: next_permutation (Answer(next_permutation 조합 정답).cpp.txt)
```cpp
vector<int> combi(emptyList.size(), 1);
fill_n(combi.begin(), 3, 0);     

do
{
    vector<pair<int,int>> picked;
    for(int i = 0; i < emptyList.size(); i++)
    {
        if(combi[i] == 0)
            picked.push_back(emptyList[i]);
    }

    // 벽 설치 → Check() → 원복

} while(next_permutation(combi.begin(), combi.end()));
```

**✅ 장점**:
- 일반화 가능 (3개 → n개로 쉽게 변경)
- 재사용 가능한 패턴
- 가독성 좋음

**⚠️ 단점**:
- combi 벡터 생성으로 메모리 사용
- picked 벡터 매번 생성
- 약간 느림 (상수 배수 차이)

**📚 next_permutation 조합 원리**:

`next_permutation`을 활용한 조합은 **"선택/미선택"을 0과 1로 표시**하는 선택 마스크를 만드는 방식입니다.

**🔍 동작 원리**:
```cpp
// emptyList = [(0,0), (0,1), (0,2), (1,3), (2,4)]  // 5개 빈 칸
vector<int> combi(5, 1);                            // {1, 1, 1, 1, 1} 모두 "선택 안 됨"
fill_n(combi.begin(), 3, 0);                        // {0, 0, 0, 1, 1} 앞 3개만 "선택됨"
```

**💡 핵심 아이디어**:
- combi[i] == 0 → emptyList[i] 선택됨 ✅
- combi[i] == 1 → emptyList[i] 선택 안 됨 ❌
- 0의 개수 = 선택할 개수 (3개)
- next_permutation이 사전순으로 다음 순열 생성

**📊 실행 예시** (5개 중 3개 선택):
```
반복 1: {0,0,0,1,1} → 0,1,2번 선택
반복 2: {0,0,1,0,1} → 0,1,3번 선택
반복 3: {0,0,1,1,0} → 0,1,4번 선택
반복 4: {0,1,0,0,1} → 0,2,3번 선택
...
반복 10: {1,1,0,0,0} → 2,3,4번 선택
→ 총 C(5,3) = 10개 조합 생성
```

**🔑 왜 0과 1을 이렇게 배치하나?**
- next_permutation은 사전순으로 다음 순열 생성 (0 < 1)
- {0,0,0,1,1}이 가장 작은 순열 (시작점)
- {1,1,0,0,0}이 가장 큰 순열 (종료점)
- 이 사이의 모든 순열이 조합을 나타냄

**🎯 결론** : 이 문제처럼 뽑는 개수가 고정(3개)이고 범위가 작으면 **3중 for문이 더 효율적**!

### 2️⃣ DFS 바이러스 확산

```cpp
void DFS(int y, int x)
{
    for(int i = 0; i < 4; i++)
    {
        int ny = y + dy[i];
        int nx = x + dx[i];

        // 경계 / 방문 / 벽 체크
        if(ny < 0 || ny >= N || nx < 0 || nx >= M || visited[ny][nx] || arr[ny][nx] == 1)
            continue;

        visited[ny][nx] = 1; // 감염 표시
        DFS(ny, nx);
    }
}
```

**✅ 핵심**:
- 4방향 탐색으로 바이러스 확산
- visited 배열로 중복 방문 방지
- 벽(1)은 확산 불가

### 3️⃣ 상태 복구 (백트래킹)

```cpp
// 벽 설치
arr[emptyList[i].first][emptyList[i].second] = 1;

// 시뮬레이션
ret = max(ret, Check());

// 원복 ⭐
arr[emptyList[i].first][emptyList[i].second] = 0;
```

**✅ 핵심**: 다음 조합을 시도하기 위해 벽을 다시 빈 칸으로 복구해야 함

### 4️⃣ fill_n을 사용한 2차원 배열 초기화

```cpp
fill_n(&visited[0][0], 10 * 10, 0);
```

**✅ 핵심**:
- 2차원 배열을 1차원처럼 연속된 메모리로 취급
- `&visited[0][0]`: 배열의 시작 주소
- `10 * 10`: 전체 원소 개수
- `0`: 초기화할 값
- 이중 for문보다 빠름

---

## ⏱️ 시간복잡도

**O(C(E,3) × N×M)**
- C(E,3): 빈 칸 중 3개 선택 (최대 C(64,3) ≈ 41,000)
- N×M: DFS 탐색 (최대 8×8 = 64)
- 전체: 약 2,600,000 연산 (충분히 빠름)

---

## 💾 공간복잡도

**O(N×M)**
- arr[10][10]: 맵 배열
- visited[10][10]: 방문 체크 배열
- emptyList: 최대 64개 원소
- virusList: 최대 64개 원소
- DFS 재귀 스택: 최대 O(N×M)

---

## 🚨 주의사항

1. **조합 중복 방지**: 3중 for문에서 `j < i`, `k < j` 조건으로 중복 방지
2. **visited 초기화**: 매 시뮬레이션마다 반드시 초기화 필요
3. **상태 복구**: 벽을 세운 후 반드시 원복해야 다음 조합 시도 가능
4. **벽 3개 고정**: 문제 조건상 반드시 3개를 세워야 함