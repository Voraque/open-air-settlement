# Plan: Enchanting Infuser 21.1.4 is in Rain Settlement, in Open-Air Settlement (client pack and FadeHost server), tested against the pack's modded enchantments, with Mending purchasable only at the advanced infuser

Written 2026-09-05 for hand-off to an executor. Do the phases in order. Commands are literal and run from the repo root named in each step. Rain goes first because its README defines it as the local development and testing pack; Open-Air follows once the singleplayer test passes.

## Background (why, in three sentences)

The pack has no enchanting mod, so enchanting is vanilla: three random offers, hidden extra enchantments, treasure only from loot or librarian rolls. Enchanting Infuser (Modrinth `ePv85y52`, Fabric 1.21.1 build `lBRm6Aii`, jar `EnchantingInfuser-v21.1.4-1.21.1-Fabric.jar`) replaces the rolls with a per-enchantment level picker priced in levels and gated by bookshelves, adds no enchantments, and reads the pool from `#minecraft:in_enchanting_table`, which every enchantment-adding mod in this pack already feeds. Its dependencies (Puzzles Lib >=21.1.38, Forge Config API Port, Fabric API) are already pinned on both packs and present on the server (`PuzzlesLib-v21.1.52`, `ForgeConfigAPIPort-v21.1.6`, `fabric-api-0.116.15`).

## Success criteria

- S1. Rain `main`: `pack/mods/enchanting-infuser.pw.toml` (`side = "both"`), `pack/moonlight-global-datapacks/open-air-infuser-tags/` present, `pack/pack.toml` at `1.8.0`, ledger section 11 added, pushed. A fresh Rain launch syncs the jar into `mods/`.
- S2. In the Rain instance, world `Mod Testing (1)`: the test table in Phase 2 is filled in with no crash, and every row in it passes.
- S3. Open-Air `main`: `packwiz/mods/enchanting-infuser.pw.toml`, `packwiz/moonlight-global-datapacks/open-air-infuser-tags/`, `server-config/enchantinginfuser-server.toml`, `packwiz/pack.toml` at `1.0.36`, docs updated (Phase 3 list), pushed.
- S4. FadeHost server: `mods/` has the jar (117 entries), `config/enchantinginfuser-server.toml` matches the checked-in file, `moonlight-global-datapacks/open-air-infuser-tags/` present. Next boot's `logs/latest.log` lists `enchantinginfuser 21.1.4` under `Loading 227 mods`, reaches `Done (`, and adds nothing to `crash-reports/`.
- S5. On the server, Benji opens an Enchanting Infuser and an Advanced Enchanting Infuser, applies a chosen enchantment to a modded item, and Mending is offered at the advanced block only. Yoz's client syncs the new pack and can open the same block.

## Assumptions ledger

| # | Assumption | Load-bearing? | Cheapest validation |
|---|---|---|---|
| A1 | `moonlight-global-datapacks/` is loaded on the dedicated server as well as the client. The pack already ships `skill-tree-tuning` there and it is on the server, but the boot log never names it. | Yes for the Mending tag (D4). If false, the tag goes to `world/datapacks/` instead. | Phase 0 step 4: RCON `datapack list enabled` must name `skill-tree-tuning`. |
| A2 | Puzzles Lib server configs land in `config/<modid>-server.toml`, not in the world folder. | Yes for where the checked-in config is deployed. | Already confirmed: `config/aether-server.toml` exists on both instances and the server; the world `serverconfig/readme.txt` says it only overrides `config/`. Phase 2 step 6 re-confirms with the generated filename. |
| A3 | `packwiz modrinth add --project-id ePv85y52 --version-id lBRm6Aii` resolves and marks the mod `side = "both"`. | Yes. | Phase 1 step 1 output; inspect the generated `.pw.toml`. |
| A4 | Enchanting Infuser opens without error on Spell Engine, Archers, Farmer's Delight, and Combat Roll gear. No issue on its tracker mentions these mods, but nobody has tested this pack. | Yes for S2. | Phase 2 table rows T3 to T6. |
| A5 | Crying obsidian is obtainable in this world (ruined portals, bastions, piglin bartering). Terralith and Tectonic do not remove ruined portals. | Medium. Wrong means the basic infuser is gated harder than intended, not broken. | Phase 5: Benji checks a ruined portal exists in explored terrain, or JEI shows the bartering route. Fallback: a recipe override in `open-air-resources`. |
| A6 | Nobody is online during the server upload. `autoHibernate=true` means the JVM boots fresh on the next join. | Yes for safety. | Phase 4 step 1: `get_player_activity`. |
| A7 | `packwiz` is at `/Users/benji/go/bin/packwiz`. | Yes. | `packwiz --version`. |

