Set-StrictMode -Version Latest

function Get-PatternMatch {
    param(
        [Parameter(Mandatory)] [string] $Line,
        [Parameter(Mandatory)] [string] $Pattern
    )

    return [regex]::IsMatch($Line, $Pattern, [Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

function Get-PackValidationLogClassification {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [AllowEmptyCollection()] [string[]] $Lines
    )

    $records = [System.Collections.Generic.List[object]]::new()
    $fatalPatterns = [ordered]@{
        'runtime-startup' = @(
            'Failed to start the minecraft server',
            'Could not execute entrypoint stage',
            'NoClassDefFoundError'
        )
        'mod-resolution' = @(
            'Mod resolution failed',
            'Incompatible mods found',
            'depends on .* but',
            'requires .* but only',
            'breaks .* conflicting version',
            'Could not find required mod'
        )
        'datapack-load' = @(
            'Failed to load datapack',
            'Couldn''t load datapack',
            'Couldn''t parse data ?pack',
            'Error loading datapack',
            'No key .* in .*pack',
            'Failed to load tag'
        )
        'function-load' = @(
            'Couldn''t load function',
            'Failed to load function',
            'Error loading function',
            'Unknown function',
            'Invalid function',
            'Couldn''t execute function',
            'Failed to execute function',
            'Unknown or incomplete command.*function'
        )
        'recipe-load' = @(
            'Parsing error loading recipe',
            'Couldn''t parse recipe',
            'Failed to load recipe'
        )
    }
    $warningPatterns = @(
        'WARN',
        'deprecated',
        'Unable to load .* optional',
        'Missing .* optional'
    )

    for ($index = 0; $index -lt $Lines.Count; $index++) {
        $line = [string]$Lines[$index]
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        $matched = $false
        foreach ($category in $fatalPatterns.Keys) {
            foreach ($pattern in $fatalPatterns[$category]) {
                if (Get-PatternMatch -Line $line -Pattern $pattern) {
                    $records.Add([pscustomobject]@{
                        severity = 'fatal'
                        category = $category
                        lineNumber = $index + 1
                        message = $line
                    })
                    $matched = $true
                    break
                }
            }
            if ($matched) { break }
        }

        if (-not $matched) {
            foreach ($pattern in $warningPatterns) {
                if (Get-PatternMatch -Line $line -Pattern $pattern) {
                    $records.Add([pscustomobject]@{
                        severity = 'warning'
                        category = 'general'
                        lineNumber = $index + 1
                        message = $line
                    })
                    break
                }
            }
        }
    }

    $fatal = @($records | Where-Object severity -eq 'fatal')
    $warnings = @($records | Where-Object severity -eq 'warning')
    return [pscustomobject]@{
        fatal = ($fatal.Count -gt 0)
        fatalCount = $fatal.Count
        warningCount = $warnings.Count
        records = @($records)
        fatalRecords = $fatal
        warningRecords = $warnings
    }
}

function Test-PackValidationJava21 {
    [CmdletBinding()]
    param([Parameter(Mandatory)] [string] $JavaPath)

    $versionOutput = & $JavaPath -version 2>&1 | Out-String
    $match = [regex]::Match($versionOutput, 'version\s+"(?<version>[^"]+)"')
    if (-not $match.Success) {
        throw "Could not determine Java version from $JavaPath."
    }
    $version = $match.Groups['version'].Value
    $major = if ($version.StartsWith('1.')) { [int]$version.Split('.')[1] } else { [int]$version.Split('.')[0] }
    if ($major -ne 21) {
        throw "Java 21 is required; $JavaPath reports Java $version."
    }
    return [pscustomobject]@{ path = $JavaPath; version = $version; major = $major }
}

function Resolve-PackValidationJava {
    [CmdletBinding()]
    param([string] $JavaPath)

    if ([string]::IsNullOrWhiteSpace($JavaPath)) {
        $command = Get-Command java -ErrorAction SilentlyContinue
        if ($null -eq $command) { throw 'Java was not found on PATH. Install Java 21 or pass -JavaPath.' }
        $JavaPath = $command.Source
    }
    return Test-PackValidationJava21 -JavaPath $JavaPath
}

function Get-PackValidationServerJar {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ServerDir,
        [string] $ServerJar
    )

    if (-not [string]::IsNullOrWhiteSpace($ServerJar)) {
        $candidate = [IO.Path]::GetFullPath((Join-Path $ServerDir $ServerJar))
        if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) { throw "Server jar not found: $candidate" }
        return $candidate
    }

    foreach ($name in @('fabric-server-launch.jar', 'server.jar')) {
        $candidate = Join-Path $ServerDir $name
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return [IO.Path]::GetFullPath($candidate) }
    }

    $jars = @(Get-ChildItem -LiteralPath $ServerDir -Filter '*.jar' -File | Where-Object {
        $_.Name -notmatch 'installer|launcher-helper|packwiz'
    } | Sort-Object Name)
    if ($jars.Count -eq 1) { return $jars[0].FullName }
    if ($jars.Count -eq 0) { throw "No server jar found in $ServerDir. Pass -ServerJar relative to the source directory." }
    throw "Multiple candidate server jars found in $ServerDir. Pass -ServerJar explicitly."
}

