[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $ServerDir,
    [string] $OutputDir = (Join-Path $PSScriptRoot 'runs'),
    [string] $ServerJar,
    [string] $JavaPath,
    [string[]] $Commands = @('list'),
    [string[]] $RequiredLogPatterns = @(),
    [int] $StartupTimeoutSeconds = 180,
    [int] $PostReadyDelaySeconds = 45,
    [int] $CommandGraceMilliseconds = 500,
    [int] $ShutdownTimeoutSeconds = 15,
    [switch] $KeepRunDirectory
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'PackValidation.psm1') -Force
if (-not $PSBoundParameters.ContainsKey('OutputDir')) {
    $PSBoundParameters['OutputDir'] = $OutputDir
}
$result = Invoke-PackSmokeTest @PSBoundParameters
if (-not $result.report.success) { exit 1 }
