<#
.SYNOPSIS
Links every skill in this repository into Antigravity, Claude Code, and Codex.
Targets:
  - ~/.gemini/config/skills (Antigravity CLI)
  - ~/.claude/skills (Claude Code)
  - ~/.agents/skills (Codex / Agent standards)
Compatible with Windows PowerShell 5.1 and PowerShell 7.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$homeDir = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)

$targets = @(
    (Join-Path $homeDir ".gemini\config\skills"),
    (Join-Path $homeDir ".claude\skills"),
    (Join-Path $homeDir ".agents\skills")
)

$skillDirs = Get-ChildItem -Path (Join-Path $repoRoot "skills\*\*\") -Directory

foreach ($target in $targets) {
    if (-not (Test-Path $target)) {
        New-Item -ItemType Directory -Path $target -Force | Out-Null
    }

    foreach ($skill in $skillDirs) {
        $skillName = $skill.Name
        $destination = Join-Path $target $skillName

        if (Test-Path $destination) {
            # Safely remove existing junction or directory
            try {
                [System.IO.Directory]::Delete($destination, $false)
            } catch {
                Remove-Item -Path $destination -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        # Create directory junction (does not require admin privileges on Windows)
        New-Item -ItemType Junction -Path $destination -Value $skill.FullName | Out-Null
        Write-Host "Linked: $destination -> $($skill.FullName)" -ForegroundColor Cyan
    }
}

Write-Host "`nAll 21 skills linked into Antigravity, Claude Code, and Codex!" -ForegroundColor Green
