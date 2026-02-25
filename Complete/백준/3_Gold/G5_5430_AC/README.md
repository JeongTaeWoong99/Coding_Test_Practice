**📅 작성일**: 2026-02-25

## 🔗 문제 링크

[백준 5430번 - AC](https://www.acmicpc.net/problem/5430)

**난이도**: Gold 5

---

## 🤔 접근법

R(뒤집기)과 D(첫번째 삭제)를 반복하는 문제.

매 함수마다 배열을 실제로 조작하면 R은 O(n), D(deque 없이)는 O(n)이 되어 전체 O(n × |p|)로 시간 초과.

핵심은 **R을 실제로 수행하지 않고 방향 플래그만 토글**하여 D 연산을 앞/뒤에서 O(1)으로 수행하는 것!

두 가지 구현 방식이 있는데, 같은 아이디어에서 자료구조 선택에 따라 성능 차이가 발생한다.

---

## 💡 정답 풀이 방법 (공통 아이디어)

**알고리즘**: 자료구조 + 방향 플래그

**핵심 아이디어**:

```
1. 배열을 자료구조에 저장 (deque<string> 또는 int 배열)
2. R → rev 플래그 토글 (실제 뒤집기 X, O(1))
3. D → rev 상태에 따라 앞/뒤 제거:
   - rev=false : 앞에서 제거 (pop_front / left++)
   - rev=true  : 뒤에서 제거 (pop_back  / right--)
4. 출력 시 rev 상태에 따라 정/역방향으로 출력
```

**시간복잡도**: O(|p| + n)
- 파싱: O(n)
- 함수 실행: O(|p|) — R, D 모두 O(1)
- 출력: O(n)

**공간복잡도**: O(n)

---

## 🔀 두 가지 구현 방법 비교

### 방법 1 : deque\<string\> 방식

**파싱**: 숫자 문자를 string에 누적 → deque에 push

```cpp
deque<string> dq;
string        numString;

for (char c : xString)
{
    if (isdigit(c))
        numString += c;
    else if (!numString.empty())
    {
        dq.push_back(numString);
        numString = "";
    }
}
```

**D 연산**:

```cpp
if (rev) dq.pop_back();
else     dq.pop_front();
```

---

### 방법 2 : int 배열 + 투 포인터 방식

**파싱**: 숫자를 int로 직접 계산 (`num * 10 + (c - '0')`) → 전역 배열에 저장

```cpp
int  left  = 0;
int  right = -1;
int  num   = 0;
bool inNum = false;

for (char c : xString)
{
    if (isdigit(c))  { num = num * 10 + (c - '0'); inNum = true; }
    else if (inNum)  { arr[++right] = num; num = 0; inNum = false; }
}
```

**D 연산**:

```cpp
if (rev) right--;
else     left++;
```

---

### 📊 성능 비교

| 항목 | deque\<string\> | int 배열 + 투 포인터 |
|------|-----------------|---------------------|
| **메모리** | 5932 KB | 3468 KB |
| **시간** | 48 ms | 28 ms |
| 원소당 크기 | ~32 bytes (string 객체 SSO) | 4 bytes (int) |
| D 연산 | pop_front / pop_back (힙 해제) | left++ / right-- (인덱스만) |
| 힙 할당 | 매 원소마다 발생 | 0회 (전역 배열 재사용) |
| 빈 배열 체크 | `dq.empty()` | `left > right` |

---

## 🔑 핵심 포인트

### 1️⃣ rev 플래그 : R의 O(1) 처리

R이 100,000번 연속 호출되어도 O(1). 실제로 뒤집으면 매번 O(n).

```cpp
if (i == 'R') rev = !rev;  // 플래그만 토글
```

---

### 2️⃣ 파싱 방식 차이 : string 누적 vs int 직접 계산

```cpp
// 방법 1 : string 누적 (string 객체 생성 발생)
numString += c;

// 방법 2 : int 직접 계산 (힙 할당 없음)
// "42" 파싱 과정 : '4' → num=4, '2' → num=4*10+2=42
num = num * 10 + (c - '0');
```

방법 2가 string 객체 생성 없이 바로 int로 변환하여 메모리/시간 효율적.

---

### 3️⃣ 투 포인터 : left/right 인덱스로 삭제

실제 원소를 지우지 않고 인덱스만 이동.

```
초기 : arr = [1, 2, 3, 4],  left=0, right=3
D(정방향) : left++ → left=1  →  유효 범위 [1,3] = [2,3,4]
D(역방향) : right-- → right=2  →  유효 범위 [1,2] = [2,3]
```

빈 배열 판단 : `left > right`이면 원소 없음.

---

### 4️⃣ 출력 시 rev 상태 처리

두 방법 모두 rev 플래그로 정/역방향 결정.

```cpp
// 방법 1 (deque 인덱스 역순)
if (rev) for i = size-1 → 0  :  cout << dq[i]
else     for i = 0 → size-1  :  cout << dq[i]

// 방법 2 (배열 인덱스 역순)
if (rev) for i = right → left  :  cout << arr[i]
else     for i = left → right  :  cout << arr[i]
```

---

## ⏱️ 시간복잡도

**O(|p| + n)**

**분석**:
- 파싱: O(n)
- 함수 실행 (|p|번): R → O(1), D → O(1) → 합계 O(|p|)
- 출력: O(n)
- **총합**: O(|p| + n)

---

## 💾 공간복잡도

**O(n)**

| 방법 | 사용 공간 | 실측 메모리 |
|------|----------|------------|
| deque\<string\> | O(n) — string 객체 × n | 5932 KB |
| int 배열 | O(n) — int × n (전역, 1회 할당) | 3468 KB |
