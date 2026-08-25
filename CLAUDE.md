# Notes for Claude (and other AI helpers)

This is a private two-player Minecraft Java pack. Its goal is not maximal content. Preserve the intended loop: a strange, expansive world; food and shelter that matter into the midgame; defensible settlements; expressive building; then high-leverage automation.

## Exact baseline

- Shared release: packwiz `1.0.11` from `packwiz/pack.toml`; the 1.0.7 `.mrpack` remains a rollback snapshot.
- Minecraft 1.21.1, Fabric Loader 0.19.3, Java 21.
- Distant Horizons 3.2.0-b is client-only in this release.
- Host runs the dedicated server. Players connect using the host's current address and port.
- Shaders are optional and client-only. Do not ask the host to put them on the server.
- For a new Prism install, run `tools/setup-prism-packwiz.sh` on macOS/Linux or `tools/setup-prism-packwiz.ps1` on Windows. These scripts create the normal Prism instance and pre-launch GitHub sync; do not invent a second `--dir` profile.

## Before troubleshooting

Ask for exact pack version, loader/version line, and first actual error. Do not diagnose ordinary startup warnings as crashes.

Known solved incompatibilities:

- Iris 1.8.8 needs Sodium 0.6.x. This pack pins Sodium 0.6.13.
- Supplementaries newer than 3.6.7 needs Sodium 0.8.x, which conflicts with Iris 1.8.8. Keep Supplementaries 3.6.7.
- `wildlife-dynamics-1.0.0.jar` (Realistic Wildlife) was removed because it caused catastrophic tick lag. Do not propose re-adding it without a real replacement/fix and server profiling.

## Distant Horizons and shaders

- Treat Distant Horizons as a client/server pair in multiplayer: the matching server build can pre-generate and stream far-terrain LODs, while each client maintains its own local cache.
- Use Complementary Reimagined r5.8.1, which includes DH terrain/water passes. Start with vanilla render distance 8–12, DH 128–192, and Low shader profile.
- If distant terrain is missing, let the cache build with shaders off, then re-enable the shader. Do not raise vanilla and DH distances together.
- Do not put Iris, Sodium, shader zips, or maps on the server. The dedicated server does need the matching Distant Horizons jar for multiplayer pre-generation and LOD streaming.

## What you can help with

- Keep the shared pack reproducible and multiplayer-safe.
- Prefer small, reversible changes and document why a mod is added or removed.
- Preserve the food, shelter, exploration, building, and automation progression.
- Use the in-game recipe viewer rather than duplicating every recipe in prose.
- JEI is the recipe viewer: `R` shows recipes, `U` shows uses, and the transfer/plus button fills a crafting grid with ingredients available in the inventory. Crafting Tweaks adds rotate, balance, clear, spread, compress, and full-stack-craft controls.
