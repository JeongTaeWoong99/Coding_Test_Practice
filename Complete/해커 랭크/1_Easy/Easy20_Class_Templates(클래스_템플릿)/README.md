**📅 작성일**: 2026-05-02

## 🔗 문제 링크

[C++ Class Templates (클래스 템플릿)](https://www.hackerrank.com/challenges/c-plus-plus-class-templates/problem?isFullScreen=true)

**난이도**: Easy 20점

---

## 🤔 접근법

타입에 따라 덧셈(int/float) 또는 이어 붙이기(string)를 수행하는 `AddElements` 클래스를 구현하는 문제.

문제에서 `main()`은 이미 제공되며, `AddElements<T>::add()`와 `AddElements<string>::concatenate()` 를 직접 구현해야 한다.

**핵심**: `template <class T>` 로 일반 템플릿을 선언하고, `template <>` 로 string 특수화를 별도로 작성. `+` 연산자는 int/float에서 덧셈, string에서 이어 붙이기로 동작한다.

---

## 💡 정답 풀이 방법

**알고리즘** : 클래스 템플릿 + 템플릿 특수화

**핵심 아이디어**:
```
1. template <class T> 선언 → int, float 등 모든 타입에 적용
2. add(other) : return element + other → int/float는 덧셈
3. template <> 로 string 특수화 → add() 대신 concatenate() 제공
4. concatenate(other) : return element + other → string은 이어 붙이기
5. main()에서 타입 문자열("int"/"float"/"string")로 분기 후 해당 메서드 호출
```

---

## 🔑 핵심 포인트

### 1️⃣ 클래스 템플릿 선언

```cpp
template <class T>
class AddElements
{
    public:
        T element = {}; // = {}로 0/기본값 초기화

    AddElements(T arg)
    {
        element = arg;
    }

    T add(T other)
    {
        return element + other;
    }
};
```

**✅ 핵심**: `template <class T>` 선언만으로 int, float, double 등 모든 숫자 타입에 동일한 코드 재사용.

### 2️⃣ 템플릿 특수화 — `template <>`

```cpp
// ✅ 특수화 : template <> 빈 꺽쇠 필수
template <>
class AddElements<string>
{
    public:
        string element = {};

    AddElements(string arg) { element = arg; }

    string concatenate(string other)
    {
        return element + other; // string의 + 는 이어 붙이기
    }
};

// ❌ 일반 템플릿에 string을 그냥 쓰면 add()가 없어서 컴파일 에러
```

**✅ 핵심**: 특수화 시 `template <>` 빈 꺽쇠를 반드시 붙여야 함. 특수화된 클래스는 일반 템플릿과 **완전히 독립적**이므로 멤버 함수도 새로 정의해야 한다.

### 3️⃣ 함수명 예외 — 소문자 유지

```cpp
// ✅ 소문자 유지 (HackerRank main()이 직접 호출하므로 변경 불가)
T add(T other) { ... }
string concatenate(string other) { ... }

// ❌ PascalCase 적용 불가 — main()에서 Add(), Concatenate()를 호출하면 컴파일 에러
```

**✅ 핵심**: 코딩 스타일상 멤버 함수는 PascalCase이나, HackerRank 제공 `main()`이 `add()`, `concatenate()`를 직접 호출하므로 소문자 유지가 필수.

### 4️⃣ `+` 연산자의 다형성

```cpp
// int : 덧셈
AddElements<int> temp(1);
temp.add(2); // → 3

// float : 덧셈
AddElements<double> temp(4.0);
temp.add(1.5); // → 5.5

// string : 이어 붙이기
AddElements<string> temp("John");
temp.concatenate("Doe"); // → "JohnDoe"
```

**✅ 핵심**: C++의 `+` 연산자는 타입에 따라 동작이 달라지므로, 일반 템플릿의 `element + other`만으로 int/float 모두 처리 가능.

---

## ⏱️ 시간복잡도

**O(N)**

**상세 분석**:
```
1. N개 테스트 케이스 반복 → O(N)
2. 각 케이스당 입력 2개 + 덧셈/이어 붙이기 → O(1)
총합: O(N)
```

**시간 제한 체크**:
- N의 상한이 명시되지 않으나 4초 제한으로 충분히 통과 ✅

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `AddElements<T> temp(a)` : 단일 원소 저장 → O(1)
- 각 케이스마다 스택 생성/소멸 → 추가 공간 없음
- 총 공간: O(1)
