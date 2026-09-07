# Stair seating - release 1.0.38

Adds Sit 1.21-28 (Fabric, Minecraft 1.21/1.21.1) on both client and server.
Right-click the top of a right-side-up stair or bottom slab with an empty hand
to sit; use the normal dismount key (Shift by default) to stand up. No chair item
or recipe is needed. Standard stairs/slabs supplied by mods are generally supported.

Source and controls: https://modrinth.com/mod/bl4cks-sit
Pinned release: https://modrinth.com/mod/bl4cks-sit/version/uQnamhq3

Validation: downloaded jar matches publisher SHA-512; existing Fabric API and
Cloth Config satisfy its dependencies. The isolated 40-jar server test loaded
Sit and Player Locator Plus together and reached Done. Visual seating behavior
with real clients remains to be checked after activation.

Deployment: the verified jar is installed on the live server and local client,
and included in the shared updater. The user requested no server restart yet;
activation waits for a later authorized restart. Both players should relaunch
Minecraft to install the shared update before joining the restarted server.
Rollback: remove Sit from the manifest and installed mods, refresh the pack,
and restart. Preserve a world backup before any mod removal.
