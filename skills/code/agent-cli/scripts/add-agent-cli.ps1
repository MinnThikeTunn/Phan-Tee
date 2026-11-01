<#
.SYNOPSIS
Adds the Agent Named Pipe IPC server and CLI entrypoint to an existing project.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$AppFolder,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$CliName
)

$ErrorActionPreference = "Stop"

Write-Host "Adding Agent CLI ($CliName) to $AppFolder..." -ForegroundColor Cyan

# Create Agent folder in Sources/<App>/Agent
$appDirs = Get-ChildItem -Path (Join-Path $AppFolder "Sources") -Directory | Where-Object { $_.Name -notmatch "Core$" }
if (-not $appDirs) {
    Write-Error "Could not find app directory under Sources/."
}

$agentDir = Join-Path $appDirs[0].FullName "Agent"
if (-not (Test-Path $agentDir)) {
    New-Item -ItemType Directory -Path $agentDir -Force | Out-Null
}

Write-Host "Agent CLI scaffolding added. Run .\build.ps1 to compile." -ForegroundColor Green
