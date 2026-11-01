<#
.SYNOPSIS
Flags spacing numbers off the 4 px grid in XAML and C# files.
Allowed numbers: 0, 1, 2, and multiples of 4.
Silence one line with: // grid: ok <why>  or  <!-- grid: ok <why> -->
#>
[CmdletBinding()]
param(
    [string]$Directory
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Directory) {
    $Directory = Join-Path $here "..\Sources"
}

$files = Get-ChildItem -Path $Directory -Recurse -Include *.xaml, *.cs | Where-Object {
    $_.Name -notmatch "Grid\.cs|Theme\.cs"
}

$badCount = 0

foreach ($file in $files) {
    $lines = Get-Content -Path $file.FullName
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $lineNum = $i + 1

        if ($line -match "grid:\s*ok") {
            continue
        }

        # Check for Padding="...", Margin="...", Width="...", Height="...", Spacing="..."
        $matches = [regex]::Matches($line, '(?:Padding|Margin|Width|Height|Spacing|CornerRadius)\s*=\s*["'']?(-?\d+(?:\.\d+)?)["'']?')
        foreach ($match in $matches) {
            $numVal = [double]$match.Groups[1].Value
            $isAllowed = ($numVal -eq 0 -or $numVal -eq 1 -or $numVal -eq 2 -or ($numVal % 4 -eq 0))
            if (-not $isAllowed) {
                Write-Host "$($file.Name):$($lineNum): off grid ($numVal): $($line.Trim())" -ForegroundColor Red
                $badCount++
            }
        }
    }
}

if ($badCount -gt 0) {
    Write-Host "`nFAIL grid-lint: $badCount lines off the grid" -ForegroundColor Red
    exit 1
} else {
    Write-Host "PASS grid-lint" -ForegroundColor Green
    exit 0
}
