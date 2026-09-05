# Decision log

## 2026-09-01 — Mob scaling and cave-horde tuning (RpgDifficulty 1.4.0, Zombie Awareness 1.13.2)

Symptoms on the fadehost server: skeletons 3-shot a wizard-robed player, zombies took ~10 frost-wand hits, caves swarmed. Server `server.properties` has `difficulty=normal`.

Diagnosis (server config pulled over SFTP; it differed from the Prism/local copy, which had been assumed in earlier notes):

- D1. Time scaling accrues on world age (`ServerWorld.getTime()`, level.dat `Data.Time`), which advances while the server idles. Server had `increasingTime 60`, `timeFactor 0.05`; at Data.Time 1,511,054 ticks (1259 min) that is 20 steps = 2.0× health and damage before distance/height. Verified via javap on the 1.4.0 jar: `startingTime` and `increasingTime` are both in minutes (ticks ÷ 1200).
- D2. Distance scaling was on at 0.1 per 300 blocks, and height scaling at 0.1 per 30 blocks above and below y62 (`positiveHeightIncreasion true`), adding ~+0.1 to +0.3 in caves.
- D3. Zombie Awareness scent/sound strength was 48 on the server (block-hitting noise was already off), so cave hordes came from sense range plus the health inflation above.

Patch applied to server `config/` (originals kept as `*.bak-2026-09-01` on the server and in the Prism instance; repo `server-config/` updated to match):

| key | before | after |
|---|---|---|
| rpgdifficulty increasingTime | 60 | 1440 |
| rpgdifficulty timeFactor | 0.05 | 0.01 |
| rpgdifficulty startingTime | 0 | 1259 (resets accrued time scaling to 1.0×) |
| rpgdifficulty distanceFactor | 0.1 | 0.0 |
| rpgdifficulty heightDistance / heightFactor | 30 / 0.1 | 20 / 0.025 |
| rpgdifficulty positiveHeightIncreasion | true | false |
| rpgdifficulty maxFactorHealth / maxFactorDamage | 3.0 / 3.0 | 2.5 / 1.5 |
| zombieawareness scentStrength / soundStrength | 48 / 48 | 30 / 30 |

Left alone: `bossTimeFactor 0.1` (bosses still gain +10% per 1440-min step, capped at `bossMaxFactor 3.0`; the startingTime reset zeroes it too).

Reload: RpgDifficulty reads its config once at init (Cloth AutoConfig, static field, no reload hook), so a full server restart is required. Zombie Awareness copies values into static fields at startup; coroutil's `/coro config common reload` may re-pull them, but the restart covers both. Existing mobs keep their scaling: RpgDifficulty persists `MobHealthMultiplier` in entity NBT and vanilla persists the attribute modifiers, so only newly spawned mobs get the new factors.

Follow-up, same day: no manual restart was needed. The panel has `autoHibernate=true`, so the JVM stopped while empty and booted fresh at 2026-09-02 02:52 UTC when a player joined, two hours after the upload. Both mods therefore loaded the patched files at init. Server power and RCON are also reachable from Claude via the FadeHost MCP (`https://api.fadehost.com/mcp`, `X-API-Key` from `.fadehost.env`), which exposes `restart_server`, `send_console_command`, `get_console_logs`, and file read/write.

## 2026-09-01 — Rune pouch spells fail after re-equip (Spell Engine 1.10.3 container cache)

Symptom: spells with a rune cost do nothing while the rune pouch sits in the Trinkets quiver slot. A fresh join fixes it; unequipping and re-equipping the pouch breaks it again.

Ruled out (client jar inspection via javap, server mods listed over SFTP): Spell Engine reads pouches only from Trinkets slots, and Accessories has no quiver slot, so the slot was right. Server and client run identical Spell Engine 1.10.3 / Runes 1.3.2 / Trinkets 3.10.0 / Bundle API 1.1.0, and `spell_cost_item_allowed` is true on both.

Diagnosis (unverified, pattern-based): equipping any trinket fires Spell Engine's equip callback, which invalidates and rebuilds the per-player spell-source cache. A rejoin rebuilds it from scratch. The config comment on `spell_container_caching` says "Might be buggy."

Patch applied to server `config/spell_engine/server.json5` (original kept as `server.json5.bak-2026-09-01` on the server and in the Prism instance; repo copy at `server-config/spell_engine/server.json5`):

| key | before | after |
|---|---|---|
| spell_container_caching | true | false |

Reload: read at init, so the change takes effect on the next server boot. autoHibernate restarts the JVM when the server empties and a player rejoins. If re-equipping the pouch still breaks casting after that boot, the cache is not the cause and the next step is inspecting the player's `playerdata` NBT after a failed re-equip.

