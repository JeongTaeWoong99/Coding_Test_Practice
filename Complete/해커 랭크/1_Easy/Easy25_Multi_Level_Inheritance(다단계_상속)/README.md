**📅 작성일**: 2026-04-30

## 🔗 문제 링크

[Multi Level Inheritance (다단계 상속)](https://www.hackerrank.com/challenges/multi-level-inheritance-cpp/problem?isFullScreen=true)

**난이도**: Easy 25점

---

## 🤔 접근법

`Triangle → Isosceles → Equilateral` 의 3단계 다단계 상속(Multi-Level Inheritance) 구조를 구현하는 문제.

`Equilateral` 객체 하나로 모든 상위 클래스의 멤버 함수(`equilateral()`, `isosceles()`, `triangle()`)를 직접 호출할 수 있다는 것이 다단계 상속의 핵심이다.

---

## 💡 정답 풀이 방법

**알고리즘** : 다단계 클래스 상속 (Multi-Level Inheritance)

**핵심 아이디어**:
```
Triangle        → triangle()    : "I am a triangle"
    ↑ 상속
Isosceles       → isosceles()   : "I am an isosceles triangle"
    ↑ 상속
Equilateral     → equilateral() : "I am an equilateral triangle"

Equilateral eql 객체로 3개 메서드 모두 호출 가능
```

---

## 🔑 핵심 포인트

### 1️⃣ 다단계 상속 — 상위 클래스 메서드 직접 접근

```cpp
Equilateral eql;
eql.equilateral(); // 자신의 메서드
eql.isosceles();   // 1단계 상위 (Isosceles) 메서드
eql.triangle();    // 2단계 상위 (Triangle) 메서드
```

**✅ 핵심**: `public` 다단계 상속 시 모든 상위 클래스의 `public` 멤버 함수를
파생 클래스 객체로 직접 호출 가능. 스코프 연산자(`::`) 없이도 접근된다.

### 2️⃣ 단일 상속 vs 다단계 상속

```
단일 상속    : A ← B                  (B가 A 상속)
다단계 상속  : A ← B ← C             (B가 A, C가 B 상속)
다중 상속    : A ← C, B ← C          (C가 A와 B 동시 상속) ← 이 문제는 해당 없음
```

**✅ 핵심**: 이 문제는 **다단계(Multi-Level)** 상속. 다중(Multiple) 상속과 혼동 주의.

---

## ⏱️ 시간복잡도

**O(1)**

**상세 분석**:
```
1. 객체 생성  : O(1)
2. 메서드 3번 : cout 3번 → O(1)
총합: O(1)
```

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `Equilateral eql` : 멤버 변수 없음 → O(1)
- 총 공간: O(1)
