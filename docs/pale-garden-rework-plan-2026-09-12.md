# Plan: Pale Garden rework (approved 2026-09-12)

Outcome: the Pale Garden reads as a fogged, silent, giant-tree forest where the only hostiles are Creakings, with shaded oak and amber moss as its rare colour and a plantable source of new wood.

Baseline: pack 1.0.46, Minecraft 1.21.1, Fabric 0.19.3, Perfect Parity: The Garden Awakens Edition 1.0.8, Complementary Reimagined r5.8.1 + Euphoria Patches 1.9.3, Iris 1.8.14-beta.1, Dynamic Trees 1.7.2-BETA, Biolith 3.0.14, Lithostitched 1.8.0.

## Success criteria
- In the garden with shaders on: sky fully faded to fog, view limited to roughly 40 to 60 blocks, sunlight dimmer, water grey-brown. Shaders off still shows vanilla gray parity.
- Ten consecutive in-game nights in the garden: no hostile other than Creakings spawns on the surface; Creaking variants appear rarely, are killable, and drop loot.
- Night only: orange dust motes, occasional distant lightning flash and thunder. Day: no storms. Rain sound and drops come and go.
- Regenerated garden: pale oaks 18 to 26 blocks tall dominate, shape variety visible, shaded oaks about one in fifteen trees, amber moss around them, resin clumps scattered on trunks.
- Shaded oak sapling grows a shaded oak; felling yields shaded oak logs; the full non-entity wood set crafts.
- Every change is a file or folder that can be deleted to revert; the noise-point change reverts independently.

## Assumptions ledger
| # | Assumption | Load-bearing | Cheapest validation |
|---|---|---|---|
| A1 | A client mod inserting the pale garden key into Iris's biome map yields a `BIOME_PALE_GARDEN` define before the pack compiles | Yes (Phase 1 fog) | Build the shim, enable Iris debug, grep `patched_shaders/` for the define |
| A2 | `moonlight-global-datapacks` loads a `data/minecraft/worldgen/biome/pale_garden.json` override and functions on both sides | Yes (all data) | Test override with a lurid water colour in a singleplayer world |
| A3 | A both-sides mod built with plain javac against the intermediary jars registers blocks on server and client | Yes (Phase 2) | One-block mod, local dedicated server |
| A4 | packwiz-installer can pull from a private repo through a token-bearing raw URL | Yes for Phase 6 only | Throwaway Prism instance pointed at a token URL |
| A5 | MCA Selector's biome filter selects pale garden chunks in this world | Yes (Phase 4) | Open a backup copy, filter, count |
| A6 | A summoned `minecraft:creaking` is non-heart-bound, killable, and accepts attribute and scale commands | Yes (variants) | Summon one in a test world at night |
| A7 | A lightning bolt summoned about 150 blocks up lights nothing, hurts nobody, and flashes under Complementary | Medium | Summon over the test garden |
| A8 | Biolith can add a TerraBlender-registered biome at a new noise point | Yes for Phase 5 only | Test in singleplayer when Phase 5 starts |
| A9 | The birches in the current garden are not produced by the pale garden biome itself | Medium | Dynamic Trees' population rules select by tags the biome lacks and the biome's feature list has no birch; Phase 3 claims the garden's Dynamic Trees rule explicitly, which makes the source moot |
| A10 | Server-side Distant Horizons refreshes LODs for regenerated chunks once its generation runs | Medium | Observe after Phase 4; manual LOD regen is the fallback |

## Phases

### Phase 0: Validation day
- Work: run A1, A2, A3, A5, A6, A7. Create the local test world on the server seed and locate a pale garden.
- Judgment calls: none pending. Repo visibility is deferred to Phase 6 (Benji, 2026-09-12): the repo stays public until the content mod is proven worth keeping.
- Dependencies: none.
- Exit: each assumption has a yes or a documented workaround; the test world has a located garden.

### Phase 1: Atmosphere and Creakings in the existing garden
- Work: Iris shim mod (client-only). Shader patch applied to the Euphoria-generated folder by an idempotent pre-launch step on macOS and Windows: dense fog term, sky fade to fog colour, sunlight dimming, lightshaft reduction, Distant Horizons pass included. Biome override in `moonlight-global-datapacks`: sky colour equal to fog colour, water grey-brown, monster spawn list empty, ambient loop reused from an existing asset, music none. Function datapack, per-player tick: night orange dust; weather state machine; Creaking first-tick buff and rare variant summon; Creaking loot table override. Euphoria extra-properties file marking open eyeblossom and resin clump emissive. Packwiz release and changelog entry.
- Judgment calls: weather illusion starts at rain windows of 3 to 6 minutes at roughly 40 percent duty, storms only at night in 2 to 4 minute windows with one bolt every 20 to 40 seconds, rain sound at volume 0.35 timed to the clip length, sparse falling water high up plus ground splashes. Variants: each heart-bound Creaking rolls a 2 percent chance per minute at night to summon one variant, never if two variants already exist within 48 blocks; variants are killable and drop one or two resin clumps, plus a 10 percent shaded oak sapling once Phase 2 ships. No shader darkening during illusion rain; the constant gloom carries it. All parameters are scoreboard values so tuning happens in game.
- Dependencies: A1, A2, A6, A7.
- Exit: the first three success criteria observed in the existing garden by both players; shaders-off comparison still vanilla; a deletion list exists that reverts the phase.

