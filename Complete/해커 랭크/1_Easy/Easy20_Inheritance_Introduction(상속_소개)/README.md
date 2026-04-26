**📅 작성일**: 2026-04-26

## 🔗 문제 링크

[Inheritance Introduction (상속 소개)](https://www.hackerrank.com/challenges/inheritance-introduction/problem?isFullScreen=true)

**난이도**: Easy 20점

---

## 🤔 접근법

`Isosceles` 클래스가 `Triangle` 클래스를 상속받는 구조에서, `isosceles()` 함수에 출력 한 줄을 추가하는 문제.

문제에서 `Triangle` 클래스와 `main()` 코드를 이미 제공하며, `Isosceles` 클래스의 `isosceles()` 함수 안에 `"In an isosceles triangle two sides are equal"` 출력만 추가하면 된다.

파생 클래스 객체(`isc`)로 기반 클래스의 `triangle()` 메서드를 직접 호출할 수 있다는 것이 상속의 핵심이다.

---

## 💡 정답 풀이 방법

**알고리즘** : 클래스 상속 (Inheritance)

**핵심 아이디어**:
```
1. Isosceles가 Triangle을 public 상속 → isc.triangle() 호출 가능
2. isosceles() 함수에 cout 한 줄 추가
3. isc.isosceles() → 2줄 출력
4. isc.triangle()  → 1줄 출력 (기반 클래스 메서드 직접 호출)
```

---

## 🔑 핵심 포인트

### 1️⃣ public 상속 — 기반 클래스 메서드 그대로 사용

```cpp
class Isosceles : public Triangle  // public 상속
{
    ...
};

Isosceles isc;
isc.triangle(); // Triangle의 public 메서드를 Isosceles 객체로 직접 호출 가능
```

**✅ 핵심**: `public` 상속 시 기반 클래스의 `public` 멤버가 파생 클래스에서도 `public`으로 유지됨.

### 2️⃣ 출력 순서

```
I am an isosceles triangle          ← isosceles() 첫 번째 줄
In an isosceles triangle two sides are equal  ← isosceles() 추가한 줄
I am a triangle                      ← triangle() (기반 클래스 메서드)
```

---

## ⏱️ 시간복잡도

**O(1)**

**상세 분석**:
```
1. 객체 생성 : O(1)
2. isosceles() : cout 2번 → O(1)
3. triangle()  : cout 1번 → O(1)
총합: O(1)
```

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `Isosceles isc` : 멤버 변수 없음 → O(1)
- 총 공간: O(1)
