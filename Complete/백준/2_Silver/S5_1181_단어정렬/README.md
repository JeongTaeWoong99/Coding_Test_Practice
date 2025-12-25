**📅 작성일**: 2025-12-25

## 🔗 문제 링크

[백준 1181번 - 단어 정렬](https://www.acmicpc.net/problem/1181)

**난이도**: Silver 5

---

## 🤔 접근법

알파벳 소문자로 이루어진 N개의 단어를 특정 조건에 따라 정렬하는 문제.

정렬 조건은 다음과 같다:
1. **길이가 짧은 것부터** 정렬
2. **길이가 같으면 사전 순**으로 정렬
3. **중복된 단어는 하나만 남기고 제거**

**핵심**: 커스텀 비교 함수를 사용한 **정렬** + 중복 제거 문제

---

## 💡 정답 풀이 방법

**알고리즘**: 정렬(Sorting) + 문자열(String)

**핵심 아이디어**:
```
1. 커스텀 비교 함수 작성 (길이 → 사전 순)
2. sort() 함수로 정렬
3. 출력하면서 이전 단어와 비교하여 중복 제거
```

---

## 🔑 핵심 포인트

### 1️⃣ 커스텀 비교 함수

```cpp
// 비교 함수 : 길이 짧은 순 → 사전 순
bool cmp(string a, string b)
{
    if(a.length() != b.length())
        return a.length() < b.length();
    return a < b;
}
```

**✅ 핵심**:
- **1순위**: 길이가 다르면 짧은 것이 앞으로 (`a.length() < b.length()`)
- **2순위**: 길이가 같으면 사전 순 (`a < b`)
- string의 `<` 연산자는 사전 순 비교를 자동으로 수행

**예시**:
```
입력: ["but", "i", "wont", "hesitate", "no"]

길이별 그룹:
- 길이 1: ["i"]
- 길이 2: ["no"]
- 길이 3: ["but"]
- 길이 4: ["wont"]
- 길이 8: ["hesitate"]

각 그룹 내에서 사전 순 정렬 완료
```

### 2️⃣ 정렬 적용

```cpp
int            n;
vector<string> words;

// 입력 처리
cin >> n;
for(int i = 0; i < n; i++)
{
    string s;
    cin >> s;
    words.push_back(s);
}

// 정렬 : 길이 짧은 순 → 사전 순
sort(words.begin(), words.end(), cmp);
```

**✅ 핵심**:
- `sort(시작, 끝, 비교함수)` 형태로 커스텀 비교 함수 적용
- vector에 모든 단어를 저장한 후 한 번에 정렬

### 3️⃣ 중복 제거하며 출력

```cpp
// 중복 제거하며 출력
for(int i = 0; i < words.size(); i++)
{
    if(i > 0 && words[i] == words[i-1]) continue;

    cout << words[i] << "\n";
}
```

**✅ 핵심**:
- 정렬 후에는 **중복된 단어가 인접**해 있음
- 이전 단어(`words[i-1]`)와 비교하여 같으면 건너뛰기 (`continue`)
- 첫 번째 단어(`i=0`)는 이전 단어가 없으므로 `i > 0` 조건 필수

**예시**:
```
정렬 후: ["i", "im", "it", "no", "no", "but", "more", "more", ...]

출력 과정:
- i=0: "i" 출력 (첫 단어)
- i=1: "im" 출력 (이전과 다름)
- i=2: "it" 출력 (이전과 다름)
- i=3: "no" 출력 (이전과 다름)
- i=4: "no" 건너뜀 (이전과 같음)
- i=5: "but" 출력 (이전과 다름)
- i=6: "more" 출력 (이전과 다름)
- i=7: "more" 건너뜀 (이전과 같음)
...
```

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ 비교 함수 반환 타입

```cpp
❌ int cmp(string a, string b)    // 잘못된 반환 타입
{
    ...
}

✅ bool cmp(string a, string b)   // 올바른 반환 타입
{
    ...
}
```

**이유**:
- C++ sort 함수의 비교 함수는 **bool 타입**을 반환해야 함
- true: a가 b보다 앞에 와야 함
- false: b가 a보다 앞에 와야 함 (또는 순서 유지)

### 2️⃣ 비교 우선순위 순서

```cpp
❌ bool cmp(string a, string b)  // 잘못된 우선순위
{
    if(a < b)                    // 사전 순을 먼저 체크
        return true;
    return a.length() < b.length();
}

✅ bool cmp(string a, string b)  // 올바른 우선순위
{
    if(a.length() != b.length()) // 길이를 먼저 체크
        return a.length() < b.length();
    return a < b;
}
```

**이유**:
- 문제 요구: **1순위 길이**, **2순위 사전 순**
- 길이를 먼저 비교해야 올바른 정렬

**반례**:
```
입력: ["abc", "ab", "z"]

❌ 사전 순 우선: ["ab", "abc", "z"]  (길이 무시됨)
✅ 길이 우선: ["z", "ab", "abc"]     (길이 1 → 2 → 3)
```

### 3️⃣ 중복 제거 시 첫 번째 원소 체크

```cpp
❌ for(int i = 0; i < words.size(); i++)
{
    if(words[i] == words[i-1]) continue;  // i=0일 때 범위 초과!
    cout << words[i] << "\n";
}

✅ for(int i = 0; i < words.size(); i++)
{
    if(i > 0 && words[i] == words[i-1]) continue;  // i > 0 조건 필수
    cout << words[i] << "\n";
}
```

**이유**:
- `i=0`일 때 `words[i-1]` = `words[-1]`은 범위 초과 (undefined behavior)
- `i > 0` 조건으로 첫 번째 원소는 무조건 출력

### 4️⃣ unique() 함수 사용 시 주의

```cpp
❌ sort(words.begin(), words.end(), cmp);
   unique(words.begin(), words.end());  // 반환값 무시!
   for(auto w : words)
       cout << w << "\n";  // 중복이 여전히 출력됨

✅ 방법 1: erase-remove idiom
   sort(words.begin(), words.end(), cmp);
   words.erase(unique(words.begin(), words.end()), words.end());
   for(auto w : words)
       cout << w << "\n";

✅ 방법 2: 출력하면서 중복 체크 (더 간단)
   sort(words.begin(), words.end(), cmp);
   for(int i = 0; i < words.size(); i++)
   {
       if(i > 0 && words[i] == words[i-1]) continue;
       cout << words[i] << "\n";
   }
```

**이유**:
- `unique()` 함수는 중복을 제거하되 **실제로 vector 크기를 줄이지 않음**
- 중복이 아닌 원소들을 앞쪽으로 모은 후, **새로운 끝 위치를 반환**
- `erase()`와 함께 사용해야 실제 제거됨
- 본 문제에서는 **방법 2**가 더 간단하고 직관적

---

## 📊 시간복잡도 분석

**전체 시간복잡도**: **O(N log N)**

**상세 분석**:
```
1. 입력 처리 : O(N)
   - N개의 단어 입력

2. 정렬 : O(N log N)
   - sort() 함수는 퀵소트/머지소트 기반
   - 문자열 비교는 O(L) (L: 최대 길이 50)
   - 실제: O(N × L × log N) ≈ O(N log N) (L이 상수)

3. 중복 제거 및 출력 : O(N)
   - N번 순회하며 각 단어 비교 및 출력

총합 : O(N) + O(N log N) + O(N) = O(N log N)
```

**시간 제한 체크**:
- N ≤ 20,000 (문제 조건)
- N log N ≈ 20,000 × 15 ≈ 300,000
- **300,000 연산** << **1억** → 시간 내 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N × L)**
- `vector<string> words(N)` : N개의 단어 저장
- 각 단어의 최대 길이 L ≤ 50
- 총 메모리: 약 20,000 × 50 = 1MB (매우 효율적)

---

## 🎯 알고리즘 분류

- **정렬(Sorting)**: 커스텀 비교 함수를 사용한 정렬
- **문자열(String)**: 문자열 길이 비교 및 사전 순 정렬
