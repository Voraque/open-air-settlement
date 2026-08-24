# Sharing and updating Open-Air Settlement

## The practical path

Use GitHub as the source of truth and publish numbered releases. Each release contains:

- a CurseForge profile zip for the easiest import;
- a Modrinth `.mrpack` for Modrinth App, Prism, and ATLauncher;
- the guide and the exact design notes for collaborators.

Both players update to the same numbered release before joining. Do not update individual gameplay mods from inside a launcher: that is how client/server mismatches and shader dependency conflicts happen.

The current release is **1.0.5**. It is built from the active client, including Critters and Companions and Hostile Harmony. The server uses the same gameplay set, with client-only rendering and convenience mods omitted where appropriate.

## Why not just share a CurseForge code?

CurseForge export/import is convenient for a snapshot, but it is not a shared update channel. A new export has to be sent again. A direct `.mrpack` has the same limitation unless it is published as a project with an update path.

For our small private group, GitHub Releases are the least surprising versioned handoff: Benji can download the latest release, import the matching file, and see the guide and change notes beside it.

## The next upgrade: packwiz

If we want one-click updates instead of importing a new file, the established next step is **packwiz**. It keeps one editable pack manifest, records exact file hashes, can export both CurseForge and Modrinth formats, and can be hosted from a private Git repository. That gives us a single place to update the pack while keeping launcher-friendly exports for people who do not use packwiz.

We are using the numbered release files first because they are immediately understandable and rollback-friendly. Packwiz should become the canonical editable format once we are ready to make frequent changes; the generated files should remain as release artifacts.

## World migration

The old singleplayer save was read without editing it. The host's meaningful player file was copied into the new server world, with the arrival position reset to `(0.5, 101, 0.5)` so the player does not spawn inside terrain. Items found in the old base chests and furnaces are being reconstructed in a stockpile warehouse near spawn. Maps are included, but their explored terrain belongs to the old world and may not be useful in the new one.

The new server world is named `open-air-settlement-scenic` and uses seed `-1549229570210257776`. The seed was recommended for Terralith/Tectonic terrain in an older Minecraft version; it is a good candidate, not a promise that every vista will match the reference screenshots.

The server world, player data, LAN address, logs, and personal settings stay off GitHub. Only the pack, guide, and reproducible release notes belong in this repository.
