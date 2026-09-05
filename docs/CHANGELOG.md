# Changelog

## 1.0.35 — 2026-09-04

- Removed Custom Time Cycle (server-side). Its 0.1.6 jar bundles fabric-permissions-api 0.3.3, built for Minecraft 1.21.2+; Fabric Loader picks that copy over the 1.21.1-compatible one, so any permission check (Waystones via Balm on placing or editing a waystone; Polymer before it was removed) crashed the server with `NoSuchMethodError ServerPlayer.method_64396`. Day and night return to vanilla length. Deleted `server-config/customtimecycle.json`.

## 1.0.32 — 2026-09-03

- Fixed the client install. Lithostitched was `side = "server"` while Terralith 2.6.2 and Tectonic 3.0.26, which both hard-depend on it, were `side = "both"`. Every packwiz client install therefore failed at Fabric mod resolution. This is the same fault as 1.0.2x's Terralith/SmartBrainLib fix, one level further down the dependency chain.
- Removed the duplicate Nullscape entry. The pack listed Modrinth project `LPjGiSO4` twice at version 1.2.14: once as a server-side mod jar and once as a both-side datapack zip. The mod jar is kept; the datapack copy was installed to `<root>/datapacks`, which is not a world datapack path on either side.
- Raised the shader stack to Iris 1.8.14-beta.1 with Sodium 0.8.12. Iris 1.8.14-beta.1 is the only 1.21.1 build above 1.8.8 and it hard-requires that exact Sodium build, so the two move together. Both are client-only and change nothing about server compatibility. This also removes the constraint that held Supplementaries at 3.6.7.
- Raised Shoulder Surfing Reloaded to 5.0.11 and [MC2] Interactive Foliage to 1.3.0. Both are client-only. Shoulder Surfing 5.0.11 requires Fabric API and Forge Config API Port, both already present, and declares Nimble and Better Third Person incompatible, neither of which is in the pack. Interactive Foliage 1.3.0 requires SWAY API, present at 2.4.3.
- Not yet raised, pending a server window: Supplementaries 3.9.3, Cupboard 1.21.1-4.0, Gravestones 1.4.2, and Easy Mob Spawn Control 1.5.8. All four are both-side, so client and server must move in the same maintenance pass. They are staged on the `server-window/both-side-raises` branch.

## 1.0.21-rc3 — 2026-08-28

- Added the Stay True resource pack (1.21 release, pack format 34, exactly matching Minecraft 1.21.1) as a client-only file in `resourcepacks/`. It ships with the pack but stays personal: each player enables it in Options > Resource Packs, so it never changes server compatibility or forces the same look on anyone.

## 1.0.21-rc2 — 2026-08-28

- Added LambDynamicLights 4.8.10 as a client-only mod: held torches, glowing entities, and dropped light-emitting items now cast light. Verified compatible with the pinned Iris 1.8.8 + Sodium 0.6.13 pair; its conflicting alternatives (RyoamicLights, Sodium Dynamic Lights) are not in the pack.

## 1.0.20

- Added Worn Path as a server-side, deliberately restrained travel trace. Repeated player movement can turn open grass or dirt into a dirt path, but it cannot spread beyond the walked block or progress into packed mud, mud bricks, gravel, stone, or stone bricks. A solid roof, nearby grazing sheep, or wool placed below the surface protects a block. The checked-in server setting is `server-config/worn_path.json5`.

## 1.0.19 — 2026-08-27

