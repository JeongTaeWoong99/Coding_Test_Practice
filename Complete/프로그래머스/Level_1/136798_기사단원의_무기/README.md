**📅 작성일**: 2026-06-05

## 🔗 문제 링크

[프로그래머스 - 기사단원의 무기](https://school.programmers.co.kr/learn/courses/30/lessons/136798)

**난이도**: Level 1

---

## 🤔 접근법

1번부터 number번까지 각 기사에게 **자신의 번호의 약수 개수**만큼 무게의 무기를 지급하는 시뮬레이션 문제.
약수 개수가 limit을 초과하면 power로 대체한다.

각 숫자의 약수를 모두 나열하지 않고, **√i까지만 탐색**해 약수 쌍으로 개수를 세면 O(√n)에 처리 가능하다.

---

## 💡 정답 풀이 방법

**알고리즘**: 브루트포스 + 약수 개수 계산

```
1. i = 1 ~ number 순회
2. j = 1 ~ √i 순회:
   a. i % j == 0 이면 divisorCnt++
   b. j != i / j (완전제곱수 아님) 이면 divisorCnt++ (대칭 약수)
3. divisorCnt > limit 이면 divisorCnt = power
4. totalWeight += divisorCnt
5. totalWeight 반환
```

---

## 🔑 핵심 개념

### 1️⃣ √i까지만 탐색해 약수 쌍으로 세기

약수는 항상 쌍으로 존재한다 (j × (i/j) = i). j와 i/j가 다르면 2개, 같으면 (완전제곱수) 1개만 추가.

```cpp
for (int j = 1; j * j <= i; j++)
{
    if (i % j == 0)
    {
        divisorCnt++;
        if (j != i / j)
            divisorCnt++;
    }
}
```

---

## ⏱️ 시간복잡도

**O(n√n)**
- n: number (최대 100,000)
- 각 i에 대해 O(√i) → 전체 O(n√n) ≈ O(100,000 × 316) = O(31,600,000)
