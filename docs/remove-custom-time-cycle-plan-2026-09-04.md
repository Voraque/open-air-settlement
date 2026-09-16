# Plan: Custom Time Cycle is gone from the Open-Air server, the Open-Air packwiz repo, and the Rain Settlement repo, and placing or editing a waystone no longer crashes the server

Written 2026-09-04 for hand-off to an executor. Do the phases in order. Every command is meant to be run literally from the repo root named in that step. Do not improvise replacements for the mod; this plan removes it and returns day/night length to vanilla (10 min day / 7 min night).

## Background (why, in three sentences)

Custom Time Cycle 0.1.6 (`customtimecycle-fabric-0.1.6-1.21.1.jar`, server-only on Open-Air) nests `fabric-permissions-api 0.3.3`, a build for Minecraft 1.21.2+. Fabric Loader picks the highest nested version, so any mod that asks that library about a player (Waystones via Balm on every waystone place/edit; Polymer before it was removed) hits `NoSuchMethodError ServerPlayer.method_64396` and the server tick loop dies. Crash reports: `crash-reports/crash-2026-09-04_10.36.06-server.txt`, `crash-2026-09-04_10.37.00-server.txt`, and nine from 2026-08-28. Rain currently pins 0.1.4 (nests 0.3.1, which is fine) but is being removed for parity.

## Success criteria

- S1. Open-Air FadeHost server `mods/` has no `customtimecycle*` jar and `config/customtimecycle.json` is gone. `logs/latest.log` of the next boot lists neither `customtimecycle` nor `fabric-permissions-api-v0` under `Loading N mods:` and reaches `Done (`.
- S2. On that boot, a player places a waystone and opens its edit screen (shift-right-click or right-click the placed waystone, then the settings/edit button) and the server stays up. No new file appears in `crash-reports/`.
- S3. `github.com/Voraque/open-air-settlement` main: `packwiz/mods/custom-time-cycle.pw.toml` and `server-config/customtimecycle.json` deleted, `packwiz/index.toml` no longer references it, `packwiz/pack.toml` version bumped, `packwiz refresh` output clean, docs updated (list in Phase 3).
- S4. `github.com/benji-hix/rain-settlement` main: `pack/mods/custom-time-cycle.pw.toml` deleted, `pack/index.toml` no longer references it, `pack/pack.toml` version bumped, the mirror ledger gets a correction note (Phase 4).
- S5. Both repos pushed. A fresh Prism launch of each instance completes the packwiz pre-launch step and the mod is not in the instance's `mods/`.

## Assumptions ledger

| # | Assumption | Load-bearing? | Cheapest validation |
|---|---|---|---|
| A1 | Nothing else on the Open-Air server provides `fabric-permissions-api-v0`. | Yes. If another jar nests it, the crash persists. | Phase 0 step 3: grep the last boot log's mod tree. Verified 2026-09-04 in the crash report: only `customtimecycle` nests it. |
| A2 | Custom Time Cycle stores nothing in world data; removing it leaves world time consistent. | Medium. Wrong means a time jump on first boot, not corruption. | Phase 0 step 4: list `world/data/` for any `customtimecycle*` file. None expected. |
| A3 | The server is hibernated (autoHibernate=true) when the jar is deleted, so no restart is needed and nobody is kicked. | Yes for safety. | Phase 2 step 1: `get_player_activity` and `get_server` state before touching files. |
| A4 | `packwiz` is installed locally at `/Users/benji/go/bin/packwiz`. | Yes for Phases 3 and 4. | `packwiz --version` prints a version. |
| A5 | Balm skips its permissions integration entirely when `fabric-permissions-api-v0` is not loaded, so Waystones needs no config change. | Yes for S2. | S2 itself is the test. Fallback if wrong: pin Waystones' `WaystonePermissionManager`-related config off is not available; report back instead. |
| A6 | Rain Settlement has no dedicated server; it is the local dev pack synced by Prism from GitHub main. | Yes for scoping Phase 4. | `rain-settlement/README.md` lines 1-10 say so. No `.fadehost.env` in that repo. |

## Phases

### Phase 0: Verify assumptions (10 minutes, read-only)