- Added [Let's Do] BloomingNature for richer vanilla biomes, smaller transition biomes, ground detail, flowers, boulders, and additional trees. It is deliberately a world-generation addition: existing terrain is unchanged; its features appear as new land is explored.
- Added Biolith, BloomingNature's required biome-placement library. BloomingNature 1.1.10 did not declare that dependency in its Fabric metadata, so the pack records it explicitly and the full dedicated-server stack was boot-tested with both mods before release.

## 1.0.18 — 2026-08-27

- Replaced the provisional custom ore-worldgen overrides with Cave Spelunking and its required Cupboard library. Its checked default is deliberately conservative: normal total ore rate and vein density, with 1% of ore allowed away from air, water, or lava. New caves—not strip mines—are therefore the reliable source of ore. Existing generated chunks retain their old terrain and ores. The exact server config is checked in at `server-config/caveore.json`.
- Added Sensible Trade Overhaul and its required VillagerConfig library. This is a full, deliberate rewrite of vanilla villager offers: diamond-tier gear is no longer the default shortcut, while limited renewable sand, iron, diamond, and sponge routes become available through profession trades. Existing locked villager offers are preserved; unlocked offers may need a refresh to adopt the new table.
- Retained Data Trades, but confirmed that there is no active Data Trades trade pack in this world, so it does not compete with Sensible Trade Overhaul.

## 1.0.17 — 2026-08-26

- Added Universal Graves with Polymer on client and server. Death now leaves a protected, physical grave at the death site, preserves items and experience, and gives the player a death compass. There is no survival teleport-to-grave shortcut.
- A grave is owner-protected for 30 minutes. If untouched after six hours of active server time, it breaks and drops its contents normally rather than leaving permanent world clutter.
- Added a cave-only natural creeper rule through Easy Mob Spawn Control.
- Added a small resource data pack: cave-exposed ore veins are no longer suppressed by vanilla's air-exposure discard chance, while total vein counts remain vanilla. Emeralds are approximately twice as common. These world-generation changes affect newly generated chunks only.

## 1.0.16 — 2026-08-26

- Removed CC:Tweaked and Oritech. The same release added the RPG Series and Spell Engine stack; the automation spine was retired deliberately in favour of character progression as the pack's late game. Tom's Simple Storage stays as the logistics layer.

*Entry reconstructed 2026-09-05 from commit `9adfdf1`, which shipped without one. The two deletions sat inside a ~100-file release diff, so nothing surfaced them, and `docs/FIELD-GUIDE.md`, `docs/DESIGN-CONTEXT.md`, and `CLAUDE.md` went on describing both mods for ten days and three releases.*

## 1.0.15 — 2026-08-25

- Added Celestria on both sides for synchronized shooting stars. Its full-moon insomnia effect is explicitly disabled in the checked-in server configuration: this is ambience and a small moment of luck, not a sleep tax.
- Corrected the local dedicated server installation by adding Waystones and Balm, which were already present in the client pack.
- Added client-only visual and third-person tools: Interactive Foliage with SWAY, Euphoria Patches with pinned Complementary Reimagined r5.8.1, Shoulder Surfing Reloaded, Seramicx Smooth F5, EMF/ETF, Fresh Animations: Player Extension, and Camera Overhaul.
- Kept all visual settings personal and optional. They never change server compatibility or force the same look on Benji.

## 1.0.14 — 2026-08-25

- Added AmbientSounds 6 client-side for biome and weather ambience, with its required client library CreativeCore.
- Added Better Clouds client-side for configurable, blocky volumetric clouds that work with Iris/Sodium; YACL is included as its configuration library.
- Added Particle Rain client-side for denser rain, snow, and weather particle effects. It is intentionally visual-only and does not add weather simulation or server load.
- Kept all three visual features off the dedicated server. A player may tune or disable them locally without affecting the shared world.

## 1.0.13 — 2026-08-25

- Added CropXp server-side at a conservative shared rate: a mature crop has a 25% chance to grant one XP. Farming now contributes to experience without becoming an automatic XP factory.
- Added Craftable Gunpowder on both client and server, providing an existing-material route to rockets and TNT so creeper farms are optional.
- Retained the player-killed zombie leather drop: it is an occasional reward for ordinary overworld defence, not a required production route.

## Design rule — 2026-08-25

- Adopted the **invisibility test**: the pack must feel like Minecraft, not a game that requires a guide before players can understand its ordinary systems. A mod that cannot teach its basic loop through visible in-game cause and consequence should be simplified, reconfigured, or removed.

## 1.0.12 — 2026-08-25

- Added Custom Time Cycle server-side. The server now uses 24,000 daylight ticks (20 minutes) and 14,400 night ticks (12 minutes), without changing tick speed or requiring a client mod.
- Checked in the intended server config at `server-config/customtimecycle.json`, so a replacement server can reproduce the rhythm exactly.

## 1.0.11 — 2026-08-25

- Added Easy Mob Spawn Control: an operator can inspect current mob counts and change spawns, caps, bans, and spawn rules in-game with `K` or `/easymsc`. The host server begins with natural creeper spawning at 50% of vanilla; it is a reversible first test, not a cave-only rewrite.
- Added Hungrier, so NutritionZ deficiencies can be addressed by eating deliberately even while the hunger bar is full.
- Added Mouse Tweaks and Shulker Box Tooltip as client-side inventory quality-of-life tools.
- Added Data Trades as the server-side, datapack-driven route for future, carefully reviewed villager trade changes. It makes no trade changes by itself.
- Added two small ecological resource routes: player-killed zombies have a modest chance to yield normal leather, and smelting gravel yields sand. No terrain is altered and no new items are added.
- Did not add a death/heart mod: Farming Experience Core is mature but bundles too many unrelated survival changes, while the focused 1.21.1 alternatives are too new for the pack's stability bar.

## 1.0.10 — 2026-08-25

- Added Waystones with Balm for shared travel routes.
- Added Effortless Building for survival-friendly shapes, mirrors, arrays, and undo.
- Added Crafting Tweaks for grid transfer, rotate, balance, clear, compress, and full-stack crafting.

## 1.0.9 — 2026-08-25

- Added Waystones with Balm; removed the experimental Zombies Break & Build mod before release.

## 1.0.8 — 2026-08-24

- Tuned the host for smoother far-terrain loading: server view distance 16, balanced Distant Horizons detail, and client ZGC guidance.
- Added a reusable `/function open_air:warehouse` datapack command. Run it while standing two blocks above the intended floor to place the migrated stockpile at that location.

## 1.0.7 — 2026-08-24

- Added The Aether 1.5.11 for a multiplayer-safe sky dimension with its own ores, creatures, mounts, and three dungeon tiers.
- Added Nullscape 1.2.14 as the End terrain overhaul.
- Added packwiz metadata as the maintainable source of truth for future synchronized releases.
- Kept space-progression experiments out of the permanent world until a stable 1.21.1 option exists.

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
- 2026-08-24: Installed the matching Distant Horizons 3.2.0-b build on the dedicated server and pre-generated a conservative 32-chunk radius around spawn using surface-only LOD generation. This keeps the useful distant silhouette without forcing the server to create a large square of real gameplay chunks.
