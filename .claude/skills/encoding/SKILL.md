---
name: encoding
description: 한글 깨짐 및 인코딩 문제 발생 시 참고. UTF-8 BOM 설정 방법.
---

# 🌏 한글 인코딩 설정

## 🔧 UTF-8 BOM 설정

> **⚠️ 중요 :** Windows Visual Studio 에서 한글 주석이 깨지지 않으려면 코드 파일에 UTF-8 BOM 필요

### 📋 BOM 적용 범위 (파일 종류별)

| 확장자 | BOM | 이유 |
|-------|-----|-----|
| `.cpp.txt` / `.cpp` | ✅ **필수** | Visual Studio 가 BOM 없으면 ANSI 로 해석 → 한글 주석 깨짐 |
| `.md` | ⚪ 불필요 | 에디터·GitHub 모두 UTF-8 로 정상 인식 |
| `.html` | ⚪ 불필요 | `<meta charset>` 로 처리 |

> BOM 을 "모든 파일"에 붙이지 않는다. **코드 파일에만** 필요하다.

### Claude Code 파일 생성 시

**BOM 바이트 :** `\xEF\xBB\xBF` = UTF-8 BOM (파일 맨 앞 3바이트)

`.cpp.txt` 를 Write 툴로 생성할 때 content 맨 앞에 BOM 포함하여 저장.

### 🤖 자동 보정 (훅)

`.claude/settings.json` 의 PostToolUse 훅이 `Complete/**/*.cpp.txt` 저장 직후
`tools/ensure-bom.ps1` 을 실행해 **BOM 이 없으면 자동으로 부여**한다.

- 훅이 있으므로 수동으로 BOM 을 챙기지 못해도 결과적으로 보장된다
- 훅을 우회한 파일이 있는지는 `pwsh tools/check-vcxproj.ps1` 로 확인 가능
- 기존 파일을 일괄 보정하려면 :

```powershell
pwsh tools/ensure-bom.ps1 -Path "Complete" -Recurse
```

### Visual Studio 설정 방법

| 방법 | 절차 |
|-----|------|
| **방법 1 : 파일별 인코딩** | 파일 → 고급 저장 옵션 → `UTF-8 서명 있음 (65001)` |
| **방법 2 : 프로젝트 전체** | 프로젝트 속성 → C/C++ → 명령줄 → `/utf-8` 추가 |
| **방법 3 : 메모장 활용** | 메모장에서 작성 → 저장 시 인코딩 `UTF-8` 선택 → VS에서 파일 열기 |

### 문제 해결 순서

1. 한글 깨질 시 UTF-8 BOM 확인
2. Visual Studio 인코딩 설정 확인
3. 필요시 파일 재생성하여 UTF-8 BOM 포함