Also noted: server `mods/` lacks six pack jars marked both/server (gravestones, pneumonocore, movingelevators, supermartijn642 corelib and configlib, walljump). Unrelated to spells; not changed.

## 2026-09-01 — Gravestones and Wall-Jump restored to the server

Missing since the pack added them: `mods/` on the FadeHost server held 113 jars and none of `gravestones`, `pneumonocore` (its dependency), or `walljump`, all three marked `side = "both"` in packwiz. Deaths therefore dropped items on the ground with no grave, and wall jumps did nothing in multiplayer. Flagged as an open item in the Spell Engine entry above.

Uploaded to `mods/` from the packwiz manifest URLs (not a Modrinth search), so the server runs the exact bytes the clients do. Downloaded hashes and post-upload remote hashes both match the manifest:

| jar | hash-format | hash |
|---|---|---|
| gravestones-1.2.6+1.21.1+A.jar | sha256 | `386e3155460dd70cf4cdc2ab154ad3bc0aec1b1b3102590f08d9c910ecbd3f08` |
| pneumonocore-1.3.1+1.21+A.jar | sha256 | `121364fe9b936c6599632e4dc234c45c835e2dd451d2fb9cc4851b1b545a7afb` |
| walljump-1.21.1-1.3.8-fabric.jar | sha512 | `97a82562e0418e4f17af3b8c44e4e520a89117c8ccbd33de251c8dc3ab5c543c5de8e5734e0996f31f160845ce842346061a32968a9fafb119a1291448bacc26` |

`mods/` is now 116 jars. The pre-change listing is on the server root as `mods-pre-gravestones-walljump-20260901-2228.txt`; rollback is deleting the three files.

Configs: neither mod had a config on the server. The Prism client copies were shipped unchanged to `config/gravestones.json` and `config/walljump.json5` (sha256-verified after upload) and tracked in `server-config/`. Load-bearing values: `gravestone_accessible_owner_only true`, `decay_time 576000` ticks (8 days), `store_experience true`, `spawn_gravestones_with_keepinv false`; `enableWallJump`/`useWallJump true`, `useDoubleJump false`.

Boot verification: server was stopped and hibernating, so it was started from the FadeHost MCP rather than waiting for a join. `logs/latest.log` for the 05:31 UTC boot shows `Loading 227 mods:` including `gravestones 1.2.6`, `pneumonocore 1.3.1`, and `walljump 1.21.1-1.3.8-fabric`, plus `Initializing Gravestones`, `Initializing PneumonoCore`, and the `walljump` / `walljump/enchantments` data packs. Reached `Done (`; no new file in `crash-reports/` (newest is still 2026-08-28). `gamerule keepInventory` is `false` over RCON, so graves will actually catch drops.

Left alone: the stale `config/universal-graves/` folder (Universal Graves and Polymer were removed 2026-08-28, commit `3bba3f7`; neither jar is on the server, nothing reads the folder).

Still open: `movingelevators` and the two supermartijn642 libraries are still absent from server `mods/`. Out of scope here.

Not yet verified: the in-game pass — a survival death leaving an openable owner-only grave, and a wall jump on the server. Needs a player.

## 2026-09-04 — Custom Time Cycle removed (server crash on waystone edit)

The dedicated server died in the tick loop whenever a permission check ran on a player. Two crash reports today, `crash-reports/crash-2026-09-04_10.36.06-server.txt` and `crash-2026-09-04_10.37.00-server.txt`, both with the same signature:

```
java.lang.NoSuchMethodError: 'net.minecraft.class_2168 net.minecraft.class_3222.method_64396()'
  at me.lucko.fabric.api.permissions.v0.Util.commandSourceFromEntity(Util.java:38)
     ~[fabric-permissions-api-v0-0.3.3-82369eda3a4fc310.jar:?]
  at me.lucko.fabric.api.permissions.v0.Permissions.check(Permissions.java:160)
  at net.blay09.mods.balm.fabric.compat.FabricPermissionsAPIIntegration.hasPermission(...)
     ~[balm-fabric-1.21.1-21.0.65.jar:?]
```

Cause: `customtimecycle-fabric-0.1.6-1.21.1.jar` nests `META-INF/jars/fabric-permissions-api-0.3.3.jar`, a build for Minecraft 1.21.2+ that calls `class_3222.method_64396()` (`ServerPlayer.createCommandSourceStack`), a method that does not exist in 1.21.1. Fabric Loader resolves the highest nested version, so this copy won the module graph for the whole server. The 10:36 boot log confirms it was the only provider: `- customtimecycle 0.1.6-1.21.1` / `   \-- fabric-permissions-api-v0 0.3.3`, with no second parent. Anything that asks the library about a player therefore crashed — Waystones through Balm on every waystone place or edit, and Polymer before it was removed. The nine crash reports from 2026-08-28 are this same bug reached through Polymer, not a separate fault.

