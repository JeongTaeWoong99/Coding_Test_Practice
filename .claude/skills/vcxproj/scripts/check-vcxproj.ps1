<#
.SYNOPSIS
    Complete 폴더와 Complete.vcxproj 의 정합성을 검사한다.

.DESCRIPTION
    6가지 항목을 검사하고, 문제가 있으면 목록을 출력한다.
      1. 디스크에 있으나 vcxproj 미등록
      2. vcxproj 에 있으나 디스크에 없음 (스테일)
      3. 문서/코드 파일이 <Content> 로 잘못 등록됨 (이미지만 Content)
      4. .cpp.txt 중 UTF-8 BOM 없음
      5. .cpp.txt 는 있는데 README.md 가 없는 폴더
      6. HTML 이 있는데 README 에 링크되지 않음

.EXAMPLE
    pwsh .claude/skills/vcxproj/scripts/check-vcxproj.ps1
#>

[CmdletBinding()]
param(
    # Complete 폴더 경로
    # 기본값 : 이 스크립트(.claude/skills/vcxproj/scripts/) 기준 4단계 위가 프로젝트 루트
    [string] $CompleteRoot = (Join-Path (Split-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent) -Parent) 'Complete')
)

$ErrorActionPreference = 'Stop'

$vcxprojPath = Join-Path $CompleteRoot 'Complete.vcxproj'

if (-not (Test-Path $vcxprojPath))
{
    Write-Host "❌ vcxproj 를 찾을 수 없음 : $vcxprojPath" -ForegroundColor Red
    exit 1
}

# ── 헬퍼 ────────────────────────────────────────────────────────────────

# 검사 제외 대상 (IDE 설정, 프로젝트 파일 자체, git 플레이스홀더)
function Test-Excluded([string] $relPath)
{
    return $relPath -match '(^|\\)\.idea(\\|$)'  -or
           $relPath -match '(^|\\)\.git(\\|$)'   -or
           $relPath -match '(^|\\)\.gitkeep$'    -or
           $relPath -match '\.vcxproj(\.filters)?$'
}

function Test-HasBom([string] $fullPath)
{
    $bytes = [System.IO.File]::ReadAllBytes($fullPath)

    return ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
}

# 항목별 결과 출력 (문제 없으면 ✅, 있으면 목록)
function Write-Result([string] $okLabel, [string] $failLabel, [string[]] $items)
{
    if ($items.Count -eq 0)
    {
        Write-Host "✅ $okLabel" -ForegroundColor Green
    }
    else
    {
        Write-Host "❌ $failLabel ($($items.Count)건)" -ForegroundColor Red

        foreach ($i in $items)
        {
            Write-Host "     $i" -ForegroundColor DarkYellow
        }
    }
}

# ── 데이터 수집 ──────────────────────────────────────────────────────────

$xmlText = Get-Content $vcxprojPath -Raw -Encoding UTF8

# 태그별 등록 경로 수집 (None / Content / ClCompile / ClInclude)
$registered = @{}   # 상대경로 → 태그명

foreach ($m in [regex]::Matches($xmlText, '<(None|Content|ClCompile|ClInclude)\s+Include="([^"]+)"'))
{
    $registered[$m.Groups[2].Value] = $m.Groups[1].Value
}

$prefixLen = $CompleteRoot.TrimEnd('\').Length + 1

$diskFiles = Get-ChildItem $CompleteRoot -Recurse -File |
             ForEach-Object { $_.FullName.Substring($prefixLen) } |
             Where-Object { -not (Test-Excluded $_) }

# ── 1. 미등록 파일 ───────────────────────────────────────────────────────

$unregistered = @($diskFiles | Where-Object { -not $registered.ContainsKey($_) })

# ── 2. 스테일 항목 ───────────────────────────────────────────────────────

$diskSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$diskFiles)
$stale   = @($registered.Keys | Where-Object { -not $diskSet.Contains($_) } | Sort-Object)

# ── 3. Content 태그 오용 ─────────────────────────────────────────────────

$wrongTag = @(
    $registered.GetEnumerator() |
    Where-Object { $_.Value -eq 'Content' -and $_.Key -match '\.(cpp\.txt|md|html|txt)$' } |
    ForEach-Object { $_.Key } |
    Sort-Object
)

# ── 4. BOM 없는 .cpp.txt ─────────────────────────────────────────────────

$noBom = @(
    $diskFiles |
    Where-Object { $_ -like '*.cpp.txt' } |
    Where-Object { -not (Test-HasBom (Join-Path $CompleteRoot $_)) } |
    Sort-Object
)

# ── 5. README 없는 문제 폴더 ──────────────────────────────────────────────
#     답안이 여러 개인 폴더는 README(변형명).md 로 나뉘므로 README*.md 를 모두 인정한다.

function Get-ReadmePaths([string] $relDir)
{
    return @(Get-ChildItem (Join-Path $CompleteRoot $relDir) -File -Filter 'README*.md' -ErrorAction SilentlyContinue)
}

$problemDirs = $diskFiles |
               Where-Object { $_ -like '*.cpp.txt' } |
               ForEach-Object { Split-Path $_ -Parent } |
               Sort-Object -Unique |
               Where-Object { $_ -notlike '연습\*' }   # 연습 폴더는 README 필수 아님

$noReadme = @(
    $problemDirs |
    Where-Object { (Get-ReadmePaths $_).Count -eq 0 }
)

# ── 6. README 에 링크되지 않은 HTML ───────────────────────────────────────

$unlinkedHtml = @()

foreach ($html in ($diskFiles | Where-Object { $_ -like '*.html' }))
{
    $dir     = Split-Path $html -Parent
    $name    = Split-Path $html -Leaf
    $readmes = Get-ReadmePaths $dir

    if ($readmes.Count -eq 0)
    {
        $unlinkedHtml += "$html  (README 자체가 없음)"
        continue
    }

    # 폴더 내 README 중 하나라도 링크하고 있으면 통과
    $linked = $false

    foreach ($r in $readmes)
    {
        if ((Get-Content $r.FullName -Raw -Encoding UTF8) -match [regex]::Escape($name))
        {
            $linked = $true
            break
        }
    }

    if (-not $linked)
    {
        $unlinkedHtml += $html
    }
}

# ── 출력 ────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "🔍 Complete ↔ vcxproj 정합성 검사" -ForegroundColor Cyan
Write-Host "   디스크 $($diskFiles.Count)개 / 등록 $($registered.Count)개"
Write-Host ""

Write-Result "미등록 파일 없음"        "vcxproj 미등록 파일"                  $unregistered
Write-Result "스테일 항목 없음"        "디스크에 없는 vcxproj 항목"           $stale
Write-Result "태그 오용 없음"          "Content 로 잘못 등록됨 (None 이어야 함)" $wrongTag
Write-Result ".cpp.txt BOM 정상"       "UTF-8 BOM 없는 .cpp.txt"              $noBom
Write-Result "README 누락 없음"        "README.md 없는 문제 폴더"             $noReadme
Write-Result "HTML 시각화 링크 정상"   "README 에 링크되지 않은 HTML"         $unlinkedHtml

$total = $unregistered.Count + $stale.Count + $wrongTag.Count + $noBom.Count + $noReadme.Count + $unlinkedHtml.Count

Write-Host ""

if ($total -eq 0)
{
    Write-Host "🎉 이상 없음" -ForegroundColor Green
    exit 0
}
else
{
    Write-Host "⚠️  총 $total 건의 문제가 있습니다." -ForegroundColor Yellow
    exit 1
}
