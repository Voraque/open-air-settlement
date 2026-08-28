[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $ServerDir,
    [Parameter(Mandatory)] [string] $JavaPath,
    [string] $ServerJar = 'fabric-server-launch.jar',
    [int] $StartupTimeoutSeconds = 220,
    [int] $PostReadyDelaySeconds = 45,
    [int] $ShutdownTimeoutSeconds = 30,
    [switch] $KeepRunDirectory
)

$ErrorActionPreference = 'Stop'

$commands = [string[]] @(
    'forceload add 0 0',
    'fill -5 63 -5 5 63 5 minecraft:stone',
    'setblock 0 64 0 minecraft:bell',
    'setblock 1 64 0 minecraft:red_bed[part=foot,facing=east]',
    'setblock 2 64 0 minecraft:red_bed[part=head,facing=east]',
    'setblock -1 64 0 minecraft:red_bed[part=foot,facing=west]',
    'setblock -2 64 0 minecraft:red_bed[part=head,facing=west]',
    'setblock 0 64 1 minecraft:red_bed[part=foot,facing=south]',
    'setblock 0 64 2 minecraft:red_bed[part=head,facing=south]',
    'setblock 0 64 -1 minecraft:red_bed[part=foot,facing=north]',
    'setblock 0 64 -2 minecraft:red_bed[part=head,facing=north]',
    'setblock 3 64 0 minecraft:lectern',
    'setblock -3 64 0 minecraft:cartography_table',
    'setblock 0 64 3 minecraft:loom',
    'settlementorigin debug claimat integration 0 64 0',
    'summon minecraft:villager 1 64 1 {Tags:["openair_anchored"]}',
    'settlementorigin debug adopt @e[type=minecraft:villager,tag=openair_anchored,limit=1] integration',
    'settlementorigin origin @e[type=minecraft:villager,tag=openair_anchored,limit=1]',
    'settlementorigin restockcheck @e[type=minecraft:villager,tag=openair_anchored,limit=1]',
    'settlementorigin claims',
    'forceload remove 0 0'
)

$requiredPatterns = [string[]] @(
    'dynamicvillagertrades 1\.4\.0-openair\.1',
    'settlementorigins 0\.1\.0-prototype\.1',
    'Debug claim created: integration',
    'Debug-adopted villager',
    'Restock decision: ALLOW',
    'Known settlement claims: 1'
)

$harness = Join-Path $PSScriptRoot 'Invoke-PackSmokeTest.ps1'
& $harness `
    -ServerDir $ServerDir `
    -ServerJar $ServerJar `
    -JavaPath $JavaPath `
    -Commands $commands `
    -RequiredLogPatterns $requiredPatterns `
    -StartupTimeoutSeconds $StartupTimeoutSeconds `
    -PostReadyDelaySeconds $PostReadyDelaySeconds `
    -ShutdownTimeoutSeconds $ShutdownTimeoutSeconds `
    -KeepRunDirectory:$KeepRunDirectory

exit $LASTEXITCODE
