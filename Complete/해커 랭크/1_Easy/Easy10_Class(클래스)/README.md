**📅 작성일**: 2026-04-18

## 🔗 문제 링크

[C++ Class Tutorial (클래스 기초)](https://www.hackerrank.com/challenges/c-tutorial-class/problem?isFullScreen=true)

**난이도**: Easy

---

## 🤔 접근법

`Student` 클래스를 직접 구현하는 문제. 멤버 변수(age, firstName, lastName, standard)를 선언하고, 각각에 대한 **설정(Setter)/조회(Getter) 메서드**와 모든 값을 쉼표로 이어붙인 문자열을 반환하는 `ToString()` 메서드를 만든다.

문제가 클래스와 메서드를 통해서만 값을 세팅하고 출력하도록 요구하기 때문에, 전역 변수로 입력을 받은 뒤 `Student` 객체에 Setter로 세팅하고 Getter로 출력하는 구조로 구현했다.

---

## 💡 정답 풀이 방법

**알고리즘** : 클래스 설계 + Getter/Setter 패턴

**핵심 아이디어**:
```
1. 전역 변수로 age, firstName, lastName, standard 입력 받기
2. Student 객체 생성 후 Setter로 각 멤버 변수에 값 세팅
3. Getter로 개별 값 출력 (age, lastName+firstName, standard)
4. ToString()으로 "age,firstName,lastName,standard" 형식 출력
```

---

## 🔑 핵심 포인트

### 1️⃣ C++에서 string은 값 타입 — 복사 비용이 있다

C#에서 `string`은 **참조 타입**이다. 메서드에 넘길 때 주소(참조)만 전달되므로 복사가 발생하지 않는다.

```csharp
// C# — string은 참조 타입, 복사 없이 참조 전달
void SetName(string name) { ... } // 내부적으로 참조만 전달됨
```

반면 C++에서 `string`은 **값 타입**이다. 메서드에 `string`을 그대로 넘기면 **문자열 전체가 복사**된다.

```cpp
// ❌ C++ — string 값 타입 전달 → 복사 발생
void SetFirstName(string fn) { firstName = fn; } // fn에 복사 1번, 대입 시 복사 1번

// ✅ C++ — const string& 참조 전달 → 복사 없음
void SetFirstName(const string& fn) { firstName = fn; } // 참조만 전달, 대입 시 복사 1번만
```

**`const string&` 의 두 가지 역할**:
```
const — 호출자가 전달한 원본 값을 메서드 내부에서 수정 못하게 보호
&     — 복사 없이 원본 메모리를 직접 참조 (C#의 ref와 유사하지만 읽기 전용)
```

### 2️⃣ Getter에도 const string& 적용 — 멤버 변수 직접 참조

```cpp
// ❌ string 반환 → 멤버 변수를 새 string으로 복사 후 반환
string GetFirstName() { return firstName; }

// ✅ const string& 반환 → 멤버 변수를 복사 없이 직접 참조로 반환
const string& GetFirstName() { return firstName; }
```

반환된 `const string&`는 `Student` 객체의 멤버 변수를 직접 가리키므로 복사가 없다. `const`이므로 호출자가 반환값을 통해 멤버 변수를 수정할 수도 없다.

### 3️⃣ ToString()은 왜 const string& 를 붙이지 않나?

```cpp
// 새로운 string을 만들어 반환 — 반드시 값 타입(string)으로 반환해야 함
string ToString()
{
    stringstream ss;
    ss << age << "," << firstName << "," << lastName << "," << standard;

    return ss.str(); // ss.str()은 함수 내부에서 만들어진 임시 string
}
```

`ToString()`은 내부에서 `stringstream`으로 **새 string을 생성**한다. 이 string은 함수가 끝나면 사라지는 **지역 변수**다.

만약 `const string&`로 반환하면:

```cpp
// ❌ 위험! 함수가 끝난 후 사라진 지역 변수를 참조 → 댕글링 참조(Dangling Reference)
const string& ToString() { return ss.str(); } // ss는 함수 종료와 함께 소멸됨
```

기존에 있던 멤버 변수를 참조로 돌려주는 Getter와 달리, `ToString()`은 **새로 만든 값**을 돌려줘야 하므로 반드시 `string` (값 타입)으로 반환해야 한다. 호출자가 이 string을 받는 순간 자신의 변수에 복사/이동되어 안전하게 사용 가능하다.

### 4️⃣ C++ 값 타입 vs 참조 타입 — C#과 비교 정리

| 항목 | C# | C++ |
|------|-----|------|
| `string` 본질 | 참조 타입 (힙 객체 주소) | 값 타입 (힙 메모리 포함한 객체 자체) |
| 메서드 파라미터 기본 | 참조 전달 (복사 없음) | 값 전달 (복사 발생) |
| 복사 없이 전달하려면 | 기본 동작 | `const string&` 사용 |
| 읽기 전용 보장 | `string`은 원래 불변 | `const` 키워드로 명시 |
| 반환값 복사 방지 | 기본 동작 | `const string&` 반환 (단, 지역 변수 반환 불가) |

**핵심 요약**:
```
C#의 string 파라미터 ≈ C++의 const string& 파라미터
→ 둘 다 복사 없이 원본을 읽기 전용으로 참조
```

---

## ⏱️ 시간복잡도

**O(1)**

**상세 분석**:
```
1. 입력   : 정수 2개, 문자열 2개 → O(1)
2. Setter : 각 멤버 변수에 값 대입 → O(1)
3. Getter : 멤버 변수 참조 반환 → O(1)
4. ToString : stringstream 조합 → O(L) (L = 문자열 길이, 최대 50자)
총합: O(1)
```

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `Student st` : 멤버 변수 4개 → O(1)
- 전역 변수 4개 → O(1)
- `ToString()` 내 stringstream : O(L), L ≤ 50
- 총 공간: O(1)