## Decisions already made

- D1. `side = "both"`. The block, menu, and network messages exist on both sides; a server-only or client-only install fails to join.
- D2. Rain first, Open-Air second. Rain is the declared testing pack; Rain runs one minor version ahead until Phase 3 closes the gap, and the ledger records that.
- D3. Ship the mod's default server config unchanged and check the generated file in. Defaults: basic infuser unenchanted-items-only, advanced infuser can modify, enchant books, repair tools and armor, and place anvil-only enchantments; `maximumCost` 30; `scaleCostsByVanillaOnly` true; `increaseAnvilRepairCost` false. Rationale: the numbers were derived from source and a script, not play; change them after one session's evidence, not before. Replan trigger R1 covers the likely adjustment.
- D4. Treasure: Mending only, advanced infuser only, delivered as a two-file datapack in `moonlight-global-datapacks/open-air-infuser-tags/`, the same channel the pack already uses for Skill Tree tuning. Rationale: Mending is the RNG grievance that drives librarian rerolling; Swift Sneak, Soul Speed, Frost Walker, Wind Burst, and Stasis stay as exploration rewards. The mod's bundled `treasure_enchantments` datapack is not used because it adds all treasure at once.
- D5. The vanilla enchanting table stays craftable. The basic infuser recipe consumes one, and the table remains the cheap early-game option.
- D6. Version numbers: Rain `1.7.3` to `1.8.0` (repo uses `<version>: <summary>` and minor bumps for additions); Open-Air `1.0.35` to `1.0.36` (repo used a patch bump for Gliding Accessories in 1.0.31).
- D7. Server gets the config file uploaded from the repo before its first boot with the mod, so the server never writes a default that differs from the checked-in copy.

## Datapack contents (used in Phases 1 and 3)

`open-air-infuser-tags/pack.mcmeta`:
```json
{
  "pack": {
    "pack_format": 48,
    "description": "Open-Air: allow Mending at the Advanced Enchanting Infuser only."
  }
}
```

`open-air-infuser-tags/data/enchantinginfuser/tags/enchantment/in_advanced_enchanting_infuser.json`:
```json
{
  "replace": false,
  "values": [
    "minecraft:mending"
  ]
}
```

## Phases

### Phase 0: Verify assumptions (10 minutes, read-only)

