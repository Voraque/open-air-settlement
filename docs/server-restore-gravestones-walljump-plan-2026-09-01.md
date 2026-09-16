# Plan: the FadeHost server runs Gravestones and Wall-Jump at the exact pack versions, so deaths leave a recoverable grave and wall-jumping works in multiplayer

Handoff for an executing model. All judgment calls are made below; execute in order. Written 2026-09-01.

## Context the executor needs

- Repo: `/Users/benji/Code/open-air-settlement`. Pack manifest is `packwiz/mods/*.pw.toml`; each file carries the exact jar filename, download URL, and hash.
- Server: FadeHost, Fabric 1.21.1 / Loader 0.19.3, reachable by SFTP only. Credentials are in `.fadehost.env` at the repo root (keys `host`, `port`, `username`, `password`; gitignored). Read them inside a script; never print them. `paramiko` 5.0 is installed for `python3`; `sftp`/`expect` also exist.
- Server layout: `mods/` (113 jars), `config/`, `logs/latest.log`, `server.properties` (`level-name=world`). Prior backups follow the pattern `mods-pre-<version>-<YYYYMMDD-HHMM>/`.
- The server reads mod configs at boot. The panel has `autoHibernate=true`: the JVM stops when empty and boots fresh when a player joins. No manual restart is needed if the server is empty; if a player is online, the change waits until they leave and someone rejoins.
- Tooling caveat: in this environment, SFTP reads have always been allowed, but the first SFTP write attempt was denied by the permission classifier and succeeded when retried as a standalone command that did nothing else. Keep uploads in their own command.
- Scratch space: `/private/tmp/claude-501/-Users-benji-Code-open-air-settlement/<session>/scratchpad`. Do not download into the repo.

## Success criteria

- `mods/` on the server contains exactly these three additional jars, byte-identical to the manifest hashes: `gravestones-1.2.6+1.21.1+A.jar`, `pneumonocore-1.3.1+1.21+A.jar`, `walljump-1.21.1-1.3.8-fabric.jar`.
- After the next boot, `logs/latest.log` lists `gravestones 1.2.6`, `pneumonocore 1.3.1`, and `walljump 1.21.1-1.3.8-fabric` in the loaded-mods block and reaches `Done (` with no crash report.
- `config/gravestones.json` and `config/walljump.json5` on the server are identical to the client copies in the Prism instance and are tracked in `server-config/`.
- In-game: a survival death leaves a gravestone the owner can open; pressing jump while touching a wall performs a wall jump on the server.
- `docs/decision-log.md` records the change.

## Assumptions ledger

| # | Assumption | Load-bearing? | Cheapest validation |
|---|---|---|---|
| A1 | All three mods are needed server-side, not client-only. | Yes | Already validated: each jar's `fabric.mod.json` has `environment: "*"`, and packwiz marks all three `side = "both"`. Gravestones must run on the server to spawn graves. Wall-Jump TXF ships a server config (`enableWallJump` etc.) that the server is expected to sync; whether the client refuses to wall-jump without the server mod is unverified, so Phase 4 confirms it. |
| A2 | Gravestones 1.2.6 has no runtime conflict with the 113 jars already on the server. | Yes | The same 116-jar set runs on Benji's client every session without error. Phase 3 boot log is the confirming check. |
| A3 | The stale `config/universal-graves/` folder on the server is inert. | No | Universal Graves and Polymer were removed from the pack on 2026-08-28 (commit `3bba3f7`); neither jar is on the server. Leave the folder; it is not read by anything. |
| A4 | `keepInventory` is false on the server, so gravestones are exercised. | Yes for the in-game test | Phase 4: read `world/level.dat` gamerule or run the death test and observe. |
| A5 | The two hash formats in the manifest (sha256 for gravestones and pneumonocore, sha512 for walljump) are what the URLs serve. | Yes | Phase 1 verifies each download against its stated `hash-format`. |
| A6 | Benji will accept the client config values as the server values. | No | Both configs were already tuned client-side (gravestones: owner-only access, 8-day decay, XP stored; walljump: wall jump on, double jump off). Copying them is the least-surprise choice. |

## Phases

### Phase 0: Confirm current state (read-only, 5 min)

- **Work**: Over SFTP, list `mods/` and confirm the three jars are absent. Read the tail of `logs/latest.log` to learn whether a player is online (`joined the game` without a later `left the game`). Read `config/` listing.
- **Judgment calls**: None.
- **Dependencies**: SFTP credentials.
- **Exit criteria**: Three jars confirmed absent; player-online status known.

### Phase 1: Fetch and verify jars (10 min)

- **Work**: For each of `packwiz/mods/gravestones.pw.toml`, `pneumonocore.pw.toml`, `wall-jump-txf.pw.toml`, read `filename`, `url`, `hash-format`, `hash`. Download each URL into the scratchpad with `curl -L`. Verify with `shasum -a 256` or `shasum -a 512` per the stated format. Abort on any mismatch.
- **Judgment calls**: Source is the packwiz manifest, not Modrinth search, so the server gets the exact bytes the clients run. Rationale: client/server version drift is the pack's number-one historical failure mode.
- **Dependencies**: Modrinth CDN reachable.
- **Exit criteria**: Three files in scratchpad, all hashes match.

