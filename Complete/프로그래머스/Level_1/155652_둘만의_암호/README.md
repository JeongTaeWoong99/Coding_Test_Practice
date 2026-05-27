**📅 작성일**: 2026-05-27

## 🔗 문제 링크

[프로그래머스 - 둘만의 암호](https://school.programmers.co.kr/learn/courses/30/lessons/155652)

**난이도**: Level 1

---

## 🤔 접근법

s의 각 문자를 알파벳 순서로 index만큼 밀되, skip에 포함된 문자는 건너뛰는 구현 문제.

skip 문자를 `unordered_set`에 미리 저장해두면 이동 중 skip 여부를 **O(1)**로 확인할 수 있다.
z를 넘어가면 a로 순환하고, skip 문자가 아닐 때만 이동 횟수를 카운트한다.

---

## 💡 정답 풀이 방법

**알고리즘**: 구현 + 해시셋

```
1. skip 문자를 unordered_set에 저장
2. s의 각 문자에 대해:
   a. 현재 문자에서 한 칸씩 이동
   b. z 초과 시 a로 순환
   c. skip 문자가 아닐 때만 moveCnt 증가
   d. moveCnt == index가 되면 해당 문자가 결과
3. result 반환
```

---

## 🔑 핵심 개념

### 1️⃣ unordered_set으로 O(1) skip 확인

```cpp
unordered_set<char> skipAlapabat;
for (const auto &c : skip)
    skipAlapabat.insert(c);
```

### 2️⃣ skip 문자만 건너뛰며 한 칸씩 이동

z를 넘으면 a로 순환하고, skip이 아닐 때만 카운트한다.

```cpp
while (moveCnt < index)
{
    curAlapa++;
    if (curAlapa > 'z')
        curAlapa = 'a';
    if (skipAlapabat.count(curAlapa) == 0)
        moveCnt++;
}
```

---

## 🚀 개선 아이디어 — 유효 알파벳 배열 pre-build

skip을 제외한 유효 알파벳을 vector로 미리 추출하면, while 루프 없이 `% size` 인덱싱 한 번으로 처리 가능.
wrap-around를 `%` 연산이 자동으로 처리해 로직이 더 명확해진다.

```cpp
vector<char> validAlpha;
for (char c = 'a'; c <= 'z'; c++)
{
    if (skipAlapabat.count(c) == 0)
        validAlpha.emplace_back(c);
}

for (const auto &c : s)
{
    int curPos = find(validAlpha.begin(), validAlpha.end(), c) - validAlpha.begin();
    result += validAlpha[(curPos + index) % validAlpha.size()];
}
```

---

## ⏱️ 시간복잡도

**O(|s| × index)** — 각 문자마다 최대 index번 이동 (알파벳 최대 26자 범위로 실질적으로 O(|s|))