# Headless Fabric pack validation

This harness is a bounded smoke test for a disposable Fabric server. It is intentionally separate from the pack and server configuration so it can be reviewed or removed without changing gameplay files.

Safety contract:

- `-ServerDir` is a read-only source. The harness copies it into `tools/pack-validation/runs/<run-id>` and launches only the copy.
- Existing worlds, logs, caches, backups, `.env` files, credential/secret/password files, keys, and certificates are not copied.
- The staged server always gets a fresh `pack-validation-world`, a random server port, offline mode, and RCON/query disabled.
- The process receives `list` (or supplied commands) through standard input and then `stop`. If it does not exit within the shutdown bound, the complete process tree is killed.
- Before force-stopping a hung Java process, the harness asks the matching JDK for a thread snapshot and saves it as `logs/shutdown-thread-dump.txt`. This identifies the thread that prevented a clean exit without weakening the shutdown gate.
- No credential variables are read, expanded, or included in the report.

## Run against a disposable lab

From the repository root in PowerShell:

```powershell
$commands = [string[]]@('list', 'datapack list')
$required = [string[]]@('OPENAIR_ASSERT_EXAMPLE_PASS')
& .\tools\pack-validation\Invoke-PackSmokeTest.ps1 `
  -ServerDir 'C:\path\to\open-air-settlement-weathering-alive-lab\lab-server' `
  -ServerJar 'fabric-server-launch.jar' `
  -Commands $commands `
  -RequiredLogPatterns $required
```

The command returns exit code 0 only when the server reports Fabric readiness, every optional required log pattern was observed, no fatal mod-resolution/datapack/function/recipe/advancement finding is present, and shutdown completed without a forced kill. Required patterns let a command-driven test prove that a behavior happened instead of merely proving that its mod loaded. It writes `report.json`, `summary.txt`, `logs\stdout.log`, and `logs\stderr.log` beneath the generated run directory.

Use a shorter bound while iterating:

```powershell
pwsh -NoProfile -File .\tools\pack-validation\Invoke-PackSmokeTest.ps1 `
  -ServerDir 'C:\path\to\lab-server' -StartupTimeoutSeconds 45 -ShutdownTimeoutSeconds 5
```

Do not point this at a live world/server directory. The copy boundary prevents writes to the source, but a disposable lab is still the correct test input.

## Tests

If Pester is installed:

```powershell
Invoke-Pester -Path .\tools\pack-validation\PackValidation.Tests.ps1 -Output Detailed
```

The test file covers the fatal-log classifier, required behavior markers, and both cooperative and forced process cleanup. No Minecraft server, world, network connection, credentials, or pack files are needed for these unit tests.

If Pester is not installed, the harness itself can still be run; install Pester only in a development PowerShell profile if desired:

```powershell
Install-Module Pester -Scope CurrentUser
```

## Report interpretation

`classification.fatalRecords` is deliberately conservative and focused on failures that make the pack unsafe to promote: runtime startup, Fabric dependency resolution, datapack parsing/loading, function loading/execution, recipe parsing, and advancement parsing. Ordinary mod warnings remain visible under `warningRecords` but do not fail the run. A successful smoke test is necessary, not sufficient: it does not prove every unasserted gameplay behavior or that a long-running server has acceptable tick time.
