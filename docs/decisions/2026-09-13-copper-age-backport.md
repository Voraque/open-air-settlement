# Copper Age Backport — prepared release 1.0.47

Live inventory check on 2026-09-13 found Copper Equipment 1.9.1 and Friends & Foes, but no Copper Age Backport on FadeHost or the active Prism client. Scanning client mod archives found golem content only in Friends & Foes. Copper Equipment provides gear, not the Copper Age item-sorting golem.

Added Copper Age Backport 0.1.4 (Fabric 1.21.1), Modrinth version FL44OinM, SHA-1 17777733974b4c3681b377aeb4a743d9d706b7ed. Retained existing mods to preserve their items and entities. The inspected pickaxe recipes differ: compressed copper for Copper Equipment, ordinary ingots for the backport.

A disposable Minecraft 1.21.1 / Fabric 0.19.3 server included both copper mods, Friends & Foes 4.0.27 with its Resourceful Lib dependency, and More Slabs Stairs & Walls 4.2.0. Summoned minecraft:copper_golem; placed eight iron ingots in a copper chest and one in a regular chest. After 2400 simulated ticks, the regular chest contained nine iron ingots. Both required assertions passed and the server stopped cooperatively.

Evidence: local validation run 20260914T060523Z-ec7c6b93. This verifies entity registration and actual item sorting in the selected compatibility fixture. Player-built pumpkin spawning, rendered appearance, oxidation, and the complete production pack were not exercised. Upstream creation logic expects a carved pumpkin placed by a player on a copper block and leaves a copper chest. The test emitted an upstream missing minecraft:incorrect_for_copper_tool tag warning; copper-tool harvesting behavior was not validated.

Deployment remains pending the same server/client restart window as the slab addition. No live server files changed.

Source: https://modrinth.com/mod/backport-copper-age
