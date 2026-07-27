---
name: coding-style
description: C++ 코드 작성 및 스타일 확인 시 참고. 코딩 스타일 가이드.
---

# 🎨 코딩 스타일

> ✅ **Complete 프로젝트는 공부를 완료한 코드들**
> 내 스타일에 맞게 수정된 코드들이므로, 코드 스타일을 참고한다.

## 📦 헤더 및 전역 변수

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll; // INF 합산 등 오버플로우 방지 시 사용

// 전역 변수는 상단에 선언하고 타입/의미별로 정렬
// 주석은 선언 위 별도 줄이 아닌, 같은 줄 오른쪽 인라인으로 작성
// 주석 시작 위치(// )는 컬럼 정렬로 맞춤
int                    n, m;       // n : 원소 수, m : 쿼리 수  ← 한 줄에 여러 변수 → 이름 명시
int                    arr[54];    // 입력 배열
ll                     dp[54][21]; // dp[idx][sum] = 경우의 수 (값이 커지므로 ll)
bool                   flag;       // 상태 플래그 (int보다 bool 권장)
vector<pair<int, int>> graph[54];  // graph[u] = {가중치, 목적지}
```

**정렬 규칙 :**
- 타입 정렬 : 동일한 타입끼리 그룹화
- 인라인 주석 : 변수 주석은 선언 위 별도 줄이 아닌 **같은 줄 오른쪽**에 작성
- typedef 주석 : `typedef` 선언에도 인라인 주석으로 사용 이유 명시
- 의미별 그룹 : 관련 변수들끼리 묶어서 선언
- bool 권장 : 사용 여부 체크는 int보다 bool 타입 권장

**⚠️ 전역변수 vs 지역변수 — 컬럼 정렬 방식이 다름 :**

```cpp
// ✅ 전역변수 : 타입과 변수명 사이를 패딩 → 변수명/주석 시작 위치를 수직 정렬
int                    n, e;       // n : 정점 수, e : 간선 수
int                    v1, v2;     // 반드시 거쳐야 하는 두 정점
vector<pair<int, int>> graph[801]; // graph[u] = {가중치, 목적지}

// ✅ 지역변수 : 선언은 컴팩트하게, 세미콜론 이후를 패딩 → 주석 시작 위치만 정렬
vector<int> dist(n + 1, INF); // 모든 거리 INF로 초기화
priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq; // 최솟값 우선 (min-heap)

// ❌ 지역변수에 전역변수 방식 적용 금지 — 타입과 변수명 사이 패딩 하지 말 것
vector<int>                            dist(n + 1, INF); // ← 타입 사이 패딩은 금지
```

---

## 🔗 typedef 규칙

typedef는 **`ll` 에만** 사용한다. `pair<int, int>` 는 몇 번 등장하든 **alias 없이 그대로 풀어서** 작성.

```cpp
// ✅ ll 만 typedef
typedef long long ll;

vector<pair<int, int>> graph[801]; // graph[u] = {가중치, 목적지}
pair<int, int>         target;     // 타입이 뭔지 선언만 봐도 바로 보임

// ❌ pair 계열 alias 금지 — pii 정의를 찾아 올라가야 타입을 알 수 있음
typedef pair<int, int> pii;

vector<pii> graph[801];
pii         target;
```

**적용 기준 :**
- `pair<int, int>` → **항상 풀어서 작성** (`pii` 등 alias 선언 금지)
- `ll` 은 오버플로우 가능성만 있어도 미리 선언 (INF 합산, 큰 곱셈 등)
- typedef는 헤더 바로 아래, 전역 변수 선언 전에 위치

### 🔤 인라인 주석 형식 규칙

**한 줄에 변수가 하나**인 경우 → 변수명은 선언에 이미 있으므로 **주석에 이름 반복 금지**, 설명만 작성.

**한 줄에 변수가 여럿**인 경우 → 어떤 설명이 어떤 변수인지 구분이 필요하므로 `이름 : 설명` 형식 사용.

```cpp
// ✅ 올바른 형식
int                 n, m, k;    // n : 사람 수, m : 파티 수, k : 진실 아는 사람 수  ← 여럿
int                 lieCnt;     // 거짓말 가능한 파티 수                             ← 하나
int                 parent[51]; // Union-Find 부모 배열 (parent[x] = x의 부모)       ← 하나
set<int>            truthSet;   // 초기 진실을 아는 사람 번호                         ← 하나
set<int>            truthRoots; // 진실 그룹의 루트 노드 집합                         ← 하나
vector<vector<int>> groups;     // 각 파티 참석자 목록                               ← 하나

