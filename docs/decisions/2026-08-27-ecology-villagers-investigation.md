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
| Librarians | Accept the private Dynamic Villager Trades fork's found-book teaching mechanic for combined-lab testing. Do not stack it with other trade engines. | Five policy/serialization tests and three Fabric GameTests pass. The GameTests traverse the real server-side lectern callback and prove exact-job-site teaching, rejection without consumption at the wrong lectern or with malformed/multi-enchantment books, immunity to lectern replacement plus DVT refresh, deterministic Efficiency III pricing at 21 emeralds plus a book, and persistence through restock, level regeneration, and entity NBT save/load. The test source set is absent from the production jar. Settlement-origin composition and a full client-network click remain before promotion. |
| Village identity | Keep the settlement-origin prototype in the lab and test it together with the librarian fork. | The isolated branch proves a 1-bell/4-bed/3-workstation claim, explicit adoption, local-only restocking, denial away from origin, restart persistence, and zombie-origin NBT persistence. This preserves travel and village identity without making villagers immovable. It still needs DVT composition and a player-driven curing test before promotion. |
| Ecological 0.3.0 | Remove after replacement behavior passes. Do not repair only its textures. | The current jar lacks the mixed-crop block model and block translations seen by the player. Its leaf mixin also forces all leaves to random-tick, cancels vanilla leaf decay globally, and contains an impossible tree-seed bounds condition. The defect is behavioral, not merely cosmetic. |
| Birds | Keep Fowl Play; do not add a second broad bird roster merely to raise visible counts. | Fowl Play already implements flying navigation, local flock steering, perching, foraging, hunting, and predator avoidance. The observed scarcity is more plausibly caused by its 200-tick spawn throttle, village-only pigeon/sparrow rules, biome eligibility, and the server's simulation distance than by a missing bird framework. Measure population first; prefer a narrow spawn or behavior fix if birds are scarce. This is not a proposal to remove Naturalist. |
| Creature ecology | Retain Naturalist as part of the baseline, alongside Critters and Companions, Hostile Harmony, and Fowl Play, while measuring overlap and population. | Naturalist is not under consideration for removal in this pass. Verified interactions include rat crop harvesting, butterfly pollination, vulture scavenging, snakes and fish hunting smaller mobs, ferret digging/hunting, otter and clam interaction, dragonfly avoidance, spider predation, and prey fear. These are real interactions rather than inferred from mod names. |
| Better Ecology | Reject the current artifact for promotion; retain its documentation and selected source ideas as research material. Do not use it to replace Naturalist. | The source contains real hard-coded vanilla-animal hunger, thirst, herd, predator, roosting, nesting, and movement systems, but the advertised YAML/JSON behavior profiles, hot reload, insects, guano, bat crop protection, persistent roost ecology, and shared spatial partition are not wired into runtime. An unmodified dedicated 1.21.1 launch crashes before world creation by registering a second spawn placement for `minecraft:cow`. An audit-only bypass ran 108 GameTests: 101 passed and seven required tests failed, while several passing tests did not actually observe the behavior named. Broad `Animal` navigation replacement and frequent area scans also create substantial interoperability and tick-cost risk alongside Naturalist, Critters and Companions, Hostile Harmony, and Fowl Play. |
| Forest renewal | Green Cuts `1.0.4+openair.1` is accepted as the Ecological replacement candidate; promotion remains gated on a clean combined pack. | It only tracks dropped saplings and checks that the target block is survivable and unoccupied. Its published jar embeds Configurate-HOCON but omits Configurate Core and its runtime graph. Branch `openair/packaging-fix-1.21.1` makes that graph explicit without changing gameplay code. The source-built jar reached readiness, planted a dropped oak sapling under a deterministic configuration, emitted the required assertion marker, saved, and shut down cleanly. |
| Creature-made paths | Keep the Worn Path animal patch in the lab until an actual animal-caused block conversion is observed. | ALIVE's Fabric base is not available for 1.21.1 and the unrelated Dynamic Life datapack used commands from newer Minecraft versions. Worn Path is already in the pack and has a bounded player-step implementation. Branch `openair-animal-trails` adds an opt-in throttle for grounded living pathfinding mobs; five policy tests, build, and two startups pass. The attempted cow fixture did not move the cow, so it did not prove the visible behavior. |
| Weathering | Disable Immersive Weathering 1.0.1 beta in the combined lab; retain weathering as a design goal pending a repaired candidate. | With the beta present, the harness classifies roughly 22 malformed advancement records. With only that jar moved to the lab's reversible `disabled-mods` folder, those advancement failures disappear. Visual fit is not sufficient without clean data loading and world-migration evidence. |
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

