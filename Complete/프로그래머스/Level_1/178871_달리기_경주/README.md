**📅 작성일**: 2026-05-17

## 🔗 문제 링크

[프로그래머스 - 달리기 경주](https://school.programmers.co.kr/learn/courses/30/lessons/178871)

**난이도**: Level 1

---

## 🤔 접근법

callings에서 이름이 불릴 때마다 해당 선수가 바로 앞 선수를 추월하는 문제.

선형 탐색으로 이름을 찾으면 **O(n × m)** → `players` 최대 50,000 × `callings` 최대 1,000,000 = 약 500억 연산으로 TLE.

`unordered_map`으로 이름 → 현재 인덱스를 관리하면 조회가 **O(1)**이 되어 전체 **O(n + m)** 으로 해결.

---

## 💡 정답 풀이 방법

**알고리즘**: 해시맵 + 구현

```
1. posMap[이름] = 인덱스 초기화 (players 순회)
2. callings 순회:
   a. currentIdx = posMap[callName]       (현재 인덱스 O(1) 조회)
   b. frontName  = players[currentIdx-1]  (바로 앞 선수)
   c. players 배열에서 두 선수 swap
   d. posMap 업데이트:
      posMap[callName]  = currentIdx - 1
      posMap[frontName] = currentIdx
3. players 반환
```

---

## 🔑 핵심 개념

### 1️⃣ unordered_map으로 O(1) 조회

`players` 배열 탐색 없이 이름으로 현재 인덱스를 즉시 얻음.

```cpp
unordered_map<string, int> posMap;
for (int i = 0; i < (int)players.size(); i++)
    posMap[players[i]] = i;
```

### 2️⃣ 배열과 맵을 항상 동기화

`players` 배열과 `posMap`은 항상 일치해야 한다. swap 후 두 선수의 인덱스를 모두 갱신.

```cpp
swap(players[currentIdx], players[currentIdx - 1]);
posMap[callName]  = currentIdx - 1;
posMap[frontName] = currentIdx;
```

---

## ⏱️ 시간복잡도

**O(n + m)** — n: players 크기, m: callings 크기
