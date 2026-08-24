# Open-Air Settlement

A deliberately small Fabric 1.21.1 survival pack for two players: a large world to travel through, food worth caring about, nights that make a defended home satisfying, better building, and a late game of storage, turtles, and machines.

**Current shared release: 1.0.6.** Both players must use this version. It adds Critters and Companions, Hostile Harmony, and client-side Distant Horizons while keeping Realistic Wildlife out because it caused severe server tick stalls.

## Join in five minutes

1. Install **Java 21** and the CurseForge app, Modrinth App, Prism Launcher, or ATLauncher.
2. Modrinth/Prism/ATLauncher users: download [`downloads/Open-Air-Settlement-1.0.6.mrpack`](downloads/Open-Air-Settlement-1.0.6.mrpack). CurseForge users: use the profile checklist in [Benji's quick start](docs/BENJI-QUICKSTART.md), or build the same import ZIP with [`tools/build-curseforge-profile.ps1`](tools/build-curseforge-profile.ps1). The prior 1.0.5 installers remain available for rollback.
3. Launch **Open-Air Settlement** once; it should say Minecraft 1.21.1 and Fabric Loader 0.19.3.
4. Get the host's current server address and join it from Multiplayer → Direct Connection.

The current GitHub release provides the small `.mrpack`, which fetches the pinned mod jars through the launcher. The repository also contains the reproducible CurseForge builder; it creates a standard manifest and carries only the two direct jars that CurseForge cannot provide.

## Benji's fastest setup

Use [the Benji quick-start checklist](docs/BENJI-QUICKSTART.md). It covers the CurseForge profile, exact Fabric/Iris/Sodium versions, Distant Horizons verification, ZGC, and the common “it installed but I cannot see it” cases.

## Optional visual setup

The pack includes Distant Horizons, Iris 1.8.8, and Sodium 0.6.13. Follow [the shader instructions](docs/SHADERS.md) after the game starts normally. Distant Horizons is client-side and does not need to be installed on the server. Shaders are personal visual settings: they do not go on the server and are not required to join.

## What is here

- `downloads/` — the current `.mrpack`, plus the 1.0.5 installers and prior archives.
- `docs/FIELD-GUIDE.md` — a quick play guide and mod index.
- `docs/BENJI-QUICKSTART.md` — the short client setup and troubleshooting checklist.
- `docs/SHADERS.md` — the safe optional shader setup, including Distant Horizons settings.
- `docs/DESIGN-CONTEXT.md` — the design goals and contribution rules.
- `field-guide/` — source for the dark field-guide site.
- `CLAUDE.md` — a concise operating note for Claude or another AI helper.
- `docs/SHARING.md` — the release/update workflow and world-migration notes.

This repository intentionally excludes the server's world, player data, LAN address, logs, and personal settings. The host keeps those locally; players only need the client pack.

## Multiplayer rules that prevent pain

- **Both players use 1.0.6.** Update the shared pack as a release, then both players update together.
- Gameplay mods must match the server. Distant Horizons, maps, and shader settings are client-only and may differ.
- The verified rendering combination is **Distant Horizons 3.2.0-b + Iris 1.8.8 + Sodium 0.6.13 + Complementary Reimagined r5.8.1**. Begin with vanilla render distance 8–12 and DH distance 128–192; let the cache build before raising it.
- Keep Supplementaries 3.6.7 with Sodium 0.6.13.
- Do not re-add `wildlife-dynamics-1.0.0.jar` / “Realistic Wildlife.” It is disabled because it repeatedly scanned the entire world and caused the severe tick lag.

## Current world

The server's new scenic world uses seed `-1549229570210257776` with Terralith and Tectonic. The seed came from a promising 1.20-era combination, so exact terrain should be treated as a 1.21.1 test rather than a guarantee. The old singleplayer save remains untouched. The meaningful player inventory has been copied to the host's account in the new world, and the old base stockpile is being placed in a small warehouse near spawn.

For the actual play loop—travel, food, danger, building, and automation—start with the [field guide](docs/FIELD-GUIDE.md).