function Test-PackValidationExcludedRelativePath {
    param([Parameter(Mandatory)] [string] $RelativePath)

    $normal = $RelativePath.Replace('/', '\').TrimStart('\')
    $parts = $normal.Split('\')
    $excludedDirectoryNames = @('world', 'world_nether', 'world_the_end', 'logs', 'crash-reports', 'backups', '.fabric', '.cache', '.tmp', 'java')
    if ($parts | Where-Object { $excludedDirectoryNames -contains $_ }) { return $true }

    $leaf = $parts[-1]
    return $leaf -match '^(\.env|.*\.env|.*credentials.*|.*secret.*|.*password.*|.*\.pem|.*\.key)$'
}

function Copy-PackValidationSource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $SourceDir,
        [Parameter(Mandatory)] [string] $DestinationDir
    )

    New-Item -ItemType Directory -Force -Path $DestinationDir | Out-Null
    $sourceRoot = [IO.Path]::GetFullPath($SourceDir).TrimEnd('\')
    $copied = 0
    $skipped = 0
    foreach ($file in Get-ChildItem -LiteralPath $sourceRoot -Recurse -File -Force) {
        $relative = [IO.Path]::GetRelativePath($sourceRoot, $file.FullName)
        if (Test-PackValidationExcludedRelativePath -RelativePath $relative) { $skipped++; continue }
        $target = Join-Path $DestinationDir $relative
        New-Item -ItemType Directory -Force -Path ([IO.Path]::GetDirectoryName($target)) | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $target -Force
        $copied++
    }

    # A smoke test must generate a fresh world and must not expose source RCON credentials.
    $propertiesPath = Join-Path $DestinationDir 'server.properties'
    $properties = @()
    $sourceProperties = Join-Path $sourceRoot 'server.properties'
    if (Test-Path -LiteralPath $sourceProperties -PathType Leaf) {
        foreach ($line in Get-Content -LiteralPath $sourceProperties) {
            if ($line -match '^(rcon\.password|enable-rcon|query\.port|enable-query)=') { continue }
            if ($line -match '^level-name=|^server-port=|^online-mode=') { continue }
            $properties += $line
        }
    }
    $properties += @(
        'level-name=pack-validation-world'
        'server-port=0'
        'online-mode=false'
        'enable-rcon=false'
        'enable-query=false'
        'motd=Open-Air Settlement pack validation'
    )
    Set-Content -LiteralPath $propertiesPath -Value $properties -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $DestinationDir 'eula.txt') -Value 'eula=true' -Encoding ASCII

    return [pscustomobject]@{ copiedFiles = $copied; skippedFiles = $skipped }
}

function Stop-PackValidationProcess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [Diagnostics.Process] $Process,
        [int] $TimeoutSeconds = 15
    )

    $result = [ordered]@{ stopCommandSent = $false; exitedCleanly = $false; forced = $false; exitCode = $null }
    if ($Process.HasExited) {
        $result.exitedCleanly = $true
        $result.exitCode = $Process.ExitCode
        return [pscustomobject]$result
    }

    try {
        if (-not $Process.StandardInput.BaseStream.CanWrite) { throw 'stdin is not writable' }
        $Process.StandardInput.WriteLine('stop')
        $Process.StandardInput.Flush()
        $result.stopCommandSent = $true
    } catch { }

    if (-not $Process.WaitForExit($TimeoutSeconds * 1000)) {
        try { $Process.Kill($true) } catch { try { $Process.Kill() } catch { } }
        # Minecraft's bundled server launcher can create a child JVM. On Windows,
        # taskkill /T is the reliable last-resort tree cleanup when that child
        # survives Process.Kill(true).
        try { & taskkill.exe /PID $Process.Id /T /F *> $null } catch { }
        [void]$Process.WaitForExit(5000)
        $result.forced = $true
    }
    $result.exitedCleanly = $Process.HasExited -and -not $result.forced
    if ($Process.HasExited) { $result.exitCode = $Process.ExitCode }
    return [pscustomobject]$result
}

