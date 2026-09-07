# Server backups

The GitHub repository is public. **World archives stay on the local computer.**
Only this tooling, restore instructions, and sanitized success records belong in GitHub.
Worlds and settings contain player information, builds, inventories and potentially passwords.
Do not commit archives, extracted server files, credentials, or the private file manifest.

## Schedule and storage

A Codex task checks nightly at 4 a.m. America/Los_Angeles. The computer must be awake,
connected, and Codex available for the task to run. This is not an always-on hosted backup.
The check defers when players are online or the server state is uncertain.
Snapshots are stored in `C:\Minecraft\Open-Air-Settlement-Snapshots\scheduled-server`.
Copies are retained; the tool refuses a new backup when there is insufficient free space.
No automatic deletion is enabled. Review retention as storage grows.

Each snapshot contains the active world, installed mods, configuration, and available
server settings and access lists. Java, downloaded libraries, logs, caches outside the
world, and launcher binaries are excluded. Restore requires a matching Fabric 1.21.1
installation with Java 21. This is a game-data snapshot, not a full machine image.

The tool checks the public Minecraft player count twice, stops the empty server using
FadeHost's save-aware stop operation, waits for it to be offline, downloads the selected
files, and restarts it. There is a small join race between the last check and the stop.
An already offline server can also be backed up and stays offline.
A failed transfer still attempts to restart a previously online server. Every archived file is then read
back and checked against SHA-256 before the archive is marked verified.
Failed `.partial` archives are not backups. A retained `backup.lock` requires inspection
of server state and the previous failure before removing it; do not bypass a live lock.
The first SFTP host key is saved locally; subsequent runs reject a changed key.

## Run manually

Requires Python 3.11+ and Paramiko (see `tools/backup-requirements.txt`). Credentials
are supplied via local files; never put their values in command arguments or GitHub.
SFTP environment file keys: `host`, `port`, `username`, `password`.
Panel environment file key: `token`.

```powershell
python tools/backup-server.py `
  --panel-env '<private panel environment file>' `
  --sftp-env '<private SFTP environment file>' `
  --server '<FadeHost server ID>' --host '<Minecraft hostname>' --port 25565 `
  --destination '<private local backup directory>' `
  --dependencies '<directory containing installed Paramiko>' `
  --record 'docs/backups/latest.json'
```

Add `--check` for a read-only preflight. A deferred run is not a successful backup and
must not overwrite `latest.json`. Only publish an allowlisted success record: creation
time, archive basename, sizes, file count, checksums, verification, and restart result.
The full manifest inside the archive remains private. Records prove archive integrity,
not an in-game restore test. GitHub alone cannot restore the world.

## Restore

1. Stop the destination server. Preserve its current world and settings in a separate
   local snapshot before changing anything. Prefer testing in an isolated server first.
2. Compare the ZIP's SHA-256 with its adjacent JSON receipt. Open the archive and verify
   each file against `BACKUP-MANIFEST.json`; do not use a partial or mismatched archive.
3. Install the matching Minecraft/Fabric version and Java 21. Move the destination's old
   world, mods and configuration aside, then extract the snapshot into the server root.
   Avoid merging old and new mod jars or world files.
4. Review restored `server.properties`, access lists and secrets for the destination.
   Keep them private. Confirm `level-name` points to the restored world.
5. Start the server and check its log for a completed startup. Join it and verify builds,
   inventory and dimensions. Keep the previous snapshot until this test succeeds.
