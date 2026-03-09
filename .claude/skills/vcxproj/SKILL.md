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
| `.h`, `.hpp` | `<ClInclude>` | 헤더 파일 |
| `.png`, `.jpg` | `<Content>` | 리소스 파일 |
| `.txt` | `<None>` | 텍스트 파일 |

**⚠️ 중요 :** Complete 폴더는 `.cpp.txt` 확장자 (Test.cpp 변수명 충돌 방지)

## 💡 vcxproj 파일 구조

```xml
<Project>
  <ItemGroup>
    <!-- .cpp.txt 파일들 (컴파일 제외) — 알파벳순 정렬 -->
    <None Include="백준\Bronze\B2_10808_알파벳개수\Answer.cpp.txt" />
    <None Include="백준\Gold\G4_12851_숨바꼭질2\Answer.cpp.txt" />
  </ItemGroup>

  <ItemGroup>
    <!-- .md 파일들 — 알파벳순 정렬 -->
    <None Include="백준\Bronze\B2_10808_알파벳개수\README.md" />
  </ItemGroup>
</Project>
```

## 📋 정렬 규칙

알파벳 순서 (백준 → 해커랭크) → 티어별 (B1 → B2 → S → G → P) → 문제 번호순

## 🚨 주의사항

| ❌ 금지 | ✅ 필수 |
|--------|--------|
| 파일만 생성 (vcxproj 미업데이트) | 파일 생성 직후 즉시 vcxproj 업데이트 |
| XML 문법 오류 | 상대 경로 사용 (백준\Bronze\...) |
| 중복 항목 추가 | 백슬래시(`\`) 사용, 알파벳순 정렬 |