- **Work**, from `/Users/benji/Code/open-air-settlement`:
  1. `packwiz --version` (A7).
  2. Confirm the Modrinth version still resolves and record the jar hash:
     ```
     curl -s -A open-air-settlement https://api.modrinth.com/v2/version/lBRm6Aii | python3 -c "import json,sys; v=json.load(sys.stdin); f=v['files'][0]; print(v['version_number'], f['filename'], f['hashes']['sha512'])"
     ```
     Expect `v21.1.4-1.21.1-Fabric EnchantingInfuser-v21.1.4-1.21.1-Fabric.jar <hash>`. Keep the hash for Phase 4 step 3.
  3. Server state and players:
     ```
     tools/fadehost-mcp.sh tools/call '{"name":"get_player_activity","arguments":{"server":"server_70ee525b4de6425e90f0c92fbe7c8cb1"}}'
     tools/fadehost-mcp.sh tools/call '{"name":"get_server","arguments":{"server":"server_70ee525b4de6425e90f0c92fbe7c8cb1"}}'
     ```
  4. A1 check. If the server is running (or after it boots for a player), run:
     ```
     tools/fadehost-mcp.sh tools/call '{"name":"send_console_command","arguments":{"server":"server_70ee525b4de6425e90f0c92fbe7c8cb1","command":"datapack list enabled"}}'
     ```
     then `get_console_logs` and look for `skill-tree-tuning` in the reply. Present: A1 holds, use `moonlight-global-datapacks/` in Phases 3 and 4. Absent: A1 fails, switch every `moonlight-global-datapacks/open-air-infuser-tags` server path in Phase 4 to `world/datapacks/open-air-infuser-tags` and note it in the decision log. If the server is hibernating, do this check at the start of Phase 4 step 5 instead; it does not block Phases 1 to 3.
- **Judgment calls**: none.
- **Dependencies**: `.fadehost.env` present (gitignored, never print it). Use `tools/fadehost-mcp.sh` for MCP calls and a Python paramiko heredoc for SFTP; do not build inline `curl -H "X-API-Key: ..."` commands.
- **Exit criteria**: steps 1 and 2 print the expected values; step 3 answered; step 4 answered or explicitly deferred to Phase 4.

### Phase 1: Rain repo (15 minutes)

- **Work**, from `/Users/benji/Code/rain-settlement` on `main`:
  1. `cd pack && packwiz modrinth add --project-id ePv85y52 --version-id lBRm6Aii && cd ..`
     If packwiz asks about dependencies, accept none: Puzzles Lib, Forge Config API Port, and Fabric API are already in `pack/mods/`. Then `cat pack/mods/enchanting-infuser.pw.toml`: `filename = "EnchantingInfuser-v21.1.4-1.21.1-Fabric.jar"`, `side = "both"`. If `side` is anything else, edit it to `"both"`.
  2. Create the datapack from the "Datapack contents" section:
     ```
     mkdir -p pack/moonlight-global-datapacks/open-air-infuser-tags/data/enchantinginfuser/tags/enchantment
     ```
     write `pack.mcmeta` and `in_advanced_enchanting_infuser.json` at the paths shown.
  3. Bump `pack/pack.toml` `version = "1.7.3"` to `"1.8.0"`, then `cd pack && packwiz refresh && cd ..`.
  4. Verify: `git status --short` shows exactly `pack/pack.toml`, `pack/index.toml`, `pack/mods/enchanting-infuser.pw.toml`, and the two datapack files. `grep -c "open-air-infuser-tags" pack/index.toml` prints `2`.
  5. Append to `docs/pack-mirror-ledger-2026-09-01.md`:
     ```
     ## 11. Enchanting Infuser added, Rain ahead of Open-Air for testing (1.8.0, 2026-09-05)

     Rain 1.8.0 adds Enchanting Infuser v21.1.4 (`side = "both"`) plus a two-file Moonlight global
     datapack `open-air-infuser-tags` that adds Mending to the advanced infuser's tag only. Rain runs
     ahead on purpose: it is the testing pack, and the singleplayer checks in
     `open-air-settlement/docs/enchanting-infuser-plan-2026-09-05.md` Phase 2 run here first.
     Open-Air 1.0.36 closes the gap with the same version, same datapack, and the generated server
     config checked in as `server-config/enchantinginfuser-server.toml`. Until then the delta is
     exactly this one mod and one datapack.
     ```
  6. `git add pack docs/pack-mirror-ledger-2026-09-01.md && git commit -m "1.8.0: add Enchanting Infuser 21.1.4 and Mending-only advanced tag (ahead of Open-Air for testing)" && git push origin main`
  7. Confirm `https://raw.githubusercontent.com/benji-hix/rain-settlement/main/pack/pack.toml` shows `version = "1.8.0"`.