The headless harness deliberately stages a fresh copy and excludes worlds, logs, backups, caches, Java runtimes, and credential-like files. Its own Pester suite currently passes 9/9 tests. The baseline pack reaches `Done` in roughly 136 seconds in the disposable lab, but is not yet considered clean: Aether's optional Supplementaries and JEED recipes have parse failures. The Green Cuts comparison reached `Done` in roughly 137 seconds and introduced no new startup or data-loading failure. Earlier shutdown timeouts were not reproduced after allowing the pack's post-start automatic resource reload to settle. A 45-second settled run reached readiness in 119 seconds, observed the DVT assertion, accepted `stop`, saved, and exited with code 0 without forced cleanup. The apparent hang was therefore a harness-timing artifact, not evidence against Distant Horizons, Beltborne Lanterns, or Green Cuts.

The 2026-08-27 combined rerun corrects the recipe ownership: all three optional-integration recipe files are inside Aether 1.21.1-1.5.11, including the misleadingly namespaced `data/supplementaries/recipe/copper_lantern_conversion.json`. Supplementaries is not the source. Aether also packages `data/jeed/recipe/inebriation.json` and `remedy.json` even though JEED is absent and client-only. Each error appears once during initial loading and once during an automatic reload, producing the six fatal records. The settled rerun confirms these six records are the remaining classified fatal failure and that shutdown itself is clean. The Aether source audit should make those integrations conditional or remove them from the Fabric artifact when their target mod is absent; installing JEED solely to silence a server recipe is not an acceptable fix.

## Evidence locations

- Headless harness: `tools/pack-validation/`
- Disposable ecology lab: `C:\Nicky-Personal-Effects\open-air-settlement-weathering-alive-lab`
- Green Cuts comparison lab: `C:\Nicky-Personal-Effects\open-air-settlement-system-lab-20260827\ecology-green-cuts`
- Baseline report: `tools/pack-validation/runs/20260827T231419Z-a351594c/report.json`
- Green Cuts failure report: `tools/pack-validation/runs/20260827T231828Z-569fe960/report.json`
- Green Cuts repaired-jar report: `tools/pack-validation/runs/20260827T232501Z-70999f6a/report.json`
- Green Cuts hand-built behavior report: `tools/pack-validation/runs/20260827T233411Z-0bd42e81/report.json`
- Green Cuts source-built behavior report: `tools/pack-validation/runs/20260827T234625Z-a9b4fa35/report.json`
- Green Cuts source branch: `C:\Nicky-Personal-Effects\open-air-settlement-weathering-alive-lab\upstream-green-cuts`, `openair/packaging-fix-1.21.1`, commits `0687e7c` and `c0349a2`
- Green Cuts source-built jar SHA-256: `6671C3F03D6F2A60516745822898C00DCC092F62F5A34165CB6F619AABD11928`
- Librarian fork: `C:\Nicky-Personal-Effects\open-air-settlement-weathering-alive-lab\upstream-dynamic-villager-trades`, `openair/librarian-balance-experiment`, production commit `0392290`, GameTest/evidence commit `cab2d762`
- Worn Path fork: `C:\Nicky-Personal-Effects\open-air-settlement-weathering-alive-lab\upstream-worn-path`, `openair-animal-trails`, commit `229c163`
- Settlement-origin prototype: `C:\Nicky-Personal-Effects\open-air-settlement-origin-lab-20260827`, `prototype/settlement-origins-20260827`, commit `d01e125`, artifact SHA-256 `932400AA91856D80FBCBA16D619926CA4A35DA9F8089DD1EABA9CF08C6208061`
- Better Ecology source audit: `C:\Nicky-Personal-Effects\open-air-settlement-better-ecology-lab-20260827`, `audit/better-ecology-20260827`, commits `03e9cd6`, `289a3c2`, and `751649c`; audited artifact SHA-256 `FD0B9FA43C6E143826F74ACFEE7B8058E311A62387388806CB3541020268E090` (rejected; not a release asset)
- Combined lab without Immersive Weathering: `tools/pack-validation/runs/20260828T000254Z-65bc7f34/report.json`
- Settled combined run with clean shutdown: `tools/pack-validation/runs/20260828T001621Z-4067dfce/report.json`

Disposable run outputs are evidence, not release assets. Large generated worlds and logs should not be committed. Durable conclusions and small machine-readable summaries should be copied into the repository when a test concludes.
