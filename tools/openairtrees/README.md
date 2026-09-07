# Open Air Trees compatibility

Released: 0.5.0 for Open-Air Settlement 1.0.39. Published and installed on FadeHost on September 7, 2026 after local tests and verified backup. See the living-landscapes implementation decision for deployment evidence and remaining DH generation.

## Scope

Fabric / Minecraft 1.21.1 / Dynamic Trees 1.7.2-BETA / Blooming Nature 1.1.10.
Ten species retain Blooming Nature wood, sapling and leaf identities: aspen, fir, larch, chestnut, ebony, cypress, swamp cypress, swamp oak, blooming oak and baobab. Blooming oak uses vanilla oak wood, matching the source mod.

Population rules cover eight Blooming Nature biomes, four vanilla biomes and two Terralith biomes. Mixtures follow the source biome's tree identities, with lower density in fields and savannas. This is partial, deliberately scoped coverage. Palms, bushes and unsupported biome populations keep their existing generation. The addon does not change terrain noise, the world seed or Terralith's landforms.

Shapes use Dynamic Trees broadleaf, conifer and acacia templates with species-specific growth proportions. These are not exact reproductions of every Blooming Nature silhouette. Blooming oak uses flowering foliage without the original bloom-state transitions. No Blooming Nature texture files are redistributed; models reference the installed assets.

## Fabric seed repair

The exact 1.7.2-BETA jar contains Seed.onEntityItemUpdate but no caller. The Fabric lifespan adapter also returns zero. SeedItemEntityMixin restores a server-side planting attempt using the saved item age and the public Seed planting API; it does not call that broken adapter. It applies only to Dynamic Trees seed items. The forest-only option, whose upstream probability adjustment was commented out, now prevents self-planting in zero-forestness biomes. A stack receives one attempt when its configured lifespan expires, matching DT's intended behavior. Normal drops remain collectible until then.

This mixin uses Minecraft 1.21.1 intermediary names and is intentionally bounded to DT >=1.7.2 <1.7.3. Re-audit it before any DT upgrade to avoid applying a second planting hook after an upstream fix. The small registration entrypoint uses the official Dynamic Trees addon API.

## Pack behavior

Normal saplings place dynamic saplings; existing ordinary saplings also convert when they grow. Green Cuts still handles ordinary dropped saplings, while DT seeds use the repaired DT path. Growth and voluntary spread are slow; disease, canopy crashing, branch climbing and falling-tree damage are disabled. Falling animation remains enabled with a reduced leaf-particle cap. No dirt-bucket crafting is needed.

## Evidence

- Final v5b dedicated-server fixture: all ten species grew beyond the starter shape after growth pulses. A survival axe felled aspen and dropped Blooming Nature aspen logs, sticks and the correct seed.
- Normal aspen sapling placement passed. An existing ordinary aspen sapling converted on growth. Four near-expiry seed stacks planted in an aspen forest; a matching plains fixture remained empty. The latter tests used 64-item stacks to exercise the probabilistic path, not to measure ordinary spread frequency.
- All seven approved YUNG mods and DH were present in the final fixture. Clean startup and cooperative shutdown passed. The migration rehearsal loaded all ten registered destinations.
- A separate DH INTERNAL_SERVER trial generated 1,824 full chunks with dynamic tree blocks and a populated distant-view database.
- The asset audit resolved 86 mod model/texture references. Actual rendered-client appearance, shader behavior and comparative frame-time performance remain unverified.

## Reproducible build

Use Java 21 and Python:

    python build.py --javac PATH_TO_JAVAC --dynamic-trees PATH_TO_DT_JAR --runtime-root PATH_TO_FABRIC_1_21_1_TEST_SERVER --output PATH_TO_OUTPUT_JAR

The runtime supplies the remapped Minecraft server jar, libraries and dependencies for compilation only. Dependencies are not bundled. Archive entries are sorted with fixed timestamps. Tree templates and loot defaults derive from DynamicTreesTeam/DynamicTrees under its included MIT license. Prototype versions 0.1-0.4 are test history, not release artifacts.
