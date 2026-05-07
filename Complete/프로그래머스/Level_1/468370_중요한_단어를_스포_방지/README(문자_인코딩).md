**📅 작성일**: 2026-05-07

## 🔗 문제 링크

[프로그래머스 - 중요한 단어를 스포 방지](https://school.programmers.co.kr/learn/courses/30/lessons/468370)

**난이도**: Level 1 (2025 카카오 하반기 1차)

---

## 🤔 접근법

메시지에서 스포일러 구간이 주어질 때, 스포일러 단어 중 **처음 공개되는 고유한 단어**를 세는 문제.

**핵심**: 스포일러 구간의 문자를 `*`로 치환하면, 위치 정보가 문자 자체에 암묵적으로 인코딩된다.  
원본 단어와 blinded 단어는 문자열 자체가 달라지므로, set 조회만으로 판별 가능.

---

## 💡 정답 풀이 방법

**알고리즘**: 문자 치환 인코딩 + stringstream 파싱 + set 중복 체크

```
1. 스포일러 구간의 비공백 문자를 '*'로 치환한 blinds 문자열 생성
   (공백은 유지 — 단어 구분자를 보존해야 함)
2. blinds에서 단어 추출 → wordSet에 저장
   (스포일러 단어는 '*' 포함 형태로, 비스포일러 단어는 원본 그대로 저장됨)
3. 원본 message에서 단어 순회
   - wordSet에 없는 단어 → 처음 등장하는 스포일러 단어 → count++, wordSet에 추가
   - wordSet에 있는 단어 → 비스포일러 단어거나 이미 등장한 스포일러 단어 → skip
```

---

## 🔑 핵심 개념

### 1️⃣ 위치 정보를 문자로 인코딩하는 발상

```
원본:   "my phone number ..."
spoiler [5,5] → 문자 위치 5번만 치환
blinds: "my ph*ne number ..."
```

`"phone"` 과 `"ph*ne"` 은 완전히 다른 문자열이다.  
→ wordSet에는 `"ph*ne"` 이 들어가고, 원본 `"phone"` 은 wordSet에 없음  
→ "처음 공개된 스포일러 단어" 로 자동 판별

**공백을 치환하지 않는 이유**: 공백이 사라지면 단어 구분자가 깨져 파싱이 불가능해진다.

---

### 2️⃣ stringstream으로 단어 파싱

```cpp
stringstream ss(blinds);
string word;

while (ss >> word)
{
    wordSet.emplace(word);
}
```

`>>` 연산자는 공백 기준으로 토큰을 자동 분리한다.  
별도의 cursor 이동 없이 단어 추출 가능.

---

## 📊 예시 추적 (예시 1)

```
message = "here is muzi here is a secret message"
spoiler = [[0,3], [23,28]]
```

**치환 후 blinds:**
```
"**** is muzi here is a ****** message"
  ↑[0,3]              ↑[23,28]
```

**wordSet (blinds에서 추출):**
```
{ "****", "is", "muzi", "here", "a", "******", "message" }
```

**원본 순회:**
```
"here"    → wordSet에 있음 ("here" 비스포일러로 포함됨) → skip
"is"      → 있음 → skip
"muzi"    → 있음 → skip
"here"    → 있음 → skip
"is"      → 있음 → skip
"a"       → 있음 → skip
"secret"  → 없음 (wordSet엔 "******"만 있음) → ✅ count=1
"message" → 있음 → skip

→ answer = 1 ✅
```

---

## ⏱️ 시간복잡도

**O(총 스포일러 문자 수 + W log W)**
- 치환 단계: O(총 스포일러 구간 길이) ≤ O(msgLen)
- stringstream 파싱: O(msgLen)
- set 조회: O(log W) per word (set 기준)
- 전체: O(msgLen + W log W)

---

## 🔄 다른 풀이와 비교

| 항목 | 이 풀이 (문자 인코딩) | 다른 풀이 (위치 추적) |
|------|----------------------|----------------------|
| 핵심 아이디어 | 스포일러 구간을 `*`로 치환해 위치를 문자에 인코딩 | 단어 위치를 구간과 직접 비교 |
| 단어 파싱 | `stringstream >>` 자동 처리 | 직접 구현 (cursor 이동) |
| 스포일러 판별 | wordSet에 없으면 자동 판별 | `IsSpoiler` 함수로 명시적 계산 |
| 구간 탐색 비용 | O(총 스포일러 문자 수) | O(W × S) |
| 코드 길이 | 짧다 | 길다 |
| 직관성 | 아이디어 파악 전까지 이해하기 어려움 | 풀이 흐름이 명확하게 드러남 |
