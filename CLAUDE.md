# 🎯 코딩 테스트 연습 규칙

## 📋 프로젝트 기본 정보

- **용도 :** 코딩테스트 연습 및 알고리즘 문제 해결 (Visual Studio C++, Windows)
- **C++ 버전 :** C++ 17
- **인코딩 :** UTF-8 BOM (한글 주석 지원)
- **참고 우선순위 :** 프로젝트 내 PDF → Complete 폴더 → 기존 README

---

## ✍️ 작업 파일 규칙 (⚠️ 중요)

사용자가 **"연습장"**, **"test.cpp"**, **"스크립트"**, **"정답 코드 작성"** 등을 언급하면
**항상 아래 단일 파일을 의미**한다. 

새 파일을 만들지 말 것.

```
C:\Users\ASUS\Desktop\Code\CoTe\Coding-Test-Practice\Test\Test.cpp
```

- ❌ 루트나 다른 위치에 `test.cpp` 등 새 파일 생성 금지
- ✅ 항상 기존 `Test\Test.cpp` 파일을 읽고 그 안에 작성/수정

---

## 📚 스킬 파일 — 필요한 상황에서 자동 호출

| 상황                                      | 스킬 |
|-------------------------------------------|----------------|
| 백준 문제 작업 시 (난이도 확인, 정보 파악) | [boj-info](.claude/skills/boj-info/SKILL.md) |
| 코드 작성 / 스타일 확인 시                 | [coding-style](.claude/skills/coding-style/SKILL.md) |
| 정리 키워드 감지 시 → 즉시 자동 작업 시작  | [complete-process](.claude/skills/complete-process/SKILL.md) |
| 한글 깨짐 / 인코딩 문제 발생 시            | [encoding](.claude/skills/encoding/SKILL.md) |
| vcxproj 수정 / 파일 등록 시                | [vcxproj](.claude/skills/vcxproj/SKILL.md) |

---

## ⚡ 정리 키워드 트리거

다음 키워드 감지 시 **즉시** `complete-process` 스킬 자동 실행:

- "컴플리트에 작업한 내용을 옮겨서 정리"
- "컴플리트로 정리"
- "완료한 문제 정리해줘"

---

## 🛠️ 검증 도구

각 스크립트는 개념상 주인인 스킬 폴더의 `scripts/` 안에 있다.

| 스크립트 | 용도 |
|---------|-----|
| `.claude/skills/vcxproj/scripts/check-vcxproj.ps1` | Complete 폴더 ↔ vcxproj 정합성 검사 (미등록/스테일/태그/BOM/README/HTML 링크) |
| `.claude/skills/encoding/scripts/ensure-bom.ps1` | `.cpp.txt` 에 UTF-8 BOM 부여 (PostToolUse 훅에서 자동 실행) |

---

**📅 마지막 업데이트 :** 2026-07-20