### Phase 2: Content mod `openair-pale` (both sides)
- Work: register shaded oak log, stripped log, wood, stripped wood, planks, stairs, slab, fence, gate, door, trapdoor, button, pressure plate, leaves, sapling; amber moss and flat amber moss carpet. Script-generate blockstates, models, item models, loot tables, recipes, tags (logs, planks, leaves, saplings, mineable, flammable, hoe), lang, creative tab. Static sapling growth through an `openair:shaded_oak` configured feature. Bonemeal spread for amber moss through a bonemeal patch feature. Textures as recolours generated by script from the local jar. Optional 2b: Dynamic Trees family and species for pale oak and shaded oak, data only.
- Judgment calls: signs, hanging signs, and boats excluded. Carpet is the flat vanilla style. Dynamic Trees support is a follow-on, not a gate. Until Phase 6 the built jar, with its derived textures, is in the public repo; accepted as interim.
- Dependencies: A3.
- Exit: sapling grows a shaded oak in the test world; every wood block crafts and drops; JEI shows no missing textures; the jar loads on a local dedicated server with no errors.

### Phase 3: Worldgen rework (new chunks only)
- Work: tree features in the `openair` namespace: giant pale oak (2x2 giant trunk, base 18 plus 0 to 8, layered foliage), twisted mid pale oak (bending trunk), leafless spires and stumps, the existing creaking-heart pale oak retained as heart carrier, shaded oak at about one in fifteen. Pale moss and creaking heart decorators reused. Amber moss patches near shaded oaks. Resin clumps on trunks via multiface growth. Dynamic Trees population rule for `minecraft:pale_garden` naming exactly the species wanted, or none. Biome override feature list swapped to the new set.
- Judgment calls: silhouette variety over species variety; shaded oak is the only colour break. Trees stay in a non-vanilla namespace so any future biome tagging cannot expose them to Dynamic Trees' vanilla-namespace canceller.
- Dependencies: Phase 2 jar.
- Exit: a fresh test world's garden matches the fourth success criterion at three locations; no worldgen errors; frame time within 10 percent of a dark forest.

### Phase 4: Regenerate the found garden
- Work: FadeHost backup, download, MCA Selector delete by biome on the copy, verify in singleplayer, then the same on the stopped server with players warned, restart, confirm Distant Horizons LODs refresh.
- Judgment calls: delete by biome, not by coordinate box, to avoid seams in neighbouring biomes.
- Dependencies: A5, A10, a server window agreed with Nicky, nothing built in the garden.
- Exit: garden regenerated with Phase 3 trees; no seams in other biomes; LODs updated or manually regenerated.

### Phase 5: Larger garden (independently revertable)
- Work: Biolith addition placing pale garden at a wider noise window, one file. Observe new chunks for a week of play.
- Judgment calls: accept that this also creates gardens where none existed; revert by deleting the file, which affects only future chunks.
- Dependencies: A8.
- Exit: kept with a changelog note, or reverted, decided by Benji after seeing it.

### Phase 6: Repo private (final, only if the content mod stays)
- Work: create a fine-grained read-only token limited to this repo's contents; edit both Prism pre-launch URLs; validate A4 on a throwaway instance; flip visibility; decision-log entry.
- Judgment calls: private repo plus token URL over stripping derived textures, because the mod jar itself would carry them anyway.
- Dependencies: A4; Nicky edits her pre-launch command first.
- Exit: both instances sync from the private repo on a clean launch.

## Failure modes and mitigations
- Iris define never appears (A1 false). Signal: Phase 0 test. Mitigation: sky-colour detection in a custom uniform, daytime only, documented as degraded.
- Euphoria or Complementary update wipes the patched folder. Signal: the pre-launch step reports a failed diff. Mitigation: it fails loudly and the stock look returns; re-fit the patch.
- Repo private breaks Nicky's sync. Signal: her pre-launch step errors on first launch. Mitigation: flip visibility only after both URLs are edited and tested.
- Weather illusion is annoying rather than eerie. Signal: either player mutes it. Mitigation: scoreboard parameters toggled by chat, one function disables the module.
- Regeneration deletes something someone built. Mitigation: backup first, both players confirm the garden is untouched, restore path is the backup.
- Chunk regen leaves stale far terrain. Signal: old canopy height in the distance. Mitigation: manual Distant Horizons regen of the area.

## Critical path
Phase 0 (1 day) -> Phase 1 (3 to 5 days part-time) -> Phase 2 (3 to 4 days) -> Phase 3 (2 to 3 days) -> Phase 4 (1 day plus a server window) -> Phase 5 (half a day) -> Phase 6 (half a day). Phases 1 and 2 share no files and can overlap once Phase 0 passes. Phase 4 and Phase 6 wait on Nicky.

## Replan triggers
A1 false; A2 false; A3 false; the Phase 1 look not accepted by both players after two tuning sessions; a Perfect Parity or Complementary version bump.