// ❌ 잘못된 형식 — 단일 변수 줄에서 이름 중복
int                 lieCnt;     // lieCnt : 거짓말 가능한 파티 수
set<int>            truthRoots; // truthRoots : 진실 그룹의 루트 노드 집합
```

**적용 기준 :**
- 단일 변수 : `// 설명` (이름 생략)
- 다중 변수 : `// a : 설명, b : 설명` (이름 명시, `:` 앞뒤 공백)

---

## 📌 STL 삽입 함수 규칙

STL 컨테이너에 삽입 시 `push` / `push_back` 대신 **`emplace` / `emplace_back`** 사용.

```cpp
// ✅ emplace 계열 사용
pq.emplace(0, src);              // priority_queue
pq.emplace(dist[next], next);
graph[a].emplace_back(c, b);     // vector
graph[b].emplace_back(c, a);

// ❌ push 계열 금지
pq.push({0, src});
graph[a].push_back({c, b});
```

**priority_queue top/pop 분리 규칙 :**

```cpp
// ✅ top()과 pop()은 반드시 두 줄로 분리
auto [d, u] = pq.top();
pq.pop();

// ❌ 한 줄 압축 금지
auto [d, u] = pq.top(); pq.pop();
```

---

## 🔧 함수 및 주석 스타일

```cpp
// 함수명 : BFS, DFS 등 알고리즘 약어는 대문자 그대로 사용
// 함수 : 중괄호는 다음 줄에, 4칸 들여쓰기
int BFS()
{
    int areaCnt = 0;  // 변수명 : 맥락이 담긴 이름 (cnt ❌ → areaCnt ✅)
    queue<pair<int,int>> bfsQ;

    // 함수 내 단계별로 주석 추가
    // 모든 시작점 체크
    for (int i = 0; i < n; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            if (!visited[i][j])
            {
                areaCnt++;  // 중요한 상태 변경 뒤에는 빈 줄로 시각 구분

                visited[i][j] = true;
                bfsQ.emplace(i, j);
            }
        }
    }
    return areaCnt;
}

// 매개변수 주석 : 콜론(`:`) 앞뒤 공백
// x : 왼쪽 숫자, y : 오른쪽 숫자, op : 부등호 기호
bool Check(char x, char y, char op) { }
```

**주석 규칙 :**
- 변수 설명 : 전역 변수 선언 후 각각의 역할 설명
- 함수 설명 : 함수 위에 한 줄로 동작 설명 (매개변수/반환값 포함)
- 콜론 공백 : 매개변수 설명 시 `: 앞뒤로 공백` (예 : `x : 설명`)
- 라인 정렬 : 같은 블록 내 주석들의 시작 위치 통일
- 명확성 : 알고리즘 로직을 이해하기 쉽게 설명
- 단계 주석 : 함수 내부도 역할별로 `// 단계 설명` 주석 추가

**함수 내부 주석 기준 — 과하지 않게, 핵심만 꼼꼼히 :**

