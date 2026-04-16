**📅 작성일**: 2025-10-04

## 🔗 문제 링크

[Attribute Parser (속성 파서)](https://www.hackerrank.com/challenges/attribute-parser/problem?isFullScreen=true)

**난이도**: Medium 35점

---

## 🤔 접근법

HRML(XML 유사 마크업)을 파싱하여 `map`에 저장한 뒤, 쿼리로 특정 태그 경로의 속성 값을 조회하는 구현 파싱 문제.

태그는 계층 구조를 가지므로 **절대 경로** 방식으로 키를 만들어야 한다. `tag1.tag2~attr` 형식의 키로 `map`에 저장하면 쿼리를 그대로 키로 사용해 O(log N)으로 조회 가능.

**핵심**: `channel` 벡터로 누적 경로 스택을 관리하고, `"경로~속성"` 형식의 키로 `map`에 저장하는 것이 전부다.

---

## 💡 정답 풀이 방법

**알고리즘** : 스택(경로 관리) + map(속성 저장) + stringstream(라인 파싱)

**핵심 아이디어**:
```
1. 각 HRML 라인에서 '"' 와 '>' 를 미리 제거 → 파싱 단순화
2. 닫는 태그(</): channel.pop_back() → 경로 한 단계 위로
3. 여는 태그(<): stringstream으로 태그명 + 속성들 파싱
   - channel.back() + "." + 태그명 → 누적 경로 생성 후 push
   - "경로~속성명" → 값  을 map에 저장
4. 쿼리: map.find(query) → 있으면 값 출력, 없으면 "Not Found!"
```

---

## 🔑 핵심 포인트

### 1️⃣ `"` 와 `>` 미리 제거 후 stringstream 파싱

```cpp
// 파싱 편의를 위해 불필요 문자 제거 : " 와 >
temp.erase(remove(temp.begin(), temp.end(), '"'), temp.end());
temp.erase(remove(temp.begin(), temp.end(), '>'), temp.end());

// 제거 후: <tag1 value = HelloWorld attr2 = World
stringstream ss;
ss.str(temp);

string t1, p1, v1;
char ch;

// ch = '<', t1 = "tag1", p1 = "value", ch = '=', v1 = "HelloWorld"
ss >> ch >> t1 >> p1 >> ch >> v1;
```

**✅ 핵심**: `"`와 `>`를 미리 제거하면 `stringstream >>` 로 공백 단위 파싱이 가능. 특수문자를 직접 다루지 않아도 됨.

### 2️⃣ `channel` 벡터로 누적 경로 스택 관리

```cpp
vector<string> channel; // 현재 경로 스택 (누적 절대 경로 저장)
// 예: channel = ["tag1", "tag1.tag2", "tag1.tag2.tag3"]

// 여는 태그: 경로 확장
string tempChannel;
if (!channel.empty())
    tempChannel = channel.back() + "." + t1; // 부모경로 + "." + 현재 태그
else
    tempChannel = t1; // 루트 태그
channel.push_back(tempChannel);

// 닫는 태그: 경로 축소
channel.pop_back();
```

**✅ 핵심**: 각 원소가 누적 절대 경로를 저장. `channel.back()`이 항상 현재 전체 경로를 반환.

### 3️⃣ `map` 키 = `"경로~속성명"` 형식

```cpp
map<string, string> m; // "tag1.tag2~attr" → "value"

// 첫 속성 저장
m[channel.back() + "~" + p1] = v1;

// 남은 속성 반복 저장
while (ss)
{
    ss >> p1 >> ch >> v1; // "속성명 = 값" 순으로 읽힘
    if (!ss) break;
    m[channel.back() + "~" + p1] = v1;
}
```

**✅ 핵심**: 구분자 `~` 는 쿼리 형식 `tag1.tag2~attr` 과 동일. 쿼리를 그대로 map 키로 사용 가능.

### 4️⃣ 닫는 태그 감지 방법

```cpp
// "</" 로 시작하면 닫는 태그
if (temp.substr(0, 2) == "</")
{
    channel.pop_back(); // 경로에서 한 단계 위로
}
```

**✅ 핵심**: `>` 를 미리 제거했으므로 `</tag` 형태. `substr(0, 2)` 로 간단히 판별 가능.

---

## 🔍 파싱 흐름 예시

**입력 예시**:
```
<tag1 value = HelloWorld>
    <tag2 name = John>
    </tag2>
</tag1>
```

```
라인 1: <tag1 value = HelloWorld
  → ch='<', t1="tag1", p1="value", v1="HelloWorld"
  → channel = ["tag1"]
  → m["tag1~value"] = "HelloWorld"

라인 2: <tag2 name = John
  → t1="tag2"
  → channel = ["tag1", "tag1.tag2"]
  → m["tag1.tag2~name"] = "John"

라인 3: </tag2
  → channel.pop_back()
  → channel = ["tag1"]

라인 4: </tag1
  → channel.pop_back()
  → channel = []
```

**쿼리** `tag1.tag2~name` → map에서 조회 → `"John"` 출력

---

## ⏱️ 시간복잡도

**O(N × M + Q × log(N × M))**

**상세 분석**:
```
1. HRML 파싱 : N개 라인, 라인당 평균 M개 토큰 → O(N × M)
2. 쿼리 처리 : Q번 × map 조회 O(log(N×M)) → O(Q × log(N×M))
총합: O(N × M + Q × log(N × M))
```

**시간 제한 체크**:
- N, Q ≤ 20 → 연산 수 매우 작음 → 여유롭게 통과 ✅

---

## 💾 공간복잡도

**O(N × M + Q)**

**분석**:
- `hrml`, `quer` 벡터: O(N + Q)
- `m` (map): 총 속성 수 = O(N × M)
- `channel` 벡터: 최대 태그 깊이 O(D) (D ≤ N)
- 총 공간: O(N × M + Q)