- **Judgment calls**: push before testing. Rain's Prism instance syncs from GitHub `main` on launch, so the push is the only way to run the test from the pack rather than from a loose jar (the ledger's section 9.5 records why loose jars are avoided).
- **Dependencies**: Phase 0 steps 1 and 2.
- **Exit criteria**: step 4 file list exact; step 7 shows 1.8.0.

### Phase 2: Singleplayer test in Rain (needs Benji, 20 to 30 minutes)

- **Work**: launch the Rain Prism instance. The pre-launch sync must print the infuser jar as downloaded. Open world `Mod Testing (1)` (or a new creative world if that one is precious). Use creative or `/give`; the blocks are `enchantinginfuser:enchanting_infuser` and `enchantinginfuser:advanced_enchanting_infuser`. Place each with 15 bookshelves around it (one block gap, two layers allowed). Fill this table; write the observed values into the decision-log entry in Phase 3.

  | ID | Check | Pass condition |
  |---|---|---|
  | T1 | Diamond sword in the basic infuser | Sharpness, Smite, Bane, Knockback, Fire Aspect, Looting, Sweeping Edge, Unbreaking listed; Sharpness V alone costs 5 levels; Sharpness V + Unbreaking III + Looting III + Fire Aspect II costs 20 |
  | T2 | Select Sharpness, then try Smite | Smite refuses to increase; tooltip names Sharpness |
  | T3 | Spell Engine staff or wand (any `wizards`/`paladins` weapon) | Spell Power, Haste, Critical Chance, Critical Damage, Energize listed; no crash; enchant applies and shows on the item |
  | T4 | Archers bow | Power, Punch, Flame, Unbreaking listed; Infinity present (non-treasure); enchant applies |
  | T5 | Farmer's Delight knife | Backstabbing listed |
  | T6 | Leather boots | Combat Roll's Acrobat, Longfooted, Multi Roll listed |
  | T7 | Mending | Absent at the basic infuser; present on the advanced infuser for a diamond pickaxe; requires more shelves than Unbreaking III |
  | T8 | Enchanted diamond pickaxe in the advanced infuser | Existing enchantments shown at their levels; lowering Efficiency to 0 shows a negative cost and, on Enchant, drops experience orbs |
  | T9 | Damaged item, advanced infuser | Repair button shows a level cost; after repair durability is full and anvil rename cost is unchanged from before |
  | T10 | Blank book in the advanced infuser | Whole pool listed; enchanting produces an Enchanted Book usable at an anvil |
  | T11 | JEI | `R` on either infuser shows its recipe |
  | T12 | Skill Tree (RPG Series) screen and a spell cast | Both still work with the infuser present |

  Then copy the generated server config out of the instance for Phase 3:
  ```
  ls "$HOME/Library/Application Support/PrismLauncher/instances/rain-settlement/minecraft/config/" | grep -i infuser
  cp "$HOME/Library/Application Support/PrismLauncher/instances/rain-settlement/minecraft/config/enchantinginfuser-server.toml" /Users/benji/Code/open-air-settlement/server-config/
  ```
  If the filename differs from `enchantinginfuser-server.toml`, use the real name everywhere below and record it (A2).
- **Judgment calls**: test in Rain, not on the server, so a crash costs one singleplayer session instead of a server boot. T1's expected numbers come from the mod's cost formula run offline; a different number is a finding, not a failure, unless it is far off (more than double or less than half).
- **Dependencies**: Phase 1 pushed; Benji at the keyboard.
- **Exit criteria**: T1 to T12 recorded; no client crash log dated today in the Rain instance; the config file copied.

### Phase 3: Open-Air repo (20 minutes)

