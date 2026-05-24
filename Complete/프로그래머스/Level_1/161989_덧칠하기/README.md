**📅 작성일**: 2026-05-24

## 🔗 문제 링크

[프로그래머스 - 덧칠하기](https://school.programmers.co.kr/learn/courses/30/lessons/161989)

**난이도**: Level 1

---

## 🤔 접근법

section 배열에서 가장 왼쪽 미칠 구역부터 m 길이로 칠하는 그리디 문제.

항상 **왼쪽 끝 미칠 구역**에서 오른쪽으로 m칸 칠하는 것이 최선이다.
→ 시작점을 왼쪽으로 당기면 오른쪽 커버 범위가 줄어들어 손해

---

## 💡 정답 풀이 방법

**알고리즘**: 그리디

```
1. startNum = 0 (section 배열 인덱스)
2. endNum = section[startNum] + m - 1 (이번 칠하기로 커버되는 마지막 위치)
3. endNum 이하인 section 원소를 모두 스킵
4. paintCount++
5. section 끝에 도달할 때까지 반복
```

---

## 🔑 핵심 개념

### 1️⃣ 그리디 — 왼쪽 끝에서 시작하는 이유

왼쪽 미칠 구역에서 오른쪽으로 m칸 칠하면, 해당 범위의 모든 구역을 한 번에 처리할 수 있다.
시작점을 왼쪽으로 당기면 오른쪽 커버가 줄어들어 항상 손해이므로, 이 방법이 최적이다.

### 2️⃣ 내부 while로 커버된 구역 스킵

```cpp
while (startNum < (int)section.size() && section[startNum] <= endNum)
{
    startNum++;
}
```

`endNum` 이하인 모든 section 원소는 이번 칠하기로 커버됨 → 스킵.

---

## 📊 테스트케이스 추적

### 케이스 1 — `n=8, m=4, section=[2,3,6]` → 2

```
startNum=0 → section[0]=2, endNum=5, paintCount=1
  section[0]=2 ≤ 5 → startNum=1
  section[1]=3 ≤ 5 → startNum=2
  section[2]=6 > 5 → stop

startNum=2 → section[2]=6, endNum=9, paintCount=2
  section[2]=6 ≤ 9 → startNum=3
  startNum=3 ≥ size → stop

return 2 ✅
```

### 케이스 2 — `n=5, m=4, section=[1,3]` → 1

```
startNum=0 → section[0]=1, endNum=4, paintCount=1
  section[0]=1 ≤ 4 → startNum=1
  section[1]=3 ≤ 4 → startNum=2
  startNum=2 ≥ size → stop

return 1 ✅
```

### 케이스 3 — `n=4, m=1, section=[1,2,3,4]` → 4

```
startNum=0 → section[0]=1, endNum=1, paintCount=1
  section[0]=1 ≤ 1 → startNum=1
  section[1]=2 > 1 → stop

startNum=1 → section[1]=2, endNum=2, paintCount=2
  section[1]=2 ≤ 2 → startNum=2
  section[2]=3 > 2 → stop

startNum=2 → section[2]=3, endNum=3, paintCount=3
  ...

startNum=3 → section[3]=4, endNum=4, paintCount=4

return 4 ✅
```

---

## ⏱️ 시간복잡도

**O(k)** — k: section 크기
- startNum은 section 배열을 단 한 번만 순회
