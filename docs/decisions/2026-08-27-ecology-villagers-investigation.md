# Ecology and village redesign: evidence log

Date: 2026-08-27  
Status: investigation; nothing in this record is promoted to the live client or server yet  
Working branch: `ecology-villagers-evidence-20260827`

## Design target

The world should reward exploration, stewardship, and player-authored settlement building. Villages should remain useful places worth revisiting and defending, without making kidnapping villagers or building a trading hall the dominant strategy. Ecology should be visible through creature behavior and gradual world change, but should not become an opaque simulation, a performance liability, or a collection of overlapping animal mods.

The implementation preference is, in order: existing mod configuration; a maintained datapack; a small compatibility patch to an existing mod; then a purpose-built server mod only for behavior that cannot be expressed safely by the earlier options.

## Decisions so far

| Area | Current decision | Evidence and rationale |
| --- | --- | --- |
| Librarians | Test a private Dynamic Villager Trades fork containing Librarian's Balance's found-book teaching mechanic. Do not stack the two unchanged. | Librarian's Balance changes one of the librarian's first two offers after a player uses a found enchanted book on the lectern. It does not bind villagers to villages or prevent lectern roulette on its own. Dynamic Villager Trades regenerates offers and would erase the unchanged datapack's mutation. One trade engine is more predictable than two competing writers. |
| Village identity | Build a small server-only settlement layer after the trade fork passes. | Villagers need a persistent origin settlement, restocking should depend on being near that settlement, and resettlement should be an explicit player act. This preserves travel and village identity without making villagers immovable. Legacy villagers should remain valid until deliberately adopted. |
| Ecological 0.3.0 | Remove after replacement behavior passes. Do not repair only its textures. | The current jar lacks the mixed-crop block model and block translations seen by the player. Its leaf mixin also forces all leaves to random-tick, cancels vanilla leaf decay globally, and contains an impossible tree-seed bounds condition. The defect is behavioral, not merely cosmetic. |
| Birds | Keep Fowl Play; do not add Birds/Boids or Flock. | Fowl Play already implements flying navigation, local flock steering, perching, foraging, hunting, and predator avoidance. The observed scarcity is more plausibly caused by its 200-tick spawn throttle, village-only pigeon/sparrow rules, biome eligibility, and the server's simulation distance than by a missing bird framework. Duplicate bird populations would obscure the cause. |
| Creature ecology | Retain Naturalist, Critters and Companions, Hostile Harmony, and Fowl Play while measuring overlap and population. | Verified interactions include rat crop harvesting, butterfly pollination, vulture scavenging, snakes and fish hunting smaller mobs, ferret digging/hunting, otter and clam interaction, dragonfly avoidance, spider predation, and prey fear. These are real interactions rather than inferred from mod names. |
| Forest renewal | Green Cuts remains the leading narrow replacement. Use the private packaging-only repair for behavior testing; do not promote it yet. | It only tracks dropped saplings and checks that the target block is survivable and unoccupied. Its published jar embeds Configurate-HOCON but omits Configurate Core and its runtime graph. The private `1.0.4+openair.1` jar changes no gameplay classes and reached full-pack server readiness with Ecological removed. A deterministic sapling-planting behavior test is still required. |
| Creature-made paths | Patch Worn Path rather than port the whole ALIVE/GSTools stack. | ALIVE's Fabric base is not available for 1.21.1 and the unrelated Dynamic Life datapack used commands from newer Minecraft versions. Worn Path is already in the pack and has a bounded player-step implementation. The private patch limits animal wear to grounded living pathfinding mobs and gives animals a separately throttled chance. |
| Weathering | Keep in the lab until its data errors and migration behavior pass. | Weathering fits the design, but earlier tests found invalid advancement data in the 1.21.1 build. Visual fit is not sufficient without clean data loading and world-migration evidence. |
| BloomingNature | Keep and test. | It adds the small-scale vegetation and terrain detail the world needs. The baseline log shows feature-order cycles that Biolith repairs at runtime, so world generation and performance still need measured acceptance tests. |

## Test gates

No candidate reaches Packwiz, Benji's client, or FadeHost until it passes all applicable gates:

1. Unit tests for deterministic policy and persistence code.
2. A disposable Java 21 Fabric server reaches readiness without mod-resolution, datapack, function, or recipe parse failures introduced by the candidate.
3. The server accepts commands and shuts down cleanly.
4. Behavior tests prove the advertised mechanic rather than only proving startup.
5. A fixed-seed population run records creature counts, spawn eligibility, and server tick time at simulation distances 6 and 10.
6. A copied-world migration test preserves players, inventories, positions, villagers, and ordinary terrain.
7. Client/server manifests and Packwiz hashes agree before promotion.

The headless harness deliberately stages a fresh copy and excludes worlds, logs, backups, caches, Java runtimes, and credential-like files. Its own Pester suite currently passes 7/7 tests. The baseline pack reaches `Done` in roughly 136 seconds in the disposable lab, but is not yet considered clean: Supplementaries and JEED have existing recipe parse failures. The Green Cuts comparison reached `Done` in roughly 137 seconds and introduced no new startup or data-loading failure. Its shutdown saved every world, then remained stuck while Distant Horizons closed its database connections until the 90-second safety timeout. Recipe failures and shutdown hangs remain whole-pack failures even when the candidate itself loads correctly.

## Evidence locations

- Headless harness: `tools/pack-validation/`
- Disposable ecology lab: `C:\Nicky-Personal-Effects\open-air-settlement-weathering-alive-lab`
- Green Cuts comparison lab: `C:\Nicky-Personal-Effects\open-air-settlement-system-lab-20260827\ecology-green-cuts`
- Baseline report: `tools/pack-validation/runs/20260827T231419Z-a351594c/report.json`
- Green Cuts failure report: `tools/pack-validation/runs/20260827T231828Z-569fe960/report.json`
- Green Cuts repaired-jar report: `tools/pack-validation/runs/20260827T232501Z-70999f6a/report.json`

Disposable run outputs are evidence, not release assets. Large generated worlds and logs should not be committed. Durable conclusions and small machine-readable summaries should be copied into the repository when a test concludes.
