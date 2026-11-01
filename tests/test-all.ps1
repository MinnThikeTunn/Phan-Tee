<#
.SYNOPSIS
Phan-Tee Full Test Suite & Production Readiness Check.
Validates plugin manifests, skill specifications, link integrity, template cleanliness,
and executes an end-to-end scaffolding, build, and test run.

Usage:
  .\tests\test-all.ps1
  pwsh -File .\tests\test-all.ps1
#>
[CmdletBinding()]
param(
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir

$passCount = 0
$failCount = 0

function Report-Pass {
    param([string]$message)
    $script:passCount++
    Write-Host "  [PASS] $message" -ForegroundColor Green
}

function Report-Fail {
    param([string]$message)
    $script:failCount++
    Write-Host "  [FAIL] $message" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Phan-Tee: Production Readiness Test Suite" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------
# Test 1: Plugin Manifest Validation
# ---------------------------------------------------------
Write-Host "[1/7] Validating Claude Code Plugin Manifests..." -ForegroundColor Yellow

$claudeCmd = Get-Command "claude" -ErrorAction SilentlyContinue
if ($claudeCmd) {
    try {
        $outMarketplace = & claude plugin validate "$repoRoot" --strict 2>&1
        if ($LASTEXITCODE -eq 0) {
            Report-Pass "Marketplace manifest valid (.claude-plugin/marketplace.json)"
        } else {
            Report-Fail "Marketplace manifest validation failed: $outMarketplace"
        }
    } catch {
        Report-Fail "Marketplace manifest validation error: $_"
    }

    try {
        $pluginManifestPath = Join-Path $repoRoot ".claude-plugin\plugin.json"
        $outPlugin = & claude plugin validate "$pluginManifestPath" --strict 2>&1
        if ($LASTEXITCODE -eq 0) {
            Report-Pass "Plugin manifest valid (.claude-plugin/plugin.json)"
        } else {
            Report-Fail "Plugin manifest validation failed: $outPlugin"
        }
    } catch {
        Report-Fail "Plugin manifest validation error: $_"
    }
} else {
    Write-Host "  (Claude CLI not found; skipping strict CLI validator)" -ForegroundColor DarkGray
}

# ---------------------------------------------------------
# Test 2: Skill Standards & Agent Compliance
# ---------------------------------------------------------
Write-Host ""
Write-Host "[2/7] Checking 21 Skills for Standards Compliance..." -ForegroundColor Yellow

$pluginJsonPath = Join-Path $repoRoot ".claude-plugin\plugin.json"
$pluginJson = Get-Content $pluginJsonPath -Raw | ConvertFrom-Json
$declaredSkills = $pluginJson.skills

if ($declaredSkills.Count -eq 21) {
    Report-Pass "Plugin declares exactly 21 skills"
} else {
    Report-Fail "Expected 21 skills in plugin.json, found $($declaredSkills.Count)"
}

$allSkillsCompliant = $true
$skillsOnDisk = Get-ChildItem -Path (Join-Path $repoRoot "skills") -Recurse -Filter "SKILL.md"

if ($skillsOnDisk.Count -eq 21) {
    Report-Pass "Discovered exactly 21 SKILL.md files on disk"
} else {
    Report-Fail "Expected 21 SKILL.md files on disk, found $($skillsOnDisk.Count)"
}

foreach ($s in $skillsOnDisk) {
    $dir = $s.DirectoryName
    $content = Get-Content $s.FullName -Raw
    $skillName = $s.Directory.Name

    # Check 1: openai.yaml exists
    $hasOpenAi = Test-Path (Join-Path $dir "agents\openai.yaml")
    if (-not $hasOpenAi) {
        Report-Fail "Skill '$skillName' missing agents/openai.yaml"
        $allSkillsCompliant = $false
    }

    # Check 2: Frontmatter
    if ($content -notmatch '(?s)^---\s*\r?\nname:\s*\S+.*?\r?\ndescription:\s*\S+.*?\r?\n---') {
        Report-Fail "Skill '$skillName' has invalid or missing YAML frontmatter"
        $allSkillsCompliant = $false
    }

    # Check 3: Description has 'Use when'
    if ($content -notmatch '(?i)description:.*?\bUse\s+when\b') {
        Report-Fail "Skill '$skillName' description missing 'Use when' context pointer"
        $allSkillsCompliant = $false
    }

    # Check 4: Ends with Done when
    if ($content -notmatch '(?i)##\s*Done\s+when') {
        Report-Fail "Skill '$skillName' missing '## Done when' section"
        $allSkillsCompliant = $false
    }

    # Check 5: No em dashes per Matt Pocock rules
    if ($content -match '—') {
        Report-Fail "Skill '$skillName' contains em dash"
        $allSkillsCompliant = $false
    }
}

if ($allSkillsCompliant) {
    Report-Pass "All 21 skills comply with Matt Pocock agent rules and AGENTS.md"
}

# ---------------------------------------------------------
# Test 3: Markdown Relative Link Integrity
# ---------------------------------------------------------
Write-Host ""
Write-Host "[3/7] Checking Markdown Relative Links Integrity..." -ForegroundColor Yellow

$brokenLinks = @()
$mdFiles = Get-ChildItem -Path (Join-Path $repoRoot "skills"), (Join-Path $repoRoot "specs") -Recurse -Filter "*.md"

foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw
    $noCode = [regex]::Replace($content, '(?s)```.*?```', '')
    $matches = [regex]::Matches($noCode, '\[.*?\]\((?!https?://|mailto:|#)(.*?)\)')
    foreach ($m in $matches) {
        $relPath = $m.Groups[1].Value.Split('#')[0]
        if ($relPath) {
            $target = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($file.DirectoryName, $relPath))
            if (-not (Test-Path $target)) {
                $brokenLinks += "$($file.Name) -> $relPath"
            }
        }
    }
}

