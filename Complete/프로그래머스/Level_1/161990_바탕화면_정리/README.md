**📅 작성일**: 2026-05-23

## 🔗 문제 링크

[프로그래머스 - 바탕화면 정리](https://school.programmers.co.kr/learn/courses/30/lessons/161990)

**난이도**: Level 1

---

## 🤔 접근법

wallpaper 그리드에서 `'#'` 파일 아이콘의 **바운딩 박스**를 구하는 문제.

`#` 이 있는 모든 위치를 순회하며 최소 행/열(좌상단)과 최대 행+1/열+1(우하단)을 갱신하면 된다.

---

## 💡 정답 풀이 방법

**알고리즘**: 브루트포스 / 배열 탐색

```
1. top = rowCnt, left = colCnt 로 초기화 (최솟값 탐색 위해 큰 값으로)
   bottom = 0,   right = 0     로 초기화 (최댓값 탐색 위해 작은 값으로)
2. 전체 그리드 순회:
   - '#' 발견 시:
     - top    = min(top, i)
     - left   = min(left, j)
     - bottom = max(bottom, i + 1)  ← 드래그 끝은 해당 칸 포함 → +1
     - right  = max(right, j + 1)
3. {top, left, bottom, right} 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 초기값 설정

```cpp
int top  = rowCnt; // 최솟값 탐색 → 가능한 최댓값으로 초기화
int left = colCnt;
int bottom = 0;    // 최댓값 탐색 → 가능한 최솟값으로 초기화
int right  = 0;
```

`min` 으로 좁혀갈 변수는 크게, `max` 로 넓혀갈 변수는 작게 초기화한다.

### 2️⃣ 드래그 끝 좌표 +1

문제 조건상 드래그 범위는 `[top, bottom) × [left, right)` 형태.  
`#` 이 있는 칸 자체를 포함해야 하므로 `i + 1`, `j + 1` 로 저장한다.

```cpp
bottom = max(bottom, i + 1); // i번 행을 포함하려면 끝은 i+1
right  = max(right,  j + 1); // j번 열을 포함하려면 끝은 j+1
```

---

## ⏱️ 시간복잡도

**O(rows × cols)**
- wallpaper 전체 셀을 한 번 순회
- rows, cols ≤ 50 → 최대 2,500번 연산
