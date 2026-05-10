**📅 작성일**: 2026-05-10

## 🔗 문제 링크

[프로그래머스 - 동영상 재생기](https://school.programmers.co.kr/learn/courses/30/lessons/340213)

**난이도**: Level 1 (PCCP 기출문제)

---

## 🤔 접근법

동영상 재생 위치를 `"mm:ss"` 형식으로 관리하면서, `prev`/`next` 커맨드에 따라 10초씩 이동하고
오프닝 구간(`op_start ≤ pos ≤ op_end`)이면 자동으로 `op_end`로 건너뛰는 시뮬레이션 문제.

**핵심**: 문자열 시간을 **초 단위 정수**로 변환 후 연산하고, 경계 처리(0초 미만, 영상 길이 초과)와 오프닝 구간 처리를 커맨드마다 반복 적용.

---

## 💡 정답 풀이 방법

**알고리즘**: 시뮬레이션

```
1. "mm:ss" → 초 단위 정수 변환 (ToSec)
2. 시작 위치가 오프닝 구간이면 op_end로 이동
3. 각 커맨드 처리:
   - "prev": curPos -= 10, max(curPos, 0)으로 하한 고정
   - "next": curPos += 10, min(curPos, videoLen)으로 상한 고정
4. 커맨드 처리 후 오프닝 구간이면 op_end로 이동
5. 최종 curPos → "mm:ss" 형식 문자열 반환 (ToStr)
```

---

## 🔑 핵심 개념

### 1️⃣ "mm:ss" ↔ 초 단위 변환

```cpp
int ToSec(const string& t)
{
    return stoi(t.substr(0, 2)) * 60 + stoi(t.substr(3, 2));
}

string ToStr(int sec)
{
    string mm = (sec / 60 < 10 ? "0" : "") + to_string(sec / 60);
    string ss = (sec % 60 < 10 ? "0" : "") + to_string(sec % 60);
    return mm + ":" + ss;
}
```

시간 연산 내내 정수로 처리하여 `+/-10` 연산과 경계 비교를 단순하게 유지.

### 2️⃣ 오프닝 구간 처리 — 시작 시점 + 커맨드마다

오프닝 건너뛰기는 **두 곳**에서 적용해야 한다:
- 처음 위치 확인 시
- 각 커맨드 실행 **후**

```cpp
if (curPos >= opStart && curPos <= opEnd)
{
    curPos = opEnd;
}
```

---

## 📊 테스트케이스 추적

### ▶️ 케이스 2 — `pos="00:05"`, commands=["prev", "next", "next"] → "06:55"

```
시작: 5초 (오프닝 [15, 415] 아님 → 그대로)

prev: 5 - 10 = -5 → max(-5, 0) = 0   (오프닝 아님)
next: 0 + 10 = 10                      (오프닝 아님)
next: 10 + 10 = 20  → 오프닝 [15, 415] → op_end = 415

최종: 415초 → "06:55" ✅
```

### ▶️ 케이스 3 — `pos="04:05"`, commands=["next"] → "04:17"

```
시작: 245초, 오프닝 [15, 247] → op_end = 247초 (04:07)

next: 247 + 10 = 257  (오프닝 [15, 247] 아님)

최종: 257초 → "04:17" ✅
```

---

## ⏱️ 시간복잡도

**O(n)** — n = commands 길이 (최대 100)
