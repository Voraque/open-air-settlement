# Open-Air Settlement

A deliberately small Fabric 1.21.1 survival pack for two players: a large world to travel through, food worth caring about, nights that make a defended home satisfying, better building, and a late game of storage, turtles, and machines.

**Current shared release: 1.0.6.** Both players must use this version. It adds client-side Distant Horizons for long views while keeping the multiplayer gameplay set unchanged. It removes the faulty Realistic Wildlife mod that caused severe server tick stalls.

## Join in five minutes

1. Install **Java 21** and the CurseForge app, Modrinth App, Prism Launcher, or ATLauncher.
2. CurseForge users: download [`downloads/Open-Air-Settlement-1.0.6-CurseForge.zip`](downloads/Open-Air-Settlement-1.0.6-CurseForge.zip) and import it as a custom profile. Modrinth/Prism/ATLauncher users: download [`downloads/Open-Air-Settlement-1.0.6.mrpack`](downloads/Open-Air-Settlement-1.0.6.mrpack).
3. Launch **Open-Air Settlement** once; it should say Minecraft 1.21.1 and Fabric Loader 0.19.3.
4. Get the host's current server address and join it from Multiplayer → Direct Connection.

The current GitHub release provides both a proper CurseForge import ZIP and a small `.mrpack`. The CurseForge ZIP uses a standard manifest for launcher-managed files and carries only the two direct jars, so it stays small enough to download here.

## Benji's fastest setup

Use [the Benji quick-start checklist](docs/BENJI-QUICKSTART.md). It covers the CurseForge profile, exact Fabric/Iris/Sodium versions, Distant Horizons verification, ZGC, and the common “it installed but I cannot see it” cases.

## Optional visual setup

The pack includes Distant Horizons, Iris 1.8.8, and Sodium 0.6.13. Follow [the shader instructions](docs/SHADERS.md) after the game starts normally. Distant Horizons is client-side and does not need to be installed on the server. Shaders are personal visual settings: they do not go on the server and are not required to join.

## What is here

- `downloads/` — the current CurseForge ZIP and `.mrpack`, plus the prior 1.0.4 archives.
- `docs/FIELD-GUIDE.md` — a quick play guide and mod index.
- `docs/BENJI-QUICKSTART.md` — the short client setup and troubleshooting checklist.
- `docs/SHADERS.md` — the safe optional shader setup, including Distant Horizons settings.
- `docs/DESIGN-CONTEXT.md` — the design goals and contribution rules.
- `field-guide/` — source for the dark field-guide site.
- `CLAUDE.md` — a concise operating note for Claude or another AI helper.

This repository intentionally excludes the server's world, player data, LAN address, logs, and personal settings. The host keeps those locally; players only need the client pack.

## Multiplayer rules that prevent pain

- **Both players use 1.0.6.** Update the shared pack as a release, then both players update together.
- Gameplay mods must match the server. Distant Horizons, maps, and shader settings are client-only and may differ.
- The verified rendering combination is **Distant Horizons 3.2.0-b + Iris 1.8.8 + Sodium 0.6.13 + Complementary Reimagined r5.8.1**. Begin with vanilla render distance 8–12 and DH distance 128–192; let the cache build before raising it.
- Keep Supplementaries 3.6.7 with Sodium 0.6.13.
- Do not re-add `wildlife-dynamics-1.0.0.jar` / “Realistic Wildlife.” It is disabled because it repeatedly scanned the entire world and caused the severe tick lag.

For the actual play loop—travel, food, danger, building, and automation—start with the [field guide](docs/FIELD-GUIDE.md).
