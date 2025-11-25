**📅 작성일**: 2025-11-25

## 🔗 문제 링크

[백준 2632번 - 피자판매](https://www.acmicpc.net/problem/2632)

**난이도**: Gold 2

---

## 🤔 접근법

(처음에는 투 포인터로 접근하려 했지만, **map을 활용한** 방**법이 더 효율적**이라는 것을 깨달음.)

(시간 초과와 범위 오류가 나서, 구현에 실패함. 애초에 횟수 카운트만 하면 되는데, 쓸데없는 탐색이 많아져, 시간초과가 났을 듯...)

두 종류의 원형 피자에서 연속된 조각들을 선택해서 목표 크기를 만드는 문제.

핵심은 **"모든 배열을 다 구하지 않고, 횟수(개수)를 기반으로 구하는 것"**!

- ❌ **비효율** : vector에 모든 부분합 저장 (중복 포함) → 메모리 낭비
- ✅ **효율적** : map<int, int>로 "값 → 횟수" 저장 → 메모리 절약 + 빠른 조회

---

## 💡 정답 풀이 방법

**알고리즘**: 누적 합 + Map + 조합 탐색

**핵심 아이디어**:
```
1. 원형 배열을 처리하기 위해 누적 합 배열을 2배 크기로 생성
2. 모든 연속 부분합을 생성하되, map에 "값 → 횟수" 형태로 저장
3. A만, B만, A+B 조합으로 목표 크기를 만드는 경우의 수 계산
```

**시간 복잡도**: O(m² log m + n² log n + want)
- 부분합 생성: O(m² + n²)
- map 삽입: O(m² log m + n² log n)
- 조합 탐색: O(want)

**공간 복잡도**: O(m² + n²)
- psum 배열: O(m + n)
- map: O(m² + n²) (최악의 경우 모든 값이 고유)

---

## 🔑 핵심 포인트

### 1️⃣ 왜 map<int, int>를 사용하는가?

**문제 상황**:
```
부분합: [2, 2, 3, 4, 4, 7]  ← 중복이 많음!
```

**❌ vector 방식 (비효율적)**:
```cpp
vector<int> sums = {2, 2, 3, 4, 4, 7};  // 크기 6
// 나중에 같은 값의 개수를 세야 함 → O(n) 추가 연산
```

**✅ map 방식 (효율적)**:
```cpp
map<int, int> cnt = {{2,2}, {3,1}, {4,2}, {7,1}};  // 크기 4
// 이미 개수가 저장되어 있음 → O(log n) 조회
```

**핵심**:
> "모든 배열을 다 구하면 안되고, 횟수를 기반으로 구한다"
>
> → vector에 중복 포함해서 모두 저장하지 말고
>
> → map으로 값과 횟수만 저장하라!

### 2️⃣ 원형 배열 처리 방법

```cpp
// A 피자 누적 합 (1~n)
for(int i = 1; i <= n; i++)
{
    psum_a[i] = psum_a[i - 1] + a[i];
}

// 원형 처리 (n+1 ~ 2n)
for(int i = n + 1; i <= 2 * n; i++)
{
    psum_a[i] = psum_a[i - 1] + a[i - n];  // 배열을 한 번 더 붙임
}
```

**핵심 원리**:
- 원형 배열 = 배열을 2번 이어붙인 것과 동일
- 누적 합으로 만들면 O(1)에 구간 합 계산 가능
- `psum[end] - psum[start]` = 구간 합

### 3️⃣ GenerateSubsums 함수의 동작 원리

```cpp
void GenerateSubsums(int pieceCount, int prefix[], map<int, int>& counter)
{
    // length: 선택할 조각의 개수 (1 ~ pieceCount)
    for(int length = 1; length <= pieceCount; length++)
    {
        // startIdx: 시작 인덱스
        for(int startIdx = length; startIdx <= pieceCount + length - 1; startIdx++)
        {
            int subsum = prefix[startIdx] - prefix[startIdx - length]; // 구간 합
            counter[subsum]++;                                         // 횟수 증가

            if(length == pieceCount) break;  // 전체 피자는 1번만 계산
        }
    }
}
```

**핵심**:
- `length`: 선택할 조각의 개수 (1 ~ pieceCount)
- `startIdx`: 시작 위치 (length ~ pieceCount + length - 1)
- 전체 피자(length == pieceCount)는 1번만 계산 (중복 방지)

### 4️⃣ 조합 탐색 로직

```cpp
// A만 또는 B만 사용
totalWays = countA[targetSize] + countB[targetSize];

// A와 B를 조합
for(int sizeA = 1; sizeA < targetSize; sizeA++)
{
    int sizeB = targetSize - sizeA;
    totalWays += countA[sizeA] * countB[sizeB];
}
```

**핵심**:
- A에서 `sizeA` 크기, B에서 `sizeB` 크기를 선택
- 각각의 경우의 수를 곱해서 누적
- map에 이미 횟수가 저장되어 있으므로 O(1) 조회

---

## 📊 예제 1 상세 시뮬레이션 (단계별)

**입력**:
```
7            ← 목표 크기
5 3          ← A 피자 5조각, B 피자 3조각
2            ┐
2            │
1            │ A 피자 (원형)
7            │
2            ┘
6            ┐
8            │ B 피자 (원형)
3            ┘
```

<br>

### 🔄 Step 1: 입력

```
targetSize = 7
numA = 5, numB = 3
pizzaA[] = {_, 2, 2, 1, 7, 2}  (1-based 인덱스)
pizzaB[] = {_, 6, 8, 3}
```

<br>

### 🔄 Step 2: A 피자 누적 합 계산

```cpp
for(int i = 1; i <= numA; i++)
{
    prefixA[i] = prefixA[i - 1] + pizzaA[i];
}
```

**결과**:
```
i       | 0 | 1 | 2 | 3 | 4 | 5 |
────────┼───┼───┼───┼───┼───┼───┤
pizzaA  |   | 2 | 2 | 1 | 7 | 2 |
prefixA | 0 | 2 | 4 | 5 | 12| 14|
```

**설명**:
- `prefixA[1] = 0 + 2 = 2`
- `prefixA[2] = 2 + 2 = 4`
- `prefixA[3] = 4 + 1 = 5`
- `prefixA[4] = 5 + 7 = 12`
- `prefixA[5] = 12 + 2 = 14`

<br>

### 🔄 Step 3: A 피자 원형 배열 처리

```cpp
for(int i = numA + 1; i <= 2 * numA; i++)
{
    prefixA[i] = prefixA[i - 1] + pizzaA[i - numA];
}
```

**💡 이 코드의 의미**:

이 코드는 사실 **Step 2와 Step 3을 합친 것**과 같습니다!

**🔸 일반적인 방법 (배열 2배로 만들고 누적 합 1번 계산)**:
```cpp
// 1단계: 배열을 2배로 이어붙이기
for(int i = 1; i <= numA; i++)
{
    pizzaA[numA + i] = pizzaA[i];  // [2,2,1,7,2,2,2,1,7,2]
}

// 2단계: 전체 배열에 누적 합 공식 적용
for(int i = 1; i <= 2 * numA; i++)
{
    prefixA[i] = prefixA[i - 1] + pizzaA[i];
}
```

**🔸 현재 코드의 방법 (배열 이어붙이기 + 누적 합을 동시에)**:
```cpp
// Step 2에서 이미 1~numA까지 누적 합 계산 완료
// Step 3에서 numA+1~2*numA 구간만 추가로 계산
for(int i = numA + 1; i <= 2 * numA; i++)
{
    prefixA[i] = prefixA[i - 1] + pizzaA[i - numA];
    // prefixA[i-1]:      이전까지의 누적 합
    // pizzaA[i - numA]:  원래 배열의 값 (배열 이어붙이기 효과)
}
```

**🎯 핵심**:
- `pizzaA[i - numA]`를 사용하면 배열을 실제로 2배로 만들지 않아도 됨!
- `prefixA[i-1] + pizzaA[i-numA]`는 "배열 이어붙이기 + 누적 합"을 동시에 수행
- 메모리 효율적 + 코드 간결

**결과**:
```
i       | 0 | 1 | 2 | 3 | 4 | 5            | 6 | 7 | 8 | 9 | 10|
────────┼───┼───┼───┼───┼───┼─── (2배 구간) ┼───┼───┼───┼───┼───┤
pizzaA  |   | 2 | 2 | 1 | 7 | 2            | 2 | 2 | 1 | 7 | 2 |
prefixA | 0 | 2 | 4 | 5 | 12| 14           | 16| 18| 19| 26| 28|
```

**설명**:
- `prefixA[6] = 14 + pizzaA[1] = 14 + 2 = 16`
- `prefixA[7] = 16 + pizzaA[2] = 16 + 2 = 18`
- `prefixA[8] = 18 + pizzaA[3] = 18 + 1 = 19`
- `prefixA[9] = 19 + pizzaA[4] = 19 + 7 = 26`
- `prefixA[10] = 26 + pizzaA[5] = 26 + 2 = 28`

**💡 원형 처리의 의미**:
- 원래 배열: [2, 2, 1, 7, 2]
- 2배 배열: [2, 2, 1, 7, 2, 2, 2, 1, 7, 2]
- 이제 어떤 시작점에서든 연속된 부분을 선택 가능!

<br>

### 🔄 Step 4: B 피자 누적 합 계산

```cpp
for(int i = 1; i <= numB; i++)
{
    prefixB[i] = prefixB[i - 1] + pizzaB[i];
}
```

**결과**:
```
i       | 0 | 1 | 2 | 3 |
────────┼───┼───┼───┼───┤
pizzaB  |   | 6 | 8 | 3 |
prefixB | 0 | 6 | 14| 17|
```

<br>

### 🔄 Step 5: B 피자 원형 배열 처리

```cpp
for(int i = numB + 1; i <= 2 * numB; i++)
{
    prefixB[i] = prefixB[i - 1] + pizzaB[i - numB];
}
```

**💡 Step 4와 Step 5는 사실 배열을 2배로 만들고 누적 합을 1번 구한 것과 같습니다!**

Step 3과 동일한 원리:
- `pizzaB[i - numB]`를 사용하여 배열을 실제로 2배로 만들지 않고도 이어붙이기 효과
- 누적 합 계산과 배열 확장을 동시에 수행
- `prefixB[i] = prefixB[i-1] + pizzaB[i-numB]` = "이전 누적합 + 원래 배열의 값"

**결과**:
```
i       | 0 | 1 | 2 | 3            | 4 | 5 | 6 |
────────┼───┼───┼───┼─── (2배 구간) ┼───┼───┼───┤
pizzaB  |   | 6 | 8 | 3            | 6 | 8 | 3 |
prefixB | 0 | 6 | 14| 17           | 23| 31| 34|
```

<br>

### 🔄 Step 6: 모든 연속 부분합 생성

#### A 피자 부분합 생성 (GenerateSubsums 함수 실행)

```cpp
GenerateSubsums(5, prefixA, countA);
```

**length = 1 (길이 1)**:
```
startIdx=1: prefixA[1] - prefixA[0] = 2 - 0 = 2    → countA[2]++
startIdx=2: prefixA[2] - prefixA[1] = 4 - 2 = 2    → countA[2]++
startIdx=3: prefixA[3] - prefixA[2] = 5 - 4 = 1    → countA[1]++
startIdx=4: prefixA[4] - prefixA[3] = 12 - 5 = 7   → countA[7]++
startIdx=5: prefixA[5] - prefixA[4] = 14 - 12 = 2  → countA[2]++
```

**length = 2 (길이 2)**:
```
startIdx=2: prefixA[2] - prefixA[0] = 4 - 0 = 4    → countA[4]++
startIdx=3: prefixA[3] - prefixA[1] = 5 - 2 = 3    → countA[3]++
startIdx=4: prefixA[4] - prefixA[2] = 12 - 4 = 8   → countA[8]++
startIdx=5: prefixA[5] - prefixA[3] = 14 - 5 = 9   → countA[9]++
startIdx=6: prefixA[6] - prefixA[4] = 16 - 12 = 4  → countA[4]++
```

**length = 3 (길이 3)**:
```
startIdx=3: prefixA[3] - prefixA[0] = 5 - 0 = 5    → countA[5]++
startIdx=4: prefixA[4] - prefixA[1] = 12 - 2 = 10  → countA[10]++
startIdx=5: prefixA[5] - prefixA[2] = 14 - 4 = 10  → countA[10]++
startIdx=6: prefixA[6] - prefixA[3] = 16 - 5 = 11  → countA[11]++
startIdx=7: prefixA[7] - prefixA[4] = 18 - 12 = 6  → countA[6]++
```

**length = 4 (길이 4)**:
```
startIdx=4: prefixA[4] - prefixA[0] = 12 - 0 = 12  → countA[12]++
startIdx=5: prefixA[5] - prefixA[1] = 14 - 2 = 12  → countA[12]++
startIdx=6: prefixA[6] - prefixA[2] = 16 - 4 = 12  → countA[12]++
startIdx=7: prefixA[7] - prefixA[3] = 18 - 5 = 13  → countA[13]++
startIdx=8: prefixA[8] - prefixA[4] = 19 - 12 = 7  → countA[7]++
```

**length = 5 (길이 5, 전체 피자)**:
```
startIdx=5: prefixA[5] - prefixA[0] = 14 - 0 = 14  → countA[14]++
break;  ← 전체 피자는 1번만 계산!
```

**최종 countA**:
```
countA = {
    1:1,   2:3,   3:1,   4:2,   5:1,
    6:1,   7:2,   8:1,   9:1,   10:2,
    11:1,  12:3,  13:1,  14:1
}
```

#### B 피자 부분합 생성

```cpp
GenerateSubsums(3, prefixB, countB);
```

**length = 1 (길이 1)**:
```
startIdx=1: prefixB[1] - prefixB[0] = 6 - 0 = 6    → countB[6]++
startIdx=2: prefixB[2] - prefixB[1] = 14 - 6 = 8   → countB[8]++
startIdx=3: prefixB[3] - prefixB[2] = 17 - 14 = 3  → countB[3]++
```

**length = 2 (길이 2)**:
```
startIdx=2: prefixB[2] - prefixB[0] = 14 - 0 = 14  → countB[14]++
startIdx=3: prefixB[3] - prefixB[1] = 17 - 6 = 11  → countB[11]++
startIdx=4: prefixB[4] - prefixB[2] = 23 - 14 = 9  → countB[9]++
```

**length = 3 (길이 3, 전체 피자)**:
```
startIdx=3: prefixB[3] - prefixB[0] = 17 - 0 = 17  → countB[17]++
break;  ← 전체 피자는 1번만 계산!
```

**최종 countB**:
```
countB = {
    3:1,   6:1,   8:1,   9:1,
    11:1,  14:1,  17:1
}
```

<br>

### 🔄 Step 7: 조합 탐색

```cpp
// A만 또는 B만 사용
totalWays = countA[7] + countB[7];
         = 2 + 0
         = 2
```

```cpp
// A와 B를 조합
for(int sizeA = 1; sizeA < 7; sizeA++)
{
    int sizeB = 7 - sizeA;
    totalWays += countA[sizeA] * countB[sizeB];
}
```

**상세 계산**:
```
sizeA=1, sizeB=6: countA[1] * countB[6] = 1 × 1 = 1
sizeA=2, sizeB=5: countA[2] * countB[5] = 3 × 0 = 0
sizeA=3, sizeB=4: countA[3] * countB[4] = 1 × 0 = 0
sizeA=4, sizeB=3: countA[4] * countB[3] = 2 × 1 = 2
sizeA=5, sizeB=2: countA[5] * countB[2] = 1 × 0 = 0
sizeA=6, sizeB=1: countA[6] * countB[1] = 1 × 0 = 0

합계: 1 + 0 + 0 + 2 + 0 + 0 = 3
```

**최종 결과**:
```
totalWays = 2 (A만) + 3 (A+B 조합) = 5 ✅
```

<br>

### ✅ Step 8: 5가지 방법 확인

**1️⃣ A만 사용 (2가지)**:
- A 피자에서 크기 7: `countA[7] = 2`
  - 방법1: 인덱스 4, 길이 1 → [7]
  - 방법2: 인덱스 5, 길이 4 → [2, 2, 2, 1] (원형)

**2️⃣ B만 사용 (0가지)**:
- B 피자에서 크기 7: `countB[7] = 0`

**3️⃣ A+B 조합 (3가지)**:
- A=1, B=6: `1 × 1 = 1`가지
  - A에서 [1], B에서 [6]
- A=4, B=3: `2 × 1 = 2`가지
  - A에서 [2,2] 또는 [1,7]의 원형, B에서 [3]

**총합: 2 + 0 + 3 = 5가지** 🎉

---

## 🚨 주의사항

1. **1-based 인덱스**: 배열과 누적 합은 모두 1부터 시작
2. **원형 배열 크기**: 누적 합 배열은 2배 크기(`2 * numA + 1`, `2 * numB + 1`)로 선언
3. **전체 피자 중복 방지**: `if(length == pieceCount) break;`로 1번만 계산
4. **map 사용의 이점**: 값과 횟수를 동시에 저장하여 효율적
5. **조합 범위**: `for(int sizeA = 1; sizeA < targetSize; sizeA++)` → `sizeA < targetSize` (등호 없음)
   - 이유: A만, B만 사용하는 경우는 이미 처리했으므로

---

## ⏱️ 시간복잡도

**O(numA² log numA + numB² log numB + targetSize)**

**분석**:
1. **A 피자 누적 합**: O(numA)
2. **A 원형 처리**: O(numA)
3. **B 피자 누적 합**: O(numB)
4. **B 원형 처리**: O(numB)
5. **GenerateSubsums(A)**: O(numA²)
   - 외부 루프: O(numA)
   - 내부 루프: 평균 O(numA)
   - map 삽입: O(log numA)
   - 총: O(numA² log numA)
6. **GenerateSubsums(B)**: O(numB² log numB)
7. **조합 탐색**: O(targetSize)
   - 각 sizeA마다 map 조회 2번: O(log numA + log numB)
   - 총: O(targetSize × log(numA × numB))
8. **전체**: O(numA² log numA + numB² log numB + targetSize)

**제한 조건**:
- numA, numB ≤ 1,000
- targetSize ≤ 2,000,000
- 1,000² × log(1,000) ≈ 10,000,000 (충분히 빠름) ✅

---

## 💾 공간복잡도

**O(numA² + numB²)**

**분석**:
- `pizzaA`, `pizzaB` 배열: O(numA + numB)
- `prefixA`, `prefixB` 배열: O(numA + numB)
- `countA` map: O(numA²) (최악의 경우 모든 부분합이 고유)
- `countB` map: O(numB²)
- **총합**: O(numA² + numB²)