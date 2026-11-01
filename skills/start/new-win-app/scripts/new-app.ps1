<#
.SYNOPSIS
Scaffolds a new native Windows app from the Phan-Tee template.
Usage:
  .\new-app.ps1 <AppName> <PackageId> [ParentFolder]
Example:
  .\new-app.ps1 Tasks com.yourname.tasks ~/Developer
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$AppName,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$PackageId,

    [Parameter(Position = 2)]
    [string]$ParentFolder = "$HOME\Developer"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ParentFolder)) {
    New-Item -ItemType Directory -Path $ParentFolder -Force | Out-Null
}

$dest = Join-Path $ParentFolder $AppName
if (Test-Path $dest) {
    # If the folder only contains docs/BRIEF.md, keep it
    $files = Get-ChildItem -Path $dest -Recurse -File
    $isOnlyBrief = ($files.Count -eq 1 -and $files[0].Name -eq "BRIEF.md")
    if (-not $isOnlyBrief) {
        Write-Error "Destination folder $dest already exists and is not empty."
    }
} else {
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateDir = Join-Path $scriptDir "..\template"

Write-Host "Scaffolding $AppName into $dest..." -ForegroundColor Cyan

# Copy template files and ensure build caches are purged
Copy-Item -Path "$templateDir\*" -Destination $dest -Recurse -Force
Get-ChildItem -Path $dest -Recurse -Directory -Include "bin", "obj", ".vs" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Rename project directories
$srcDir = Join-Path $dest "Sources"
$testsDir = Join-Path $dest "Tests"

if (Test-Path (Join-Path $srcDir "__APP_NAME__")) {
    Rename-Item -Path (Join-Path $srcDir "__APP_NAME__") -NewName $AppName
}
if (Test-Path (Join-Path $srcDir "__APP_NAME__Core")) {
    Rename-Item -Path (Join-Path $srcDir "__APP_NAME__Core") -NewName "${AppName}Core"
}
if (Test-Path (Join-Path $testsDir "__APP_NAME__CoreTests")) {
    Rename-Item -Path (Join-Path $testsDir "__APP_NAME__CoreTests") -NewName "${AppName}CoreTests"
}

# Rename project files
if (Test-Path (Join-Path $srcDir "$AppName\__APP_NAME__.csproj")) {
    Rename-Item -Path (Join-Path $srcDir "$AppName\__APP_NAME__.csproj") -NewName "$AppName.csproj"
}
if (Test-Path (Join-Path $srcDir "${AppName}Core\__APP_NAME__Core.csproj")) {
    Rename-Item -Path (Join-Path $srcDir "${AppName}Core\__APP_NAME__Core.csproj") -NewName "${AppName}Core.csproj"
}
if (Test-Path (Join-Path $testsDir "${AppName}CoreTests\__APP_NAME__CoreTests.csproj")) {
    Rename-Item -Path (Join-Path $testsDir "${AppName}CoreTests\__APP_NAME__CoreTests.csproj") -NewName "${AppName}CoreTests.csproj"
}
if (Test-Path (Join-Path $dest "__APP_NAME__.slnx")) {
    Rename-Item -Path (Join-Path $dest "__APP_NAME__.slnx") -NewName "$AppName.slnx"
}
if (Test-Path (Join-Path $dest "__APP_NAME__.sln")) {
    Rename-Item -Path (Join-Path $dest "__APP_NAME__.sln") -NewName "$AppName.sln"
}

# Perform token replacement
$textFiles = Get-ChildItem -Path $dest -Recurse -File | Where-Object {
    $_.Extension -match "\.(cs|xaml|csproj|slnx|sln|ps1|md|json|manifest|xml|props)$"
}

foreach ($file in $textFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -match "__APP_NAME__|__BUNDLE_ID__") {
        $replaced = $content.Replace("__APP_NAME__", $AppName).Replace("__BUNDLE_ID__", $PackageId)
        Set-Content -Path $file.FullName -Value $replaced -NoNewline
    }
}

# Generate initial AppIcon.ico
$makeIcon = Join-Path $dest "tools\make_icon.ps1"
if (Test-Path $makeIcon) {
    & $makeIcon
}

# Initialize Git repository
Push-Location $dest
try {
    $oldEap = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    git init *>$null
    git add -A *>$null
    git commit -m "Scaffold $AppName with Phan-Tee" *>$null
    $ErrorActionPreference = $oldEap
} finally {
    Pop-Location
}

Write-Host "`nScaffold complete: $dest" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  cd `"$dest`""
Write-Host "  .\build.ps1 -Open"
