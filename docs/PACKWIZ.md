# Updating the shared pack

The `packwiz/` folder is the source of truth for the Open-Air Settlement client pack. It pins the Minecraft/Fabric versions and exact mod files, including Nullscape as a server-side data pack.

## For Benji

The easy route is to install the exported `.mrpack` from the repository's Releases page in Prism Launcher, Modrinth App, or CurseForge. That gives a fixed snapshot.

For faster updates, use a packwiz-compatible installer with the raw `packwiz/pack.toml` URL from this repository. The installer will pull the exact files and can update the instance when we publish a new commit.

Do not copy the `packwiz/` metadata into a normal Minecraft instance by hand. It is a recipe for the instance, not the instance itself.

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

The 1.0.7 pack remains Fabric 1.21.1. It adds The Aether as the first major exploration destination and Nullscape, which changes End terrain only. It keeps the exact Sodium 0.6.13 / Iris 1.8.8 pairing used by the current 1.21.1 pack. Ad Astra and Nerospace remain future experiments: Ad Astra's 1.21.1 work is still a development branch, while the newer Nerospace line targets later Minecraft versions.