- **Work**, from `/Users/benji/Code/open-air-settlement` on `main`. The working tree has unrelated untracked files (`.DS_Store`, older plan docs, `server-config/rpgdifficulty.json`, `server-config/spell_engine/`, `server-config/walljump.json5`, `server-config/zombieawareness/`, `tools/fadehost-mcp.sh`); do not use `git add -A`.
  1. `cd packwiz && packwiz modrinth add --project-id ePv85y52 --version-id lBRm6Aii && cd ..`, then check `packwiz/mods/enchanting-infuser.pw.toml` for `side = "both"`.
  2. `cp -R /Users/benji/Code/rain-settlement/pack/moonlight-global-datapacks/open-air-infuser-tags packwiz/moonlight-global-datapacks/`
  3. `server-config/enchantinginfuser-server.toml` is already in place from Phase 2. Open it and confirm the values match D3; do not edit.
  4. Bump `packwiz/pack.toml` `version = "1.0.35"` to `"1.0.36"`, then `cd packwiz && packwiz refresh && cd ..`.
  5. Docs, surgical edits in the existing style:
     - `docs/CHANGELOG.md`, add at the top:
       ```
       ## 1.0.36 — 2026-09-05

       - Added Enchanting Infuser 21.1.4 on client and server. Two new blocks replace the enchanting table's random offers with a menu that lists every enchantment the item accepts, including the Spell Power, Spell Engine, Combat Roll, Farmer's Delight, and RPG-class ones, and charges experience levels per chosen level. Bookshelves still gate maximum levels. The basic infuser is crafted from an enchanting table, crying obsidian, and amethyst; the advanced one adds netherite and can modify, remove, repair, and enchant books. No new enchantments. The vanilla table stays craftable.
       - Added the `open-air-infuser-tags` global datapack: Mending is purchasable at the advanced infuser only, at double cost. Other treasure enchantments remain loot-only.
       - Checked in `server-config/enchantinginfuser-server.toml` with the mod's defaults.
       ```
     - `docs/DESIGN-CONTEXT.md`, under "Current pack decisions", add after the CropXp bullet:
       `- **Enchanting Infuser:** added in 1.0.36 to remove the enchanting table's random rolls. Players choose enchantments and pay levels; bookshelves gate levels. Mending is the only treasure enchantment sold, and only at the netherite-tier advanced infuser, so the remaining treasure enchantments keep their exploration value. Costs are the mod's defaults pending one session of play.`
     - `docs/FIELD-GUIDE.md`, add a subsection under "The systems that matter", after "Recipes and ordinary questions": `### Enchanting: Enchanting Infuser` with four sentences: what the block does, the two tiers and their gates, that 15 bookshelves on two layers unlock max levels, and that the advanced infuser repairs with levels and sells Mending. Add one line to the "Self-sufficiency ladder" where enchanting first matters.
     - `docs/PACKWIZ.md`, the checked-in server settings sentence: add `server-config/enchantinginfuser-server.toml`.
     - `docs/decision-log.md`, append `## 2026-09-05 — Enchanting Infuser added (deterministic enchanting)` with: the reason (RNG removal), the alternatives rejected in one line each (Better Enchanting deletes enchanted books and conflicts with the librarian teaching fork; Enchanting Overhauled moves RNG into tome loot and caps levels at III; Easy Magic keeps the RNG), D3 and D4 with their rationale, the Phase 2 table results, and the rollback: `packwiz remove enchanting-infuser`, delete the datapack folder and config, remove the jar, config, and datapack folder from the server.
  6. Commit:
     ```
     git add packwiz/pack.toml packwiz/index.toml packwiz/mods/enchanting-infuser.pw.toml packwiz/moonlight-global-datapacks/open-air-infuser-tags server-config/enchantinginfuser-server.toml docs/CHANGELOG.md docs/DESIGN-CONTEXT.md docs/FIELD-GUIDE.md docs/PACKWIZ.md docs/decision-log.md docs/enchanting-infuser-plan-2026-09-05.md
     git commit -m "feat(packwiz): add Enchanting Infuser 21.1.4 with Mending-only advanced tag, promote 1.0.36"
     ```
     Do not push yet.
