**📅 작성일**: 2026-05-04

## 🔗 문제 링크

[Overload Operators (연산자 오버로드)](https://www.hackerrank.com/challenges/overload-operators/problem?isFullScreen=true)

**난이도**: Easy 30점

---

## 🤔 접근법

`Complex` 클래스에서 `operator+`와 `operator<<`를 오버로드하는 문제.

- `operator+` : 두 복소수를 더해 새 `Complex` 반환 — `(a+ib) + (c+id) = (a+c) + i(b+d)`
- `operator<<` : `a+ib` 형식으로 스트림에 삽입

클래스 정의와 `main()`은 HackerRank가 제공하므로, 두 연산자 함수만 작성하면 된다.

---

## 💡 정답 풀이 방법

**알고리즘** : 연산자 오버로드 (전역 함수)

**핵심 아이디어**:
```
1. operator+ : Complex 두 개를 받아 실수부/허수부 각각 합산 후 반환
2. operator<< : ostream&를 받아 "a+ib" 출력 후 ostream& 반환 (체이닝 지원)
```

---

## 🔑 핵심 포인트

### 1️⃣ operator+ — 전역 함수로 오버로드

```cpp
// (a+ib) + (c+id) = (a+c) + i(b+d)
Complex operator+(Complex x, Complex y)
{
    Complex result;

    result.a = x.a + y.a;
    result.b = x.b + y.b;

    return result;
}
```

**✅ 핵심**: 멤버 함수가 아닌 **전역 함수**로 선언. `Complex result`를 새로 생성해 합산 후 반환.

### 2️⃣ operator<< — ostream& 반환으로 체이닝 지원

```cpp
// a+ib 형식으로 스트림에 삽입
ostream& operator<<(ostream& out, Complex x)
{
    out << x.a << "+i" << x.b;

    return out;
}
```

**✅ 핵심**: 반환 타입이 반드시 `ostream&`이어야 `cout << a << b` 같은 연속 체이닝이 가능.
`out`을 반환해야 하며 `void` 반환 시 체이닝 불가.

### 3️⃣ 입력 파싱 — "3+i4" 형식 처리

```cpp
void Input(string s)
{
    // '+' 전까지 읽어 실수부 추출
    while (s[i] != '+') { v1 = v1 * 10 + s[i] - '0'; i++; }

    // '+', 'i' 건너뛰기
    while (s[i] == '+' || s[i] == 'i') { i++; }

    // 나머지 읽어 허수부 추출
    while (i < s.length()) { v2 = v2 * 10 + s[i] - '0'; i++; }
}
```

**✅ 핵심**: `+` 기준으로 앞은 실수부(`a`), `i` 건너뛰고 나머지는 허수부(`b`).

---

## ⏱️ 시간복잡도

**O(1)**

**상세 분석**:
```
1. 입력 파싱 : 문자열 길이에 비례하나 숫자 범위 제한으로 실질적 O(1)
2. operator+ : 덧셈 2번 → O(1)
3. operator<< : 출력 → O(1)
총합: O(1)
```

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `Complex x, y, z` : 상수 개수의 변수 → O(1)
- 총 공간: O(1)
