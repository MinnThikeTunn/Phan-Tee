<#
.SYNOPSIS
Measures exact pixel dimensions, margins, and colors from a reference screenshot.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ImagePath,

    [int]$X = 0,
    [int]$Y = 0
)

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $ImagePath)) {
    Write-Error "Cannot find image at $ImagePath"
}

$bmp = [System.Drawing.Bitmap]::FromFile($ImagePath)
$color = $bmp.GetPixel($X, $Y)

Write-Host "Image Size: $($bmp.Width) x $($bmp.Height)" -ForegroundColor Cyan
Write-Host "Pixel ($X, $Y): RGB($($color.R), $($color.G), $($color.B)) Hex: #$($color.R.ToString('X2'))$($color.G.ToString('X2'))$($color.B.ToString('X2'))" -ForegroundColor Yellow

$bmp.Dispose()
