# Player visibility — release 1.0.37

Adds Player Locator Plus 2.4.0 to both clients and the server for Fabric 1.21.1.
The bar points toward other players without needing a minimap. Player heads remain
visible, markers neither shrink nor fade with distance, and crouching does not hide
players. Invisibility and disguise equipment retain their default hiding behavior.
Hold Tab to show names on the locator. Tracking is within the same dimension.

Xaero's default radar profile now gives players 1.5x heads, always-visible names,
larger fallback dots, no height fading, and permission to render over the map frame.
Other entity categories are unchanged. This improves loaded player markers; it does
not extend Xaero's tracking range. The locator handles distant-player directions.

Both clients must update and restart Minecraft. The server jar and configuration
are staged and require a server restart. The launcher setup scripts in tools configure
the shared pack updater; existing installations must have that updater enabled.

Validation: publisher SHA-512 matched; dependencies match the existing Fabric API
and Cloth Config 15.0.140. A disposable local server containing 39 mod jars reached
Done, loaded player-locator-plus 2.4.0, accepted the intended configuration, and
shut down with exit code 0. This is startup compatibility evidence, not an in-game
visual or full-current-server compatibility test. Verify both clients can see each
other on the locator after the live restart, including beyond entity render distance.

Source: https://modrinth.com/mod/player-locator-plus
Rollback: remove its pack entry and both configs, restore the preceding Xaero radar
profile, remove the locator jar from server/clients, and restart. No world conversion
is involved.
