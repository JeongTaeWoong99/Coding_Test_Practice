**📅 작성일**: 2026-06-29

## 🔗 문제 링크

[프로그래머스 - 성격 유형 검사하기](https://school.programmers.co.kr/learn/courses/30/lessons/118666)

**난이도**: Level 1 (2022 KAKAO TECH INTERNSHIP)

---

## 🤔 접근법

4개의 지표 축(RT / CF / JM / AN)에 대해 설문 응답을 집계하여 최종 성격 유형 문자열을 만드는 시뮬레이션 문제.

**핵심 1**: `survey[i]`의 두 글자는 **순서가 바뀔 수 있다** (`"RT"` 또는 `"TR"`).
→ 문자열 전체를 비교(`survey[i] == "RT"`)하면 안 되고, **각 글자(char)를 개별로** 다뤄야 한다.

**핵심 2**: 첫 글자는 **비동의(1~3)** 시 점수를 받고, 둘째 글자는 **동의(5~7)** 시 점수를 받는다.
→ 응답 값을 `4`를 기준으로 양쪽으로 나누면, 어느 글자에 몇 점을 줄지 한 번에 정리된다.

```
응답 1~3 (비동의) → 첫 글자에  (4 - choice)점  : 1→3, 2→2, 3→1
응답   4 (모르겠음) → 점수 없음
응답 5~7 (동의)   → 둘째 글자에 (choice - 4)점 : 5→1, 6→2, 7→3
```

---

## 💡 정답 풀이 방법

**알고리즘**: 해시맵 누적 집계 + 축별 비교

```
1. unordered_map<char, int> score 로 각 지표 점수 누적
2. survey/choices 순회:
   a. first  = survey[i][0]  (비동의 지표)
   b. second = survey[i][1]  (동의   지표)
   c. choice < 4 → score[first]  += 4 - choice
      choice > 4 → score[second] += choice - 4
      choice == 4 → 무시
3. 축 문자열 "RTCFJMAN"을 두 글자씩 묶어 비교:
   score[a] >= score[b] ? a : b  (동점이면 알파벳 빠른 a)
4. 결과 문자열 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 문자열 전체가 아닌 char 단위 처리

`survey`의 두 글자는 순서가 보장되지 않으므로 `[0]`, `[1]`로 직접 접근한다.

```cpp
char curFirstAlpa  = survey[i][0]; // 비동의(1~3) 시 가리키는 지표
char curSecondAlpa = survey[i][1]; // 동의(5~7)   시 가리키는 지표
```

> ⚠️ **주의**: `survey[i] == "RT"`처럼 통째로 비교하면 `"TR"`, `"MJ"`, `"NA"` 같은 뒤집힌 입력을 놓쳐 점수가 0이 된다.

### 2️⃣ 4를 기준으로 한 점수 공식

응답 값(1~7)을 4 기준 거리로 환산하면 `if` 한 줄로 점수가 계산된다.

```cpp
if      (curChoice < 4) score[curFirstAlpa]  += 4         - curChoice; // 1→3, 2→2, 3→1
else if (curChoice > 4) score[curSecondAlpa] += curChoice - 4;         // 5→1, 6→2, 7→3
```

> ⚠️ **주의**: 동의 쪽을 `7 - choice` 같은 식으로 잘못 쓰면 점수가 거꾸로(5→3, 7→1) 들어간다. 동의는 `choice - 4`.

### 3️⃣ 정렬이 필요 없으니 unordered_map

지표 점수는 키 순서대로 꺼내 쓰지 않고, `"RTCFJMAN"` 순서를 **직접 지정**해 조회한다.
→ `map`(트리)의 정렬 기능이 불필요하므로 평균 O(1)인 `unordered_map`이 의도에 맞다.

```cpp
string axis = "RTCFJMAN"; // 두 글자씩 한 쌍, 앞 글자가 알파벳 우선
for (int i = 0; i < 8; i += 2)
    answer += (score[axis[i]] >= score[axis[i + 1]]) ? axis[i] : axis[i + 1];
```

> 💡 각 쌍의 앞 글자(R/C/J/A)가 항상 알파벳이 빠르므로, **동점 처리**를 `>=` 한 줄로 깔끔하게 해결.

---

## ⏱️ 시간복잡도

**O(n)** — n: survey(= choices) 크기. 마지막 축 비교는 상수(4쌍) 작업.
