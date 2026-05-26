**📅 작성일**: 2026-05-26

## 🔗 문제 링크

[프로그래머스 - 카드 뭉치](https://school.programmers.co.kr/learn/courses/30/lessons/159994)

**난이도**: Level 1

---

## 🤔 접근법

cards1, cards2 각각의 순서를 유지하면서 goal 순서를 완성할 수 있는지 확인하는 시뮬레이션 문제.

goal[i]가 cards1의 현재 맨 앞과 같으면 cards1에서 소비, cards2의 현재 맨 앞과 같으면 cards2에서 소비, 둘 다 아니면 불가능.

---

## 💡 정답 풀이 방법

**알고리즘**: 그리디 / 시뮬레이션

`
1. cards1Num, cards2Num = 0 (각 카드 스택의 현재 위치)
2. goal 순회:
   a. goal[i] == cards1[cards1Num] → cards1Num++
   b. goal[i] == cards2[cards2Num] → cards2Num++
   c. 둘 다 아님              → isPossible = false, break
3. isPossible ? "Yes" : "No" 반환
`

---

## 🔑 핵심 개념

### 1️⃣ 반복문 조건 — < vs <=

`cpp
for (int i = 0; i < (int)goal.size(); i++)  // ✅
for (int i = 0; i <= goal.size(); i++)       // ❌ 범위 초과 (UB)
`

goal.size()는 size_t(부호 없음)이므로 (int) 캐스팅 필수.

### 2️⃣ 배열 접근 전 범위 체크

`cpp
if (cards1Num < (int)cards1.size() && goal[i] == cards1[cards1Num])
`

cards1Num이 cards1.size()에 도달한 뒤에도 goal이 남아있을 수 있으므로 범위 체크 후 접근.

### 3️⃣ 불가능 판정 즉시 break

`cpp
else
{
    isPossible = false;
    break;  // 불필요한 순회 차단
}
`

---

## ⏱️ 시간복잡도

**O(n)** — n: goal 크기 (goal을 최대 한 번 순회)