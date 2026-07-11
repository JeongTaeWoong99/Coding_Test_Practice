**📅 작성일**: 2026-07-11

## 🔗 문제 링크

[프로그래머스 - 로또의 최고 순위와 최저 순위](https://school.programmers.co.kr/learn/courses/30/lessons/77484)

**난이도**: Level 1

---

## 🤔 접근법

로또 용지에서 **알아볼 수 없는 번호(0)** 가 섞여 있을 때, 나올 수 있는 **최고 순위와 최저 순위**를 구하는 문제.

핵심은 0을 어떻게 가정하느냐에 따라 순위가 갈린다는 점이다.

- **최고 순위**: 알아볼 수 없는 번호(0)가 **전부 당첨 번호와 일치**한다고 가정 → 맞춘 개수 최대
- **최저 순위**: 알아볼 수 없는 번호(0)가 **전부 꽝**이라고 가정 → 맞춘 개수 최소

따라서 확실히 맞춘 개수 `matchCnt`와 0의 개수 `zeroCnt`만 세면 된다.

- 최고 순위 = `matchCnt + zeroCnt` 개를 맞춘 순위
- 최저 순위 = `matchCnt` 개를 맞춘 순위

---

## 💡 정답 풀이 방법

**알고리즘**: 구현 (카운팅)

```
1. lottos를 순회하며
   - 0이면 zeroCnt++
   - 당첨 번호(win_nums)에 포함되면 matchCnt++
2. 최고 순위 = GetRank(matchCnt + zeroCnt)
3. 최저 순위 = GetRank(matchCnt)
4. {최고, 최저} 반환

GetRank(k): k개 맞췄을 때 순위
   - k < 2 → 6등 (순위 없음)
   - 그 외  → 7 - k
```

```cpp
for (int num : lottos)
{
    if (num == 0)
    {
        zeroCnt++;
    }
    else if (winSet.count(num))
    {
        matchCnt++;
    }
}

int highRank = GetRank(matchCnt + zeroCnt);
int lowRank  = GetRank(matchCnt);
```

---

## 🔑 핵심 개념

### 1️⃣ 맞춘 개수 → 순위 변환 공식

로또는 6개 중 맞춘 개수가 많을수록 높은 순위(1등)다. 맞춘 개수 `k`를 순위로 바꾸면:

| 맞춘 개수 | 6 | 5 | 4 | 3 | 2 | 1 · 0 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 순위 | 1등 | 2등 | 3등 | 4등 | 5등 | 6등 |

즉 `k >= 2`일 때는 `7 - k`, `k < 2`(0개·1개)일 때는 모두 6등이다.

```cpp
int GetRank(int matchCnt)
{
    if (matchCnt < 2)
    {
        return 6;
    }

    return 7 - matchCnt;
}
```

### 2️⃣ 0의 방향에 따라 최고/최저가 갈린다

알아볼 수 없는 번호(0)는 당첨일 수도, 꽝일 수도 있다. 최고 순위는 **0이 전부 당첨**인 낙관적 가정, 최저 순위는 **0이 전부 꽝**인 비관적 가정이다.

확실히 맞춘 `matchCnt`는 고정이고, 여기에 `zeroCnt`를 더하느냐(최고) 안 더하느냐(최저)의 차이일 뿐이다.

### 3️⃣ set으로 당첨 번호 조회

당첨 번호를 `set`에 담아 `count`로 포함 여부를 조회한다. 번호가 6개뿐이라 성능 차이는 미미하지만, 의도가 명확하고 가독성이 좋다.

```cpp
set<int> winSet(win_nums.begin(), win_nums.end());
```

---

## ⏱️ 시간복잡도

**O(1)** — lottos와 win_nums의 크기는 항상 6으로 고정되어 있어 상수 시간에 처리된다.
