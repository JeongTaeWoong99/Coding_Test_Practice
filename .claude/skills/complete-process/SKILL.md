---
name: complete-process
description: Complete 정리 작업 프로세스. "컴플리트에 작업한 내용을 옮겨서 정리", "컴플리트로 정리", "완료한 문제 정리해줘" 키워드 감지 시 즉시 호출.
---

# 🔄 Complete 정리 작업 프로세스

## 🎯 Complete 정리 9단계

1. **Test.cpp 확인** : 작성된 코드 읽기
2. **문제 정보 확인** : 플랫폼별 방법으로 난이도/점수/제목 확인 (아래 플랫폼별 정보 확인 섹션 참고)
3. **기존 형식 참고** : 최소 3개 README.md 읽기 (폴더명/작성 형식/코드 스타일)
4. **폴더/파일 생성** : 플랫폼별 경로로 생성 + Answer.cpp.txt + README.md
5. **Answer.cpp.txt** : Test.cpp 복사 → UTF-8 BOM → 스타일 정리 (⚠️ `.cpp.txt` 확장자!)
6. **README.md** : 기존 형식과 동일하게 (작성일/링크/시각화링크/접근법/풀이/시간복잡도)
7. **vcxproj 업데이트** : `<None>` 섹션에 .cpp.txt와 .md 추가, 알파벳순 정렬
8. **파일명 확인** : `.cpp.txt` 확장자 검증
9. **검증** : 위치/형식/vcxproj 업데이트 확인 (아래 체크리스트 필수 수행)

---

## 🌐 플랫폼별 문제 정보 확인

### 📌 백준 (Baekjoon)

solved.ac API로 난이도 + 제목 확인:

```
https://solved.ac/api/v3/problem/show?problemId={번호}
```

- 티어 : `level` 값 → 1~5=Bronze, 6~10=Silver, 11~15=Gold, 16~20=Platinum
- 제목 : `titleKo` 값
- 폴더명 형식 : `{티어}{레벨}_{번호}_{제목}/` (예: `G5_1916_최단경로`)

### 📌 해커랭크 (HackerRank)

**⚠️ 주의**: HackerRank는 점수/제목이 JavaScript 동적 렌더링 또는 로그인 후에만 표시됨.
`WebFetch`로 문제 URL을 가져와도 **점수(Max Score)와 정확한 제목이 누락**될 수 있음.

#### ✅ 찾을 수 있는 경우 — WebFetch 시도

```
WebFetch(문제 URL) → 응답에서 점수/제목 확인
```

응답에 `Max Score`, `Easy`, `Medium`, `Hard` 등이 포함되어 있으면 해당 정보 사용.

#### ❌ 찾을 수 없는 경우 — 사용자에게 직접 요청

WebFetch 결과에 점수나 정확한 제목이 없으면 **반드시 작업 전에 사용자에게 확인 요청**:

```
❓ HackerRank 문제의 다음 정보를 알려주세요:
   1. 문제 제목 (영문 그대로)
   2. 난이도 (Easy / Medium / Hard)
   3. Max Score (점수)
```

확인 없이 임의의 숫자(40 등)를 붙이거나 추측으로 폴더명을 짓지 말 것.

#### 📁 해커랭크 폴더명 형식

```
Complete/해커 랭크/{난이도_번호}/Easy{점수}_{제목(한글)}/ 
```

예시:
- `Easy10_Class(클래스)` — 10점, 제목 "Class"
- `Easy20_Classes_and_Objects(클래스_객체)` — 20점, 제목 "Classes and Objects"
- `Medium35_Attribute_Parser(속성_파서)` — 35점, 제목 "Attribute Parser"

> **📝 참고**: 같은 점수의 문제가 여러 개 존재할 수 있음 (예: Easy10이 2개). 폴더명이 겹치지 않도록 제목으로 구분.

---

## 🖥️ HTML 시각화 파일이 있는 경우

시각화 HTML 파일이 있을 경우 아래 순서로 처리한다.

### 📁 파일 위치
- HTML 파일을 `Complete/백준/{티어}_{번호}_{제목}/` 폴더 안에 함께 배치
- 파일명 : `시각화.html` 또는 `visualization.html` (기존 명명 방식 참고)

### 📋 README 시각화 섹션
HTML이 있으면 README에 **문제 링크 바로 다음, 접근법 바로 위**에 시각화 섹션을 추가한다.

```markdown
**📅 작성일**: YYYY-MM-DD

## 🔗 문제 링크

[백준 XXXX번 - 제목](https://www.acmicpc.net/problem/XXXX)

**난이도**: Gold N

---

## 🖥️ 시각화

[시각화 보기 (HTML)](시각화.html)

> 한 줄 설명 — 어떤 내용을 시각화했는지 간략히 기재

---

## 🤔 접근법
...
```

### 📋 vcxproj 등록
- HTML 파일도 `<None>` 섹션에 함께 등록 (알파벳순 정렬)

---

## ✅ 필수 검증 체크리스트

### 📋 vcxproj 등록 확인
- [ ] `.cpp.txt` 파일이 Complete.vcxproj의 **첫 번째** `<ItemGroup>` 섹션에 등록되었는가?
- [ ] `README.md` 파일이 Complete.vcxproj의 **두 번째** `<ItemGroup>` 섹션에 등록되었는가?
- [ ] HTML 파일이 있을 경우 `<None>` 섹션에 등록되었는가?
- [ ] 모든 파일이 **알파벳순**으로 정렬되었는가? (티어 → 문제 번호 순)
- [ ] 경로에 **백슬래시(`\`)** 를 사용했는가? (슬래시 `/` 아님!)

### 🔍 파일 확인
- [ ] 파일 확장자가 `.cpp.txt`인가? (`.cpp` 아님!)
- [ ] UTF-8 BOM 인코딩으로 저장되었는가?
- [ ] 폴더명이 `{티어}_{번호}_{제목}` 형식인가?
- [ ] HTML이 있을 경우 README 시각화 섹션에 링크가 포함되었는가?

### 🎨 IDE 확인
- [ ] Visual Studio / Rider 솔루션 탐색기에서 파일이 **보이는가**?
- [ ] 폴더 구조가 올바르게 표시되는가?

### 📢 작업 완료 메시지
작업 완료 시 **반드시** 다음을 사용자에게 안내:
```
✅ 파일 생성 완료
✅ vcxproj 등록 완료
📁 추가된 파일:
   - Complete\백준\{티어}_{번호}_{제목}\Answer.cpp.txt
   - Complete\백준\{티어}_{번호}_{제목}\README.md
   - Complete\백준\{티어}_{번호}_{제목}\시각화.html  (있을 경우)

⚠️ Visual Studio / Rider에서 솔루션 탐색기를 새로고침해주세요!
```

---

## 📋 README.md 작성 규칙

| ❌ 절대 하지 말 것 | ✅ 반드시 해야 할 것 |
|----------------|-----------------|
| 임의로 형식 변경 | 최소 3개 기존 README 읽기 |
| 확인 없이 작성 | 동일한 섹션 구조/이모지/스타일 사용 |
| 대충 작성 | 현재 날짜로 작성일 기록 |
| HTML 있는데 시각화 섹션 누락 | HTML 있으면 문제 링크 다음에 시각화 섹션 추가 |

> **⚠️ 주의사항**
> - 정리 작업은 자동 진행, 정보 부족 시 사용자 확인
> - README 형식 절대 임의 변경 금지
