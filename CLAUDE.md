# Notes for Claude (and other AI helpers)

This is a private two-player Minecraft Java pack. Its goal is not maximal content. Preserve the intended loop: a strange, expansive world; food and shelter that matter into the midgame; defensible settlements; expressive building; then high-leverage automation.

## Exact baseline

- Minecraft 1.21.1, Fabric Loader 0.19.3, Java 21.
- Shared release: `downloads/Open-Air-Settlement-1.0.4-CurseForge.zip` or `.mrpack`.
- Host runs the dedicated server locally. Players connect using the host's current LAN address and port `25565`.
- Shaders are optional and client-only. Do not ask the host to put them on the server.

## Before troubleshooting

Ask for the exact pack version, loader/version line from the log, and the first actual error. Do not diagnose ordinary startup warnings as crashes.

Known solved incompatibility:

- Iris 1.8.8 needs Sodium 0.6.x. This pack pins Sodium 0.6.13.
- Supplementaries newer than 3.6.7 needs Sodium 0.8.x, which conflicts with Iris 1.8.8. Keep Supplementaries 3.6.7.
- `wildlife-dynamics-1.0.0.jar` (Realistic Wildlife) was removed in 1.0.4 because it caused catastrophic tick lag. Do not propose re-adding it without a real replacement/fix and server profiling.

## What you can help with

- Explain a mod's mechanics, make settlement plans, write CC:Tweaked turtle programs, diagnose logs, and propose small balanced additions.
- Treat a mod change as a shared-release change. Check Fabric 1.21.1 compatibility, both client/server requirements, performance cost, and interaction with the survival loop.
- Suggest automations that remove chores without erasing the reason to build a farm, workshop, or defensive base.

## What you cannot assume

- You are not connected to the running Minecraft server or a player account merely because you can read this repository. Playing alongside the group requires a separate, explicit in-game bridge/bot installation and host permission.
- Do not expose the host's LAN address, world files, logs, player data, or credentials in a public issue or repository.
