**📅 작성일**: 2026-04-07

## 🔗 문제 링크

[백준 1043번 - 거짓말](https://www.acmicpc.net/problem/1043)

**난이도**: Gold 4

---

## 🖥️ 시각화

[Union-Find 동작 시각화 (HTML)](시각화.html)

> 예제 4 기준으로 parent 배열 초기화 → Unite → truthRoots 구성 → 파티별 판정 과정을 단계별로 확인 가능

---

## 🤔 접근법

진실을 아는 사람 목록만 보고 파티별로 체크하면 틀린다. 핵심은 **진실의 전파**다.

진실을 아는 사람 A와 모르는 사람 B가 같은 파티에 참석하면, B는 진실을 들은 것이므로 이후 파티에서 거짓말을 들으면 Jimin이 거짓말쟁이로 들통난다.

따라서 **같은 파티에 참석한 사람들은 하나의 그룹**으로 묶고, 그 그룹 안에 진실을 아는 사람이 한 명이라도 있으면 해당 그룹의 모든 파티가 진실을 말해야 한다.

이것이 **Union-Find (분리 집합)** 으로 풀어야 하는 이유다.

---

## 💡 정답 풀이 방법

**알고리즘**: Union-Find (분리 집합)

**핵심 아이디어**:
```
1. 각 파티의 참석자들을 Union-Find로 하나의 그룹으로 묶기
2. 모든 파티 처리 후, 진실을 아는 사람들의 루트 노드를 truthRoots에 저장
   (Unite 완료 후 Find를 해야 전파된 그룹 정보가 반영됨)
3. 각 파티에서 Find(참석자)의 결과가 truthRoots에 있으면 거짓말 불가
4. 거짓말 가능한 파티 수를 카운트
```

**시간 복잡도**: O(M × α(N)) ≈ O(M)
- M : 파티 수 (최대 50), N : 사람 수 (최대 50)
- α : 애커만 함수의 역함수 (사실상 상수)
- 경로 압축 적용으로 Find 연산이 거의 O(1)

**공간 복잡도**: O(N + M)
- parent 배열: O(N)
- groups (각 파티 참석자 저장): O(M × 참석자 수)

---

## 🔑 핵심 포인트

### 1️⃣ 왜 파티 참석자를 groups에 저장하는가?

```cpp
// 파티 입력 시 Unite만 하고 입력값을 버리면,
// 나중에 "이 파티에 진실 그룹 참석자가 있는지" 확인할 수 없음
groups.resize(m);
for (int i = 0; i < m; i++)
{
    // 참석자 저장 후 Unite → 판정 시 재사용
    for (int j = 0; j < siz; j++) 
        cin >> groups[i][j];
        
    for (int j = 1; j < siz; j++) 
        Unite(groups[i][0], groups[i][j]);
}
```

### 2️⃣ truthRoots는 반드시 Unite 완료 후에 구성

```cpp
// ❌ 잘못된 순서 : 입력과 동시에 루트 저장 (전파 반영 안 됨)
// ✅ 올바른 순서 : 모든 Unite 완료 후 Find로 루트 저장
for (int t : truthSet)
{
    truthRoots.insert(Find(t)); // 이 시점의 Find(t)가 전파된 그룹 루트를 반환
}
```

### 3️⃣ 판정 시 Find()로 루트 비교

```cpp
// 직접 truthSet에 있는지 확인이 아니라,
// Find()로 루트를 구해 truthRoots에 있는지 확인
if (truthRoots.count(Find(person))) { canLie = false; }
```

**✅ 핵심**: 사람 4가 truthSet에 없어도 Unite(4,1)으로 묶였다면 Find(4) = Find(1) → truthRoots에 해당됨

---

## 📊 예제 4 실행 흐름

**입력**:
```
4 5 / 진실:{1}
파티1:1 / 파티2:2 / 파티3:3 / 파티4:4 / 파티5:4,1
```

```
Unite 과정:
  파티1~4: 1명 → Unite 없음
  파티5: Unite(4,1) → parent[4] = 1

truthRoots 구성:
  Find(1) = 1 → truthRoots = {1}

판정:
  파티1: Find(1)=1 ∈ truthRoots → ❌
  파티2: Find(2)=2 ∉ truthRoots → ✅ +1
  파티3: Find(3)=3 ∉ truthRoots → ✅ +1
  파티4: Find(4)=1 ∈ truthRoots → ❌  ← 기존 코드가 틀렸던 부분
  파티5: Find(4)=1 ∈ truthRoots → ❌
```

**출력**: `2`

---

## ⏱️ 시간복잡도

**O(M × α(N)) ≈ O(M)**
- 경로 압축이 적용된 Find: 거의 O(1) (α(N) ≈ 상수)
- 파티별 Unite: O(M × 참석자 수)
- N, M ≤ 50으로 제약이 작아 복잡도보다 구현 정확성이 핵심
