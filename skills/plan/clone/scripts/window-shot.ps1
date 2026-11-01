<#
.SYNOPSIS
Saves a full-resolution PNG of the largest on-screen window of an application.
Usage:
  .\window-shot.ps1 <AppName> <out.png>
Example:
  .\window-shot.ps1 "Notepad" docs/screens/01-main.png
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$AppName,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$OutPath
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32Window
{
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBkgnd, uint nFlags);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
}
"@

$processes = Get-Process -Name $AppName -ErrorAction SilentlyContinue
if (-not $processes) {
    Write-Error "No running process found for '$AppName'. Is the app open?"
}

$targetHwnd = [IntPtr]::Zero
$maxArea = 0
$targetRect = $null

foreach ($proc in $processes) {
    $hwnd = $proc.MainWindowHandle
    if ($hwnd -ne [IntPtr]::Zero -and [Win32Window]::IsWindowVisible($hwnd)) {
        $rect = New-Object Win32Window+RECT
        if ([Win32Window]::GetWindowRect($hwnd, [ref]$rect)) {
            $w = $rect.Right - $rect.Left
            $h = $rect.Bottom - $rect.Top
            $area = $w * $h
            if ($area -gt $maxArea) {
                $maxArea = $area
                $targetHwnd = $hwnd
                $targetRect = $rect
            }
        }
    }
}

if ($targetHwnd -eq [IntPtr]::Zero) {
    Write-Error "Could not find a visible window for '$AppName'."
}

$outDir = Split-Path -Parent $OutPath
if ($outDir -and -not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$width = $targetRect.Right - $targetRect.Left
$height = $targetRect.Bottom - $targetRect.Top

$bmp = New-Object System.Drawing.Bitmap $width, $height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$hdc = $g.GetHdc()

try {
    # 2 = PW_RENDERFULLCONTENT
    [Win32Window]::PrintWindow($targetHwnd, $hdc, 2) | Out-Null
} finally {
    $g.ReleaseHdc($hdc)
}

$bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Write-Host "Captured window to $OutPath ($width x $height)" -ForegroundColor Green
