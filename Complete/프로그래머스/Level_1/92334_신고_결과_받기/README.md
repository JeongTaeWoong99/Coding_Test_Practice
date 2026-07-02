**📅 작성일**: 2026-07-02

## 🔗 문제 링크

[프로그래머스 - 신고 결과 받기](https://school.programmers.co.kr/learn/courses/30/lessons/92334)

**난이도**: Level 1 (2022 KAKAO BLIND RECRUITMENT)

---

## 🤔 접근법

각 유저의 신고 기록을 바탕으로 **정지된 유저를 신고한 사람에게 발송되는 메일 수**를 구하는 구현 문제.

**핵심 규칙**:
- 한 유저가 같은 유저를 여러 번 신고해도 **1건으로만 처리** (중복 제거 필요)
- k번 이상 신고당한 유저는 정지
- 정지된 유저를 신고한 모든 유저에게 안내 메일 발송

report 최대 200,000건이므로 이중 반복 대신 **해시 자료구조**로 O(n + m) 처리.

---

## 💡 정답 풀이 방법

**알고리즘**: 해시맵 + 구현

```
1. report 순회 (중복 제거하며 관계 저장):
   a. "신고자 피신고자" 를 공백 기준으로 분리
   b. "신고자_피신고자" 키가 이미 있으면 패스 (중복 신고)
   c. 처음이면: 피신고자 신고 수++, 피신고자의 신고자 목록에 추가
2. 피신고자별 신고 수 순회:
   - k 이상이면 정지 → 그를 신고한 사람들의 메일 수++
3. id_list 순서대로 각 유저의 메일 수를 answer에 담기
```

---

## 🔑 핵심 개념

### 1️⃣ unordered_set으로 중복 신고 제거

`"신고자_신고당한사람"` 문자열을 키로 저장해, 같은 조합이 다시 나오면 건너뛴다.

```cpp
string key = front + '_' + back;
if (checkSet.count(key)) continue;
checkSet.insert(key);
```

### 2️⃣ 피신고자 → 신고자 목록 역추적

정지 확정 후 "누구에게 메일을 보낼지" 바로 알기 위해, 피신고자별로 신고한 사람들을 미리 모아둔다.

```cpp
reportedCount[back]++;             // 피신고자 신고 수
reporters[back].push_back(front);  // 신고자 기록
```

### 3️⃣ 문자열 분리 (find + substr)

`"muzi frodo"` → `front = "muzi"`, `back = "frodo"` 로 분리.

```cpp
int    space = report[i].find(' ');
string front = report[i].substr(0, space);
string back  = report[i].substr(space + 1, report[i].size());
```

### 4️⃣ map 기본값 활용

`mailCount[id]`는 키가 없으면 `0`이 반환되므로, 메일을 한 통도 안 받은 유저는 별도 처리 없이 0으로 채워진다.

---

## ⏱️ 시간복잡도

**O(n + m)**
- n: id_list 크기 (최대 1,000)
- m: report 크기 (최대 200,000) → 중복 제거·집계 모두 해시로 O(1) 처리
