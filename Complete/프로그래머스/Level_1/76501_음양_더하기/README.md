**📅 작성일**: 2026-07-14

## 🔗 문제 링크

[프로그래머스 - 음양 더하기](https://school.programmers.co.kr/learn/courses/30/lessons/76501)

**난이도**: Level 1

---

## 🤔 접근법

절댓값 배열 `absolutes`와 부호 배열 `signs`가 주어질 때, 각 수의 실제 값을 모두 더한 결과를 구하는 문제.

두 배열은 인덱스가 서로 대응되므로, 같은 인덱스끼리 짝지어 부호에 따라 더하거나 빼면 된다.

- `signs[i] == true`  → 양수 → `absolutes[i]`를 **더한다**
- `signs[i] == false` → 음수 → `absolutes[i]`를 **뺀다**

---

## 💡 정답 풀이 방법

**알고리즘**: 배열 순회 (부호에 따른 누적 합)

```
1. answer = 0
2. 인덱스 i를 0부터 끝까지 순회
3. signs[i]가 true면 answer += absolutes[i], false면 answer -= absolutes[i]
4. answer 반환
```

```cpp
int answer = 0;
for (int i = 0; i < absolutes.size(); ++i)
{
    if (signs[i]) answer += absolutes[i];
    else          answer -= absolutes[i];
}
return answer;
```

---

## 🔑 핵심 개념

### 1️⃣ 두 배열의 인덱스 대응

`absolutes[i]`와 `signs[i]`는 같은 수를 가리킨다. 별도 매칭 없이 하나의 for문으로 함께 처리하면 된다.

### 2️⃣ 부호를 조건으로 더하기/빼기 선택

`bool` 값을 그대로 조건으로 사용해 누적 방향(+/-)만 바꿔주면 되는 단순한 구조다.

---

## ⏱️ 시간복잡도

**O(n)** — n: absolutes 크기 (배열을 한 번만 순회)