- **Work**
  1. From `/Users/benji/Code/open-air-settlement`: `packwiz --version`.
  2. Confirm SFTP works and note the current mod count (expected 117):
     ```
     python3 - <<'EOF'
     import paramiko
     env={}
     for line in open('.fadehost.env'):
         line=line.strip()
         if '=' in line and not line.startswith('#'):
             k,v=line.split('=',1); env[k.strip()]=v.strip().strip('"')
     t=paramiko.Transport((env['host'],int(env['port']))); t.connect(username=env['username'],password=env['password'])
     s=paramiko.SFTPClient.from_transport(t)
     mods=s.listdir('mods'); print(len(mods), [m for m in mods if 'customtimecycle' in m])
     print([c for c in s.listdir('config') if 'customtimecycle' in c])
     print([d for d in s.listdir('world/data') if 'time' in d.lower()])
     t.close()
     EOF
     ```
     Expect: `117 ['customtimecycle-fabric-0.1.6-1.21.1.jar']`, `['customtimecycle.json']`, `[]`.
  3. Download `logs/latest.log` the same way (`s.get('logs/latest.log', ...)`) and run `grep -n "fabric-permissions-api" latest.log`. Expect exactly one hit, indented under `customtimecycle`. Any other parent mod means A1 is false: stop and report.
- **Judgment calls**: none.
- **Dependencies**: `.fadehost.env` present (gitignored, never print its contents). Use `tools/fadehost-mcp.sh` for MCP calls and a Python heredoc for SFTP; do not build inline `curl -H "X-API-Key: ..."` commands (the auto-mode classifier blocks those).
- **Exit criteria**: all three expectations above met.

### Phase 1: Repo change, Open-Air (15 minutes)

- **Work**, from `/Users/benji/Code/open-air-settlement` on branch `main` (or a branch named `remove-custom-time-cycle` if you prefer a PR; either is fine):
  1. `cd packwiz && packwiz remove custom-time-cycle && cd ..`  
     If `packwiz remove` reports no match, run `git rm packwiz/mods/custom-time-cycle.pw.toml` and then `cd packwiz && packwiz refresh && cd ..`.
  2. `git rm server-config/customtimecycle.json`
  3. Bump `packwiz/pack.toml` `version = "1.0.34"` to `"1.0.35"`, then `cd packwiz && packwiz refresh && cd ..`.
  4. Verify: `grep -rn "custom-time-cycle\|customtimecycle" packwiz server-config` prints nothing.
  5. Docs (surgical edits, keep existing wording style):
     - `docs/CHANGELOG.md`: add at the top. The file's newest entry is 1.0.32 while `pack.toml` is already 1.0.34 (1.0.33 and 1.0.34 were commit-message-only, see `git log`). Do not backfill them; just add 1.0.35 above 1.0.32.
       ```
       ## 1.0.35 — 2026-09-04

       - Removed Custom Time Cycle (server-side). Its 0.1.6 jar bundles fabric-permissions-api 0.3.3, built for Minecraft 1.21.2+; Fabric Loader picks that copy over the 1.21.1-compatible one, so any permission check (Waystones via Balm on placing or editing a waystone; Polymer before it was removed) crashed the server with `NoSuchMethodError ServerPlayer.method_64396`. Day and night return to vanilla length. Deleted `server-config/customtimecycle.json`.
       ```
     - `docs/DESIGN-CONTEXT.md` line 44, replace the `**Custom Time Cycle:**` bullet with:
       `- **Custom Time Cycle:** removed in 1.0.35. The 20/12-minute day/night was liked, but 0.1.6 ships a fabric-permissions-api built for 1.21.2+ that crashed the server on every waystone edit. A replacement must not bundle fabric-permissions-api above 0.3.1, and must be checked with a waystone place/edit on the dedicated server before release.`
     - `docs/PACKWIZ.md` line 44: remove `server-config/customtimecycle.json` from the list of checked-in server settings.
     - `docs/decision-log.md`: append an entry `## 2026-09-04 — Custom Time Cycle removed (server crash on waystone edit)` with: the crash signature, the two crash-report filenames, the nested-jar finding (`customtimecycle-fabric-0.1.6-1.21.1.jar` → `META-INF/jars/fabric-permissions-api-0.3.3.jar`, which references `class_3222.method_64396`), the note that the 2026-08-28 crash reports were the same bug via Polymer, and the rollback (re-add via `packwiz modrinth add --project-id Xuf4fk5b --version-id AykEapdy`, re-upload jar and config).
  6. `git add -A && git commit -m "fix(packwiz): remove Custom Time Cycle, promote 1.0.35"` (repo convention; see `git log --oneline -5`). Do not push yet.
