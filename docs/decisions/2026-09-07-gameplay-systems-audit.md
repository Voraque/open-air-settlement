# Gameplay systems audit — September 7, 2026

Historical snapshot before1.0.41. See [the subsequent implementation](2026-09-07-book-first-and-villagers.md) for corrections and staged additions.

Read-only inspection of shared pack1.0.39, local Prism client jars/configuration, live FadeHost mod list/configuration, and saved enabled datapack list. No gameplay changes made.

## Inventory
Local client loads both Inventory Profiles Next2.2.6 and Nemo inventory sorting1.8.2.1. Shared manifest includes only IPN. Nemo enables its sorting/movement buttons; this is real overlap. Mouse Tweaks handles gestures, Crafting Tweaks handles the grid, Tom's Storage handles connected inventories, and Traveler's Backpack supplies portable storage. Proposed cleanup: one general sorter (IPN), keeping those distinct roles.

The local IPN JSON contains visual/audio failed-replacement notification overrides set to false, but no tool replacement/durability behavior override. This is evidence of attempted alert suppression only, not a validated fix; no shared IPN configuration is present. The earlier copper-pickaxe warning matches IPN's shipped replacement-failure string. Reproduce with a nearly broken tool and compatible spare before claiming resolved. Do not assume the nested JSON overrides were accepted by the running client.

## Villagers
Live VillagerConfig4.5.4: max_discount100, max_raise100, conversion_chance-1, trade_cycling true, infinite_trades false. Data Trades3.0.1 is installed; it is a customization framework. Sensible Trade Overhaul is declared in the repository but absent from the live world datapack directory and saved enabled list. Experimental trade_rebalance is disabled. Dynamic Villager Trades teaching fork and settlement-origin prototype are absent from live mods.

Use ordinary emerald barter with employed villagers, trade to level them, and preserve access to their workstation for restocking. Existing mod additions mean offers are not purely vanilla: RPG professions and gear trades, Supplementaries trades/red merchant, and additions from other installed mods remain relevant. No full census of individual villagers' saved offers was performed. Existing offers may retain prior history. The old ecology decision is experiment evidence, not an active gameplay manual.

## Creature farming
No dedicated iron-golem-farm restriction was found in installed mods or live custom datapacks. VillagerConfig's active options do not discourage trading halls or golem farms. Cave Spelunking is active: normal surface ore chance100%, hidden-ore chance1%, large iron/copper vein density1.0. Cave exploration and iron veins are the existing alternative, not a renewable replacement matched to farm output. Craftable Gunpowder and CropXP are installed alternatives for some mob resources/XP. The repository's open-air-resources datapack (including zombie iron loot) is absent from the live enabled datapack list. Proposed policy: improve exploration/trade access to materials first, then consider narrowly removing iron golem iron drops while preserving village defenders; this is not implemented or approved as a new balance change.

## Crafting interfaces
Vanilla recipe book is a recipe/unlock interface, not an all-item encyclopedia. JEI is the broad item and recipe browser; R recipes, U uses, plus transfers ingredients on supported screens. Transfer is not unattended production. IPN's shipped text identifies continuous crafting as grid ingredient refill with an additional held shortcut for auto crafting. Crafting Tweaks adds grid operations. Tom's terminal searches connected stock, not every registered item.

Better Recipe Book adds brewing/smithing books, pins, optional locked recipes and instant crafting (https://modrinth.com/mod/brb). Recipe Book is Pain reorganizes book categories using creative tabs (https://modrinth.com/mod/rbip). Both list Fabric1.21.1 availability; neither is installed or tested in this pack. Neither replaces JEI's general item/mod-machine coverage. Prefer retaining JEI and reducing redundant controls; consider BRB only if the user prefers the recipe-book workflow. No compatibility claim for stacking BRB and RBIP.

## Jade and Presence
Jade15.10.6 is in local Prism and appears in its client log, but absent from shared pack manifest/index and live server jars. Benji does not receive it from the shared updater today. Server support would enable additional server-supplied details; client-only installation still has useful information.

Neither Presence nor Null Signals/static_mod is in the current server, shared manifest or local client. Historical memory records a September4 Null Signals chatless installation on a different local server; that is not evidence it reached FadeHost. Current server cannot generate those mods' events. No current event data was found; earlier historical events cannot be ruled out without the older instance's logs/state. No signs should be expected from that absent mod now. No anomaly was triggered for testing.

## DH snapshot
At00:04 UTC September8 (17:04 Pacific September7), radius128 pregen was18.29% complete at approximately9 chunks/second. Estimated95 minutes remaining for stage1 fluctuates and excludes later256-radius expansion. Disk2.33/10GB; memory3331/4096MB. Server online and hibernation disabled. Generation continues despite intermittent block-attached-entity placement messages; those are not a verified all-clear for generated decorations. Existing monitor remains responsible for progress, health and disk checks.
