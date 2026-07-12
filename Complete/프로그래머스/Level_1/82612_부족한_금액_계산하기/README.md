**📅 작성일**: 2026-07-12

## 🔗 문제 링크

[프로그래머스 - 부족한 금액 계산하기](https://school.programmers.co.kr/learn/courses/30/lessons/82612)

**난이도**: Level 1

---

## 🤔 접근법

놀이기구 이용료가 `price`이고, 이용할 때마다 1회씩 요금이 오르는(N번째 이용 시 `price × N`) 구조.
`count`번 이용하는 데 필요한 총 금액과, 가진 돈 `money`를 비교해 **부족한 금액**을 구하는 문제.

총 필요 금액은 등차수열의 합이다:
`price×1 + price×2 + ... + price×count = price × (1+2+...+count)`

`1+2+...+count = count(count+1)/2` 공식을 쓰면 반복 없이 **O(1)** 로 계산된다.

부족 금액은 `총 필요 금액 - money`이며, 돈이 충분하면(음수) 0을 반환한다.

---

## 💡 정답 풀이 방법

**알고리즘**: 수학 (등차수열 합)

```
1. total = price * count * (count + 1) / 2   (총 필요 금액)
2. lack  = total - money                     (부족 금액)
3. lack > 0 이면 lack, 아니면 0 반환
```

```cpp
long long total = (long long)price * count * (count + 1) / 2;
long long lack  = total - money;
return lack > 0 ? lack : 0;
```

---

## 🔑 핵심 개념

### 1️⃣ 등차수열 합 공식으로 O(1) 계산

`price`를 하나씩 누적하지 않고 `count(count+1)/2` 공식으로 한 번에 총액을 구한다.

### 2️⃣ 오버플로우 주의 — long long 캐스팅

`price`(최대 10만)와 `count`(최대 1000)의 곱은 int 범위를 넘길 수 있다.
반드시 계산 전에 `(long long)`으로 캐스팅해야 한다.

```cpp
long long total = (long long)price * count * (count + 1) / 2;
```

### 3️⃣ 부족하지 않으면 0

`money`가 충분하면 `total - money`가 음수가 되는데, 이때는 부족 금액이 없으므로 0을 반환한다.

---

## ⏱️ 시간복잡도

**O(1)** — 반복 없이 공식으로 즉시 계산