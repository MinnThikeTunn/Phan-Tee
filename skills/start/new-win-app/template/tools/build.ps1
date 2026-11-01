<#
.SYNOPSIS
Builds __APP_NAME__ and installs it to %LOCALAPPDATA%\Programs\__APP_NAME__\.
#>
[CmdletBinding()]
param(
    [switch]$DebugBuild,
    [switch]$Open
)

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$buildScript = Join-Path $root "build.ps1"

if ($DebugBuild) {
    & $buildScript -DebugBuild
} elseif ($Open) {
    & $buildScript -Open
} else {
    & $buildScript
}
