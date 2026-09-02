# Lightning Expansion v1 — working notes (2026-09-01)

Decision: build as a tiny Fabric mod (path 1a), executed in Claude Code. Not started.

## Scope
Lightning spell school: spells + Spell Binding Table book, lightning staff/wand, 4-piece robe set. Art = programmatic recolors of Wizards assets plus hand pixel tweaks. No More Wizards assets (ARR, old schema).

## Environment (from mods-list.txt)
- Fabric, MC 1.21.1
- spell_engine 1.10.3, spell_power 1.6.0, wizards 3.1.1, runes 1.3.2, azurelibarmor 3.1.3, more_rpg_library 2.7.1, elemental_wizards_rpg 3.1.0, bettercombat 2.4.0, accessories 1.1.0-beta.53, trinkets 3.10.0
- Server: fadehost. Datapack on server + client; resource pack/mod jar on all clients.

## Findings
- More Wizards 0.1.8 (Jan 2026) targets Spell Engine 1.8.19. Spell Engine 1.9.0 (Feb 2026) broke SpellContainer (`content`/`is_proxy` → `access`/`access_param`/`extra_tier_binding`) and moved spell-book generation to tags `<ns>:spell_books/<name>`. Rejected.
- More Wizards 0.1.8 manifest also requires More Craftings of Runes, Elemental Metals, Dragonsteel & Star Alloy (not on description page).
- Armory/Arsenal are content mods, not data-driven item libraries. Items need Java in 1.21.1.
- Spell book creation at binding table is on (config/spell_engine/server.json5: `spell_book_creation_enabled`).
- Item stats live in configs: config/wizards/equipment_v2.json (attributes per item id, e.g. `spell_power:fire` ADD_VALUE 5.0 on wands), config/armory_rpgs/equipment_v3.json (armor sets, ADD_MULTIPLIED_BASE spell power + haste).

## Unverified — check in jars first
- Spell Power 1.6.0 ships a `lightning` school (attribute + damage type). If not, register one.
- Spell Engine 1.10 spell JSON schema: copy real files from wizards jar `data/wizards/spell/` as templates.
- Elemental Wizards 3.1.0 is the template for a third-party class addon (item registration, spell book tag, AzureLib armor).

## Steps
1. Copy jars into `jars/`: wizards, spell_engine, spell_power, elemental_wizards_rpg, more_rpg_library, runes, azurelibarmor.
2. Unzip; read Elemental Wizards item/armor registration + spell JSON + spell_books tag layout.
3. Scaffold Fabric mod (JDK 21, Loom), deps via Modrinth maven.
4. Spells (~5): bolt, chain, storm AoE, static shield/buff, blink or shock nova. Vanilla `lightning_bolt`, `electric_spark` particles.
5. Spell book tag → Spell Binding Table book.
6. Items: staff, wand, robes; attributes via config entries mirroring wizards equipment_v2 pattern.
7. Textures: hue-map arcane → cyan/yellow, review as images, hand tweaks.
8. Build locally, test client → server, read latest.log per round (expect 3–5 rounds).
