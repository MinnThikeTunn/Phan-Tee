<#
.SYNOPSIS
Snapshots every page in light and dark mode, with seed data, on a fresh test store.
Usage:
  .\tools\snap.ps1
  $env:PHANTEE_SNAPSHOT_PAGES="all,starred"; .\tools\snap.ps1
#>
[CmdletBinding()]
param()

$name = "__APP_NAME__"
$tempDir = [System.IO.Path]::GetTempPath()
$shotsDir = Join-Path $tempDir "$name-shots"
$testStore = Join-Path $tempDir "$name-test.db"

# Remove old test database and wal files
Remove-Item -Path "$testStore*" -Force -ErrorAction SilentlyContinue
if (Test-Path $shotsDir) {
    Remove-Item -Path $shotsDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path $shotsDir -Force | Out-Null

$appExe = Join-Path $env:LOCALAPPDATA "Programs\$name\$name.exe"
if (-not (Test-Path $appExe)) {
    $here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $appExe = Join-Path $here "..\Sources\$name\bin\x64\Release\net10.0-windows10.0.19041.0\win-x64\$name.exe"
    if (-not (Test-Path $appExe)) {
        $appExe = Join-Path $here "..\Sources\$name\bin\x64\Release\net9.0-windows10.0.19041.0\win-x64\$name.exe"
    }
}

if (-not (Test-Path $appExe)) {
    Write-Error "Cannot find binary at $appExe. Run .\build.ps1 first."
}

Write-Host "Running snapshot harness into $shotsDir..." -ForegroundColor Cyan

$env:PHANTEE_STORE = $testStore
$env:PHANTEE_SEED = "1"
$env:PHANTEE_SNAPSHOT = $shotsDir

$process = Start-Process -FilePath $appExe -PassThru
$process.WaitForExit(30000)

Write-Host "Snapshots completed. Files saved to $shotsDir" -ForegroundColor Green
Get-ChildItem -Path $shotsDir -Filter "*.png" | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor Yellow
}
