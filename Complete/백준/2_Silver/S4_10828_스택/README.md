**📅 작성일**: 2026-01-09

## 🔗 문제 링크

[백준 10828번 - 스택](https://www.acmicpc.net/problem/10828)

**난이도**: Silver 4

---

## 🤔 접근법

정수를 저장하는 스택을 구현하고, 주어진 명령어를 처리하는 문제.

5가지 명령어(push, pop, size, empty, top)를 구현해야 함.

**핵심**: STL `stack<int>`를 활용하여 간단히 구현!

---

## 💡 정답 풀이 방법

**알고리즘**: 스택(Stack) - STL 활용

**핵심 아이디어**:
```
1. N개의 명령어를 순서대로 입력받아 처리
2. 명령어별로 적절한 스택 연산 수행:
   - push X: 정수 X를 스택에 삽입
   - pop: 스택의 top을 출력하고 제거 (비어있으면 -1)
   - size: 스택에 들어있는 정수의 개수 출력
   - empty: 스택이 비어있으면 1, 아니면 0 출력
   - top: 스택의 top 출력 (비어있으면 -1)
```

---

## 🔑 핵심 포인트

### 1️⃣ STL stack 활용

```cpp
stack<int> stk;

// push 연산
stk.push(x);

// pop 연산
if (!stk.empty())
{
    cout << stk.top() << "\n";
    stk.pop();
}

// size 연산
cout << stk.size() << "\n";

// empty 연산
cout << (stk.empty() ? 1 : 0) << "\n";

// top 연산
if (!stk.empty())
    cout << stk.top() << "\n";
```

**✅ 핵심**:
- C++ STL의 `stack<int>` 사용으로 간단히 구현
- `push()`, `pop()`, `top()`, `size()`, `empty()` 메서드 제공
- 직접 구현할 필요 없이 STL 활용

### 2️⃣ 명령어 처리

```cpp
for(int i = 0; i < n; i++)
{
    cin >> s;

    if(s == "push")
    {
        cin >> x;
        stk.push(x);
    }
    else if(s == "pop")
    {
        // pop 처리
    }
    // ... 다른 명령어들
}
```

**✅ 핵심**: 문자열 비교로 명령어 구분
- `string` 타입으로 명령어를 받아서 `==` 연산자로 비교
- `if-else if` 체인으로 각 명령어별 처리

### 3️⃣ 빈 스택 확인

```cpp
// pop 또는 top 명령 처리 시
if(stk.empty())
    cout << -1 << "\n";
else
{
    cout << stk.top() << "\n";
    if(pop 명령) stk.pop();
}
```

**✅ 핵심**: `pop`과 `top` 명령 처리 전 반드시 빈 스택 체크
- `stk.empty()` 체크 없이 `stk.top()` 호출 시 런타임 에러
- 빈 스택일 경우 -1 출력

---

## 🚨 "맞왜틀" 방지 포인트

### 1️⃣ 빈 스택 체크 필수

```cpp
❌ cout << stk.top() << "\n";  // 스택이 비어있으면 런타임 에러!

✅ if(stk.empty())
    cout << -1 << "\n";
   else
    cout << stk.top() << "\n";
```

**이유:**
- `stk.top()` 호출 시 스택이 비어있으면 undefined behavior
- 반드시 `stk.empty()` 체크 후 접근

### 2️⃣ pop과 출력 순서

```cpp
❌ stk.pop();              // pop 먼저 하면 출력할 값이 사라짐!
   cout << ??? << "\n";

✅ cout << stk.top() << "\n";  // top으로 값 확인 후
   stk.pop();                   // pop으로 제거
```

**이유:**
- `pop()` 메서드는 값을 반환하지 않고 제거만 함
- 값을 출력하려면 `top()`으로 먼저 확인 후 `pop()` 호출

### 3️⃣ empty 명령의 삼항 연산자

```cpp
✅ cout << (stk.empty() ? 1 : 0) << "\n";
```

**이유:**
- `empty()`는 bool 타입 반환 (true/false)
- 문제에서 요구하는 출력 형식은 1/0 (정수)
- 삼항 연산자로 변환하여 출력

---

## ⏱️ 시간복잡도

**전체 시간복잡도**: **O(N)**

**상세 분석**:
```
1. N개의 명령어 처리 : O(N)
2. 각 명령어마다:
   - push/pop/top/size/empty : O(1)
   - 문자열 비교 : O(명령어 길이) ≈ O(1) (명령어가 짧음)

총합 : O(N)
     ≤ O(10,000)  (문제 조건: N ≤ 10,000)
```

**시간 제한 체크**:
- 0.5초 제한 → 약 5천만 연산 가능
- O(10,000) < 5천만 → 시간 내 통과 가능 ✅

---

## 💾 공간복잡도

**O(N)**

- `stk` : 최악의 경우 N개의 push 명령으로 N개 저장
  - 예: N=10,000일 때 모두 push 명령 → 10,000개 저장
- 최대 10,000개의 정수 저장 가능