- **Judgment calls**: docs land in the same commit as the pack change (repo convention since 1.0.35). The plan file itself is committed here so the decision log can link it.
- **Dependencies**: Phase 2 exit criteria.
- **Exit criteria**: `git status --short` shows only the pre-existing unrelated untracked files; `packwiz refresh` exited 0.

### Phase 4: Server deploy (15 minutes, plus a boot)

- **Work**, from `/Users/benji/Code/open-air-settlement`:
  1. Re-run Phase 0 step 3. If a player is online, wait.
  2. Get the jar: after Phase 2 it is at `"$HOME/Library/Application Support/PrismLauncher/instances/rain-settlement/minecraft/mods/EnchantingInfuser-v21.1.4-1.21.1-Fabric.jar"`. Verify `shasum -a 512` on it equals the Phase 0 step 2 hash.
  3. Over SFTP (paramiko heredoc, same pattern as the 2026-09-04 plan):
     - write the current `mods/` listing to server root as `mods-pre-infuser-<YYYYMMDD-HHMM>.txt`;
     - `s.put(<jar>, 'mods/EnchantingInfuser-v21.1.4-1.21.1-Fabric.jar')`;
     - `s.put('server-config/enchantinginfuser-server.toml', 'config/enchantinginfuser-server.toml')`;
     - `s.mkdir` the chain `moonlight-global-datapacks/open-air-infuser-tags/data/enchantinginfuser/tags/enchantment` (or the `world/datapacks/...` chain if A1 failed) and `s.put` the two datapack files;
     - re-list: `mods/` has 117 entries including the jar; `config/` has the toml; the datapack path lists both files.
  4. Boot: if `get_server` said stopped or hibernating, `start_server`; if running with nobody online, `restart_server`.
  5. After about 90 s, fetch `logs/latest.log` and check:
     - `grep -n "Loading .* mods" latest.log` shows `Loading 227 mods`
     - `grep -n "enchantinginfuser 21.1.4" latest.log` present
     - `grep -n "Done (" latest.log` present
     - `grep -in "infuser" latest.log | grep -i "error\|exception"` empty
     - `crash-reports/` has no file dated today
     - RCON `datapack list enabled` (Phase 0 step 4 command) names `open-air-infuser-tags` (Moonlight's display name may carry a prefix; match on `infuser`). If it does not, and A1 was never confirmed, move the folder to `world/datapacks/` over SFTP and `send_console_command` `reload`, then re-check.
- **Judgment calls**: upload before pushing the client pack so no client syncs 1.0.36 against a server that lacks the mod (that join fails with a missing-mod screen). Upload the config first so the server never writes its own default (D7).
- **Dependencies**: Phase 3 committed; server empty (A6).
- **Exit criteria**: all six checks in step 5 pass.

### Phase 5: Push Open-Air and verify in game (needs Benji and ideally Yoz, 10 minutes)

- **Work**:
  1. `git push origin main`, then confirm `https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml` shows `version = "1.0.36"`.
  2. Benji launches the Open-Air Prism instance (pre-launch sync downloads the jar and the two datapack files), joins `alpha.fadehost.net:26087`, and as op runs `/give @s enchantinginfuser:advanced_enchanting_infuser` and `/give @s enchantinginfuser:enchanting_infuser`, places both near bookshelves, opens each, enchants one modded item (a Spell Engine weapon), confirms Mending appears only at the advanced block, then breaks both blocks and drops the items (or keeps them, Benji's call; they are the intended endgame blocks).
  3. Yoz launches, syncs, joins, and opens one of the blocks.
  4. `get_console_logs` after both sessions: no exception mentioning `enchantinginfuser`; `crash-reports/` unchanged.
  5. Record the result in `docs/decision-log.md` under the Phase 3 entry ("Verified on the server 2026-09-0X" or "Not yet verified"), commit `docs: record Enchanting Infuser server verification`, push.
- **Judgment calls**: an op `/give` is used rather than a survival craft so the test does not depend on A5; A5 is checked separately by Benji looking for a ruined portal or the JEI bartering entry.
- **Dependencies**: Phase 4 exit criteria; two humans.
- **Exit criteria**: S5 met and recorded.

## Failure modes & mitigations

- F1. Opening the infuser with a Spell Engine weapon crashes or kicks the client (issue tracker has "kicked when opening menu" reports on other packs) → early signal: Phase 2 T3 → pull the crash report, revert Rain to 1.7.3 content in a `1.8.1` commit (`packwiz remove enchanting-infuser`, delete the datapack folder), report the trace. Do not proceed to Open-Air.
- F2. Moonlight global datapacks are client-only (A1 false) → signal: Phase 0 step 4 or Phase 4 step 5 lacks the pack → server path becomes `world/datapacks/`; the client packs keep `moonlight-global-datapacks/` (singleplayer worlds still need it) and the decision log records the split.
- F3. Costs feel wrong in play (T1 numbers far off, or a full kit under 15 levels on a Spell Engine weapon because modded enchantments do not enter the divisor) → signal: Phase 2 T1 and T3 costs → ship anyway with defaults (D3) and open replan trigger R1; the fix is `maximumCost` or `scaleCostsByVanillaOnly` in the checked-in toml, a config-only change on the server.
- F4. `packwiz modrinth add` marks the mod `side = "client"` or `"server"` (packwiz infers from Modrinth's `required`/`required` flags, which should give `both`) → signal: Phase 1 step 1 inspection → edit the toml to `"both"` and `packwiz refresh`.
- F5. A player joins between the SFTP upload and the boot check → signal: `get_player_activity` non-empty at Phase 4 step 4 → do not restart; the join booted the JVM from the new `mods/`, run the step-5 checks as they are.
- F6. The generated server config has a different filename or lives elsewhere (A2 false) → signal: Phase 2 `ls | grep -i infuser` → use the real path in Phase 3 step 3, Phase 4 step 3, and `docs/PACKWIZ.md`.
- F7. A client sync runs ahead of the server (someone launches Open-Air between the push and the server boot) → signal: missing-mod screen on join → prevented by ordering Phase 4 before Phase 5 step 1; if it happens anyway, the join succeeds after the server boot with no action.

## Critical path

Phase 0 (steps 1 to 2) → Phase 1 (push) → Phase 2 (Benji's singleplayer session) → Phase 3 → Phase 4 (server boot) → Phase 5 (Benji and Yoz). Executor time is about an hour; the two human sessions set the calendar. Compression: Phase 3's docs edits can be drafted while Phase 2 runs, and Phase 0 step 4 can run during Phase 4 if the server is asleep. Nothing else compresses without skipping the singleplayer test, which is the only step that exercises A4.

## Replan triggers

- R1. After the first real session, a full enchantment kit on a diamond or netherite piece costs under 15 levels, or a Spell Engine weapon kit costs under 10: raise `maximumCost` in `server-config/enchantinginfuser-server.toml` (start at 45) or set `scaleCostsByVanillaOnly = false`, upload, and note the change.
- R2. Phase 2 T3 or T4 crashes (F1).
- R3. The librarian found-book teaching fork is promoted: revisit D4, since Mending would then have a deterministic villager route and the advanced-infuser tag could be dropped.

## Follow-up finding, out of scope

The server's `world/datapacks/` holds only `beltborne_lanterns_generated`, and `datapacks/Sensible Trade Overhaul.zip` in the client instance root is not a world datapack path (CHANGELOG 1.0.32 noted the same for Nullscape). Sensible Trade Overhaul is therefore probably not active on the server. Not touched by this plan.

## First 3 actions

1. From `/Users/benji/Code/open-air-settlement`, run Phase 0 steps 1 to 3.
2. From `/Users/benji/Code/rain-settlement`, run Phase 1 steps 1 to 7.
3. Benji launches Rain and fills the Phase 2 table.
