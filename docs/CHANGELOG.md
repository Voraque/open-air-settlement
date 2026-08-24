# Changelog

## 1.0.5 — 2026-08-24

- Added Critters and Companions 2.7.0 for creature variety, companions, mounts, taming, and breeding.
- Added Hostile Harmony 1.0.4 for more responsive hostile-mob encounters.
- Built CurseForge and Modrinth release files from the active, tested client installation.
- Generated the new Terralith + Tectonic scenic world with seed `-1549229570210257776`.
- Copied the meaningful singleplayer player inventory into the new server world and prepared a one-time stockpile migration for the old base containers.
- Documented the GitHub Releases workflow and the future packwiz migration path.

## 1.0.6 — 2026-08-24

- Added Critters and Companions 2.7.0 for creature variety, companions, mounts, taming, and breeding.
- Added Hostile Harmony 1.0.4 for more responsive hostile-mob encounters.
- Added Distant Horizons 3.2.0-b for Fabric 1.21.1 as a client-only multiplayer-safe far-terrain renderer.
- Kept Iris 1.8.8 + Sodium 0.6.13 + Supplementaries 3.6.7; this avoids the known Sodium 0.8/Iris conflict.
- Documented Complementary Reimagined r5.8.1 as the shader pairing, plus conservative render-distance settings.
- Published the small `.mrpack` handoff for Benji. The full CurseForge zip is not included because the new export exceeds GitHub's file-size limit.

## 1.0.4 — 2026-08-23

- Disabled Realistic Wildlife (`wildlife-dynamics-1.0.0.jar`) on client and server after profiling proved it was repeatedly scanning the whole world and causing severe tick stalls.
- Kept Naturalist as the lightweight wildlife layer.
- Kept the verified Iris 1.8.8, Sodium 0.6.13, and Supplementaries 3.6.7 combination.
- Added official Complementary Reimagined installation instructions; shader remains optional and client-only.
