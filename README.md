# Open-Air Settlement

A deliberately small Fabric 1.21.1 survival pack for two players: a large world to travel through, food worth caring about, nights that make a defended home satisfying, better building, and a late game of storage, turtles, and machines.

**Current shared release: 1.0.4.** Both players must use this version. It removes the faulty Realistic Wildlife mod that caused severe server tick stalls.

## Join in five minutes

1. Install **Java 21** and the CurseForge app, Modrinth App, Prism Launcher, or ATLauncher.
2. Choose one installer:
   - **CurseForge:** download [`downloads/Open-Air-Settlement-1.0.4-CurseForge.zip`](downloads/Open-Air-Settlement-1.0.4-CurseForge.zip), then Minecraft → Create Custom Profile → Import. Select the zip.
   - **Modrinth App / Prism / ATLauncher:** download [`downloads/Open-Air-Settlement-1.0.4.mrpack`](downloads/Open-Air-Settlement-1.0.4.mrpack), then import it.
3. Launch **Open-Air Settlement** once; it should say Minecraft 1.21.1 and Fabric Loader 0.19.3.
4. Get the host's current LAN address and join `address:25565` from Multiplayer → Direct Connection.

CurseForge may flag manual custom-profile files. This is expected for a private shared profile; accept only this exact file from this repository. Its own guide confirms that exported profile zip files are the supported import format.

## Optional visual setup

The pack includes the compatible Iris + Sodium pair, but **not** a shader by default. Follow [the shader instructions](docs/SHADERS.md) after the game starts normally. Shaders are personal visual settings: they do not go on the server and are not required to join.

## What is here

- `downloads/` — the two actual client installers.
- `docs/FIELD-GUIDE.md` — a quick play guide and mod index.
- `docs/SHADERS.md` — the safe optional shader setup.
- `field-guide/` — source for the dark field-guide site.
- `CLAUDE.md` — a concise operating note for Claude or another AI helper.

This repository intentionally excludes the server's world, player data, LAN address, logs, and personal settings. The host keeps those locally; players only need the client pack.

## Multiplayer rules that prevent pain

- Do **not** update a single gameplay mod in isolation. Update the shared pack as a release, then both players update together.
- Client-only conveniences and shader settings can differ. Gameplay/world mods must match the server.
- The verified rendering combination is **Iris 1.8.8 + Sodium 0.6.13 + Supplementaries 3.6.7**. Do not let a launcher update only one of these.
- Do not re-add `wildlife-dynamics-1.0.0.jar` / “Realistic Wildlife.” It is disabled because it repeatedly scanned the entire world and caused the severe tick lag.

For the actual play loop—travel, food, danger, building, and automation—start with the [field guide](docs/FIELD-GUIDE.md).
