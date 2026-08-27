Set-StrictMode -Version Latest
Import-Module (Join-Path $PSScriptRoot 'PackValidation.psm1') -Force

Describe 'Get-PackValidationLogClassification' {
    It 'classifies entrypoint and missing runtime classes as fatal startup failures' {
        $result = Get-PackValidationLogClassification -Lines @(
            '[main/ERROR]: Failed to start the minecraft server'
            "java.lang.RuntimeException: Could not execute entrypoint stage 'main'"
            'Caused by: java.lang.NoClassDefFoundError: org/example/Missing'
        )
        $result.fatalCount | Should Be 3
        ($result.fatalRecords | Where-Object category -eq 'runtime-startup').Count | Should Be 3
    }

    It 'classifies Fabric mod resolution failures as fatal' {
        $result = Get-PackValidationLogClassification -Lines @(
            '[main/INFO]: Mod resolution failed'
            "[main/ERROR]: Mod 'Iris' requires Sodium 0.6.x but only 0.8.12 is present"
        )
        $result.fatal | Should Be $true
        (($result.fatalRecords | ForEach-Object { $_.category }) -contains 'mod-resolution') | Should Be $true
    }

    It 'classifies datapack and function failures as fatal' {
        $result = Get-PackValidationLogClassification -Lines @(
            "Couldn't parse datapack 'dynamic_life'"
            "Couldn't load function dynamic_life:tick"
        )
        $result.fatalCount | Should Be 2
        (($result.fatalRecords | ForEach-Object { $_.category }) -contains 'datapack-load') | Should Be $true
        (($result.fatalRecords | ForEach-Object { $_.category }) -contains 'function-load') | Should Be $true
    }

    It 'classifies recipe parse failures as fatal' {
        $result = Get-PackValidationLogClassification -Lines @(
            '[main/ERROR]: Parsing error loading recipe supplementaries:copper_lantern_conversion'
        )
        $result.fatalCount | Should Be 1
        $result.fatalRecords[0].category | Should Be 'recipe-load'
    }

    It 'classifies advancement parse failures as fatal' {
        $result = Get-PackValidationLogClassification -Lines @(
            '[Server thread/ERROR]: Parsing error loading custom advancement example:broken'
        )
        $result.fatalCount | Should Be 1
        $result.fatalRecords[0].category | Should Be 'advancement-load'
    }

    It 'does not treat ordinary startup warnings as fatal' {
        $result = Get-PackValidationLogClassification -Lines @(
            '[main/WARN]: Mod uses an outdated metadata format'
            '[main/INFO]: Done (4.2s)! For help, type "help"'
        )
        $result.fatal | Should Be $false
        $result.warningCount | Should Be 1
    }
}

Describe 'Test-PackValidationRequiredPatterns' {
    It 'reports observed and missing behavior markers' {
        $result = Test-PackValidationRequiredPatterns -Lines @(
            '[Server thread/INFO]: OPENAIR_ASSERT_TREE_PASS'
        ) -Patterns @('OPENAIR_ASSERT_TREE_PASS', 'OPENAIR_ASSERT_VILLAGE_PASS')

        $result.passed | Should Be $false
        ($result.records | Where-Object pattern -eq 'OPENAIR_ASSERT_TREE_PASS').matched | Should Be $true
        ($result.records | Where-Object pattern -eq 'OPENAIR_ASSERT_VILLAGE_PASS').matched | Should Be $false
    }
}

Describe 'Stop-PackValidationProcess' {
    It 'stops a cooperative process without forcing it' {
        $startInfo = [Diagnostics.ProcessStartInfo]::new()
        $startInfo.FileName = (Get-Command pwsh).Source
        $startInfo.ArgumentList.Add('-NoLogo')
        $startInfo.ArgumentList.Add('-NoProfile')
        $startInfo.ArgumentList.Add('-Command')
        $startInfo.ArgumentList.Add('[Console]::In.ReadLine() | Out-Null')
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardInput = $true
        $process = [Diagnostics.Process]::new()
        $process.StartInfo = $startInfo
        [void]$process.Start()
        try {
            $result = Stop-PackValidationProcess -Process $process -TimeoutSeconds 3
            $result.stopCommandSent | Should Be $true
            $result.exitedCleanly | Should Be $true
            $result.forced | Should Be $false
        } finally {
            if (-not $process.HasExited) { $process.Kill($true) }
            $process.Dispose()
        }
    }

    It 'forces cleanup after the shutdown timeout' {
        $startInfo = [Diagnostics.ProcessStartInfo]::new()
        $startInfo.FileName = (Get-Command pwsh).Source
        $startInfo.ArgumentList.Add('-NoLogo')
        $startInfo.ArgumentList.Add('-NoProfile')
        $startInfo.ArgumentList.Add('-Command')
        $startInfo.ArgumentList.Add('Start-Sleep -Seconds 30')
        $startInfo.UseShellExecute = $false
        $process = [Diagnostics.Process]::new()
        $process.StartInfo = $startInfo
        [void]$process.Start()
        try {
            $result = Stop-PackValidationProcess -Process $process -TimeoutSeconds 1
            $result.forced | Should Be $true
            $process.HasExited | Should Be $true
        } finally {
            if (-not $process.HasExited) { $process.Kill($true) }
            $process.Dispose()
        }
    }
}
