# Open-Air Settlement

A deliberately small Fabric 1.21.1 survival pack for two players: a large world to travel through, food worth caring about, nights that make a defended home satisfying, better building, and a late game of storage, turtles, and machines.

**Current shared release: 1.0.15.** It adds synchronized shooting stars (without the full-moon sleep penalty), fixes the server's missing Waystones support, and brings a deliberately optional client visual suite: foliage response, animation support, third-person camera control, and the Euphoria shader enhancement layer. Realistic Wildlife remains out because it caused severe server tick stalls.

## Join in five minutes

1. Install **Java 21** and the CurseForge app, Modrinth App, Prism Launcher, or ATLauncher.
2. Packwiz users: use the [Benji quick-start checklist](docs/BENJI-QUICKSTART.md) or the deterministic setup script. The existing 1.0.7 `.mrpack` remains available as a fixed rollback snapshot.
3. Launch **Open-Air Settlement** once; it should say Minecraft 1.21.1 and Fabric Loader 0.19.3.
4. Get the host's current server address and join it from Multiplayer → Direct Connection.

The current GitHub release provides the small `.mrpack`, which fetches the pinned mod jars through the launcher. The repository also contains the reproducible CurseForge builder; it creates a standard manifest and carries only the two direct jars that CurseForge cannot provide.

## Benji's fastest setup

Use [the Benji quick-start checklist](docs/BENJI-QUICKSTART.md), or give Claude [the deterministic terminal handoff](docs/BENJI-CLAUDE-SETUP.md). It covers the normal Prism data folder, the packwiz pre-launch sync, exact Fabric/Iris/Sodium versions, Distant Horizons verification, ZGC, and the common “it installed but I cannot see it” cases.

## Optional visual setup

The pack includes Distant Horizons, Iris 1.8.14-beta.1, Sodium 0.8.12, AmbientSounds 6, Better Clouds, Particle Rain, and Complementary Reimagined with Euphoria Patches. Follow [the shader instructions](docs/SHADERS.md) after the game starts normally. The dedicated server also carries the matching Distant Horizons build so it can pre-generate and stream far-terrain data; personal visual settings, Iris, Sodium, and shaders remain client-only and are not required to join.

## What is here

- `downloads/` — the current `.mrpack`, plus prior installers and archives.
- `docs/FIELD-GUIDE.md` — a quick play guide and mod index.
- `docs/BENJI-QUICKSTART.md` — the short client setup and troubleshooting checklist.
- `docs/SHADERS.md` — the safe optional shader setup, including Distant Horizons settings.
- `docs/DESIGN-CONTEXT.md` — the design goals and contribution rules.
- `field-guide/` — source for the dark field-guide site.
- `CLAUDE.md` — a concise operating note for Claude or another AI helper.
- `docs/SHARING.md` — the release/update workflow and world-migration notes.

This repository intentionally excludes the server's world, player data, LAN address, logs, and personal settings. The host keeps those locally; players only need the client pack.

## Multiplayer rules that prevent pain

- **Both players use 1.0.15.** Update the shared pack as a release, then both players update together.
- Gameplay mods must match the server. Distant Horizons should match the server build for streamed far terrain; maps and shader settings are client-only and may differ.
- The rendering combination is **Distant Horizons 3.2.0-b + Iris 1.8.14-beta.1 + Sodium 0.8.12 + Complementary Reimagined r5.8.1**. Begin with vanilla render distance 8–12 and DH distance 128–192; let the cache build before raising it.
- Keep Supplementaries 3.6.7 until the server is raised with it. It is a both-side mod, so client and server move together.
- Do not re-add `wildlife-dynamics-1.0.0.jar` / “Realistic Wildlife.” It is disabled because it repeatedly scanned the entire world and caused the severe tick lag.

## Current world

The server's new scenic world uses seed `-1549229570210257776` with Terralith and Tectonic. The seed came from a promising 1.20-era combination, so exact terrain should be treated as a 1.21.1 test rather than a guarantee. The old singleplayer save remains untouched. The meaningful player inventory has been copied to the host's account in the new world, and the old base stockpile is being placed in a small warehouse near spawn.

For the actual play loop—travel, food, danger, building, and automation—start with the [field guide](docs/FIELD-GUIDE.md).
