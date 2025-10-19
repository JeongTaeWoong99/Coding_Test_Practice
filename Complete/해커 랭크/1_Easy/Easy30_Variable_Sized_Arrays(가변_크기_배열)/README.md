**📅 작성일**: 2025-10-03

## 🔗 문제 링크
[Variable Sized Arrays(가변 크기 배열)](https://www.hackerrank.com/challenges/variable-sized-arrays/problem?isFullScreen=true)

---

## 🤔 접근법

n개의 가변 크기 배열을 생성하고, q개의 쿼리로 특정 위치의 값을 출력하는 문제.

## 💡 정답 풀이 방법

- `vector<vector<int>>` 사용하여 각 배열의 크기가 다른 2D 배열 생성
- 각 배열마다 크기 k를 입력받아 `resize(k)` 후 원소 입력
- 쿼리는 `arrays[i][j]` 로 O(1) 접근