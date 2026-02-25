# 🎯 코딩 테스트 연습 및 정리 규칙 CLAUDE.MD

<br>

## 📑 목차 (Table of Contents)

1. [🔍 백준 문제 정보 파악 방법](#-백준-문제-정보-파악-방법)
2. [📋 프로젝트 정보](#-프로젝트-정보)
3. [🎨 코딩 스타일](#-코딩-스타일)
4. [🔄 작업 방식](#-작업-방식)
5. [🌏 한글 인코딩 설정](#-한글-인코딩-설정)
6. [🔧 Visual Studio 프로젝트 파일 관리](#-visual-studio-프로젝트-파일-관리)

<br>

---

# 🔍 백준 문제 정보 파악 방법

## ⚠️ 중요 : 백준 문제 처리 시 필수 확인 사항

백준 문제를 처리할 때는 **반드시** 다음 프로세스를 따라야 합니다.

### 1️⃣ 문제 난이도 확인 (solved.ac API)

```
https://solved.ac/api/v3/problem/show?problemId={문제번호}
```

**확인 정보 :** 문제 번호, 제목, 난이도 (Bronze/Silver/Gold 1~5)

<br>

### 2️⃣ 문제 상세 정보 파악

> **🚫 백준 사이트 직접 접근 불가** (403 Forbidden)
>
> **✅ 대안 :** WebSearch로 문제 내용 검색 또는 사용자에게 직접 확인 요청

**반드시 파악해야 할 정보 :**

| 항목 | 필수 여부 |
|-----|----------|
| 문제 내용, 입력/출력 형식, 예제 입출력 | ✅ 필수 |
| 출처, 알고리즘 분류 | ⚪ 선택 |

<br>

### 3️⃣ 작업 순서

```
1. solved.ac API로 난이도 확인
2. WebSearch 또는 사용자에게 문제 상세 정보 확인
3. 모든 정보 확인 후 작업 시작
4. 폴더 생성 (올바른 난이도)
5. Answer.cpp.txt 작성
6. README.md 작성 (기존 형식 참고)
7. Complete.vcxproj 업데이트
```

**❌ 금지 :** 난이도 추측, 정보 미확인 상태 작업, 불확실한 정보로 파일 생성

※ 사용자가 문제 정보를 미리 알려준 경우, 정보를 기억해 놨다가, 1번과 2번 작업을 생략하고, 해당 정보로 진행.

<br>

---

# 📋 프로젝트 정보

**용도 :** 코딩테스트 연습 및 알고리즘 문제 해결 (Visual Studio C++, Windows)

**C++ 버전 :** C++ 17

**참고 자료 우선순위 :**
1. **프로젝트 내 PDF** : C++문법 교안.pdf, 개념 교안.pdf, 문제 정답.pdf
2. **Complete 폴더** : 기존 코드 스타일 패턴
3. **기존 README** : 작성 형식 반드시 참고

<br>

---

# 🎨 코딩 스타일

> ✅ **Complete 프로젝트는 공부를 완료한 코드들**
> 내 스타일에 맞게 수정된 코드들이므로, 코드 스타일을 참고한다.

## 📦 헤더 및 전역 변수

```cpp
#include <bits/stdc++.h>
using namespace std;

// 전역 변수는 상단에 선언하고 타입/의미별로 정렬
int    visited[54][54], a[54][54]
int    n, l, r;
int    sum = 0, cnt = 0;
bool   flag = false;  // int보다 bool 권장 (메모리 효율, 의미 명확)
vector<pair<int,int>> uni;
```

**정렬 규칙 :**
- 타입 정렬 : 동일한 타입끼리 그룹화
- 컬럼 정렬 : 타입 / 변수명 / = / 초기값 정렬
- 의미별 그룹 : 관련 변수들끼리 묶어서 선언
- bool 권장 : 사용 여부 체크는 int보다 bool 타입 권장

<br>

## 🔧 함수 및 주석 스타일

```cpp
// 함수 : 중괄호는 다음 줄에, 4칸 들여쓰기
void dfs(int y, int x)
{
    for(int i = 0; i < 4; i++)
    {
        visited[ny][nx] = 1;     // 라인별 주석 정렬
        uni.push_back({ny, nx}); // 연합에 추가
    }
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

<br>

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
    return 0;
}
```

**필수 포함 사항 :**
- 입출력 최적화 : `ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);`
- 간결한 구조 : 입력 → 처리 → 출력 순서
- 명확한 구분 : 각 단계별로 주석으로 구분
- 필요시 메서드 : 메인 로직이 너무 길어지면 핵심 알고리즘을 메서드로 묶기

<br>

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
- [ ] 중괄호 스타일이 일관된가?
- [ ] ios_base 최적화가 포함되었는가?
- [ ] PDF 교안의 패턴을 따르고 있는가?

<br>

---

# 🔄 작업 방식

## 📦 Complete 폴더로 정리 작업 프로세스

### ⚠️ 중요 : "정리" 키워드 인식

다음 키워드 시 **자동으로 Complete 정리 작업 시작** :
- "컴플리트에 작업한 내용을 옮겨서 정리"
- "컴플리트로 정리"
- "완료한 문제 정리해줘"

<br>

### 🎯 Complete 정리 9단계

1. **Test.cpp 확인** : 작성된 코드 읽기
2. **문제 정보 확인** : solved.ac API로 난이도 + WebSearch로 상세 정보
3. **기존 형식 참고** : 최소 3개 README.md 읽기 (폴더명/작성 형식/코드 스타일)
4. **폴더/파일 생성** : `Complete/백준/{티어}_{번호}_{제목}/` + Answer.cpp.txt + README.md
5. **Answer.cpp.txt** : Test.cpp 복사 → UTF-8 BOM → 스타일 정리 (⚠️ `.cpp.txt` 확장자!)
6. **README.md** : 기존 형식과 동일하게 (작성일/링크/접근법/풀이/시간복잡도)
7. **vcxproj 업데이트** : `<None>` 섹션에 .cpp.txt와 .md 추가, 알파벳순 정렬
8. **파일명 확인** : `.cpp.txt` 확장자 검증
9. **검증** : 위치/형식/vcxproj 업데이트 확인 (아래 체크리스트 필수 수행)

<br>

### ✅ 필수 검증 체크리스트 (9단계 상세)

작업 완료 후 **반드시** 다음을 확인해야 합니다:

#### 📋 vcxproj 등록 확인
- [ ] `.cpp.txt` 파일이 Complete.vcxproj의 **첫 번째** `<ItemGroup>` 섹션에 등록되었는가?
- [ ] `README.md` 파일이 Complete.vcxproj의 **두 번째** `<ItemGroup>` 섹션에 등록되었는가?
- [ ] 모든 파일이 **알파벳순**으로 정렬되었는가? (티어 → 문제 번호 순)
- [ ] 경로에 **백슬래시(`\`)** 를 사용했는가? (슬래시 `/` 아님!)

#### 🔍 파일 확인
- [ ] 파일 확장자가 `.cpp.txt`인가? (`.cpp` 아님!)
- [ ] UTF-8 BOM 인코딩으로 저장되었는가?
- [ ] 폴더명이 `{티어}_{번호}_{제목}` 형식인가?

#### 🎨 IDE 확인
- [ ] Visual Studio / Rider 솔루션 탐색기에서 파일이 **보이는가**?
- [ ] 폴더 구조가 올바르게 표시되는가?

#### 📢 작업 완료 메시지
작업 완료 시 **반드시** 다음을 사용자에게 안내:
```
✅ 파일 생성 완료
✅ vcxproj 등록 완료
📁 추가된 파일:
   - Complete\백준\{티어}_{번호}_{제목}\Answer.cpp.txt
   - Complete\백준\{티어}_{번호}_{제목}\README.md

⚠️ Visual Studio / Rider에서 솔루션 탐색기를 새로고침해주세요!
```

<br>

### 📋 README.md 작성 규칙

| ❌ 절대 하지 말 것 | ✅ 반드시 해야 할 것 |
|----------------|-----------------|
| 임의로 형식 변경 | 최소 3개 기존 README 읽기 |
| 확인 없이 작성 | 동일한 섹션 구조/이모지/스타일 사용 |
| 대충 작성 | 현재 날짜로 작성일 기록 |

> **⚠️ 주의사항**
> - 정리 작업은 자동 진행, 정보 부족 시 사용자 확인
> - README 형식 절대 임의 변경 금지
> - TodoWrite로 진행 상황 추적

<br>

### 💡 자동화 예시

**사용자 입력 :**
```
"컴플리트에 작업한 내용을 옮겨서 정리"
```

**Claude의 자동 작업 순서 :**
```
✅ 1. Test.cpp 읽기
✅ 2. solved.ac API로 난이도 확인
✅ 3. 기존 README 3개 읽어서 형식 파악
✅ 4. 폴더 생성 (올바른 티어로)
✅ 5. Answer.cpp.txt 작성 (Test.cpp 복사 + 스타일 정리)
✅ 6. README.md 작성 (기존 형식과 동일하게)
✅ 7. Complete.vcxproj 업데이트 (.cpp.txt는 <None> 태그로)
✅ 8. 파일명 .cpp.txt 확인
✅ 9. 완료 메시지 출력
```

<br>

---

# 🌏 한글 인코딩 설정

## 🔧 UTF-8 BOM 설정

> **⚠️ 중요 :** Windows에서 한글 주석 지원을 위해 반드시 UTF-8 BOM 사용

### Claude Code 파일 생성 시

```bash
echo -e "\xEF\xBB\xBF#include <bits/stdc++.h>" > filename.cpp
```

**BOM 바이트 :** `\xEF\xBB\xBF` = UTF-8 BOM (파일 맨 앞 3바이트)

<br>

### Visual Studio 설정 방법

| 방법 | 절차 |
|-----|------|
| **방법 1 : 파일별 인코딩** | 파일 → 고급 저장 옵션 → `UTF-8 서명 있음 (65001)` |
| **방법 2 : 프로젝트 전체** | 프로젝트 속성 → C/C++ → 명령줄 → `/utf-8` 추가 |
| **방법 3 : 메모장 활용** | 메모장에서 작성 → 저장 시 인코딩 `UTF-8` 선택 → VS에서 파일 열기 |

**문제 해결 :**
1. 한글 깨질 시 UTF-8 BOM 확인
2. Visual Studio 인코딩 설정 확인
3. 필요시 파일 재생성하여 UTF-8 BOM 포함

<br>

---

# 🔧 Visual Studio 프로젝트 파일 관리

## ⚠️ 중요 : 파일 생성 후 프로젝트 등록 필수!

**문제 :** Claude Code로 파일 생성 시 파일 시스템에만 생성, IDE에 미표시

**원인 :** `.vcxproj` 파일에 명시적 등록 필요

<br>

## 📋 필수 작업 절차

### 1️⃣ Complete.vcxproj 파일 수정

**위치 :** `C:\Users\ASUS\Desktop\Code\CoTe\Coding-Test-Practice\Complete\Complete.vcxproj`

**파일 추가 예시 :**
```xml
<ItemGroup>
  <!-- .cpp.txt 파일 (컴파일 제외) -->
  <None Include="백준\Bronze\B2_10808_알파벳개수\Answer.cpp.txt" />

  <!-- README.md 파일 -->
  <None Include="백준\Bronze\B2_10808_알파벳개수\README.md" />
</ItemGroup>
```

<br>

### 2️⃣ 파일 타입별 태그

| 확장자 | 태그 | 용도 |
|-------|------|-----|
| `.cpp.txt` | `<None>` | Complete 폴더 전용 (컴파일 제외) |
| `.cpp` | `<ClCompile>` | Test 폴더 전용 (컴파일 대상) |
| `.md` | `<None>` | 문서 파일 |
| `.h`, `.hpp` | `<ClInclude>` | 헤더 파일 |
| `.png`, `.jpg` | `<Content>` | 리소스 파일 |
| `.txt` | `<None>` | 텍스트 파일 |

**⚠️ 중요 :** Complete 폴더는 `.cpp.txt` 확장자 (Test.cpp 변수명 충돌 방지)

<br>

### 3️⃣ 정렬 규칙

알파벳 순서 (백준 → 해커랭크) → 티어별 (B1 → B2) → 문제 번호순

<br>

### 4️⃣ 자동화 플로우

1. **폴더 생성** : `powershell "New-Item -ItemType Directory -Path 'Complete\백준\Bronze\B2_문제명' -Force"`
2. **파일 작성** : Write tool (UTF-8 BOM) → Answer.cpp.txt + README.md
3. **vcxproj 업데이트** : Edit tool → `<None>` 섹션 추가 → 알파벳순 정렬
4. **검증** : IDE 솔루션 탐색기 확인

<br>

## 🚨 주의사항

| ❌ 금지 | ✅ 필수 |
|--------|--------|
| 파일만 생성 (vcxproj 미업데이트) | 파일 생성 직후 즉시 vcxproj 업데이트 |
| XML 문법 오류 | 상대 경로 사용 (백준\Bronze\...) |
| 중복 항목 추가 | 백슬래시(\) 사용, 알파벳순 정렬 |

<br>

## 💡 빠른 참조 (vcxproj 파일 구조)

```xml
<Project>
  ...
  <ItemGroup>
    <!-- .cpp.txt 파일들 (컴파일 제외) -->
    <None Include="백준\Bronze\B2_10808_알파벳개수\Answer.cpp.txt" />
    <None Include="백준\Gold\G4_12851_숨바꼭질2\Answer.cpp.txt" />
  </ItemGroup>

  <ItemGroup>
    <!-- .md 파일들 -->
    <None Include="백준\Bronze\B2_10808_알파벳개수\README.md" />
  </ItemGroup>

  <ItemGroup>
    <!-- 이미지 등 -->
    <Content Include="..." />
  </ItemGroup>
  ...
</Project>
```

**⚠️ 중요 :** Complete 프로젝트는 `.cpp.txt` 사용
- 모든 C++ 소스 파일은 `.cpp.txt` 확장자
- `<None>` 태그로 컴파일 대상에서 제외
- Test.cpp와의 변수명 충돌 완전 방지

<br>

---

**📅 마지막 업데이트 :** 2025-12-01

**🎯 용도 :** 코딩테스트 연습 및 알고리즘 문제 해결

**🌏 인코딩 :** UTF-8 BOM 지원

**🔧 프로젝트 관리 :** .vcxproj 파일 자동 업데이트 필수

**✅ 검증 체크리스트 :** vcxproj 등록 확인 필수

**[↑ 목차로 돌아가기](#-목차-table-of-contents)**