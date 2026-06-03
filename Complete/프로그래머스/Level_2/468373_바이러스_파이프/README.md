**📅 작성일**: 2026-06-03

## 🔗 문제 링크

[프로그래머스 - 바이러스 파이프](https://school.programmers.co.kr/learn/courses/30/lessons/468373)

**난이도**: Level 2 (2025 카카오 하반기 1차)

---

## 🤔 접근법

트리 구조의 n개 노드에서 infection 노드를 시작점으로, k번 파이프를 열어 최대한 많은 노드를 감염시키는 문제.

파이프는 A/B/C(1/2/3) 세 종류이며, **같은 종류 파이프 전체가 동시에 열렸다 닫힌다**.  
한 번 열고 닫은 뒤 다음 종류를 선택할 수 있고, **직전과 같은 타입은 연속으로 선택 불가**.

k번의 타입 선택 순서 (ABA, ABC 등)를 DFS로 모두 탐색하고, 각 순서마다 BFS flood-fill로 확산 시뮬레이션 후 최댓값을 반환한다.

---

## 💡 정답 풀이 방법

**알고리즘**: DFS (타입 선택 순서 탐색) + BFS (flood-fill 확산 시뮬레이션)

```
SelectDFS(infectCnt, lastType, remain):
  ans = max(ans, infectCnt)
  if remain == 0: return

  for type in {1, 2, 3}:
    if type == lastType: skip  // 연속 금지

    newNodes = SpreadBFS(type)  // 해당 타입 파이프 전체 개방 → BFS 확산
    if newNodes.empty(): skip   // 새 감염 없으면 pruning

    SelectDFS(infectCnt + newNodes.size(), type, remain - 1)
    backtrack(newNodes)         // 감염 취소

SpreadBFS(openType):
  모든 감염 노드를 BFS 시작점으로 설정
  openType 타입 간선을 따라 미감염 노드로 연쇄 확산
  새로 감염된 노드 목록 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 파이프 개방 = 같은 타입 전체 동시 개방

파이프 하나하나를 선택하는 게 아니다.  
타입 A를 선택하면 **그래프 전체의 A타입 간선이 일제히 열리며** 감염이 연쇄 확산된다.

```
infected = {1}, edges: 1-[A]->2, 2-[A]->3, 3-[A]->4

타입 A 선택 시 → BFS flood-fill → {1, 2, 3, 4} 한 번에 감염
(1-hop만 퍼지는 게 아님!)
```

### 2️⃣ 연속 같은 타입만 금지 (전체 반복은 허용)

```
ABA  ✅  직전 타입이 B이므로 A 다시 가능
AAB  ❌  직전 타입이 A인데 A 선택 → 불가
```

k > 3이어도 유효한 시퀀스가 존재한다. (A→B→A→B→...)

### 3️⃣ 빈 step skip pruning 유효성

타입 t를 열었는데 새 감염 노드가 0개이면 → skip.

**왜 skip이 안전한가?**

BFS flood-fill은 한 번 실행되면 해당 타입으로 도달 가능한 노드를 **모두** 커버한다.  
따라서 같은 infected 집합에서 같은 타입을 다시 열어도 0개가 추가된다.

또한, 빈 step을 끼워서 직전 타입을 다시 쓰는 "bridge 패턴"도 무의미하다:

```
X → B(0 new) → X  :  2 step 소모, 감염 집합 변화 없음 (X는 이미 flood-fill 완료)
X → 다른 타입     :  1 step 소모로 동일하거나 더 좋은 결과
```

빈 step을 허용하면 ABA, ABAB, ABABAB... 처럼 무한히 재귀하므로 반드시 skip해야 한다.

---

## ⚠️ 주의사항 — 실수하기 쉬운 포인트

### ❌ 실수 1 : 1-hop 확산으로 구현

```cpp
// 잘못된 구현 — 감염 노드에서 1칸만 퍼짐
for (int u = 1; u <= nodes; u++) {
    if (!infected[u]) continue;
    for (pii edge : adj[u]) {
        if (edge.second == type) newNodes.push_back(edge.first);
    }
}
```

새로 추가된 노드에서 연쇄 확산이 일어나지 않는다.  
**BFS flood-fill로 구현해야 한다.**

---

### ❌ 실수 2 : 전체 반복 금지로 오해

```
"이전에 연 파이프 알파벳(A B C) 다시 열지만 않으면 되는거고"
→ "직전 타입만 피하면 된다"는 뜻이지, "한번 쓴 타입은 영원히 사용 불가"가 아님
```

전체 반복 금지로 구현하면 k > 3인 경우 모든 브랜치가 막혀 `ans = 1` 이 나온다.

---

### ❌ 실수 3 : infected 배열을 지역 vector로 선언

```cpp
// 지역 선언 → DFS/BFS 파라미터로 계속 넘겨야 함
vector<bool> infected(n + 1, false);
void SelectDFS(vector<bool>& infected, ...)
```

전역 `bool infected[301]`로 선언하고 함수에서 직접 접근하는 게 코드가 단순해진다.

---

### ❌ 실수 4 : 전역 배열 초기화 누락

```cpp
// ❌ 초기화 없이 시작점만 설정
infected[infection] = true;

// ✅ solution() 진입 시 초기화 후 시작점 설정
for (int i = 0; i <= n; i++)
{
    adj[i].clear();
    infected[i] = false;
}
infected[infection] = true;
```

프로그래머스는 `solution()`을 테스트케이스마다 반복 호출한다.  
전역 배열은 프로그램 시작 시 한 번만 0으로 초기화되므로, 이전 테스트의 감염 상태와 간선 정보가 남아 오답이 발생한다.

---

### ❌ 실수 5 : `pii` 값 복사

```cpp
// ❌ 8바이트 값 복사
for (pii edge : adj[curNode])

// ✅ 참조로 접근
for (const pii& edge : adj[curNode])
```

---

## ⏱️ 시간복잡도

**O(2^k × N)**

- DFS 분기: 매 step 최대 2가지 선택 (3종류 중 직전 타입 제외) → 최대 3 × 2^(k-1) 시퀀스
- 각 step에서 SpreadBFS: O(N + E) = O(N) (트리이므로 E = N-1)
- empty step pruning으로 실제 탐색 공간은 대폭 줄어듦
