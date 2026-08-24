# Notes for Claude (and other AI helpers)

This is a private two-player Minecraft Java pack. Its goal is not maximal content. Preserve the intended loop: a strange, expansive world; food and shelter that matter into the midgame; defensible settlements; expressive building; then high-leverage automation.

## Exact baseline

- Shared release: `downloads/Open-Air-Settlement-1.0.6.mrpack`.
- Minecraft 1.21.1, Fabric Loader 0.19.3, Java 21.
- Distant Horizons 3.2.0-b is client-only in this release.
- Host runs the dedicated server. Players connect using the host's current address and port.
- Shaders are optional and client-only. Do not ask the host to put them on the server.

## Before troubleshooting

Ask for exact pack version, loader/version line, and first actual error. Do not diagnose ordinary startup warnings as crashes.

Known solved incompatibilities:

- Iris 1.8.8 needs Sodium 0.6.x. This pack pins Sodium 0.6.13.
- Supplementaries newer than 3.6.7 needs Sodium 0.8.x, which conflicts with Iris 1.8.8. Keep Supplementaries 3.6.7.
- `wildlife-dynamics-1.0.0.jar` (Realistic Wildlife) was removed because it caused catastrophic tick lag. Do not propose re-adding it without a real replacement/fix and server profiling.

## Distant Horizons and shaders

- Treat Distant Horizons as client-side: it builds each player's local far-terrain cache from areas they explore.
- Use Complementary Reimagined r5.8.1, which includes DH terrain/water passes. Start with vanilla render distance 8–12, DH 128–192, and Low shader profile.
- If distant terrain is missing, let the cache build with shaders off, then re-enable the shader. Do not raise vanilla and DH distances together.
- Do not put Iris, Sodium, Distant Horizons, shader zips, or maps on the server.

## What you can help with

- Keep the shared pack reproducible and multiplayer-safe.
- Prefer small, reversible changes and document why a mod is added or removed.
- Preserve the food, shelter, exploration, building, and automation progression.
- Use the in-game recipe viewer rather than duplicating every recipe in prose.
