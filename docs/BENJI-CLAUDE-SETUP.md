# Claude setup handoff

This is the short, deterministic procedure for Claude on Benji's machine. It exists so a future agent does not have to rediscover how packwiz, Prism, and the GitHub source fit together.

## What Claude should do

1. Confirm that Prism Launcher is installed. If it is missing, install Prism with the platform's normal package method:
   - macOS: `brew install --cask prismlauncher`
   - Windows: `winget install --exact PrismLauncher.PrismLauncher`
2. Clone or download this repository.
3. Run exactly one platform setup script:
   - macOS/Linux: `bash tools/setup-prism-packwiz.sh`
   - Windows PowerShell: `powershell -ExecutionPolicy Bypass -File .\tools\setup-prism-packwiz.ps1`
4. Open Prism and let the human complete Microsoft sign-in if Prism asks for it.
5. Launch the **Open-Air Settlement** instance once.

The setup script is idempotence-by-refusal: if the instance already exists, it stops and reports the path. Claude should inspect the existing instance before changing anything. It must not create a second Prism data root with `--dir`, copy `packwiz/` into `.minecraft`, or install a generic Fabric profile beside the managed instance.

## What the script creates

The script creates the standard Prism instance structure:

```text
PrismLauncher/
└── instances/
    └── Open-Air-Settlement/
        ├── instance.cfg
        ├── mmc-pack.json
        └── minecraft/
            └── packwiz-installer-bootstrap.jar
```

The pre-launch command is:

```text
"$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml
```

That command is the ongoing update path. The `.mrpack` is a fixed snapshot; the GitHub `pack.toml` is the source that updates the instance before launch.

## What requires the human

Microsoft authentication should remain a human step. Claude can open Prism and verify the instance, but it should not handle passwords, one-time codes, or account prompts.

The first launch can download a substantial amount of data from Mojang, Fabric, Modrinth, and other mod hosts. This is expected because Prism's global cache is separate from the instance. Subsequent launches should validate the existing files and fetch only pack changes.

## Troubleshooting checklist

- **Two Prism windows, one empty:** close both; relaunch Prism normally. Check that the instance exists under Prism's standard data folder. A custom `--dir` launch creates a separate profile.
- **Iris/Sodium warning:** do not update Sodium independently. This pack intentionally pins Sodium 0.6.13 with Iris 1.8.8.
- **No instance after the script:** the script may have stopped because an instance already exists. Inspect it rather than overwriting it.
- **Server connection fails:** verify the host server is running the same Minecraft 1.21.1/Fabric 0.19.3 pack and use the host's LAN address.