function Invoke-PackSmokeTest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ServerDir,
        [Parameter(Mandatory)] [string] $OutputDir,
        [string] $ServerJar,
        [string] $JavaPath,
        [string[]] $Commands = @('list'),
        [int] $StartupTimeoutSeconds = 180,
        [int] $PostReadyDelaySeconds = 45,
        [int] $CommandGraceMilliseconds = 500,
        [int] $ShutdownTimeoutSeconds = 15,
        [switch] $KeepRunDirectory
    )

    $source = [IO.Path]::GetFullPath($ServerDir)
    if (-not (Test-Path -LiteralPath $source -PathType Container)) { throw "Server source directory not found: $source" }
    $outputRoot = [IO.Path]::GetFullPath($OutputDir)
    New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
    $runId = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') + '-' + ([guid]::NewGuid().ToString('N').Substring(0, 8))
    $runDir = Join-Path $outputRoot $runId
    $logDir = Join-Path $runDir 'logs'
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null

    $started = Get-Date
    $copyStats = Copy-PackValidationSource -SourceDir $source -DestinationDir $runDir
    $java = Resolve-PackValidationJava -JavaPath $JavaPath
    $jar = Get-PackValidationServerJar -ServerDir $runDir -ServerJar $ServerJar
    $stdoutPath = Join-Path $logDir 'stdout.log'
    $stderrPath = Join-Path $logDir 'stderr.log'
    $stdoutTask = $null
    $stderrTask = $null
    $process = $null
    $ready = $false
    $timedOut = $false
    $startupElapsedMilliseconds = $null
    $commandResults = [Collections.Generic.List[object]]::new()
    $cleanup = $null
    $stopwatch = [Diagnostics.Stopwatch]::StartNew()

    try {
        $psi = [Diagnostics.ProcessStartInfo]::new()
        $psi.FileName = $java.path
        $psi.WorkingDirectory = $runDir
        $psi.UseShellExecute = $false
        $psi.CreateNoWindow = $true
        $psi.RedirectStandardInput = $true
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        [void]$psi.ArgumentList.Add('-Xms512M')
        [void]$psi.ArgumentList.Add('-Xmx2G')
        [void]$psi.ArgumentList.Add('-jar')
        [void]$psi.ArgumentList.Add((Split-Path -Leaf $jar))
        [void]$psi.ArgumentList.Add('nogui')
        $process = [Diagnostics.Process]::new()
        $process.StartInfo = $psi
        [void]$process.Start()
        $stdoutTask = $process.StandardOutput.ReadLineAsync()
        $stderrTask = $process.StandardError.ReadLineAsync()

        while (-not $process.HasExited -and $stopwatch.Elapsed.TotalSeconds -lt $StartupTimeoutSeconds) {
            if ($stdoutTask.IsCompleted) {
                $line = $stdoutTask.GetAwaiter().GetResult()
                if ($null -ne $line) {
                    [IO.File]::AppendAllText($stdoutPath, $line + [Environment]::NewLine)
                    Write-Host $line
                    if ($line -match 'Done \([^)]+\)! For help, type') { $ready = $true }
                    $stdoutTask = $process.StandardOutput.ReadLineAsync()
                }
            }
            if ($stderrTask.IsCompleted) {
                $line = $stderrTask.GetAwaiter().GetResult()
                if ($null -ne $line) {
                    [IO.File]::AppendAllText($stderrPath, $line + [Environment]::NewLine)
                    Write-Host $line
                    $stderrTask = $process.StandardError.ReadLineAsync()
                }
            }
            if ($ready) { break }
            Start-Sleep -Milliseconds 100
        }
        if (-not $ready) { $timedOut = -not $process.HasExited }
        $startupElapsedMilliseconds = [int]$stopwatch.Elapsed.TotalMilliseconds

        if ($ready) {
            # Some mods trigger an automatic datapack reload immediately after the
            # vanilla readiness line. Keep draining both pipes while that settles;
            # otherwise a queued stop command can be starved behind the reload.
            $settleUntil = [DateTime]::UtcNow.AddSeconds($PostReadyDelaySeconds)
            while (-not $process.HasExited -and [DateTime]::UtcNow -lt $settleUntil) {
                if ($stdoutTask.IsCompleted) {
                    $line = $stdoutTask.GetAwaiter().GetResult()
                    if ($null -ne $line) {
                        [IO.File]::AppendAllText($stdoutPath, $line + [Environment]::NewLine)
                        Write-Host $line
                        $stdoutTask = $process.StandardOutput.ReadLineAsync()
                    }
                }
                if ($stderrTask.IsCompleted) {
                    $line = $stderrTask.GetAwaiter().GetResult()
                    if ($null -ne $line) {
                        [IO.File]::AppendAllText($stderrPath, $line + [Environment]::NewLine)
                        Write-Host $line
                        $stderrTask = $process.StandardError.ReadLineAsync()
                    }
                }
                Start-Sleep -Milliseconds 100
            }
            foreach ($command in $Commands) {
                $commandWatch = [Diagnostics.Stopwatch]::StartNew()
                $process.StandardInput.WriteLine($command)
                $process.StandardInput.Flush()
                Start-Sleep -Milliseconds $CommandGraceMilliseconds
                $commandResults.Add([pscustomobject]@{ command = $command; sent = $true; waitMilliseconds = [int]$commandWatch.Elapsed.TotalMilliseconds })
            }
        }
    } catch {
        $timedOut = $false
        $commandResults.Add([pscustomobject]@{ command = $null; sent = $false; error = $_.Exception.Message })
    } finally {
        if ($null -ne $process) {
            $cleanup = Stop-PackValidationProcess -Process $process -TimeoutSeconds $ShutdownTimeoutSeconds
            if ($process.HasExited) { try { $process.WaitForExit() } catch { } }
        }
        $stopwatch.Stop()
    }

    # The process has stopped by this point. Drain the async readers without invoking
    # PowerShell callbacks from thread-pool threads, and keep the report complete.
    if ($null -ne $stdoutTask) {
        while ($true) {
            while (-not $stdoutTask.IsCompleted) { Start-Sleep -Milliseconds 25 }
            $line = $stdoutTask.GetAwaiter().GetResult()
            if ($null -eq $line) { break }
            [IO.File]::AppendAllText($stdoutPath, $line + [Environment]::NewLine)
            $stdoutTask = $process.StandardOutput.ReadLineAsync()
        }
    }
    if ($null -ne $stderrTask) {
        while ($true) {
            while (-not $stderrTask.IsCompleted) { Start-Sleep -Milliseconds 25 }
            $line = $stderrTask.GetAwaiter().GetResult()
            if ($null -eq $line) { break }
            [IO.File]::AppendAllText($stderrPath, $line + [Environment]::NewLine)
            $stderrTask = $process.StandardError.ReadLineAsync()
        }
    }
    if ($null -ne $process) { $process.Dispose() }

    $stdout = if (Test-Path -LiteralPath $stdoutPath) { @(Get-Content -LiteralPath $stdoutPath) } else { @() }
    $stderr = if (Test-Path -LiteralPath $stderrPath) { @(Get-Content -LiteralPath $stderrPath) } else { @() }
    $allLines = @($stdout + $stderr)
    $classification = Get-PackValidationLogClassification -Lines $allLines
    if ($timedOut) {
        $classification.records += [pscustomobject]@{ severity = 'fatal'; category = 'startup-timeout'; lineNumber = $null; message = "Server did not become ready within $StartupTimeoutSeconds seconds." }
        $classification.fatalRecords += $classification.records[-1]
        $classification.fatal = $true
        $classification.fatalCount++
    } elseif (-not $ready) {
        $classification.records += [pscustomobject]@{ severity = 'fatal'; category = 'startup-exit'; lineNumber = $null; message = 'Server exited before reporting readiness.' }
        $classification.fatalRecords += $classification.records[-1]
        $classification.fatal = $true
        $classification.fatalCount++
    }

    $report = [ordered]@{
        schemaVersion = 1
        generatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
        sourceServer = $source
        stagedServer = $runDir
        java = $java
        serverJar = [IO.Path]::GetFileName($jar)
        copy = $copyStats
        startup = [ordered]@{ ready = $ready; elapsedMilliseconds = $startupElapsedMilliseconds; timeoutSeconds = $StartupTimeoutSeconds }
        commands = @($commandResults)
        cleanup = $cleanup
        logs = [ordered]@{ stdout = $stdoutPath; stderr = $stderrPath }
        classification = $classification
        success = $ready -and (-not $classification.fatal) -and ($null -ne $cleanup) -and $cleanup.exitedCleanly
    }
    $jsonPath = Join-Path $runDir 'report.json'
    $summaryPath = Join-Path $runDir 'summary.txt'
    $report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
    $summary = @(
        "Pack validation: $(if ($report.success) { 'PASS' } else { 'FAIL' })"
        "Ready: $ready; startup: $([int]$report.startup.elapsedMilliseconds) ms; Java: $($java.version)"
        "Fatal findings: $($classification.fatalCount); warnings: $($classification.warningCount)"
        "Clean shutdown: $($cleanup.exitedCleanly); forced cleanup: $($cleanup.forced)"
        "JSON report: $jsonPath"
    )
    $summary | Set-Content -LiteralPath $summaryPath -Encoding UTF8
    $summary | Write-Host
    if (-not $KeepRunDirectory) { Write-Host "Disposable run retained at $runDir for log inspection; pass -KeepRunDirectory only to document intent." }
    return [pscustomobject]@{ report = $report; reportPath = $jsonPath; summaryPath = $summaryPath }
}

Export-ModuleMember -Function Get-PackValidationLogClassification, Test-PackValidationJava21, Resolve-PackValidationJava, Get-PackValidationServerJar, Stop-PackValidationProcess, Invoke-PackSmokeTest
