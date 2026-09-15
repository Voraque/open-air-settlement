# Iris block-type map guard — hotfix release 1.0.48

Symptom: pack 1.0.47 crashed every client at "Initializing game" (Windows client, 2026-09-14 00:15). First actual error: `NullPointerException ... WorldRenderingSettings.getBlockTypeIds() is null` inside Iris's `ItemBlockRenderTypes` mixin, called from `MoreSlabsStairsAndWallsFabricClient.initRenderLayers`. The server was unaffected; Iris is client-only. Clients could not work around it locally: removing the jar leaves the server with blocks the client lacks, and registry sync refuses the join.

Cause: Iris 1.8.x (verified in the 1.21.1 branch source and identical in 1.8.14-beta.1) leaves the block-type map null until a rendering pipeline exists at the title screen. `VanillaRenderingPipeline` then installs `Object2ObjectMaps.emptyMap()`; `IrisRenderingPipeline` installs the pack's map. More Slabs 4.2.0 queries `getChunkRenderType` in its client entrypoint, before either pipeline. Upstream: https://github.com/IrisShaders/Iris/issues/3084 (open, reported against Iris 1.8.8 with the same mod version). The shader toggle does not matter. More Slabs 4.1.1 has no client entrypoint and no copper grate slabs, so pinning back removes the feature the mod was added for. No Iris build above 1.8.14-beta.1 exists for 1.21.1.

Fix: Open Air Iris Compat 0.2.0, client only, built with javac against fabric-loader only (`tools/iris-compat/build.sh`). Its `preLaunch` entrypoint, which Fabric runs before any mod's client entrypoint, sets the map to an empty map by reflection if it is null. This is the state Iris reaches on its own one step later, so the only behavioural change is that the early query returns the vanilla layer instead of crashing. Everything is wrapped in try/catch; a missing Iris logs a skip line. The jar also carries the Phase 0 pale garden biome registration for shader packs (see the 2026-09-12 rework plan); it is inert until a pack references the define.

Validation: Mac client launch with 1.0.47 content plus the jar, reaching the title screen and joining FadeHost, is the acceptance test. Recorded below when done.

Rollback: remove `packwiz/mods/openair-iris-compat.pw.toml` and the jar, `packwiz refresh`, bump version. That restores the crash unless More Slabs is also removed from server and pack.

## Validation and second finding (2026-09-14, Mac)

Guard verified: the log shows `[openair-iris-compat] pre-filled Iris block type map` at pre-launch, More Slabs 4.2.0 initialised past the point that crashed Windows, the title screen appeared, and the client joined FadeHost with 1.0.47's registries. The `final.fsh` compile error at the title screen is pre-existing (present in the 2026-09-07 and 2026-09-13 logs) and Iris recovers when the world loads.

Second crash, one second after joining: `IllegalStateException: max stack size of 16 reached` from `Matrix4fStack.pushMatrix` in HUD rendering. Cause from bytecode: Cinematic Weather's `WorldRendererMixin` injects `pushMatrix` at HEAD and `popMatrix` at RETURN of `renderSnowAndRain`, gated on `enableDynamicRain`; Particle Rain's `WeatherEffectRendererMixin` cancels the same method partway, so the RETURN injection never runs and one push leaks per frame. 1.0.47 turned dynamic rain on; 1.0.46 had it off, which is why the 2026-09-13 session was fine. Fix in 1.0.48: `enableDynamicRain=false` again. Fog stays on. Not a guard-mod issue.
