**📅 작성일**: 2026-03-28

## 🔗 문제 링크

[백준 7662번 - 이중 우선순위 큐](https://www.acmicpc.net/problem/7662)

**난이도**: Gold 4

---

## 🤔 접근법

처음에는 `priority_queue` 하나로 해결할 수 있을 것 같았지만, **`priority_queue`는 한쪽 끝만 O(log n)**으로 접근 가능하다는 한계가 있다.

이 문제는 최댓값 삭제(`D 1`)와 최솟값 삭제(`D -1`) **양쪽 끝을 모두 O(log n)으로 처리**해야 하므로, 내부적으로 레드블랙트리(Red-Black Tree)를 사용하는 `multiset`이 적합하다.

---

## 💡 정답 풀이 방법

**알고리즘**: multiset (레드블랙트리)

**핵심 아이디어**:

```
1. multiset<int>은 항상 정렬된 상태 유지 (레드블랙트리)
2. begin()  → 최솟값 (맨 왼쪽 노드)  — O(log n) 접근
3. rbegin() → 최댓값 (맨 오른쪽 노드) — O(log n) 접근
4. 빈 상태에서 D 연산 → 무시
```

**시간복잡도**: O(k log k)
- 삽입/삭제 모두 O(log k)
- k개 연산이므로 O(k log k)

**공간복잡도**: O(k)
- multiset에 최대 k개 저장

---

## 🔑 핵심 포인트

### 1️⃣ priority_queue vs multiset — 왜 multiset인가?

**Binary Heap (priority_queue) 내부 구조**:

```
max-heap 예시: [10, 9, 3, 7, 5] 삽입

        10          ← top() = 최댓값만 보장
       /  \
      9    3
     / \
    7   5

맨 뒤 원소 = 불확실 (최솟값 위치 보장 없음)
→ 반대쪽 끝을 찾으려면 O(n) 전체 탐색 필요
```

**Red-Black Tree (multiset) 내부 구조**:

```
{3, 5, 7, 9, 10} 삽입

        7
       / \
      5   9
     /     \
    3       10

in-order 순회 = 3 → 5 → 7 → 9 → 10 (항상 정렬 상태)

begin()  → 맨 왼쪽 = 3  (최솟값 보장)
rbegin() → 맨 오른쪽 = 10 (최댓값 보장)
```

**비교 요약**:

| | 최댓값 접근 | 최솟값 접근 | 이 문제 적합도 |
|---|---|---|---|
| `priority_queue` (max-heap) | ✅ O(log n) | ❌ O(n) | ❌ |
| `priority_queue` (min-heap) | ❌ O(n) | ✅ O(log n) | ❌ |
| `multiset` | ✅ O(log n) | ✅ O(log n) | ✅ |

> 핵심 차이: Heap은 **"한쪽만 빠른 불완전 정렬"**, Tree는 **"전체가 정렬된 완전 정렬"**

---

### 2️⃣ C++ STL 자료구조 비교표

| 자료구조 | 내부 알고리즘 | 최솟값 | 최댓값 | 중복 허용 | 순서 보장 | 삽입/삭제 |
|---|---|---|---|---|---|---|
| `priority_queue<T>` | Binary Heap | ❌ O(n) | ✅ O(1) top | ✅ | ❌ | O(log n) |
| `priority_queue<T, vector<T>, greater<T>>` | Binary Heap | ✅ O(1) top | ❌ O(n) | ✅ | ❌ | O(log n) |
| `set<T>` | Red-Black Tree | ✅ *begin() | ✅ *rbegin() | ❌ | ✅ 오름차순 | O(log n) |
| `multiset<T>` | Red-Black Tree | ✅ *begin() | ✅ *rbegin() | ✅ | ✅ 오름차순 | O(log n) |
| `map<K,V>` | Red-Black Tree | ✅ begin()->first | ✅ rbegin()->first | ❌ (키) | ✅ 키 오름차순 | O(log n) |
| `multimap<K,V>` | Red-Black Tree | ✅ begin()->first | ✅ rbegin()->first | ✅ (키) | ✅ 키 오름차순 | O(log n) |
| `unordered_set<T>` | Hash Table | ❌ | ❌ | ❌ | ❌ | **O(1)** 평균 |
| `unordered_multiset<T>` | Hash Table | ❌ | ❌ | ✅ | ❌ | **O(1)** 평균 |
| `unordered_map<K,V>` | Hash Table | ❌ | ❌ | ❌ (키) | ❌ | **O(1)** 평균 |
| `unordered_multimap<K,V>` | Hash Table | ❌ | ❌ | ✅ (키) | ❌ | **O(1)** 평균 |

> `priority_queue`의 top()은 O(1)이지만, erase(top) 후 내부 재정렬에 O(log n) 소요
> `unordered_*`는 평균 O(1)이지만 해시 충돌 시 최악 O(n), 정렬/순서 보장 없음

---

### 3️⃣ prev(it)를 사용하는 이유

```cpp
dpq.erase(prev(dpq.end())); // ✅ 올바른 최댓값 삭제

// dpq.erase(dpq.end()); ← ❌ UB 발생!
```

**이유**:
- `end()`는 마지막 원소의 **다음**을 가리키는 이터레이터 (과거 끝, past-the-end)
- 유효한 원소를 가리키지 않으므로 직접 erase하면 **Undefined Behavior**
- `prev(end())` = 실제 마지막 원소(최댓값)를 가리키는 이터레이터

---

## ⏱️ 시간복잡도

**O(k log k)** — k는 연산의 수

**분석**:
- 삽입 `I n`: O(log k)
- 삭제 `D 1` / `D -1`: O(log k)
- k개 연산 처리: O(k log k)

---

## 💾 공간복잡도

**O(k)**

**분석**:
- multiset에 최대 k개의 정수 저장
