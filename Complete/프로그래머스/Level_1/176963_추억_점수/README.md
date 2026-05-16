**📅 작성일**: 2026-05-15

## 🔗 문제 링크

[프로그래머스 - 추억 점수](https://school.programmers.co.kr/learn/courses/30/lessons/176963)

**난이도**: Level 1

---

## 🤔 접근법

name 배열에서 각 사람의 그리움 점수를 **map으로 매핑**한 뒤, 각 사진에 등장하는 사람들의 점수 합을 구하는 구현 문제.

name에 없는 사람은 map 기본값(0)이 적용되어 별도 예외 처리 없이 합산 가능.

---

## 💡 정답 풀이 방법

**알고리즘**: 해시맵 + 구현

```
1. name[i] → yearning[i] 매핑을 map으로 구성
2. 각 사진(photo[i])에 등장하는 모든 사람 순회:
   - map에서 점수 조회 (없으면 0)
   - sum에 누적
3. sum을 answer에 push_back
4. answer 반환
```

---

## 🔑 핵심 개념

### 1️⃣ map 기본값 활용

`map<string, int>`에서 없는 키를 읽으면 `0`이 반환되므로, name에 없는 사람은 자동으로 0점 처리.

```cpp
map<string, int> score;
for (int i = 0; i < (int)name.size(); i++)
    score[name[i]] = yearning[i];
```

---

## ⏱️ 시간복잡도

**O(n + m × k × log n)** — n: name 크기, m: photo 수, k: 사진 당 인원 수 (map 조회 log n)
