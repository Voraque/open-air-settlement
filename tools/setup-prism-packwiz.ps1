param(
    [string]$PrismRoot
)

$ErrorActionPreference = 'Stop'

$packUrl = 'https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml'
$bootstrapUrl = 'https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar'

if ([string]::IsNullOrWhiteSpace($PrismRoot)) {
    if ([string]::IsNullOrWhiteSpace($env:APPDATA)) {
        throw 'APPDATA is not available. Pass -PrismRoot explicitly.'
    }
    $PrismRoot = Join-Path $env:APPDATA 'PrismLauncher'
}

$instanceDir = Join-Path $PrismRoot 'instances\Open-Air-Settlement'
$minecraftDir = Join-Path $instanceDir 'minecraft'
$instanceCfg = Join-Path $instanceDir 'instance.cfg'

if (Test-Path -LiteralPath $instanceCfg) {
    throw "An Open-Air Settlement instance already exists at $instanceDir. Inspect it instead of overwriting it."
}

New-Item -ItemType Directory -Force -Path $minecraftDir | Out-Null
Invoke-WebRequest -Uri $bootstrapUrl -OutFile (Join-Path $minecraftDir 'packwiz-installer-bootstrap.jar')

@'
InstanceType=OneSix
JoinServerOnLaunch=false
OverrideCommands=true
OverrideConsole=false
OverrideGameTime=false
OverrideJavaArgs=false
OverrideJavaLocation=false
OverrideMemory=false
OverrideNativeWorkarounds=false
OverrideWindow=false
PreLaunchCommand="$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml
iconKey=default
name=Open-Air Settlement
notes=Packwiz-managed shared pack. The pre-launch command syncs the current GitHub release.
'@ | Set-Content -LiteralPath $instanceCfg -Encoding UTF8

@'
{
  "formatVersion": 1,
  "components": [
    {
      "uid": "net.minecraft",
      "version": "1.21.1",
      "important": true
    },
    {
      "uid": "net.fabricmc.fabric-loader",
      "version": "0.19.3"
    }
  ]
}
'@ | Set-Content -LiteralPath (Join-Path $instanceDir 'mmc-pack.json') -Encoding UTF8

Write-Host "Created $instanceDir" -ForegroundColor Green
Write-Host 'Next: open Prism, sign in once if needed, and launch Open-Air Settlement.' -ForegroundColor Cyan
