**📅 작성일**: 2026-04-16

## 🔗 문제 링크

[Classes and Objects (클래스와 객체)](https://www.hackerrank.com/challenges/classes-objects/problem?isFullScreen=true)

**난이도**: Easy 20점

---

## 🤔 접근법

n명의 학생이 각각 5개의 시험 점수를 가진다. **첫 번째 학생이 Kristen**이며, Kristen보다 **총점이 높은 학생의 수**를 출력하는 문제.

문제에서 `Student` 클래스를 직접 구현하도록 요구하며, 잠긴 코드(locked code)가 나머지 로직을 처리한다.

**핵심**: `Input()`으로 5개 점수를 읽고, `CalculateTotalScore()`로 합산 후 첫 번째 학생과 순차 비교.

---

## 💡 정답 풀이 방법

**알고리즘** : 클래스 구현 + 선형 순회 비교

**핵심 아이디어**:
```
1. Student 클래스에 int scores[5] = {} 멤버 변수 선언 (= {}로 0 초기화)
2. Input()   : cin으로 5개 점수를 scores에 저장
3. CalculateTotalScore() : scores[0..4] 합산 후 반환
4. students[0]이 Kristen → kristenScore 저장
5. students[1..n-1]과 총점 비교 → higherCnt 카운트
```

---

## 🔑 핵심 포인트

### 1️⃣ C++ 클래스 접근 제한자 스타일

```cpp
class Student
{
    public:                     // public: 4칸 들여쓰기
        int scores[5] = {};     // 멤버 변수는 8칸 들여쓰기, = {}로 0 초기화

    void Input() { ... }        // 멤버 함수는 4칸 들여쓰기 (public: 와 같은 수준)
    int CalculateTotalScore() { ... }
};
```

**✅ 핵심**: CP에서 `private:` 지양, `public:` 만 사용. 멤버 변수는 `= {}`로 초기화해야 미초기화 경고 없음.

### 2️⃣ 멤버 함수명은 PascalCase

```cpp
// ✅ PascalCase (일반 함수와 동일 규칙 적용)
void Input() { ... }
int CalculateTotalScore() { ... }

// ❌ camelCase 금지
void input() { ... }
int calculateTotalScore() { ... }
```

**✅ 핵심**: 멤버 함수도 일반 함수와 동일하게 PascalCase 적용.

### 3️⃣ 동적 할당 대신 vector 사용

```cpp
// ✅ vector 사용
vector<Student> students(n); // n명의 학생

// ❌ new/delete 지양
Student* students = new Student[n];
...
delete[] students;
```

**✅ 핵심**: `new`/`delete` 대신 `vector<Student>(n)` 사용. 메모리 관리 자동화.

### 4️⃣ Kristen 비교 로직

```cpp
// 첫 번째 학생이 Kristen (카린 점수 합 구하기)
int kristenScore = students[0].CalculateTotalScore();

// Kristen을 제외한 나머지 학생과 비교
for (int i = 1; i < n; i++)
{
    // 카린의 점수 합 보다 크다면, 카운트
    if (students[i].CalculateTotalScore() > kristenScore)
    {
        higherCnt++;
    }
}
```

**✅ 핵심**: 인덱스 `0`이 Kristen. 비교는 `i = 1`부터 시작.

---

## ⏱️ 시간복잡도

**O(N)**

**상세 분석**:
```
1. 입력: N명 × 5개 점수 → O(5N) = O(N)
2. Kristen 총점: O(5) = O(1)
3. 나머지 비교: (N-1)명 × O(5) → O(N)
총합: O(N)
```

**시간 제한 체크**:
- N ≤ 200 (문제 조건) → 최악 약 1,000 연산 → 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N)**

**분석**:
- `vector<Student> students(n)` : N명 × 5개 정수 → O(5N) = O(N)
- `kristenScore`, `higherCnt` : O(1) (전역 변수)
- 총 공간: O(N)
