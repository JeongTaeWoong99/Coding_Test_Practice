**📅 작성일**: 2026-07-05

## 🔗 문제 링크

[프로그래머스 - 숫자 문자열과 영단어](https://school.programmers.co.kr/learn/courses/30/lessons/81301)

**난이도**: Level 1 (2021 카카오 채용연계형 인턴십)

---

## 🤔 접근법

숫자와 영단어(`zero`~`nine`)가 섞인 문자열을, 영단어를 해당 숫자로 바꾼 뒤 통째로 정수 변환하는 문제.

두 가지 풀이를 정리한다.

- **① 치환 방식** (`Answer(정답).cpp.txt`) — `find`+`replace`로 단어를 찾아 숫자로 바꾸기를 0~9까지 반복. 짧고 직관적이지만 매 치환마다 문자열을 처음부터 재탐색 → **O(N²)**.
- **② 앞에서부터 파싱** (`Answer(O(N)_앞에서부터_파싱).cpp.txt`) — 인덱스 `i`를 앞에서부터 한 번만 훑으며, 숫자면 붙이고 영단어면 길이만큼 점프 → **O(N)**.

> 처음 떠올렸던 "앞에서부터 보며 단어면 점프" 아이디어가 바로 ② 방식이다. ①로 간단히 풀고, ②로 최적화까지 정리한다.

---

## 💡 정답 풀이 방법 ① — 치환 (find + replace)

**알고리즘**: 문자열 치환(구현)

```
1. words[10] = { "zero", ..., "nine" }  (인덱스 = 숫자)
2. num = 0 ~ 9 반복:
   a. s.find(words[num])로 단어 위치 pos 탐색
   b. 찾으면(npos 아니면) s.replace(pos, 길이, to_string(num))
   c. 같은 단어가 또 있을 수 있으니 while로 전부 치환
3. 치환 끝나면 s는 숫자 문자만 남음 → stoi(s)
```

```cpp
for (int num = 0; num < 10; num++)
{
    size_t pos;

    while ((pos = s.find(words[num])) != string::npos)
    {
        // pos자리부터 words[num].size() 크기만큼, to_string(num)으로 교체.
        s.replace(pos, words[num].size(), to_string(num));
    }
}
return stoi(s);
```

---

## 🚀 정답 풀이 방법 ② — 앞에서부터 파싱 (O(N))

`i`를 앞에서부터 한 번만 이동시킨다. 재탐색이 없어 뒤로 되돌아가지 않는다.

```cpp
string result;

for (int i = 0; i < (int)s.size(); )
{
    // 숫자면 그대로 붙이고 한 칸 이동
    if (isdigit(s[i]))
    {
        result += s[i];
        i++;
        continue;
    }

    // 영단어면 i 위치부터 어떤 단어와 일치하는지 검사
    for (int num = 0; num < 10; num++)
    {
        // s의 i자리부터 words[num].size() 크기만큼이 words[num]과 같은지 비교
        if (s.compare(i, words[num].size(), words[num]) == 0)
        {
            result += to_string(num);   // 해당 숫자 붙이기
            i += words[num].size();     // 단어 길이만큼 점프
            break;
        }
    }
}
return stoi(result);
```

- `s.compare(i, len, words[num])` : `s`의 `i`자리부터 `len`글자가 `words[num]`과 같으면 `0` 반환
- `i`가 절대 뒤로 가지 않으므로 전체 문자열을 딱 한 번만 통과 → **O(N)**

---

## 🔑 핵심 개념

### 1️⃣ `size_t` — 크기·인덱스를 담는 부호 없는 정수 타입

`size_t`는 **부호 없는(unsigned) 정수** 타입으로, 배열/문자열의 크기나 인덱스처럼 **음수가 될 수 없는 값**을 담기 위해 존재한다. (`sizeof` 연산자의 반환 타입)

- `s.find(...)`의 반환 타입이 `size_t`이고, "못 찾음"을 뜻하는 `string::npos`는 `size_t`의 **최댓값**(`-1`을 unsigned로 해석한 값)이다.

### 2️⃣ `size_t`를 `int`로 바꿔도 되나? → 이 문제에선 OK, 하지만 정석은 `size_t`

```cpp
int pos;   // 이 문제에선 동작함
while ((pos = s.find(words[num])) != string::npos) { ... }
```

**왜 동작하나?**
- 이 문제의 문자열은 매우 짧아(최대 약 50자) 인덱스가 `int` 범위를 넘지 않는다.
- `find`가 `npos`를 반환하면 `int pos`에는 `-1`이 담기고, `pos != string::npos` 비교 시 `-1`이 다시 `size_t`(최댓값)로 변환되어 `npos`와 같아진다 → 조건 판정이 우연히 맞아떨어진다.

**그래도 `size_t`를 쓰는 이유**
- 문자열이 `int` 범위(약 21억)를 넘으면 인덱스가 오버플로우로 깨진다.
- `int`(signed) ↔ `size_t`(unsigned) 비교는 컴파일러 경고(`-Wsign-compare`) 대상이다.
- `find`의 반환 타입과 **타입을 맞추는 것**이 의도가 명확하고 안전하다.

> 결론: **"바꿔도 이 문제는 통과하지만, 타입을 맞추는 `size_t`가 정석"**.

### 3️⃣ `find` → 위치, `replace` → 그 위치를 잘라 끼워 넣기

- `s.find(words[num])` : 단어가 **처음 등장하는 위치(인덱스)** 반환, 없으면 `npos`
- `s.replace(pos, len, str)` : `pos`부터 `len`글자를 지우고 그 자리에 `str` 삽입
- `replace` 후 `s`의 내용·길이가 바뀌므로, 다음 `find`는 **바뀐 s의 맨 앞(0번)부터** 다시 검색한다 → 이 재탐색이 ①의 O(N²) 원인.

---

## ⏱️ 시간복잡도 비교

문자열 길이를 N이라 하면:

| 방식 | 복잡도 | 이유 |
|------|--------|------|
| ① 치환 (find+replace) | **O(N²)** | 10(숫자) × 치환 반복(O(N)) × 매번 앞에서부터 재탐색(O(N)) |
| ② 앞에서부터 파싱 | **O(N)** | `i`가 앞으로만 이동, 각 위치에서 단어 비교는 상수(10단어×5글자) |

- 질문했던 **"S × 10 × N"** 감각은 정확하다 — 재탐색 때문에 N이 한 번 더 곱해져 ①은 **O(N²)** 에 가깝다.
- 다만 이 문제는 N이 매우 작아(최대 약 50자) ①로도 즉시 끝난다. 최적화가 필요한 건 아니지만, **되돌아가지 않는 단일 스캔**으로 O(N)을 만드는 감각을 ②에서 정리해둔다.
