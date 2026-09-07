# Living landscapes implementation and migration review â€” September 7, 2026

## Current status

Pack 1.0.39 and Open Air Trees 0.5.0 were published in commit 48c135a and activated on FadeHost on September 7, 2026. The preserved world and all nine new mods are installed. The server started normally. Matching local client files are prepared; players must relaunch Minecraft to load the update.

The user explicitly approved uploading after backup verification. Every one of the 214 staged files passed remote SHA-256 readback before promotion. The original world and modified configurations remain on the same server for rollback. DH generation is running at radius 128 chunks; expansion to 256 remains pending. Automatic hibernation is verified disabled.

## User direction and scope

The latest user instructions approve the recommended structure set, subject to a Cave Biomes test, and prioritize Dynamic Trees. They authorize regeneration outside the protected area, preservation of waystones, and DH pregeneration around the base. Registered destinations take priority. This supersedes the earlier no-restart boundary for the necessary migration work, and the user subsequently explicitly approved uploading the backed-up payload to the existing server.

The approved set is Better Desert Temples 4.1.5, Bridges 5.1.1, Extras 5.1.1, Better Nether Fortresses 3.1.5, Better Strongholds 5.1.3, Better Ocean Monuments 4.1.2 and Cave Biomes 3.1.1, all exact Fabric 1.21.1 releases. Better Dungeons remains installed. DT, the compatibility addon and Cave Biomes require matching clients; the six structure additions are server-side.

## What is ready

Open Air Trees ports ten Blooming Nature wood/leaf identities into Dynamic Trees, with fourteen targeted biome population rules. It also repairs the missing Fabric seed self-planting hook. Normal sapling placement, seed self-planting, forest-only spread, growth and survival wood harvesting passed command-driven dedicated-server tests. The final fixture included the full approved mod set and DH. The implementation deliberately retains existing vegetation where equivalent support has not been added.

Tree growth remains slow. Disease, climbing, canopy crashing and falling-tree damage are disabled; falling animation remains. Voluntary seed drops are 0.002, planting probability is 0.04 before species suitability, and self-planting is restricted to forest-like biomes. Leaf crash particles are capped at 64. These are restrained settings, not a measured long-term equilibrium.

Cave Biomes generated both Frosted and Lost Caves alongside the tree addon and all approved structures, with the expected saved blocks and no fatal startup findings. Sandstorms and their extra particles are disabled to avoid conspicuous effects and the documented fog interaction. The prepared DH client configuration enables vanilla fog. Actual client shaders and cave visuals still need observation during play.

## Backup and preservation

A full consistent local backup contains 594 files. Every archived file was read back and checked against its SHA-256. The private archive stays outside this public repository. The sanitized receipt is published in docs/backups; the archive remains private.

The prepared migration retains 6,773 existing Overworld chunk records and removes 38,671 others from the disposable copy so they can regenerate. It preserves:

- The 400-block circle centered at X 5835, Z 4954, through the full world height.
- A 128-block buffer around registered/shared destinations and a 32-block buffer around other existing waystones.
- Current player and respawn locations, world spawn, and complete existing structure pieces connected to the protected chunks.
- Player inventories and unlock data, global waystone identities, names, ownership and other world data.
- Every other dimension unchanged, including the existing Nether. Better Nether Fortresses will therefore appear in newly generated Nether terrain; this pass does not reset it.

All 9,621 retained region/entity/POI records and 90 other files passed byte-for-byte validation in the untouched migration copy. All ten activated destinations remain present: Cryuraker, Underground Cavern, Amethyst Island, First Night Base, Field Base, Lukmirimur, Krairzur, Terrace Farm, Lush Hollow and Warped Forest. Six old sorting-list references were already absent from the original global registry; no currently activated destination was missing.

The separate startup rehearsal loaded all ten registered stones. Both original player files remained byte-identical. Amethyst Island's existing registry pointed to the upper half at Y81; loading normalized it to its unchanged lower half at Y80. Its identity, name and ownership did not change.

After adjacent generation and 3,600 accelerated ticks, the rehearsal had 274 block updates across 40 retained chunks. Within the protected 400-block base circle, the only 18 updates were crop growth and dirt becoming grass. Outside it, updates included ore/ground changes near generation boundaries, leaf decay, fluid and amethyst growth. The untouched migration payload itself still matches every retained original record. This evidence does not promise every boundary block remains static after gameplay resumes.

## DH generation

The old server configuration used SURFACE mode and a 32-chunk bound centered near the old location. That mode omits trees and structures. The prepared server configuration uses INTERNAL_SERVER, two worker threads, and a center at chunk X364 Z309 near the base.

The local trial generated 1,824 full chunks containing dynamic tree branches/leaves and Cave Biomes blocks, plus 178 DH FullData rows. It shut down cleanly after the bounded test. This proves generation and storage, not client rendering or complete distant-view coverage.

The live run started at a 128-chunk radius (roughly 2,048 blocks) around X5835 Z4954. Expand to 256 chunks (roughly 4,096 blocks, the current client view setting) after checking generation speed, server responsiveness and free disk. Stop before disk use exceeds 8 GB of the 10 GB allowance. Do not promise a completion time from this desktop's generation speed. Rebuild the Overworld DH cache; retain other dimensions' caches. The prepared server level-key prefix changes to open-air-living-landscapes-20260907 so clients use a fresh scenery cache after rejoining. This also refreshes other dimensions' client cache namespaces; their server-side caches and terrain remain preserved. Keep the existing serverId when applying the public configuration template; machine-generated identifiers are omitted from the public files.

Short local warmed-scene sprints measured 1.69, 1.72 and 1.24 ms per tick. These are not a controlled before/after benchmark and do not establish a less-than-10-percent cost or predict FadeHost performance. Rendering and long-term spread performance remain unmeasured.

## Deployment evidence and remaining work

The critical live save files matched the verified backup before staging. All 201 world files, nine mod jars and four configuration files were uploaded to an inactive directory and checked, then promoted while stopped. Installed mod and configuration hashes were rechecked. The matching public pack was fetched from GitHub and verified after publication. Normal live startup and actual DH progress were observed.

At approximately 23:50 UTC, generation was about 6% through the first 128-chunk radius. Disk usage was 2.24 GB of 10 GB and memory 3,092 MB of 4,096 MB. This is a point-in-time observation, not a completed-generation or performance guarantee. A ten-minute follow-through monitor will check progress, health and storage before expanding to 256 chunks. The full distant-view radius remains unfinished.

The private world, player data, seed and credentials must never be committed or uploaded to the public GitHub repository. The public release contains only mod source, the small built addon, pinned manifests, non-secret configuration and documentation.

## Evidence locations

Private local runs are under the living-landscapes-20260907 and forest-comparison-20260907 staging directories: migration-validation.json, registered-waystone-audit.json, rehearsal-preservation-detailed.json, existing-final-dynamic-v5b, migration-rehearsal-dynamic-v5b, fresh-caves-dynamic-v3 and fresh-dh-dynamic-v4. Source and build instructions are in tools/openairtrees.

See the earlier living-landscapes-and-yung-review decision for creator pages, reviews and exact-version research. The installed DH command was verified against its command implementation: `dh pregen start minecraft:overworld 5835 4954 128`, `dh pregen status`, and `dh pregen stop`.
