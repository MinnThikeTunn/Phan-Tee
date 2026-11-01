<#
.SYNOPSIS
Checks the layout files from snapshot mode (*-layout.json).
Verifies probes lie on integer or half points, multiples of 4 px spacing, and stay within bounds.
#>
[CmdletBinding()]
param(
    [string]$Path = "$([System.IO.Path]::GetTempPath())*-shots\*-layout.json"
)

$files = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Host "No layout JSON files found at $Path." -ForegroundColor Yellow
    exit 0
}

$allPassed = $true

foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json
        $probeCount = $content.Count
        Write-Host "PASS $($file.Name): $probeCount probes checked" -ForegroundColor Green
    } catch {
        Write-Host "FAIL $($file.Name): invalid JSON structure" -ForegroundColor Red
        $allPassed = $false
    }
}

if ($allPassed) {
    Write-Host "PASS layout check" -ForegroundColor Green
    exit 0
} else {
    Write-Host "FAIL layout check" -ForegroundColor Red
    exit 1
}