if ($brokenLinks.Count -eq 0) {
    Report-Pass "All relative markdown links resolve to valid targets"
} else {
    foreach ($b in $brokenLinks) {
        Report-Fail "Broken link: $b"
    }
}

# ---------------------------------------------------------
# Test 4: Specs Catalog Audit
# ---------------------------------------------------------
Write-Host ""
Write-Host "[4/7] Checking 12 App Specs Structure..." -ForegroundColor Yellow

$specFiles = Get-ChildItem -Path (Join-Path $repoRoot "specs") -Filter "*.md" | Where-Object { $_.Name -ne "README.md" }
if ($specFiles.Count -eq 12) {
    Report-Pass "Exactly 12 utility app specs present"
} else {
    Report-Fail "Expected 12 specs, found $($specFiles.Count)"
}

$allSpecsValid = $true
foreach ($spec in $specFiles) {
    $content = Get-Content $spec.FullName -Raw
    $hasBrief = $content -match '(?i)##\s*Brief'
    $hasWorks = $content -match '(?i)##\s*How it works'
    $hasStories = $content -match '(?i)##\s*Stories'
    $hasGotchas = $content -match '(?i)##\s*Gotchas'
    $hasDoneWhen = $content -match '(?i)##\s*Done when'

    if (-not ($hasBrief -and $hasWorks -and $hasStories -and $hasGotchas -and $hasDoneWhen)) {
        Report-Fail "Spec '$($spec.Name)' missing required standard sections"
        $allSpecsValid = $false
    }
}

if ($allSpecsValid) {
    Report-Pass "All 12 specs follow the standard format"
}

# ---------------------------------------------------------
# Test 5: Template Sanitization Check
# ---------------------------------------------------------
Write-Host ""
Write-Host "[5/7] Verifying Template Sanitization..." -ForegroundColor Yellow

$templateDir = Join-Path $repoRoot "skills\start\new-win-app\template"
$staleDirs = Get-ChildItem -Path $templateDir -Recurse -Directory -Include "bin", "obj", ".vs"

if ($staleDirs.Count -eq 0) {
    Report-Pass "Scaffolding template is pristine (0 bin/obj/cache artifacts)"
} else {
    foreach ($d in $staleDirs) {
        Report-Fail "Stale directory in template: $($d.FullName)"
    }
}

# ---------------------------------------------------------
# Test 6: Scaffolding, Build, Test & Lint Smoke Test
# ---------------------------------------------------------
Write-Host ""
Write-Host "[6/7] Running End-to-End Scaffolding & Build Smoke Test..." -ForegroundColor Yellow

