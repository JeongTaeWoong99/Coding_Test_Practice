---
name: vcxproj
description: vcxproj 수정 및 파일 등록 시 참고. Visual Studio 프로젝트 파일 관리.
---

# 🔧 Visual Studio 프로젝트 파일 관리

## ⚠️ 파일 생성 후 프로젝트 등록 필수!

**문제 :** Claude Code로 파일 생성 시 파일 시스템에만 생성, IDE에 미표시
**원인 :** `.vcxproj` 파일에 명시적 등록 필요

**위치 :** `C:\Users\ASUS\Desktop\Code\CoTe\Coding-Test-Practice\Complete\Complete.vcxproj`

## 📋 파일 타입별 태그

| 확장자 | 태그 | 용도 |
|-------|------|-----|
| `.cpp.txt` | `<None>` | Complete 폴더 전용 (컴파일 제외) |
| `.cpp` | `<ClCompile>` | Test 폴더 전용 (컴파일 대상) |
| `.md` | `<None>` | 문서 파일 |
| `.html` | `<None>` | 시각화 파일 |
| `.txt` | `<None>` | 텍스트 파일 (연습 폴더 등) |
| `.h`, `.hpp` | `<ClInclude>` | 헤더 파일 |
| `.png`, `.jpg` | `<Content>` | 이미지 리소스 |

**⚠️ 중요 :** Complete 폴더는 `.cpp.txt` 확장자 (Test.cpp 변수명 충돌 방지)

**⚠️ `<Content>` 는 이미지 전용 :** `.cpp.txt` / `.md` / `.html` / `.txt` 는 **모두 `<None>`** 으로 등록한다.
`<Content>` 로 등록하면 빌드 시 출력 폴더로 복사 시도되며, 기존 항목들과 태그가 어긋나 정렬·검색이 깨진다.

## 💡 vcxproj 파일 구조

```xml
<Project>
  <ItemGroup>
    <!-- .cpp.txt 파일들 (컴파일 제외) — 알파벳순 정렬 -->
    <None Include="백준\1_Bronze\B2_10808_알파벳개수\Answer.cpp.txt" />
    <None Include="백준\3_Gold\G4_12851_숨바꼭질2\Answer.cpp.txt" />
  </ItemGroup>

  <ItemGroup>
    <!-- .md / .html 파일들 — 알파벳순 정렬 -->
    <None Include="백준\1_Bronze\B2_10808_알파벳개수\README.md" />
    <None Include="백준\3_Gold\G4_9251_LCS\시각화.html" />
  </ItemGroup>

  <ItemGroup>
    <!-- 이미지 리소스만 Content -->
    <Content Include="백준\3_Gold\G4_2240_자두나무\img.png" />
  </ItemGroup>
</Project>
```

## 📋 정렬 규칙

플랫폼 (백준 → 연습 → 프로그래머스 → 해커 랭크) → 난이도 폴더 → 문제 번호순

**실제 난이도 폴더명 (접두 숫자 포함) :**

| 플랫폼 | 폴더 |
|-------|-----|
| 백준 | `1_Bronze` / `2_Silver` / `3_Gold` / `4_Platinum` |
| 프로그래머스 | `Level_0` ~ `Level_5` |
| 해커 랭크 | `1_Easy` / `2_Medium` / `3_Hard` |

> 폴더명은 `Bronze` 가 아니라 **`1_Bronze`** 다. 경로에서 접두 숫자를 빠뜨리지 말 것.

## 📄 Complete.vcxproj.filters 는 관리 대상 아님

`Complete.vcxproj.filters` 는 존재하지 않는 `Complete.cpp` 만 참조하는 스텁 상태이며,
파일 등록과 무관하다. **정리 작업 시 이 파일은 수정하지 않는다.**

## ✅ 등록 후 검증

파일 등록을 마치면 검증 스크립트로 정합성을 확인한다.

```powershell
pwsh tools/check-vcxproj.ps1
```

## 🚨 주의사항

| ❌ 금지 | ✅ 필수 |
|--------|--------|
| 파일만 생성 (vcxproj 미업데이트) | 파일 생성 직후 즉시 vcxproj 업데이트 |
| XML 문법 오류 | 상대 경로 사용 (백준\1_Bronze\...) |
| 중복 항목 추가 | 백슬래시(`\`) 사용, 알파벳순 정렬 |
| 문서/코드를 `<Content>` 로 등록 | 이미지 외에는 모두 `<None>` |
| 파일이 등록된 폴더에 `<Folder>` 중복 선언 | `<Folder>` 는 **빈 폴더에만** 사용 |
