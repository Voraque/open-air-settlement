param(
    [string]$InstancePath = 'C:\Users\dnich\curseforge\minecraft\Instances\Open-Air Settlement',
    [string]$PackOutput = 'C:\Nicky-Personal-Effects\minecraft-open-air-settlement\assembled-v1.0.6'
)

$ErrorActionPreference = 'Stop'
$instanceMetadata = Join-Path $InstancePath 'minecraftinstance.json'
$instanceMods = Join-Path $InstancePath 'mods'
$sourceConfig = Join-Path $PackOutput 'curseforge-stage\overrides\config'
$stage = Join-Path $PackOutput 'curseforge-canonical-stage'
$dist = Join-Path $PackOutput 'dist'
$outputZip = Join-Path $dist 'Open-Air-Settlement-1.0.6-CurseForge.zip'

if (-not (Test-Path -LiteralPath $instanceMetadata)) { throw "CurseForge metadata not found: $instanceMetadata" }
if (-not (Test-Path -LiteralPath $instanceMods)) { throw "CurseForge mods folder not found: $instanceMods" }
if (-not (Test-Path -LiteralPath $sourceConfig)) { throw "Pack config template not found: $sourceConfig" }

if (Test-Path -LiteralPath $stage) {
    $resolvedStage = (Resolve-Path -LiteralPath $stage).Path
    $resolvedPack = (Resolve-Path -LiteralPath $PackOutput).Path
    if (-not $resolvedStage.StartsWith($resolvedPack, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to remove a stage outside the pack output: $resolvedStage"
    }
    Remove-Item -LiteralPath $stage -Recurse -Force
}
New-Item -ItemType Directory -Force -Path (Join-Path $stage 'overrides\mods') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $stage 'overrides\config') | Out-Null
New-Item -ItemType Directory -Force -Path $dist | Out-Null

$metadata = Get-Content -Raw -LiteralPath $instanceMetadata | ConvertFrom-Json
$actualNames = @(Get-ChildItem -LiteralPath $instanceMods -File -Filter '*.jar' | Select-Object -ExpandProperty Name)
$actualSet = @{}
foreach ($name in $actualNames) { $actualSet[$name] = $true }

$managed = @{}
$manifestFiles = @(
    foreach ($addon in $metadata.installedAddons) {
        $fileName = [string]$addon.fileNameOnDisk
        if ($actualSet.ContainsKey($fileName) -and $addon.addonID -and $addon.installedFile.id) {
            $managed[$fileName] = $true
            [ordered]@{
                projectID = [int]$addon.addonID
                fileID = [int]$addon.installedFile.id
                required = $true
            }
        }
    }
)

# Keep only jars that CurseForge does not know about as direct overrides.
# The current pack has two such files; they are small and remain redistributable
# in the custom-profile ZIP while all other mods are fetched by project/file ID.
foreach ($name in $actualNames | Where-Object { -not $managed.ContainsKey($_) }) {
    Copy-Item -LiteralPath (Join-Path $instanceMods $name) -Destination (Join-Path $stage "overrides\mods\$name") -Force
}
Get-ChildItem -LiteralPath $sourceConfig -Force | Copy-Item -Destination (Join-Path $stage 'overrides\config') -Recurse -Force
Copy-Item -LiteralPath (Join-Path $PackOutput 'README.md') -Destination (Join-Path $stage 'overrides\README.md') -Force

$manifest = [ordered]@{
    minecraft = [ordered]@{
        version = '1.21.1'
        modLoaders = @([ordered]@{ id = 'fabric-0.19.3'; primary = $true })
    }
    manifestType = 'minecraftModpack'
    manifestVersion = 1
    name = 'Open-Air Settlement'
    version = '1.0.6'
    author = 'Nicky and Benji'
    files = @($manifestFiles)
    overrides = 'overrides'
}
$manifestJson = $manifest | ConvertTo-Json -Depth 8
[IO.File]::WriteAllText((Join-Path $stage 'manifest.json'), $manifestJson, (New-Object Text.UTF8Encoding($false)))

if (Test-Path -LiteralPath $outputZip) { Remove-Item -LiteralPath $outputZip -Force }
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $outputZip -Force
$size = (Get-Item -LiteralPath $outputZip).Length
[PSCustomObject]@{
    Output = $outputZip
    SizeBytes = $size
    CurseForgeFiles = $manifestFiles.Count
    DirectOverrideJars = @($actualNames | Where-Object { -not $managed.ContainsKey($_) }).Count
}

