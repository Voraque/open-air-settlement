# Equipment retained on death

Lenient Death 1.2.5+1.21.1 plus a small server-only Gravestones API adapter. Equipment recognized by Lenient Death bypasses grave capture, stays through inventory drop, and transfers on respawn. Gravestones remains installed; existing graves are preserved. Food and potions changed from upstream preserve to ignore, so normal supplies/materials go to graves. No additional durability penalty configured. Vanilla tool, weapon, armour and shield categories retain upstream preservation; trinket compatibility remains upstream and has not been integration-tested with every pack accessory.

Isolated Fabric 1.21.1 test with actual Gravestones 1.2.6 and Lenient Death proved classification, grave capture, inventory drop and respawn copying for diamond pickaxe, iron chestplate, bow, shield and iron sword. Bread and cobblestone appeared only in grave contents. Test harness does not simulate a connected player's lethal damage or grave UI. Production adapter contains only the public skip-predicate registration; test class is excluded. Modded equipment and accessory acceptance testing remains outstanding.

Server files uploaded and hashes verified. Activation awaits a server restart. Shared entries are server-only; clients do not need another mod to use the live server rules. Source: tools/equipment-graves. Config: server-config/lenientdeath.json5.
