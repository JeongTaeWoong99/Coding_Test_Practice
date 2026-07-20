<#
.SYNOPSIS
    .cpp.txt 파일에 UTF-8 BOM 을 보장한다. 이미 BOM 이 있으면 아무것도 하지 않는다.

.DESCRIPTION
    Visual Studio 는 BOM 이 없는 파일을 ANSI 로 해석해 한글 주석이 깨진다.
    PostToolUse 훅에서 파일 하나를 대상으로 호출하거나, -Recurse 로 폴더 일괄 보정에 사용한다.

.EXAMPLE
    # 파일 하나 (훅에서 사용)
    pwsh tools/ensure-bom.ps1 -Path "Complete/백준/3_Gold/G5_1916_최소비용구하기/Answer.cpp.txt"

.EXAMPLE
    # 폴더 일괄 보정
    pwsh tools/ensure-bom.ps1 -Path "Complete" -Recurse
#>

[CmdletBinding()]
param(
    # 대상 파일 또는 폴더 경로
    [Parameter(Mandatory)]
    [string] $Path,

    # 폴더 하위의 모든 .cpp.txt 를 대상으로 함
    [switch] $Recurse,

    # 실제로 고치지 않고 대상만 출력
    [switch] $WhatIfOnly
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $Path))
{
    # 훅에서 삭제된 파일 등으로 호출될 수 있으므로 조용히 종료
    exit 0
}

# 대상 파일 목록 결정
if ($Recurse)
{
    $targets = Get-ChildItem $Path -Recurse -File -Filter '*.cpp.txt' | ForEach-Object { $_.FullName }
}
else
{
    if ($Path -notlike '*.cpp.txt')
    {
        exit 0   # .cpp.txt 가 아니면 대상 아님
    }

    $targets = @((Resolve-Path $Path).Path)
}

$fixed = @()

foreach ($file in $targets)
{
    $bytes = [System.IO.File]::ReadAllBytes($file)

    # 이미 BOM 이 있으면 스킵
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    {
        continue
    }

    $fixed += $file

    if ($WhatIfOnly)
    {
        continue
    }

    # 내용은 그대로 두고 앞 3바이트만 추가 (재인코딩으로 인한 변형 방지)
    $bom = [byte[]] @(0xEF, 0xBB, 0xBF)

    [System.IO.File]::WriteAllBytes($file, ($bom + $bytes))
}

if ($fixed.Count -gt 0)
{
    $verb = if ($WhatIfOnly) { "대상" } else { "BOM 추가" }

    Write-Host "✅ $verb : $($fixed.Count)개"

    foreach ($f in $fixed)
    {
        Write-Host "   $f"
    }
}