### Phase 2: Stage configs (10 min)

- **Work**: Copy `gravestones.json` and `walljump.json5` from `/Users/benji/Library/Application Support/PrismLauncher/instances/Open-Air-Settlement/minecraft/config/` into `server-config/` in the repo. Diff them against the repo copies if any already exist (none do today).
- **Judgment calls**: Ship the client configs to the server unchanged (A6). Do not touch `spawn_gravestones_with_keepinv` or any other value.
- **Dependencies**: None.
- **Exit criteria**: `server-config/gravestones.json` and `server-config/walljump.json5` exist and match the Prism copies byte-for-byte.

### Phase 3: Upload and boot (15 min plus wait for hibernate cycle)

- **Work**:
  1. Write a manifest of the current `mods/` listing to the server as `mods-pre-gravestones-walljump-<YYYYMMDD-HHMM>.txt` at the server root. A jar-only addition needs no jar backup; the rollback is deleting three files.
  2. Upload the three jars to `mods/` in one standalone command. Re-list `mods/` and confirm sizes match the local files.
  3. Upload the two config files to `config/` in a second standalone command.
  4. If the server is empty, it boots on next join. If a player is online, wait for them to leave, then have Benji or the executor join to trigger the boot. Do not restart from the panel while someone is playing.
  5. After boot, read `logs/latest.log`: confirm the boot timestamp is after the upload, the three mods appear in the mod list, and `Done (` is reached. Check `crash-reports/` for a new file.
- **Judgment calls**: Trigger the boot by hibernate cycle rather than panel restart. Rationale: the panel API has been unreliable from this environment and a restart with a player online loses their session.
- **Dependencies**: Server empty at some point; a player to trigger the boot.
- **Exit criteria**: Boot log shows all three mods loaded, no crash report, `Done (` present.

### Phase 4: In-game verification (10 min, needs a player)

- **Work**: In survival, away from the settlement: (a) wall jump against any wall and observe the jump and falling sound; (b) drop a junk item into the hotbar and die (fall or `/kill` if the tester is an operator), then confirm a gravestone appears at the death point, opens for the owner, and returns the item and XP. Confirm a second player cannot open it (`gravestone_accessible_owner_only` is true).
- **Judgment calls**: Use a throwaway item, not real gear, for the death test. If `keepInventory` turns out to be true (A4), the grave test is skipped and noted; do not change the gamerule without Benji.
- **Dependencies**: One player online; ideally two for the owner-only check.
- **Exit criteria**: Both mechanics observed working, or a specific failure recorded with the log excerpt.

### Phase 5: Record (5 min)

- **Work**: Append an entry to `docs/decision-log.md`: date, what was missing, what was uploaded (filenames and hashes), config copies added to `server-config/`, boot verification result, in-game result. Leave the remaining three missing jars (movingelevators and the two supermartijn642 libraries) as an explicit open item; they are out of scope here.
- **Judgment calls**: Do not commit; Benji commits.
- **Exit criteria**: Decision log entry present; `git status` shows only the intended new files.

## Failure modes & mitigations

| Probable failure | Early signal | Mitigation |
|---|---|---|
| Hash mismatch on download (CDN version replaced or URL rot) | Phase 1 `shasum` differs | Stop. Report the URL and both hashes. Do not upload an unverified jar. |
| Server boot crash from Gravestones or Pneumonocore | New file in `crash-reports/`, or `latest.log` stops before `Done (` | Delete the three jars over SFTP, rejoin to trigger a clean boot, attach the crash report to the decision log. A2 says this is unlikely since the client runs the same set. |
| Upload denied by the permission classifier | Tool call rejected with a classifier message | Retry the upload as its own command with nothing else in it. If denied twice, stop and tell Benji which step needs a permission rule. |
| Server never hibernates because a player stays online | `latest.log` shows a join without a leave for hours | Ask Benji to log out and back in; do not force a restart. |
| Wall jump works locally but not on the server | Phase 4 jump fails while the client single-player works | Compare `config/walljump.json5` on the server to the client copy; `enableWallJump` and `useWallJump` must both be true server-side. |
| Gravestone spawns but the item is missing | Grave opens empty | Check `spawn_gravestones_with_keepinv` and the `keepInventory` gamerule; if keepInventory is true, no items were ever at risk and the test is moot. |

## Critical path

Phase 1 (fetch + verify) → Phase 3 step 2 (upload) → hibernate cycle → Phase 3 step 5 (boot log) → Phase 4 (in-game).

The only uncontrollable wait is the hibernate cycle. It compresses to zero if the server is already empty when the upload lands, so do Phases 0 through 2 first and upload the moment the server is empty. Everything else is minutes.

## First 3 actions

1. Run the Phase 0 SFTP listing and log tail; note whether a player is online.
2. Download the three jars from the manifest URLs into the scratchpad and verify hashes.
3. Copy `gravestones.json` and `walljump.json5` from the Prism instance into `server-config/`.