```cpp
// src를 시작점으로 다익스트라 실행, 각 정점까지의 최단 거리 반환
vector<int> Dijkstra(int src)
{
    vector<int> dist(n + 1, INF); // INF로 초기화
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq; // 최솟값 우선 (min-heap)

    dist[src] = 0;
    pq.emplace(0, src); // {거리, 정점}

    while (!pq.empty())
    {
        auto [d, u] = pq.top();
        pq.pop();

        if (d > dist[u]) // 이미 처리된 정점 스킵
        {
            continue;
        }

        for (auto [w, next] : graph[u]) // 인접 정점 탐색
        {
            if (dist[u] + w < dist[next])
            {
                dist[next] = dist[u] + w;
                pq.emplace(dist[next], next);
            }
        }
    }

    return dist;
}
```

**주석 달아야 할 위치 (기준) :**
- 자료구조 선언부 : 역할/정렬 방향 등 (`// 최솟값 우선 (min-heap)`)
- 초기 삽입 : 형식 설명 (`// {거리, 정점}`)
- 핵심 조건 : 조건의 의미 (`// 이미 처리된 정점 스킵`)
- 반복문 : 무엇을 순회하는지 (`// 인접 정점 탐색`)
- 양방향 간선 : 명시 (`// 양방향 간선`)
- 분기 결과 : 의미 (`// 경로 없음`)
- 경우 계산 : 경로 방향 명시 (`// 1 → v1 → v2 → N`)

**함수명 규칙 :**
- BFS, DFS, LCS 등 알고리즘 약어 → **대문자 그대로** (`bfsAll` ❌ → `BFS` ✅)
- 일반 함수명 → PascalCase (`Check`, `Solve`)

**변수명 규칙 :**
- 단순 `cnt` 대신 맥락이 담긴 이름 사용 (`areaCnt`, `colorCnt`, `nodeCnt`)

---

## 📥 입력 변수 선언 분리 규칙

임시 변수 선언 + `cin` 입력과, 이후 **메서드 호출/로직** 사이에는 **빈 줄**을 넣는다.

```cpp
// ✅ 올바른 형식 — 선언/입력과 메서드 호출을 빈 줄로 구분
for (int i = 0; i < k; i++)
{
    int x;
    cin >> x;

    truthSet.insert(x);
}

// ❌ 잘못된 형식 — 한 줄에 몰아쓰거나 빈 줄 없이 바로 연결
for (int i = 0; i < k; i++)
{
    int x; cin >> x;
    truthSet.insert(x);
}
```

**적용 범위 :**
- 루프 내에서 임시 변수를 선언해 입력받고 컨테이너에 삽입하는 패턴
- 입력받은 값으로 즉시 연산/함수 호출하는 패턴 전반

---

## 🗺️ 값 변환은 공식보다 매핑 테이블

경우의 수가 **적고 고정**되어 있는 변환(숫자 → 좌표, 문자 → 인덱스 등)은
공식으로 계산하지 말고 **미리 배열에 적어두고 꺼내 쓴다.**

```cpp
// ✅ 매핑 테이블 — 키패드 모양이 코드에 그대로 보임
pair<int, int> keyPos[10] =
{
    { 3, 1 }, // 0
    { 0, 0 }, // 1
    { 0, 1 }, // 2
    { 0, 2 }, // 3
    { 1, 0 }, // 4
    { 1, 1 }, // 5
    { 1, 2 }, // 6
    { 2, 0 }, // 7
    { 2, 1 }, // 8
    { 2, 2 }  // 9
};

pair<int, int> target = keyPos[num]; // 인덱싱 한 번이면 끝

// ❌ 공식 계산 — 예외(0)를 위해 분기가 붙고, 공식이 맞는지 머리로 검산해야 함
pair<int, int> GetPos(int num)
{
    if (num == 0)
    {
        return { 3, 1 };
    }

    return { (num - 1) / 3, (num - 1) % 3 };
}
```

**적용 기준 :**
- 값의 개수가 적고 고정 → **표**
- 공식에 예외 케이스가 하나라도 생김 → **표** (분기 없이 표에 적어두면 끝)
- 표는 전역에 선언하고, 각 원소 오른쪽에 인라인 주석으로 무엇에 대응하는지 명시

---

## 🔲 중괄호 규칙 (Allman 스타일 완전 준수)

