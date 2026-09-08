# Book-first crafting and maintained village systems

September7,2026. Pack1.0.41 prepared and tested; server activation follows terrain generation and a fresh empty-server backup. No claim of live activation yet.

## User direction

Prefer crafting through the recipe book, but retain every available recipe and material-use explanation in game. Reduce duplicate systems. Include Jade and Presence and audit missed installation requests. Rebalance villagers using existing maintained systems rather than a custom economy implementation. The briefly explored custom trade-table/resource-mod prototype was withdrawn; none of it is shipped.

## Crafting and inventory

Better Recipe Book1.10.0-rc5 supports our1.21.1 Fabric client. It shows undiscovered recipes, pins favorites, keeps the screen centered, separates grouped recipes and offers the instant-craft toggle. Instant crafting starts off so a normal recipe click fills the grid; the lightning toggle makes it one-click crafting. JEI remains installed with its full recipe/use lookup and modded machine integrations; its item pane is narrowed to four columns. R and U on inventory items remain the reference workflow. Do not replace JEI with the vanilla book: non-book recipes and items without recipes still need an encyclopedia.

IPN remains the sole general sorter and depleted-stack refill owner. Its continuous-crafting checkbox and remembered enabled state are disabled. The previous failed-replacement alert overrides used nested objects, but libIPN expects primitive booleans: the shipped settings correct that format. This fixes the configuration defect; actual tool swapping and refill with the player's gear are still an interactive acceptance check. Nemo's local-only sorter was moved to a private rollback folder. Mouse Tweaks, Crafting Tweaks, Tom's Storage and backpacks keep their distinct roles. Do not add another stack-refill mod merely to duplicate IPN.

A normal book plus paper crafts Settlement Field Notes containing the crafting, storage and trading explanation. This is documentation data only, not a custom trade engine. It loads through Paxi with ordinary recipes and is visible through BRB/JEI. Client-rendered page layout and book/JEI keyboard interaction still need play testing.

## Village implementation

Use Shifting Wares3.1.1, VillagerConfig4.5.4, their published compatibility addon2.1.0, and the unchanged upstream Sensible Trade Overhaul datapack pinned by hash. Data Trades is retired to avoid a competing trade provider. The Dynamic Villager Trades teaching fork and settlement-origin prototype remain experiments; no custom teaching, adoption, happiness, or simulation code ships.

The first daily restock rotates stock. Depletion-triggered extra rerolls are disabled. Explorer-map rerolls remain disabled. VillagerConfig caps discounts at25%, keeps normal price increases and restocking, and retains vanilla zombie-conversion chance. These are ordinary upstream options. Both protections intended to stop workstation rerolls are requested, but actual profession-reset tests show that protection is unreliable for custom VillagerConfig offers with this addon. This is an explicitly accepted upstream compatibility limitation, not a passing assertion. Daily stock rotation and trade balance remain independently tested. Do not describe kidnapping/trading halls/iron farms as disabled: they are not.

Sensible Trade Overhaul supplies all trade prices/stock unchanged. Among its options, journeyman armorers can sell3 iron for8 emeralds and master masons offer building resources; diamond smith equipment is removed, while a costly diamond resource trade remains. Enchanting Infuser stays the primary controllable enchantment route. Higher tiers require leveling through ordinary trades. Existing entities are not deleted or globally trade-reset; their stored offers transition through the mod's ordinary restocks/level-ups. Preserved old deals may not all disappear immediately.

The stock content is upstream authored and pinned. Paxi loads it from config/paxi/datapacks, fixing the original ineffective root-datapack installation. Paxi's broad root-directory scan is disabled, so the old warehouse command pack is not accidentally activated. Only the already approved open-air-resources and the small field-notes documentation pack are additionally loaded.

## Install-request reconciliation

- Presence2.3.1: exact requested ambient mod, newly included on both sides. This supersedes the earlier local-only Null Signals experiment; two overlapping anomaly systems are not added. Minimum roll interval1200 seconds; forced nearby hostile spawns, mob-to-killer replacement, and difficult-mob spawning disabled. Bounded64-block/32-vertical checks enabled. Event logging enabled for evidence. No production event is manually triggered.
- Jade15.10.6: existing local version now pinned in shared pack and staged server-side for server-supplied information.
- JEI WorldGen1.4.4: newly pinned on both sides; replaces local/server1.1.2 on activation.
- RightClickHarvest4.6.1 and JamLib: restored the requested crop-harvest capability. No hoe requirement; single-crop harvest (radius off), no extra XP or hunger system layered over CropXP.
- Fishing Real, Carry On, InvMove/InvMoveCompats: already published1.0.40; two server additions still waiting for activation after terrain work.
- Sit/chairs, player locator, Moving Elevators, gliding bridge, Dynamic Trees/Blooming Nature addon and approved YUNG set: present in shared manifest; terrain-release server versions were verified earlier this session.
- Automatic updater: shared Prism setup targets public pack.toml. Earlier local-only additions explain differences from the shared pack; the pack now owns the additions above.
- Dynamic Life, Recipe Book is Pain, village-origin enforcement and the old teaching fork were comparison/experiment topics, not missing approved installations. Better Recipe Book is selected instead of stacking both book replacements.
- Iron-farm prohibition, recursive storage autocrafting, and a second refill mod are not installed or claimed. The requested refill audit is handled through the existing IPN owner.

## Validation boundary

Pinned downloads verified against metadata; game/loader/dependency requirements inspected. Dedicated full-pack tests use real villagers, vanilla level-up/restock calls and entity NBT roundtrips, not hand-assigned fake offers. They check finite stock, smith gear balance, upstream iron price, resource availability, daily librarian changes, profession-reset behavior and nonempty modded-profession offers. The profession-reset check reports a known negative result instead of being claimed as fixed. Test-only Java stays out of production artifacts. Startup validation does not prove rendered-client UI or a player-driven Presence event.

## Sources and selection

- https://modrinth.com/mod/brb — book features and versions.
- https://modrinth.com/mod/shifting-wares — daily/depletion rotation, maps and workstation design.
- https://modrinth.com/mod/shiftingwares-villagerconfig-addon — supported bridge and its limitations.
- https://modrinth.com/datapack/sensible-trade-overhaul — upstream offer design and removal of diamond equipment.
- https://modrinth.com/mod/dynamic-villager-trades — considered specialization alternative; not selected because it adds a less visible learning system and would need a different trade data format.
- https://www.reddit.com/r/Minecraft/comments/1qcolsy/prepping_for_the_trade_rebalance/ — player concern that biome-bound books still encourage relocation/breeding instead of pleasant village visits; commentary, not implementation proof.
- https://www.reddit.com/r/Minecraft/comments/1rdkljq/if_mojang_hates_trading_halls_why_do_they_keep/ — mixed player experiences of grind and progression bypass; anecdotal design input.
- https://modrinth.com/mod/paxi — established datapack loader.
- https://www.curseforge.com/minecraft/mc-mods/presence-an-ambient-horror-mod — exact Presence project.

Final dedicated test reached readiness, completed all accepted assertions, found10 offers for each of7 modded professions, and exited0. The workstation-reset limitation remains false. See the adjacent sanitized test result.
