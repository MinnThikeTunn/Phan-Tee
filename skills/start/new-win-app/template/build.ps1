<#
.SYNOPSIS
Builds __APP_NAME__ and installs it to %LOCALAPPDATA%\Programs\__APP_NAME__\.
Usage:
  .\build.ps1               # Release build and install
  .\build.ps1 -DebugBuild   # Faster debug build while iterating
  .\build.ps1 -Open         # Install and restart the app
#>
[CmdletBinding()]
param(
    [switch]$DebugBuild,
    [switch]$Open
)

$ErrorActionPreference = "Stop"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$name = "__APP_NAME__"
$config = if ($DebugBuild) { "Debug" } else { "Release" }

Write-Host "Building $name ($config)..." -ForegroundColor Cyan

$projectPath = Join-Path $here "Sources\$name\$name.csproj"
if (-not (Test-Path $projectPath)) {
    # Check if we are inside tools/ or root
    $projectPath = Join-Path $here "..\Sources\$name\$name.csproj"
}

# Execute dotnet build
dotnet build "$projectPath" -c $config -r win-x64 --no-incremental

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed with exit code $LASTEXITCODE"
}

$publishDir = Join-Path $env:LOCALAPPDATA "Programs\$name"
if (-not (Test-Path $publishDir)) {
    New-Item -ItemType Directory -Path $publishDir -Force | Out-Null
}

$binDir = Join-Path (Split-Path -Parent $projectPath) "bin\x64\$config\net10.0-windows10.0.19041.0\win-x64"
if (-not (Test-Path $binDir)) {
    $binDir = Join-Path (Split-Path -Parent $projectPath) "bin\x64\$config\net9.0-windows10.0.19041.0\win-x64"
}

if (Test-Path $binDir) {
    Copy-Item -Path "$binDir\*" -Destination $publishDir -Recurse -Force
    Write-Host "Installed $name to $publishDir" -ForegroundColor Green
} else {
    Write-Host "Build succeeded (loose files at $binDir)" -ForegroundColor Green
}

if ($Open) {
    Write-Host "Starting $name..." -ForegroundColor Cyan
    Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 400
    $exePath = Join-Path $publishDir "$name.exe"
    if (Test-Path $exePath) {
        Start-Process -FilePath $exePath
    } else {
        $looseExe = Join-Path $binDir "$name.exe"
        if (Test-Path $looseExe) {
            Start-Process -FilePath $looseExe
        }
    }
}