중괄호는 **항상** 다음 줄에, 내용도 **항상** 별도 줄에. 인라인 압축 금지.

```cpp
// ✅ 단일 문장도 항상 Allman 스타일로 완전히 풀어쓰기
for (int i = 0; i < n; ++i)
{
    for (int j = 0; j < n; ++j)
    {
        cin >> arr[i][j];
    }
}

if (arr[i][j] == 'G')
{
    arr[i][j] = 'R';
}

if (d > dist[u]) // continue/break 같은 단문도 반드시 풀어쓰기
{
    continue;
}

if (ans >= INF) // if-else도 항상 풀어쓰기
{
    cout << -1 << "\n";
}
else
{
    cout << ans << "\n";
}

// ❌ 인라인 압축 금지 — 단일 문장이라도 절대 한 줄에 쓰지 않음
if (d > dist[u]) { continue; }
if (ans >= INF) { cout << -1 << "\n"; } else { cout << ans << "\n"; }
for (int i = 0; i < n; ++i)
    cin >> arr[i]; // 중괄호 생략 금지
```

## 🏗️ 클래스 스타일

문제에서 클래스가 명시적으로 요구될 때만 사용. 그 외에는 전역 변수 + 전역 함수로 구현.

```cpp
// ✅ 올바른 클래스 스타일
class Student
{
    public:                     // public: 은 4칸 들여쓰기
        int scores[5] = {};     // 멤버 변수는 public: 아래 8칸 들여쓰기, = {}로 0 초기화

    // 멤버 함수 위 동작 설명 주석
    void Input()                // 멤버 함수는 4칸 들여쓰기 (public: 와 같은 수준)
    {
        for (int i = 0; i < 5; i++)
        {
            cin >> scores[i];
        }
    }

    // 멤버 함수명도 PascalCase
    int CalculateTotalScore()
    {
        int total = 0;

        for (int i = 0; i < 5; i++)
        {
            total += scores[i];
        }

        return total;
    }
};

// ❌ 잘못된 클래스 스타일
class Student
{
private:              // private: 지양 — CP에서 불필요한 캡슐화
    int scores[5];    // 초기화 없음 → 경고 발생

public:               // public: 들여쓰기 없음 — 잘못된 형식
    void input() { }  // camelCase 함수명 금지
};
```

**클래스 규칙 :**
- `public:` 레이블은 클래스 본문에서 **4칸 들여쓰기**
- `public:` 아래 멤버 변수는 **8칸 들여쓰기** (추가 4칸)
- 멤버 함수는 **4칸 들여쓰기** (public: 와 같은 수준)
- `private:` 지양 — CP에서 불필요한 캡슐화, `public:` 만 사용
- 멤버 변수는 **`= {}`** 로 0 초기화 (미초기화 경고 방지)
- 멤버 함수명도 **PascalCase** (`input` ❌ → `Input` ✅)
- 동적 할당(`new`/`delete`) 대신 **`vector<ClassName>`** 사용

---

## 📝 복잡한 줄 주석 위치

단순 값 설명은 인라인, 긴 설명 또는 메서드 호출 결과 설명은 위 줄에 단독으로 작성.

```cpp
// ✅ 메서드 호출 결과 — 위 줄에 단독 주석
// 첫 번째 학생이 Kristen (카린 점수 합 구하기)
int kristenScore = students[0].CalculateTotalScore();

// ✅ 조건문 의미 — if 위 줄에 단독 주석
// 카린의 점수 합 보다 크다면, 카운트
if (students[i].CalculateTotalScore() > kristenScore)
{
    higherCnt++;
}

// ✅ 단순 변수 — 인라인 주석으로 충분
vector<Student> students(n); // n명의 학생
int scores[5] = {};          // 시험 점수 5개 (0으로 초기화)
```

**적용 기준 :**
- 단순 선언/값 : 인라인 `// 짧은 설명`
- 메서드 호출 결과 / 긴 설명 : 위 줄에 `// 설명` 단독 작성
- 조건문 의미 설명 : if/for 위 줄에 `// 설명` 단독 작성