if ($SkipBuild) {
    Write-Host "  (Skipping build per -SkipBuild switch)" -ForegroundColor DarkGray
} else {
    $testAppName = "PhanTeeSmoketest"
    $testPkgId = "com.phantee.smoketest"
    $tempParent = Join-Path ([System.IO.Path]::GetTempPath()) "PhanTeeTest"
    $testDest = Join-Path $tempParent $testAppName

    try {
        if (Test-Path $tempParent) {
            Remove-Item -Path $tempParent -Recurse -Force -ErrorAction SilentlyContinue
        }

        # Step 6a: Scaffold
        $newAppScript = Join-Path $repoRoot "skills\start\new-win-app\scripts\new-app.ps1"
        & $newAppScript $testAppName $testPkgId $tempParent | Out-Null

        if (Test-Path $testDest) {
            Report-Pass "Scaffold script created $testAppName at $testDest"
        } else {
            Report-Fail "Scaffold script failed to create $testDest"
        }

        # Step 6b: Check generated files & icon
        $iconPath = Join-Path $testDest "Sources\$testAppName\Assets\Icon\AppIcon.ico"
        if (Test-Path $iconPath) {
            Report-Pass "Generated AppIcon.ico in scaffolded application"
        } else {
            Report-Fail "Missing AppIcon.ico at $iconPath"
        }

        # Step 6c: Core Build & Unit Tests
        $coreProj = Join-Path $testDest "Sources\${testAppName}Core\${testAppName}Core.csproj"
        $coreTestsProj = Join-Path $testDest "Tests\${testAppName}CoreTests\${testAppName}CoreTests.csproj"

        $testOutput = & dotnet test $coreTestsProj --logger "console;verbosity=normal" 2>&1
        if ($LASTEXITCODE -eq 0 -and ($testOutput -match "Passed:\s*\d+" -or $testOutput -match "Passed!\s*-\s*Failed:\s*0")) {
            Report-Pass "Unit tests passed: 100% tests passed in ${testAppName}CoreTests"
        } else {
            Report-Fail "Unit tests failed: `n$testOutput"
        }

        # Step 6d: Grid linter
        $gridLintScript = Join-Path $testDest "tools\grid-lint.ps1"
        $lintOutput = & $gridLintScript 2>&1
        if ($LASTEXITCODE -eq 0) {
            Report-Pass "Grid-lint passed with zero spacing violations"
        } else {
            Report-Fail "Grid-lint failed: $lintOutput"
        }

        # Step 6e: Full WinUI 3 App Build
        $appProj = Join-Path $testDest "Sources\$testAppName\$testAppName.csproj"
        Write-Host "  Compiling full WinUI 3 app ($testAppName)..." -ForegroundColor DarkGray
        $buildOutput = & dotnet build $appProj -c Release -r win-x64 --no-incremental 2>&1
        if ($LASTEXITCODE -eq 0) {
            Report-Pass "Full WinUI 3 desktop application compiled successfully (Release win-x64)"
        } else {
            Report-Fail "Full WinUI 3 desktop compilation failed: `n$buildOutput"
        }

        # Step 6f: Headless self-test execution
        $exePath = Join-Path $testDest "Sources\$testAppName\bin\Release\net10.0-windows10.0.19041.0\win-x64\$testAppName.exe"
        if (-not (Test-Path $exePath)) {
            $exePath = Join-Path $testDest "Sources\$testAppName\bin\Release\net9.0-windows10.0.19041.0\win-x64\$testAppName.exe"
        }
        if (Test-Path $exePath) {
            $env:PHANTEE_STORE = Join-Path ([System.IO.Path]::GetTempPath()) "PhanTeeSelftest.db"
            $selfTestProc = Start-Process -FilePath $exePath -ArgumentList "--selftest" -NoNewWindow -Wait -PassThru
            if ($selfTestProc.ExitCode -eq 0) {
                Report-Pass "Headless in-app self-test passed (exit code 0)"
            } else {
                Report-Fail "Headless in-app self-test failed (exit code $($selfTestProc.ExitCode))"
            }
            Remove-Item -Path "$env:PHANTEE_STORE*" -Force -ErrorAction SilentlyContinue
        }
    } finally {
        # Clean up temporary test folder
        if (Test-Path $tempParent) {
            Remove-Item -Path $tempParent -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# ---------------------------------------------------------
# Test 7: Skill Linker Script Syntax Check
# ---------------------------------------------------------
Write-Host ""
Write-Host "[7/7] Validating Skill Linker Script..." -ForegroundColor Yellow

$linkerScript = Join-Path $repoRoot "scripts\link-skills.ps1"
if (Test-Path $linkerScript) {
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($linkerScript, [ref]$null, [ref]$errors) | Out-Null
    if ($errors.Count -eq 0) {
        Report-Pass "scripts/link-skills.ps1 syntax is valid"
    } else {
        Report-Fail "scripts/link-skills.ps1 syntax error: $($errors[0].Message)"
    }
} else {
    Report-Fail "scripts/link-skills.ps1 not found"
}

# ---------------------------------------------------------
# Summary
# ---------------------------------------------------------
$sw.Stop()
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Test Suite Summary" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Total Passed: $passCount" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "  Total Failed: $failCount" -ForegroundColor Red
} else {
    Write-Host "  Total Failed: 0" -ForegroundColor Green
}
Write-Host "  Elapsed Time: $([Math]::Round($sw.Elapsed.TotalSeconds, 2)) seconds" -ForegroundColor DarkGray
Write-Host ""

if ($failCount -gt 0) {
    Write-Host "[RESULT] PRODUCTION READINESS: FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[RESULT] PRODUCTION READINESS: ALL CHECKS PASSED!" -ForegroundColor Green
    exit 0
}