Decision: remove the mod rather than downgrade to 0.1.4 (which nests the harmless 0.3.1). The author has shipped a wrong nested library once already, and Rain Settlement had to pin around the same thing. Day and night return to vanilla length, 10 minutes day / 7 minutes night. Removed from the pack and deleted `server-config/customtimecycle.json`; nothing reads it once the jar is gone. `world/data/` held no `customtimecycle*` file, so no world state is orphaned.

Rollback: `packwiz modrinth add --project-id Xuf4fk5b --version-id AykEapdy`, then re-upload the jar to server `mods/` and the config to `config/`. A rollback copy of both is kept off-repo. Any future replacement must not bundle fabric-permissions-api above 0.3.1, and must be tested with a waystone place and edit on the dedicated server before release.

Server verification: the FadeHost server was Stopped and empty, so the jar and config were deleted over SFTP and the server started from the MCP rather than waiting for a join. The pre-change listing is on the server root as `mods-pre-ctc-removal-20260904-1044.txt`; `mods/` is now 116 jars. The 17:44 UTC boot log shows `Loading 226 mods:` (down from 228 — the mod and its nested library both drop out), zero matches for `customtimecycle` or `fabric-permissions-api`, and reaches `Done (1.398s)`. No new file in `crash-reports/`; the newest is still `crash-2026-09-04_10.37.00-server.txt`.

Not yet verified: the in-game pass — placing a waystone and opening its edit screen on the dedicated server. That is the only test that exercises the exact crash path; the log checks do not prove it. Needs a player.

## 2026-09-05 — Docs corrected to match the 1.0.16 automation removal

Found while implementing the Enchanting Infuser plan. `docs/FIELD-GUIDE.md` still described CC:Tweaked and Oritech as the pack's automation spine, including two of the six self-sufficiency ladder rungs, and `docs/DESIGN-CONTEXT.md` and `CLAUDE.md` carried the same premise. Neither mod has been in the pack since 1.0.16.

Cause: `9adfdf1` ("Release Open-Air Settlement 1.0.16", 2026-08-26) deleted `packwiz/mods/cc-tweaked.pw.toml` and `packwiz/mods/oritech.pw.toml` inside a ~100-file diff that was otherwise the RPG Series addition. The release shipped with no `## 1.0.16` changelog entry — the changelog jumped 1.0.15 to 1.0.17 — and no decision-log or mirror-ledger record. With no paper trail, later doc edits maintained the prose around the hole: `4508c85` (1.0.32) touched FIELD-GUIDE and `9f475ca` (1.0.35) touched DESIGN-CONTEXT, neither noticing.

The removals were intentional: the pack's late game is character progression through the RPG Series and Spell Engine stack, not industry. Confirmed with Benji 2026-09-05.

Corrections applied, verified by grepping every mod named in both docs against `packwiz/mods/` — CC:Tweaked and Oritech were the only two stale names out of 27 checked:

- `FIELD-GUIDE.md`: `### Automation: CC:Tweaked + Oritech` replaced by `### Character progression: Spell Engine + Skill Tree + the RPG classes`. Ladder rungs 5 (turtle job) and 6 (Oritech) collapsed into one `Character independence` rung, so the ladder is five rungs. Session 3's "turtle or Oritech job" line and the two dead links in "Optional deeper references" also replaced.
- `DESIGN-CONTEXT.md`: the Fabric-1.21.1 justification, the "satisfying graduation" vision bullet, and the two automation design-principle bullets no longer name absent mods; the `Tom's Simple Storage → CC:Tweaked → Oritech` ladder bullet became a Tom's-only bullet plus a removal record; Future-work items 3 and 4 (build a CC:Tweaked starter library, add Oritech milestones) deleted and the list renumbered.
- `CLAUDE.md`: the intended loop now ends in character progression rather than high-leverage automation.
- `CHANGELOG.md`: `## 1.0.16` reconstructed from the commit, marked as reconstructed.

Structural note: `packwiz/mods/` is machine-readable truth and the prose docs are a hand-maintained projection of it with nothing linking the two, so divergence is silent. `git log --diff-filter=D -- packwiz/mods/` is the check that finds a removal buried in a bulk release commit.

Unverified: `server-config/rpgdifficulty.json` is untracked in this repo, so the FIELD-GUIDE's claim that mobs scale with world age and depth reflects that local file, not a confirmed server state. Same drift risk as above, in the other direction.