---

## ⚡ main 함수 구조

```cpp
int main()
{
    ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);  // 필수

    // 입력 처리
    cin >> n >> l >> r;

    // 알고리즘 로직
    // ...

    // 결과 출력
    cout << cnt << "\n";

    return 0;  // return 0 직전에 빈 줄 추가
}
```

**필수 포함 사항 :**
- 입출력 최적화 : `ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);`
- 간결한 구조 : 입력 → 처리 → 출력 순서
- 명확한 구분 : 각 단계별로 주석으로 구분
- 필요시 메서드 : 메인 로직이 너무 길어지면 핵심 알고리즘을 메서드로 묶기

## 🎯 코딩 원칙

| DO ✅ | DON'T ❌ |
|-------|----------|
| 빠른 구현 (직관적 코드) | 과도한 객체지향 |
| 전역 변수/STL 적극 활용 | 복잡한 템플릿 |
| 입출력 최적화 기본 적용 | 불필요한 최적화 |
| PDF 교안 패턴 따르기 | 동작 전 최적화 |

**체크리스트 :**
- [ ] 전역 변수 정렬이 올바른가?
- [ ] 주석이 정렬되어 있는가?
- [ ] 단일 변수 줄의 인라인 주석에서 변수명을 중복 작성하지 않았는가?
- [ ] 다중 변수 줄의 인라인 주석에서 `이름 : 설명` 형식으로 각각 구분했는가?
- [ ] `pair<int, int>` 를 `pii` 등으로 typedef 하지 않고 그대로 풀어 썼는가?
- [ ] 경우의 수가 적고 고정된 변환을 공식 대신 매핑 테이블로 처리했는가?
- [ ] `ll` typedef를 선언했는가? (오버플로우 가능성 있으면 선언)
- [ ] `push_back` / `push` 대신 `emplace_back` / `emplace` 를 사용했는가?
- [ ] `pq.top()` 과 `pq.pop()` 을 두 줄로 분리했는가?
- [ ] 모든 if/for/while 이 Allman 스타일로 완전히 풀어 써졌는가? (인라인 압축 없음)
- [ ] 함수 위에 동작 설명 주석이 있는가?
- [ ] 자료구조 선언부, 핵심 조건, 반복문, 분기 결과에 핵심 인라인 주석이 있는가?
- [ ] 중괄호 스타일이 일관된가? (단일 문장도 항상 중괄호, 항상 다음 줄)
- [ ] ios_base 최적화가 포함되었는가?
- [ ] PDF 교안의 패턴을 따르고 있는가?
- [ ] 함수명이 BFS/DFS 등 약어를 대문자로 유지하는가?
- [ ] 변수명이 맥락을 담고 있는가? (cnt ❌ → areaCnt ✅)
- [ ] 입력 변수 선언/cin 과 이후 메서드 호출 사이에 빈 줄이 있는가?
- [ ] 중요 상태 변경 뒤 빈 줄이 있는가?
- [ ] return 0 직전에 빈 줄이 있는가?
- [ ] 클래스 사용 시 `public:` 이 4칸 들여쓰기 되어 있는가?
- [ ] 클래스 멤버 변수가 `public:` 아래 8칸 들여쓰기 되어 있는가?
- [ ] 클래스 멤버 함수가 4칸 들여쓰기 (public: 와 같은 수준) 되어 있는가?
- [ ] `private:` 을 사용하지 않았는가? (CP에서 불필요)
- [ ] 멤버 변수가 `= {}` 로 0 초기화 되어 있는가?
- [ ] 멤버 함수명도 PascalCase 인가? (`input` ❌ → `Input` ✅)
- [ ] 동적 할당(`new`/`delete`) 대신 `vector<ClassName>` 을 사용했는가?
- [ ] 메서드 호출 결과 / 긴 설명 주석이 위 줄에 단독으로 작성되었는가?
