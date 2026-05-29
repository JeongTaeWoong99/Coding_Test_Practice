**📅 작성일**: 2026-05-29

## 🔗 문제 링크

[프로그래머스 - 개인정보 수집 유효기간](https://school.programmers.co.kr/learn/courses/30/lessons/150370)

**난이도**: Level 1 (2023 KAKAO BLIND RECRUITMENT)

---

## 🤔 접근법

유효기간(month)이 지난 개인정보를 파기 대상으로 찾는 시뮬레이션 문제.

**핵심 조건**: 모든 달은 28일 → 날짜를 **총 일수 단위 정수** 하나로 변환하면 덧셈과 대소 비교만으로 만료 판단이 가능하다.

변환 공식: `(year * 12 + month - 1) * 28 + day`
- `month - 1`: month는 1~12이므로 0-indexed(0~11)로 변환해야 1월이 0개월 오프셋이 됨

> ⚠️ **주의**: `month - 1`을 빼는 이유는 month가 1-indexed(1~12)이기 때문. 빼지 않으면 1월인데도 1개월치(28일)가 이미 더해진 상태가 됨.

---

## 💡 정답 풀이 방법

**알고리즘**: 날짜 정수 변환 + 시뮬레이션

```
1. terms를 map<char, int>로 파싱 → 약관 종류(char) : 유효기간(월)
2. today를 총 일수(todayDays)로 변환
3. privacies 순회:
   a. 수집일 앞 10자리 → 총 일수(privacyDays)
   b. index 11의 char → termMap에서 유효기간(term) 조회
   c. privacyDays + term * 28 <= todayDays → 파기 대상
4. 1-indexed 번호 수집 후 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 날짜 → 총 일수 변환

모든 달이 28일이므로 날짜를 하나의 정수로 선형 변환할 수 있다.

```cpp
int ToTotalDays(const string& date)
{
    int year  = stoi(date.substr(0, 4));
    int month = stoi(date.substr(5, 2));
    int day   = stoi(date.substr(8, 2));

    return (year * 12 + month - 1) * 28 + day;
}
```

> ⚠️ **주의**: `month - 1` 없이 `month`를 그대로 쓰면 1월이 0이 아닌 1로 계산되어 28일 오차 발생.

### 2️⃣ 약관 타입 파싱 — char 직접 접근

`privacies[i]` 형식: `"2021.05.02 A"` (index 11이 약관 종류)

`map<char, int>`이므로 `[11]`로 char를 직접 키로 사용.

```cpp
map<char, int> termMap;

for (string& t : terms)
    termMap[t[0]] = stoi(t.substr(2)); // t[0] : 약관 종류, t.substr(2) : 유효기간(월)

int term = termMap[privacies[i][11]]; // index 11의 char → map 조회
```

> ⚠️ **주의**: `stoi(t[2])` 형태도 안 됨. `t[2]`는 char이라 `stoi`에 넘길 수 없고, 유효기간이 두 자리("12")인 경우 첫 글자 '1'만 읽혀 값이 틀림. 반드시 `t.substr(2)`로 끝까지 잘라야 함.
>
> ⚠️ **주의**: `privacies[i].substr(11)` 또는 `privacies[i].substr(11, 1)`은 string `"A"`를 반환해 `map<char, int>`의 키 타입과 불일치 → 컴파일 에러.

### 3️⃣ 만료 판단 — 이하(≤) 조건

만료일 당일도 파기 대상이므로 `<`가 아닌 `<=` 사용.

```cpp
if (privacyDays + term * 28 <= todayDays)
    answer.emplace_back(i + 1); // 1-indexed
```

---

## ⏱️ 시간복잡도

**O(n + m)** — n: terms 크기, m: privacies 크기
