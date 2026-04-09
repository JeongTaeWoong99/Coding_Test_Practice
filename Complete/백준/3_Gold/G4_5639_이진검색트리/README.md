**📅 작성일**: 2026-04-09

## 🔗 문제 링크

[백준 5639번 - 이진 검색 트리](https://www.acmicpc.net/problem/5639)

**난이도**: Gold 4

---

## 🖥️ 시각화

[시각화 보기 (HTML)](시각화.html)

> 전위 순회 배열을 BST 구조로 시각화하고, PostOrder 재귀 호출 흐름을 단계별로 확인할 수 있다.

---

## 🤔 접근법

전위 순회(루트-왼쪽-오른쪽)가 주어졌을 때, BST의 성질을 이용해 후위 순회(왼쪽-오른쪽-루트)를 구해야 한다.

전위 배열에서 **첫 번째 원소가 항상 현재 서브트리의 루트**이고, BST의 성질로 인해:
- 루트보다 작은 값들 → **왼쪽 서브트리**
- 루트보다 큰 값들 → **오른쪽 서브트리**

이 구분선을 찾아 재귀적으로 후위 순회를 출력하면 된다.

---

## 💡 정답 풀이 방법

**알고리즘**: 재귀 + BST 분할

**핵심 아이디어**:
```
PostOrder(start, end):
  1. start > end → return (범위가 없으면 종료)
  2. root = preorder[start]
  3. start+1부터 root보다 큰 첫 번째 위치 = rightStart
  4. PostOrder(start+1, rightStart-1)  ← 왼쪽 서브트리 먼저
  5. PostOrder(rightStart, end)        ← 오른쪽 서브트리
  6. print root                        ← 루트를 마지막에 출력
```

**예제 분할 과정**:
```
전위: [50, 30, 24, 5, 28, 45, 98, 52, 60]
       └ root=50
          ├ 왼쪽: [30, 24, 5, 28, 45]  (모두 50보다 작음)
          └ 오른쪽: [98, 52, 60]         (모두 50보다 큼)
```

**시간 복잡도**: O(N²)
- 각 호출마다 선형 탐색으로 rightStart를 찾음
- N = 10,000 이하이므로 1초 내 충분히 통과

**공간 복잡도**: O(N)
- preorder 배열: O(N)
- 재귀 스택: 최악(편향 트리)의 경우 O(N)

---

## 🔑 핵심 포인트

### 1️⃣ rightStart 초기값 설정

```cpp
int rightStart = end + 1;  // 오른쪽 서브트리가 없는 경우를 기본값으로
for (int i = start + 1; i <= end; i++)
{
    if (preorder[i] > root)
    {
        rightStart = i;
        break;
    }
}
```

**핵심**: `rightStart = end + 1`로 초기화하면 오른쪽 자식이 없는 경우 `PostOrder(end+1, end)`가 호출되어 `start > end` 조건으로 자연스럽게 return된다.

### 2️⃣ EOF 입력 처리

```cpp
int x;
while (cin >> x)
{
    preorder.emplace_back(x);
}
```

**핵심**: 입력 종료 조건이 별도로 없으므로 `while(cin >> x)`로 EOF까지 읽는다.

### 3️⃣ 트리를 직접 구성하지 않아도 됨

BST를 실제로 빌드하지 않고, 전위 배열의 **인덱스 범위만** 재귀적으로 분할해도 동일한 결과가 나온다.

---

## 📊 예시 실행 흐름

**입력**:
```
50 30 24 5 28 45 98 52 60
```

**BST 구조**:
```
          50
         /  \
       30    98
      /  \   /
     24  45 52
    /  \    \
   5   28   60
```

**PostOrder 재귀 호출 순서**:
```
PostOrder(0,8) → root=50
  PostOrder(1,5) → root=30
    PostOrder(2,4) → root=24
      PostOrder(3,3) → root=5  → 출력: 5
      PostOrder(4,4) → root=28 → 출력: 28
    → 출력: 24
    PostOrder(5,5) → root=45  → 출력: 45
  → 출력: 30
  PostOrder(6,8) → root=98
    PostOrder(7,8) → root=52
      PostOrder(8,7) → start>end, return
      PostOrder(8,8) → root=60 → 출력: 60
    → 출력: 52
  → 출력: 98
→ 출력: 50
```

**출력**: `5 28 24 45 30 60 52 98 50` ✅

---

## ⏱️ 시간복잡도

**O(N²)**
- rightStart 탐색: 각 호출마다 최대 O(N)
- 총 호출 횟수: O(N)
- 최악의 경우(편향 트리): O(N) × O(N) = O(N²)
- N = 10,000이므로 최대 1억 연산 → 시간 제한(1초) 내 통과

---

## 💾 공간복잡도

**O(N)**
- `preorder` 벡터: O(N)
- 재귀 스택: 최악 O(N) (편향 트리 시 깊이 N)
