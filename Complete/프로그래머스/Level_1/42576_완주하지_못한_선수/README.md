**📅 작성일**: 2026-07-14

## 🔗 문제 링크

[프로그래머스 - 완주하지 못한 선수](https://school.programmers.co.kr/learn/courses/30/lessons/42576)

**난이도**: Level 1

---

## 🤔 접근법

마라톤에 참가한 선수 명단 `participant`와 완주한 선수 명단 `completion`이 주어진다.
완주자는 참가자보다 정확히 **한 명 적으며**, 그 한 명이 완주하지 못한 선수다.

동명이인이 있을 수 있으므로 단순 비교로는 안 되고, **이름별 등장 횟수**를 세야 한다.

- 참가자 명단은 `+1`
- 완주자 명단은 `-1`

이렇게 상쇄하면, 완주하지 못한 한 명만 개수가 **1로 남는다**.

> ⚠️ 참가자 수가 최대 100,000명이므로 정렬(O(n log n))이나 해시맵(O(n))으로 풀어야 한다.
> 이중 for문으로 하나씩 비교하면 O(n²)이라 시간 초과가 난다.

---

## 💡 정답 풀이 방법

**알고리즘**: 해시맵 (이름별 개수 카운트)

```
1. participant를 순회하며 countMap[이름]++
2. completion을 순회하며 countMap[이름]--
3. countMap에서 값이 0보다 큰(1로 남은) 이름을 찾아 반환
```

```cpp
unordered_map<string, int> countMap;

for (string& p : participant) countMap[p]++;
for (string& c : completion)  countMap[c]--;

for (auto& person : countMap)
    if (person.second > 0)
        return person.first;
```

---

## 🔑 핵심 개념

### 1️⃣ 동명이인 처리 = 개수 세기

이름이 중복될 수 있으므로 존재 여부(bool)가 아니라 **몇 번 나왔는지**를 세야 한다.
`+1 / -1` 상쇄로 남는 개수가 곧 완주하지 못한 인원이다.

> ⚠️ 그래서 `unordered_set`(중복 미저장)으로는 풀 수 없다. 동명이인이 하나로 합쳐져
> 개수 정보가 사라지기 때문. 개수를 세는 `map`, 또는 중복 저장하는 `multiset`이 필요하다.

### 2️⃣ 해시맵으로 O(n)

`unordered_map`은 평균 O(1) 조회/삽입이라, 전체를 두 번 순회해도 O(n)에 끝난다.

> 💡 정렬 후 앞에서부터 두 배열을 비교하는 O(n log n) 방식으로도 풀 수 있지만,
> 해시맵이 코드가 더 간결하고 빠르다.

---

## ⏱️ 시간복잡도

**O(n)** — n: participant 크기 (두 배열을 각각 한 번씩 순회)
