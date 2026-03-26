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

typedef long long ll; // 사용 이유 주석 (예 : '2^63 - 1' 까지 필요하므로 ll 사용)

// 전역 변수는 상단에 선언하고 타입/의미별로 정렬
// 주석은 선언 위 별도 줄이 아닌, 같은 줄 오른쪽 인라인으로 작성
// 주석 시작 위치(// )는 컬럼 정렬로 맞춤
int    n;                    // n     : 숫자 개수
int    arr[54];              // arr   : 입력 배열
ll     dp[54][21];           // dp    : dp[idx][sum] = 경우의 수 (값이 커지므로 ll)
bool   flag = false;         // flag  : 상태 플래그 (int보다 bool 권장)
vector<pair<int,int>> uni;   // uni   : 유니온 파인드용 벡터
```

**정렬 규칙 :**
- 타입 정렬 : 동일한 타입끼리 그룹화
- 컬럼 정렬 : 타입 / 변수명 / `//` 주석 시작 위치 정렬
- 인라인 주석 : 변수 주석은 선언 위 별도 줄이 아닌 **같은 줄 오른쪽**에 작성
- typedef 주석 : `typedef` 선언에도 인라인 주석으로 사용 이유 명시
- 의미별 그룹 : 관련 변수들끼리 묶어서 선언
- bool 권장 : 사용 여부 체크는 int보다 bool 타입 권장

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
- 함수 설명 : 매개변수와 동작 방식 설명
- 콜론 공백 : 매개변수 설명 시 `: 앞뒤로 공백` (예 : `x : 설명`)
- 라인 정렬 : 같은 블록 내 주석들의 시작 위치 통일
- 명확성 : 알고리즘 로직을 이해하기 쉽게 설명
- 단계 주석 : 함수 내부도 역할별로 `// 단계 설명` 주석 추가

**함수명 규칙 :**
- BFS, DFS, LCS 등 알고리즘 약어 → **대문자 그대로** (`bfsAll` ❌ → `BFS` ✅)
- 일반 함수명 → PascalCase (`Check`, `Solve`)

**변수명 규칙 :**
- 단순 `cnt` 대신 맥락이 담긴 이름 사용 (`areaCnt`, `colorCnt`, `nodeCnt`)

## 🔲 중괄호 규칙

```cpp
// ✅ for/if 단일 문장이라도 항상 중괄호 사용
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

// ❌ 중괄호 생략 금지
for (int i = 0; i < n; ++i)
    for (int j = 0; j < n; ++j)
        cin >> arr[i][j];
```

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
- [ ] 중괄호 스타일이 일관된가? (단일 문장도 항상 중괄호 사용)
- [ ] ios_base 최적화가 포함되었는가?
- [ ] PDF 교안의 패턴을 따르고 있는가?
- [ ] 함수명이 BFS/DFS 등 약어를 대문자로 유지하는가?
- [ ] 변수명이 맥락을 담고 있는가? (cnt ❌ → areaCnt ✅)
- [ ] 중요 상태 변경 뒤 빈 줄이 있는가?
- [ ] return 0 직전에 빈 줄이 있는가?
