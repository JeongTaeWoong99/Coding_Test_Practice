**📅 작성일**: 2026-06-02

## 🔗 문제 링크

[프로그래머스 - 문자열 나누기](https://school.programmers.co.kr/learn/courses/30/lessons/140108)

**난이도**: Level 1

---

## 🤔 접근법

문자열의 첫 글자를 기준 문자로 정하고, 기준 문자와 나머지 문자의 등장 횟수가 같아질 때마다 하나의 구간으로 나누는 구현 문제.

외부 while로 구간 시작점을 이동하고, 내부 while로 동수 조건을 탐색한다.  
내부 while이 조건 없이 종료되는 경우(마지막 남은 구간)도 `splitCnt++`로 자동 처리된다.

---

## 💡 정답 풀이 방법

**알고리즘**: 구현

```
1. curIndex가 s 끝에 닿을 때까지 반복
2. base = s[curIndex] (현재 구간의 기준 문자)
3. s[curIndex]를 순회하며 base면 sameCnt++, 아니면 diffCnt++
4. sameCnt == diffCnt → break (나누기)
5. splitCnt++
6. splitCnt 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 마지막 구간 자동 카운트

내부 while이 `sameCnt == diffCnt` 없이 자연 종료되어도(마지막 남은 문자열) 외부 루프에서 `splitCnt++`가 실행되므로 별도 처리가 불필요하다.

```cpp
while (curIndex < (int)s.size())
{
    // sameCnt == diffCnt가 되지 않으면 그냥 while 종료
}
splitCnt++; // 마지막 남은 구간도 여기서 카운트됨
```

---

## ⏱️ 시간복잡도

**O(|s|)** — curIndex는 s를 정확히 한 번만 순회
