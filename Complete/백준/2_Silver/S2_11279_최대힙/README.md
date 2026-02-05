**📅 작성일**: 2026-02-05

## 🔗 문제 링크

[백준 11279번 - 최대 힙](https://www.acmicpc.net/problem/11279)

**난이도**: Silver 2

---

## 🔄 관련 문제

> ⚠️ **이 문제는 [1927번 - 최소 힙](../S2_1927_최소힙/README.md)과 거의 동일합니다!**
>
> **차이점**: `priority_queue` 선언 **한 줄**만 다름

| 문제 | 연산 | priority_queue 선언 |
|------|------|---------------------|
| 1927 최소 힙 | 가장 **작은** 값 출력 | `priority_queue<int, vector<int>, greater<int>>` |
| **11279 최대 힙** | 가장 **큰** 값 출력 | `priority_queue<int>` **(기본값)** |

---

## 💡 핵심 코드 차이

### 최소 힙 (1927번)
```cpp
priority_queue<int, vector<int>, greater<int>> pQ;  // 최소 힙
```

### 최대 힙 (11279번) ⭐
```cpp
priority_queue<int> pQ;  // 최대 힙 (기본값!)
```

**✅ 최대 힙은 `priority_queue`의 기본값이라 간단함!**

---

## 🔑 priority_queue 복습

```cpp
priority_queue<T, Container, Compare>
```

| 타입 | 선언 | top()에 오는 값 |
|------|------|----------------|
| **최대 힙** | `priority_queue<int>` | 가장 **큰** 값 |
| 최소 힙 | `priority_queue<int, vector<int>, greater<int>>` | 가장 **작은** 값 |

**비교 함수**:
- `less<int>` (기본값): 큰 값이 top → **최대 힙**
- `greater<int>`: 작은 값이 top → **최소 힙**

---

## 📋 상세 설명

> **priority_queue 템플릿 매개변수, 빈 힙 처리, 시간/공간복잡도 등**
> **자세한 내용은 👉 [최소 힙 README](../S2_1927_최소힙/README.md) 참조**

---

## 🎯 알고리즘 분류

- **자료 구조 (Data Structure)**: 힙(Heap) 기반 우선순위 큐
- **우선순위 큐 (Priority Queue)**: 최댓값을 빠르게 찾는 자료구조
