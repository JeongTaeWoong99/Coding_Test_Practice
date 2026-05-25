**📅 작성일**: 2026-05-25

## 🔗 문제 링크

[프로그래머스 - 대충 만든 자판](https://school.programmers.co.kr/learn/courses/30/lessons/160586)

**난이도**: Level 1

---

## 🤔 접근법

각 알파벳을 입력하기 위한 **최소 버튼 누름 횟수**를 미리 계산한 뒤, 각 타겟 문자열의 합산으로 해결하는 문제.

**핵심**: 같은 알파벳이 여러 keymap에 등장할 수 있으므로, 모든 keymap을 순회하며 **최솟값**을 갱신해두면 타겟 합산 시 O(1)로 조회 가능하다.

---

## 💡 정답 풀이 방법

**알고리즘**: 그리디 (전처리 + 선형 탐색)

```
1. minPress[26] 배열을 INT_MAX로 초기화
2. 모든 keymap 순회:
   a. i번째 위치 문자 c → i+1번 누름으로 입력 가능
   b. minPress[c - 'A'] = min(현재값, i+1)
3. 각 target 문자열 순회:
   a. 문자 c의 minPress가 INT_MAX이면 -1 처리
   b. 그 외엔 sum에 누적
4. answer에 sum 또는 -1 삽입
```

---

## 🔑 핵심 개념

### 1️⃣ 알파벳별 최소 누름 횟수 전처리

```cpp
fill_n(minPress, 26, INT_MAX);

for (auto& km : keymap)
    for (int i = 0; i < (int)km.size(); i++)
        minPress[km[i] - 'A'] = min(minPress[km[i] - 'A'], i + 1);
```

keymap 개수에 관계없이 각 알파벳의 최솟값만 기억하면 되므로 배열 크기는 항상 26.

### 2️⃣ 타이핑 불가능 문자 처리

어떤 keymap에도 없는 문자는 minPress가 INT_MAX로 남는다.
target 합산 중 INT_MAX를 만나면 해당 target은 -1.

```cpp
if (minPress[c - 'A'] == INT_MAX)
{
    possible = false;
    break;
}
```

---

## ⏱️ 시간복잡도

**O(K + T)**
- K: 모든 keymap 문자 수의 합
- T: 모든 target 문자 수의 합