- **Judgment calls**
  - Remove rather than downgrade to 0.1.4: the mod author shipped a wrong nested library once already and Rain already had to pin around it; Benji chose removal.
  - Version bump to 1.0.35 (patch), matching prior single-mod changes.
- **Dependencies**: none.
- **Exit criteria**: step 4 grep empty; `git status` clean after commit; `packwiz refresh` exited 0.

### Phase 2: Server change, Open-Air (10 minutes, plus a boot)

- **Work**, from `/Users/benji/Code/open-air-settlement`:
  1. Check nobody is online and the server state:
     ```
     tools/fadehost-mcp.sh tools/call '{"name":"get_player_activity","arguments":{"server":"server_70ee525b4de6425e90f0c92fbe7c8cb1"}}'
     tools/fadehost-mcp.sh tools/call '{"name":"get_server","arguments":{"server":"server_70ee525b4de6425e90f0c92fbe7c8cb1"}}'
     ```
     If a player is online, stop and wait; do not restart under them.
  2. Over SFTP (same Python pattern as Phase 0):
     - write the current `mods/` listing to server root as `mods-pre-ctc-removal-<YYYYMMDD-HHMM>.txt` (matches the 2026-09-01 gravestones convention);
     - `s.get('mods/customtimecycle-fabric-0.1.6-1.21.1.jar', <scratch>)` and `s.get('config/customtimecycle.json', <scratch>)` as a rollback copy;
     - `s.remove('mods/customtimecycle-fabric-0.1.6-1.21.1.jar')`;
     - `s.remove('config/customtimecycle.json')`;
     - re-list `mods/`: expect 116 entries and no `customtimecycle`.
  3. Boot it: if `get_server` said stopped/hibernating, `tools/fadehost-mcp.sh tools/call '{"name":"start_server","arguments":{"server":"server_70ee525b4de6425e90f0c92fbe7c8cb1"}}'`; if it was running (someone joined between steps), use `restart_server` only after re-checking `get_player_activity`.
  4. After ~60 s, fetch `logs/latest.log`. Check:
     - `grep -c customtimecycle latest.log` → 0
     - `grep -c "fabric-permissions-api" latest.log` → 0
     - `grep -n "Loading .* mods:" latest.log` shows one fewer mod than the previous boot (previous: see Phase 0 log)
     - `grep -n "Done (" latest.log` → present
     - `crash-reports/` has no file newer than `crash-2026-09-04_10.37.00-server.txt`
- **Judgment calls**
  - Delete rather than rename in place: Fabric Loader still loads renamed `.jar` files in `mods/`; a `.disabled` suffix works but leaves clutter. The rollback copy lives in scratch and on Modrinth (`AykEapdy`).
  - Delete the config too: nothing reads it once the jar is gone, and the checked-in copy is being removed from the repo.
- **Dependencies**: server empty (A3). Benji available for step S2 in Phase 5.
- **Exit criteria**: all five log checks pass.

### Phase 3: Push Open-Air (2 minutes)

- **Work**: `git push origin main` (or open the PR and merge). Then confirm `https://raw.githubusercontent.com/Voraque/open-air-settlement/main/packwiz/pack.toml` shows `version = "1.0.35"`.
- **Judgment calls**: push after the server is verified, not before, so a client sync never runs ahead of a broken server.
- **Dependencies**: Phase 2 exit criteria.
- **Exit criteria**: raw URL shows 1.0.35.

### Phase 4: Rain Settlement repo (10 minutes)

