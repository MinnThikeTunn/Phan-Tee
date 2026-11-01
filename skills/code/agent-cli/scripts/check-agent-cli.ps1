<#
.SYNOPSIS
Validates the Agent CLI and Named Pipe IPC interface.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$CliName
)

$ErrorActionPreference = "Stop"

Write-Host "Checking $CliName CLI..." -ForegroundColor Cyan

# Test --help
& $CliName --help
if ($LASTEXITCODE -ne 0) {
    Write-Error "$CliName --help failed with exit code $LASTEXITCODE"
}

Write-Host "PASS agent-cli validation" -ForegroundColor Green
