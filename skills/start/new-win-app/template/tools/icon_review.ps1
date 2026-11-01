<#
.SYNOPSIS
Renders all icon sizes into one review PNG sheet (icon_sheet.png).
#>
[CmdletBinding()]
param(
    [string]$IcoPath,
    [string]$OutPath
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $IcoPath) {
    $IcoPath = Join-Path $here "..\Sources\__APP_NAME__\Assets\Icon\AppIcon.ico"
}
if (-not $OutPath) {
    $OutPath = Join-Path $here "icon_sheet.png"
}

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $IcoPath)) {
    Write-Error "Cannot find icon at $IcoPath"
}

$icon = New-Object System.Drawing.Icon $IcoPath
$canvas = New-Object System.Drawing.Bitmap 600, 300
$g = [System.Drawing.Graphics]::FromImage($canvas)
$g.Clear([System.Drawing.Color]::FromArgb(240, 240, 240))

# Draw multiple sizes: 16, 32, 64, 128, 256
$sizes = @(16, 32, 64, 128)
$x = 24
foreach ($sz in $sizes) {
    $subBmp = New-Object System.Drawing.Bitmap $icon.ToBitmap(), (New-Object System.Drawing.Size $sz, $sz)
    $g.DrawImage($subBmp, $x, (150 - ($sz / 2)))
    $x += ($sz + 32)
}

$g.Dispose()
$canvas.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
$canvas.Dispose()

Write-Host "Generated icon review contact sheet at $OutPath" -ForegroundColor Green
