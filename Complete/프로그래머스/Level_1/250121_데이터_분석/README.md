**📅 작성일**: 2026-05-16

## 🔗 문제 링크

[프로그래머스 - 데이터 분석](https://school.programmers.co.kr/learn/courses/30/lessons/250121)

**난이도**: Level 1 (PCCE 기출문제)

---

## 🤔 접근법

4개의 속성(code, date, maximum, remain)을 가진 2D 데이터에서, `ext` 기준으로 `val_ext`보다 작은 행만 필터링한 뒤 `sort_by` 기준으로 오름차순 정렬하는 구현 문제.

**핵심**: 문자열 컬럼명을 인덱스로 변환하는 map을 전역으로 구성하면, 필터링과 정렬 모두 같은 map 하나로 처리 가능.

---

## 💡 정답 풀이 방법

**알고리즘**: 필터링 + 버블 정렬

```
1. check map으로 컬럼명 → 인덱스 매핑 (code=0, date=1, maximum=2, remain=3)
2. data 순회: row[check[ext]] < val_ext 조건 만족하는 행만 answer에 추가
3. sortIdx = check[sort_by] 로 정렬 기준 인덱스 추출
4. 버블 정렬: answer[j][sortIdx] > answer[j+1][sortIdx] 이면 swap
5. answer 반환
```

---

## 🔑 핵심 개념

### 1️⃣ 컬럼명 → 인덱스 전역 map

```cpp
map<string, int> check = {{"code", 0}, {"date", 1}, {"maximum", 2}, {"remain", 3}};
```

문자열을 직접 비교하지 않고 인덱스로 변환해 `row[check[ext]]` 형태로 접근.

### 2️⃣ STL sort 사용 시 (람다)

버블 정렬 대신 `sort`를 사용할 경우, 세 번째 인자에 비교 함수(람다)를 전달:

```cpp
// [sortIdx] : 외부 변수 sortIdx를 람다 안으로 캡처
// return a[sortIdx] < b[sortIdx] : true면 a를 앞에 배치 (오름차순)
sort(answer.begin(), answer.end(), [sortIdx](const vector<int>& a, const vector<int>& b)
{
    return a[sortIdx] < b[sortIdx];
});
```

---

## ⏱️ 시간복잡도

**O(n²)** — 버블 정렬 기준 (n = 필터링 후 행 수, 최대 100)
