**📅 작성일**: 2026-05-13

## 🔗 문제 링크

[프로그래머스 - 붕대 감기](https://school.programmers.co.kr/learn/courses/30/lessons/250137)

**난이도**: Level 1 (PCCP 기출문제)

---

## 🤔 접근법

붕대 감기 스킬의 회복량을 계산하며 몬스터 공격을 처리하는 시뮬레이션 문제.

**핵심 규칙**:
- 공격과 공격 사이의 시간(`healSec`)만큼 초당 회복량이 쌓임
- `healSec / 시전시간` 으로 완전 시전 횟수를 구해 보너스 회복 적용
- 회복 후 최대 체력 초과 불가, 공격 후 체력 0 이하면 즉시 -1 반환

1초씩 for문을 돌리지 않고, **공격 사이 구간을 수학 공식으로 한 번에 계산**하면 간결하게 처리할 수 있다.

---

## 💡 정답 풀이 방법

**알고리즘**: 시뮬레이션

```
1. 공격마다 healSec = atkTime - prevAtk - 1 계산
2. healSec > 0이면:
   a. curHealth += healSec * perHeal         (초당 회복)
   b. curHealth += (healSec / needTime) * bonusHeal  (완전 시전 보너스)
   c. curHealth = min(curHealth, health)     (최대 체력 cap)
3. curHealth -= damage 후 0 이하면 -1 반환
4. prevAtk = atkTime 갱신
```

---

## 🔑 핵심 개념

### 1️⃣ 구간 회복 공식 — 1초씩 루프 대신 수학으로 처리

```cpp
int healSec = atkTime - prevAtk - 1; // 현재 공격 직전까지의 회복 가능 시간

curHealth += healSec * perHeal;                // 초당 회복
curHealth += (healSec / needTime) * bonusHeal; // 완전 시전 횟수 × 보너스
```

`healSec / needTime`은 정수 나눗셈이므로 완전 시전 완료 횟수를 자동으로 구한다.

### 2️⃣ 체력 상한 처리

```cpp
curHealth = min(curHealth, health); // 최대 체력 초과 불가
```

회복 후에만 cap 적용; 공격 피해는 cap 없이 그대로 감소.

---

## ⏱️ 시간복잡도

**O(n)** — n = attacks 길이 (최대 100)
