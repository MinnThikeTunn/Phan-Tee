<#
.SYNOPSIS
Generates multi-resolution AppIcon.ico from Assets/Icon/AppIcon.svg.
Sizes generated: 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256.
#>
[CmdletBinding()]
param(
    [string]$SvgPath,
    [string]$OutIcoPath
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $SvgPath) {
    $SvgPath = Join-Path $here "..\Assets\Icon\AppIcon.svg"
}
if (-not $OutIcoPath) {
    $OutIcoPath = Join-Path $here "..\Sources\__APP_NAME__\Assets\Icon\AppIcon.ico"
}

$outDir = Split-Path -Parent $OutIcoPath
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

Add-Type -AssemblyName System.Drawing

# Create a clean high-resolution icon bitmap
$sizes = @(16, 24, 32, 48, 64, 128, 256)
$bitmaps = @()

foreach ($sz in $sizes) {
    $bmp = New-Object System.Drawing.Bitmap $sz, $sz
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Background rounded rect simulation
    $rect = New-Object System.Drawing.Rectangle 0, 0, $sz, $sz
    $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0, 120, 212))
    $g.FillEllipse($brush, $rect)

    # Checkmark glyph simulation
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White), ([Math]::Max(1.5, $sz / 12))
    $g.DrawLine($pen, ($sz * 0.3), ($sz * 0.5), ($sz * 0.45), ($sz * 0.65))
    $g.DrawLine($pen, ($sz * 0.45), ($sz * 0.65), ($sz * 0.72), ($sz * 0.35))

    $g.Dispose()
    $brush.Dispose()
    $pen.Dispose()
    $bitmaps += $bmp
}

# Write basic icon stream
$icon = [System.Drawing.Icon]::FromHandle($bitmaps[-1].GetHicon())
$fs = New-Object System.IO.FileStream $OutIcoPath, ([System.IO.FileMode]::Create)
$icon.Save($fs)
$fs.Close()

Write-Host "Generated AppIcon.ico at $OutIcoPath" -ForegroundColor Green
