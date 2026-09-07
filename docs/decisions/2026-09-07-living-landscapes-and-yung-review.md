# Living landscapes and YUNG review â€” September 7, 2026

> Updated implementation and current authorization: see 2026-09-07-living-landscapes-implementation.md. The original review below predates approval and local tests.

## User-approved direction

Make forests more beautiful and visibly dynamic, with modest performance cost and few conspicuous mechanics. Forest outlines, density and tree shapes may change. Largely retain the existing world's landforms: hills, valleys, rivers and coastlines. Benji values hostile encounters; structures should provide memorable expeditions without covering the landscape in loot.

The user explicitly permits autonomous mod/datapack adaptations, including Dynamic Trees support for Blooming Nature. This authorizes implementation and local tests; it does not revoke the outstanding no-restart instruction or authorize an unreviewed live-world deletion. Preserve the 400-block circle centered on X 5835, Z 4954, all waystones and their registries, and other identified builds. Keep private world copies out of the public repository.

This refines the earlier tree-only comparison requirement: differences in forest extent and vegetation are now acceptable. An arbitrary count of changed non-tree blocks is not itself a rejection. Measure landform changes separately from vegetation, root soil, ores and structure footprints.

## Review method and limitations

Checked the creator's Modrinth catalogue, primary feature descriptions, exact Fabric 1.21.1 releases through the Modrinth API, ModDex written reviews, and player discussions. Review samples are small, frequently one reviewer across several mods, and mix Minecraft versions. These are useful design criticisms, not a representative consensus or benchmarks. No candidate was installed, performance-tested or deployed in this review pass.

## Main candidates

| Mod | Fabric 1.21.1 version | Review evidence | Recommendation for this pack |
| --- | --- | --- | --- |
| Better Desert Temples | 4.1.5 | One written review praises appearance but objects to frequent, lucrative temples. | High priority. Test spacing and rewards. Retain the dungeon's intended traps and final encounter initially; evaluate mining fatigue through actual play. |
| Bridges | 5.1.1 | No written ModDex reviews found. Creator warns that Terralith's steep banks make bridges rare. | High priority for atmosphere. Inspect placement against our rivers before increasing frequency; do not flatten riverbanks to make bridges fit. |
| Extras | 5.1.1 | No written ModDex reviews found. Creator describes small desert/swamp structures and low overhead. | High priority for understated landmarks; inspect rare novelty structures and avoid crowding. Low overhead is an author claim, not our measurement. |
| Better Nether Fortresses | 3.1.5 | Reviewer praises architecture and interactive Create bridges; criticizes excessive salvageable Create machinery. | High priority for Benji. Optional Create-specific criticism is conditional, not a demonstrated issue in our pack. Check encounter density and loot. |
| Better Strongholds | 5.1.3 | Reviewer strongly praises a buried-city feel, while noting a scale that can overwhelm vanilla surroundings. | Good candidate. Treat as a major expedition; test portal access, navigation and rewards with the rest of our RPG pack. |
| Better Ocean Monuments | 4.1.2 | Reviewer praises appearance but objects to frequency and large structures protruding above water. | Conditional. Sample our existing ocean depths and reduce frequency if needed. Do not change global ocean depth just to fit this mod. |
| Cave Biomes | 3.1.1 | No written ModDex review found; release discussion is enthusiastic but mostly first impressions. | Separate trial, lower priority. New mobs, blocks and sandstorms add more mechanics; creator documents shader and Fabric Distant Horizons fog issues. |

Desert Temples adds puzzles, traps, parkour and a final pharaoh encounter; by default mining fatigue lasts until that temple is cleared and is configurable. Nether Fortresses adds bridge networks, a keep and underground lava halls. Ocean Monuments offers larger randomized layouts and rewards including tridents and a Heart of the Sea. These are feature claims verified against the creator's descriptions, not results of local play.

## Remaining world-generation lineup

| Mod | Fabric 1.21.1 version | Assessment |
| --- | --- | --- |
| Better Dungeons | Already in pack, 5.1.4 | Keep. Written review praises varied underground danger and worthwhile, restrained loot. Audit actual pack loot before changing it. |
| Better Mineshafts | 5.1.1 | Worth considering after the requested set. Reviews praise paths and discoveries; one finds mushroom variants tonally odd. |
| Better Jungle Temples | 3.1.2 | Optional second wave. No written ModDex review found; avoid pretending we have independent gameplay evidence. |
| Better Witch Huts | 4.1.1 | Optional smaller addition. No written ModDex review found; comparatively narrow destination scope. |
| Better End Island | 3.1.2 | Defer from the Overworld pass. Review praises spectacle but notes obstacles alter the dragon fight. Requires separate End progression/migration review. |
| Better Caves | 3.1.6 | Defer. This changes cave geometry, unlike Cave Biomes. A review finds it less necessary since vanilla's cave update; the author describes its modern connected-cave generation. It broadens our terrain-change scope unnecessarily. |

