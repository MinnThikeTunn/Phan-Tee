<#
.SYNOPSIS
Runs the in-app self-test against a fresh store in TEMP. Exit code 0 when every check passes.
#>
[CmdletBinding()]
param()

$name = "__APP_NAME__"
$tempDir = [System.IO.Path]::GetTempPath()
$testStore = Join-Path $tempDir "$name-self.db"

Remove-Item -Path "$testStore*" -Force -ErrorAction SilentlyContinue

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

$env:PHANTEE_STORE = $testStore

$p = Start-Process -FilePath $appExe -ArgumentList "--selftest" -NoNewWindow -Wait -PassThru
exit $p.ExitCode