- **Work**, from `/Users/benji/Code/rain-settlement` on `main`:
  1. `cd pack && packwiz remove custom-time-cycle && cd ..` (fallback: `git rm pack/mods/custom-time-cycle.pw.toml` then `packwiz refresh` inside `pack/`).
  2. Bump `pack/pack.toml` `version = "1.7.2"` to `"1.7.3"`, then `cd pack && packwiz refresh && cd ..`.
  3. `grep -rn "custom-time-cycle\|customtimecycle" pack` prints nothing. (The two `crash-*.txt` files at the repo root will still mention it; they are historical artifacts, leave them.)
  4. Append to `docs/pack-mirror-ledger-2026-09-01.md`:
     ```
     ## 10. Custom Time Cycle removed on both packs (1.7.3, 2026-09-04)

     Section 9c's conclusion was wrong. Open-Air's dedicated server crashed on 2026-09-04 with the same
     `NoSuchMethodError ServerPlayer.method_64396`, reached through Waystones → Balm's
     fabric-permissions-api integration, with Do a Barrel Roll absent. The nested
     fabric-permissions-api 0.3.3 in Custom Time Cycle 0.1.6 is reachable by any permission check, not
     only DABR's. Open-Air 1.0.35 removes the mod; Rain 1.7.3 removes it too (Rain's 0.1.4 pin nested
     0.3.1 and was not crashing, removal is for parity). Day/night length is vanilla on both packs.
     ```
  5. `git add -A && git commit -m "1.7.3: remove Custom Time Cycle (parity with Open-Air 1.0.35)"` (repo convention: `<version>: <summary>`), then `git push origin main`.
- **Judgment calls**: Rain drops the mod even though its pin was safe, because the README promises Rain mirrors Open-Air exactly.
- **Dependencies**: none on Open-Air, but do it after Phase 3 so the ledger's "Open-Air 1.0.35" claim is true when pushed.
- **Exit criteria**: step 3 grep empty; push done; `raw.githubusercontent.com/benji-hix/rain-settlement/main/pack/pack.toml` shows 1.7.3.

### Phase 5: In-game verification (needs Benji, 5 minutes)

- **Work**: Benji launches the Open-Air Prism instance (pre-launch sync must print `Deleted customtimecycle...` or simply no longer list it), joins `alpha.fadehost.net:26087`, places a waystone, opens its edit screen, renames it, closes it. Then in the FadeHost console or via MCP `get_console_logs`, confirm no crash; `crash-reports/` unchanged.
- **Judgment calls**: this is the only test that exercises the exact crash path; log checks alone do not prove S2.
- **Dependencies**: Phases 2 and 3.
- **Exit criteria**: S2 met. Report the result in `docs/decision-log.md` under the Phase 1 entry ("Verified in game 2026-09-0X" or "Not yet verified").

## Failure modes & mitigations

- F1. Another server jar also nests `fabric-permissions-api` ≥0.3.2 → early signal: Phase 0 step 3 shows a second parent → stop, report the jar name; the same removal logic applies to it only if Benji agrees.
- F2. A player joins between the SFTP delete and the boot check → signal: `get_player_activity` non-empty at step 3 → do not `restart_server`; the join itself boots the JVM fresh from the edited `mods/`, so just run the step-4 log checks.
- F3. `packwiz remove` cannot find the slug → fallback commands are listed inline in Phases 1 and 4. After the fallback, `git diff packwiz/index.toml` must show only the one removed block plus the `pack.toml` hash line.
- F4. World time visibly jumps after removal (A2 false) → signal: sudden day/night change on first join → harmless; note it in the decision log. Do not try to `/time set` to compensate.
- F5. Waystone edit still crashes (A5 false) → signal: new file in `crash-reports/` during Phase 5 → pull it, check whether the trace still contains `me.lucko.fabric.api.permissions`; if yes, find the jar that provides it (`grep` the boot log tree) and report; if the trace is different, that is a new bug, report it separately.

## Critical path

Phase 0 → Phase 1 → Phase 2 (server boot) → Phase 3 (push) → Phase 5 (Benji's test). Phase 4 is parallel to Phases 1-3 apart from its ledger wording. The only wait is Phase 5 on a human; everything else is under an hour of executor time. Nothing compresses further without skipping the in-game test, which is the one step that proves the fix.

## Replan triggers

- Phase 0 finds a second provider of `fabric-permissions-api` (F1).
- Phase 5 crashes with the same signature (F5).

## First 3 actions

1. From `/Users/benji/Code/open-air-settlement`, run Phase 0 steps 1-3.
2. Run Phase 1 steps 1-4 and commit.
3. Run Phase 2 steps 1-2 (check players, back up, delete over SFTP).
