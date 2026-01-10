**📅 작성일**: 2026-01-10

## 🔗 문제 링크

[백준 10845번 - 큐](https://www.acmicpc.net/problem/10845)

**난이도**: Silver 4

---

## 🤔 접근법

정수를 저장하는 큐를 구현하고, 주어진 6가지 명령을 처리하는 문제.

**핵심**: C++ STL `queue<int>`를 사용하면 간단히 해결!

---

## 💡 정답 풀이 방법

**알고리즘**: 큐 (Queue) - STL 활용

**핵심 아이디어**:
```
1. queue<int> 선언

2. 명령어를 입력받아 분기 처리
   - push X: que.push(x)
   - pop: que.front() 출력 후 que.pop()
   - size: que.size() 출력
   - empty: que.empty() 출력 (1 또는 0)
   - front: que.front() 출력
   - back: que.back() 출력
   
3. 큐가 비어있을 때는 -1 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ STL queue 주요 함수

```cpp
queue<int> que;

que.push(x);      // 큐에 x 추가 (뒤쪽에 삽입)
que.front();      // 맨 앞 원소 반환
que.back();       // 맨 뒤 원소 반환
que.pop();        // 맨 앞 원소 제거
que.size();       // 큐의 크기 반환
que.empty();      // 비어있으면 true, 아니면 false
```

**✅ 핵심**: 모든 연산이 **O(1)** 시간복잡도

### 2️⃣ 큐가 비어있을 때 처리

```cpp
if(que.empty())
    cout << -1 << "\n";
else
    cout << que.front() << "\n";
```

**✅ 핵심**: `pop`, `front`, `back` 명령 시 큐가 비어있으면 **-1** 출력

### 3️⃣ 명령어 분기 처리

```cpp
if(s == "push")
{
    cin >> x;
    que.push(x);
}
else if(s == "pop")
{
    // pop 처리
}
// ...
```

**✅ 핵심**: `push`는 추가 입력(x)이 필요하므로 별도로 `cin >> x` 처리

---

## 📊 동작 예시

```
명령: push 1   → 큐: [1]
명령: push 2   → 큐: [1, 2]
명령: front    → 출력: 1    (큐: [1, 2])
명령: back     → 출력: 2    (큐: [1, 2])
명령: size     → 출력: 2    (큐: [1, 2])
명령: empty    → 출력: 0    (큐: [1, 2])
명령: pop      → 출력: 1    (큐: [2])
명령: pop      → 출력: 2    (큐: [])
명령: pop      → 출력: -1   (큐: [])
```

---

## ⏱️ 시간복잡도

**O(N)**

**분석**:
- N개의 명령어를 순차 처리
- 각 명령어는 O(1) 시간에 처리
  - `push`, `pop`, `front`, `back`, `size`, `empty` 모두 O(1)
- 총합: O(N × 1) = **O(N)**

**시간 제한 체크**:
- N ≤ 10,000
- O(10,000) → 충분히 시간 내 통과 가능 ✅

---

## 💾 공간복잡도

**O(N)**

- `queue<int> que`: 최대 N개의 정수 저장 가능
- 최악의 경우: push만 N번 수행 → 큐에 N개 저장
