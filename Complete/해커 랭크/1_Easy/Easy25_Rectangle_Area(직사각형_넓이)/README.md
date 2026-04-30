**📅 작성일**: 2026-04-30

## 🔗 문제 링크

[Rectangle Area (직사각형 넓이)](https://www.hackerrank.com/challenges/rectangle-area/problem?isFullScreen=true)

**난이도**: Easy 25점

---

## 🤔 접근법

클래스 상속을 이용해 직사각형의 가로/세로를 출력하고, 넓이를 계산하는 문제.

- `Rectangle` : `width`, `height` 멤버 변수 + `display()` (가로 세로 출력)
- `RectangleArea` : `Rectangle` 상속 + `read_input()` (입력) + `display()` 오버라이드 (넓이 출력)

메인에서 `r_area.Rectangle::display()`로 기반 클래스의 display()를 **명시적으로** 호출해 두 줄 출력을 구현한다.

---

## 💡 정답 풀이 방법

**알고리즘** : 클래스 상속 + 메서드 오버라이드

**핵심 아이디어**:
```
1. Rectangle 클래스 : width, height 선언, display()로 "width height" 출력
2. RectangleArea 클래스 : Rectangle 상속
   - read_input() : width, height 입력
   - display() 오버라이드 : width * height 출력
3. main :
   - r_area.Rectangle::display() → 첫째 줄 "10 5"
   - r_area.display()            → 둘째 줄 "50"
```

---

## 🔑 핵심 포인트

### 1️⃣ 기반 클래스 메서드 명시적 호출

```cpp
r_area.Rectangle::display(); // 기반 클래스 display() 명시적 호출 → "10 5"
r_area.display();            // 파생 클래스 display() (오버라이드) → "50"
```

**✅ 핵심**: `r_area.display()`만 호출하면 파생 클래스의 display()만 실행됨.
기반 클래스의 display()를 호출하려면 `클래스명::` 스코프 연산자로 명시해야 한다.

### 2️⃣ 상속 시 멤버 변수 접근

```cpp
class RectangleArea : public Rectangle
{
    public:
    void read_input()
    {
        cin >> width >> height; // 기반 클래스의 public 멤버에 직접 접근 가능
    }
};
```

**✅ 핵심**: `public` 상속 시 기반 클래스의 `public` 멤버(`width`, `height`)를
파생 클래스에서 `this->` 없이 직접 사용 가능.

### 3️⃣ 클래스 스타일 (멤버 변수 초기화)

```cpp
class Rectangle
{
    public:
        int width = {};   // = {}로 0 초기화 (미초기화 경고 방지)
        int height = {};
};
```

**✅ 핵심**: 멤버 변수는 반드시 `= {}`로 0 초기화.

---

## ⏱️ 시간복잡도

**O(1)**

**상세 분석**:
```
1. 입력 : width, height 2개 → O(1)
2. 출력 : 2줄 → O(1)
총합: O(1)
```

---

## 💾 공간복잡도

**O(1)**

**분석**:
- `RectangleArea r_area` : width, height 2개 int → O(1)
- 총 공간: O(1)