The rest of the creator's current Modrinth catalogue includes API/Paxi infrastructure, Menu Tweaks, Traveler's Titles, Ribbits and The First City. These are outside the requested structure/forest comparison: no blanket install recommendation. Titles would add conspicuous presentation; new creature or special-purpose content needs its own brief. This is a review of the world-generation lineup, not a claim to have playtested every product in the catalogue.

## Forest implementation direction

Prefer a restrained Dynamic Trees adaptation over Dynamic Life's more elaborate ecosystem simulation. Preserve Blooming Nature's wood identities and distinctive silhouettes. Do not solve compatibility by replacing every tree species with generic oak/birch. Keep tree growth slow and regeneration bounded; avoid new fertilizer chores, involuntary tree disease, special rituals or broad ground-scanning scripts.

Inspected the exact local Dynamic Trees Fabric 1.7.2-BETA jar. Its tree resources define families, leaf properties, species, shapes and biome population rules. Several default rules explicitly select minecraft names, consistent with our previous observation of missing dynamic trees in the sampled Terralith forests. The jar's current server configuration exposes growth, voluntary seed drops, planting and disease controls; the local test config already has diseaseChance=0.0 and treeGrowthMultiplier=0.5. These are observations of the local test configuration, not a claim about a live Dynamic Trees deployment.

Blooming Nature 1.1.10 contains 16 custom biome definitions and saplings including aspen, baobab, blooming oak, chestnut, cypress, ebony, fir, larch, swamp cypress and swamp oak. The older upstream compatibility addon has nine species definitions and custom growth-kit references (for example aspen). Its world-generation rules target older vanilla biome integration. Therefore it cannot simply be renamed or copied into the current Fabric pack.

Implement a small compatibility module/treepack where possible, with new definitions for current biomes and current species IDs. Start with representative aspen, fir/larch and oak-edge cases, retain unsupported species until equivalent rendering and drops are proven, then extend coverage. Inspect upstream licensing and source provenance before redistributing adapted source/assets. A completed port is not claimed by this audit.

## Acceptance evidence for the implementation

- Same seed, exact generation configuration, identical settling time and matched mods for baseline/repeat/treatment; isolate the previously observed feature-order cycles before attributing biome shifts.
- Compare ground elevations excluding vegetation, water masks, coastlines, river routes and cross-sections. Report vegetation and structure-footprint changes separately. Generate a local map before considering any live regeneration.
- Preserve protected chunks across their full height, waystone block entities and global registry identities. Obtain a consistent full backup and an all-dimension preservation inventory before live migration.
- Compare server tick time, memory and chunk-generation time in identical warmed-up scenes, including two separated players. Measure client frame time with the actual shaders/Distant Horizons too. An initial engineering target is under 10% steady-state cost, subject to measurement noise; this is a proposed gate, not a achieved result.
- Confirm actual species silhouettes, natural generation, wood drops, sapling/seed behavior, FallingTree interactions and GreenCuts interactions. Startup alone is insufficient.
- YUNG structures only need new generation to appear naturally. Existing chunks can remain; regeneration is an option to bring structures nearer, not a prerequisite to install the mods. Review seams and full structure footprints at retained/regenerated boundaries.

## Sources

Primary feature/release pages: https://modrinth.com/user/YUNGNICKYOUNG ; https://modrinth.com/mod/yungs-better-desert-temples ; https://modrinth.com/mod/yungs-bridges ; https://modrinth.com/mod/yungs-extras ; https://modrinth.com/mod/yungs-better-nether-fortresses ; https://modrinth.com/mod/yungs-better-strongholds ; https://modrinth.com/mod/yungs-better-ocean-monuments ; https://modrinth.com/mod/yungs-cave-biomes . Release versions verified with project/version API filtered to Fabric and 1.21.1 on September 7, 2026.

Written reviews: https://moddex.gg/mod/yungs-better-desert-temples ; https://moddex.gg/mod/yungs-better-nether-fortresses ; https://moddex.gg/mod/yungs-better-strongholds ; https://moddex.gg/mod/yungs-better-ocean-monuments ; https://moddex.gg/mod/yungs-better-dungeons ; https://moddex.gg/mod/yungs-better-mineshafts ; https://moddex.gg/mod/yungs-better-end-island ; https://moddex.gg/mod/yungs-better-caves . Bridges, Extras, Cave Biomes, Jungle Temples and Witch Huts listing pages had no written reviews in the inspected results.

Player discussions: https://www.reddit.com/r/feedthebeast/comments/1f9fftu/ ; https://www.reddit.com/r/feedthebeast/comments/1ftyztt/ . Modern Better Caves author announcement: https://www.reddit.com/r/feedthebeast/comments/1n3bwe1/ .

Tree source: https://github.com/DynamicTreesTeam/DynamicTrees ; https://github.com/DynamicTreesTeam/Dynamic-Trees-for-Blooming-Nature . Prior local evidence: C:/Minecraft/Open-Air-Settlement-Staging/forest-comparison-20260907/REPORT.md .