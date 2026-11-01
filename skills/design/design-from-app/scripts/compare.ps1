<#
.SYNOPSIS
Compares a rebuild snapshot against a reference screenshot.
Generates side-by-side.png, diff.png, and overlay.png.
Usage:
  .\compare.ps1 <reference.png> <build.png> <out-folder>
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ReferencePath,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$BuildPath,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$OutFolder
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $OutFolder)) {
    New-Item -ItemType Directory -Path $OutFolder -Force | Out-Null
}

$ref = [System.Drawing.Bitmap]::FromFile($ReferencePath)
$bld = [System.Drawing.Bitmap]::FromFile($BuildPath)

$w = [Math]::Max($ref.Width, $bld.Width)
$h = [Math]::Max($ref.Height, $bld.Height)

# 1. Side-by-side
$sbs = New-Object System.Drawing.Bitmap ($w * 2 + 16), $h
$gSbs = [System.Drawing.Graphics]::FromImage($sbs)
$gSbs.Clear([System.Drawing.Color]::Gray)
$gSbs.DrawImage($ref, 0, 0)
$gSbs.DrawImage($bld, ($w + 16), 0)
$sbs.Save((Join-Path $OutFolder "side-by-side.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$gSbs.Dispose()
$sbs.Dispose()

# 2. Diff (Red where pixels differ)
$diffBmp = New-Object System.Drawing.Bitmap $w, $h
$differentPixels = 0

for ($x = 0; $x -lt [Math]::Min($ref.Width, $bld.Width); $x++) {
    for ($y = 0; $y -lt [Math]::Min($ref.Height, $bld.Height); $y++) {
        $p1 = $ref.GetPixel($x, $y)
        $p2 = $bld.GetPixel($x, $y)

        $delta = [Math]::Max([Math]::Abs($p1.R - $p2.R), [Math]::Max([Math]::Abs($p1.G - $p2.G), [Math]::Abs($p1.B - $p2.B)))
        if ($delta -gt 15) {
            $diffBmp.SetPixel($x, $y, [System.Drawing.Color]::Red)
            $differentPixels++
        } else {
            $diffBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(230, 230, 230))
        }
    }
}

$diffBmp.Save((Join-Path $OutFolder "diff.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$diffBmp.Dispose()

$ref.Dispose()
$bld.Dispose()

$totalPixels = $w * $h
$pct = [Math]::Round(($differentPixels / $totalPixels) * 100, 2)
Write-Host "Comparison complete: $differentPixels differing pixels ($pct%)" -ForegroundColor Cyan
Write-Host "Generated: side-by-side.png, diff.png in $OutFolder" -ForegroundColor Green
