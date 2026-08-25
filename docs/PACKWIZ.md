# Updating the shared pack

The `packwiz/` folder is the source of truth for the Open-Air Settlement client pack. It pins the Minecraft/Fabric versions and exact mod files, including Nullscape as a server-side data pack.

## For Benji

The easiest repeatable route is [`tools/setup-prism-packwiz.sh`](../tools/setup-prism-packwiz.sh) on macOS/Linux or [`tools/setup-prism-packwiz.ps1`](../tools/setup-prism-packwiz.ps1) on Windows. These scripts create a normal Prism instance, install the official bootstrap, and write the pre-launch command. They stop if an instance with the same name already exists so they cannot silently replace somebody's world or settings.

After running the script, sign into Microsoft in Prism once and launch the instance. Prism will separately download Minecraft's client jar, libraries, assets, Fabric libraries, and any uncached mod files on that first launch. That is expected: Prism's global cache is separate from the instance folder. It is not a pack-version change.

The exported `.mrpack` from the repository's Releases page remains a good fixed snapshot for Prism, Modrinth App, or CurseForge. Use the script when we want automatic GitHub-backed updates.

For faster updates, use a packwiz-compatible installer with the raw `packwiz/pack.toml` URL from this repository. The installer will pull the exact files and can update the instance when we publish a new commit.

Do not copy the `packwiz/` metadata into a normal Minecraft instance by hand. It is a recipe for the instance, not the instance itself. Do not launch a second Prism data folder with a custom `--dir` for ordinary setup; that creates a second empty-looking Prism window and separate account/cache state.

## For maintainers

Install packwiz from the [official instructions](https://packwiz.infra.link/installation/), then run these from the `packwiz/` folder:

```text
packwiz update
packwiz refresh
packwiz modrinth export
packwiz curseforge export
```

Add a mod by its exact project and version when possible:

```text
packwiz modrinth add --project-id <project> --version-id <version>
```

If a dependency is only distributed through CurseForge, pin its project and file IDs with `packwiz curseforge add`. Keep client-only visual/performance mods marked client-side and test any world-generation or dimension change in a disposable world first.

## Current release notes

The 1.0.11 pack remains Fabric 1.21.1. It adds Easy Mob Spawn Control, Hungrier, Mouse Tweaks, Shulker Box Tooltip, and the small renewable-resource datapack to the existing settlement systems. Data Trades is installed server-side for future reviewed trade work but changes no trade by itself. It keeps the exact Sodium 0.6.13 / Iris 1.8.8 pairing used by the current 1.21.1 pack. Ad Astra and Nerospace remain future experiments: Ad Astra's 1.21.1 work is still a development branch, while the newer Nerospace line targets later Minecraft versions.
