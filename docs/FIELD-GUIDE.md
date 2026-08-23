# Open-Air Settlement: practical field guide

This is a working guide, not a recipe catalogue. Use JEI for recipes and item uses: hover an item and press `R` for recipes or `U` for uses; search by name or `@modname`. Use Mod Menu and Options → Controls when a setting or keybind is unclear. Come back here for priorities, tradeoffs, and shared projects.

## First three sessions

### Session 1: stay alive and map the problem

Find temporary shelter, water, several food sources, a retreat, and a route home. Do not spend the whole first session on a permanent house. Mark the return route and notice what the terrain offers: wood, crops, animals, stone, and defensible sightlines.

### Session 2: make food and night predictable

Start a small mixed plot and keep a simple emergency food chest. Watch the NutritionZ display and rotate foods when a nutrient falls behind; ask JEI which meals contain what you need. Test the base entrance, lighting, inner retreat, and alternate exit. Zombie Awareness makes sound, blood, and exposed light meaningful, so a torch wall is not the whole defence.

### Session 3: make the settlement useful

Give the base rooms and names: pantry, farm, workshop, storage, map wall, and lookout. Connect a small Tom’s Simple Storage network. Mark routes with signs, towers, caches, or bridges. Choose one repeated chore that should eventually become a turtle or Oritech job.

## The systems that matter

### Recipes and ordinary questions: JEI

Do not memorise the pack. Use JEI for exact recipes, uses, machine inputs, and unfamiliar items. If a recipe is not obvious, search the item, check both `R` and `U`, and search by `@modname` to narrow the list. The web is for troubleshooting or deep dives, not for remembering how to make a knife.

### Food: NutritionZ + Farmer's Delight

The first food milestone is reliable variety, not a perfect kitchen. Plant several crops and keep a few animal sources nearby. Farmer’s Delight gives the food chain a purpose: ingredients can be portioned on the Cutting Board and meals assembled in the Cooking Pot. JEI supplies the exact layouts. Keep emergency simple food for expeditions; meals should support leaving home.

### Danger: Zombie Awareness + Better Dungeons

Enhanced mobs investigate blood, mining and building sounds, doors, containers, and other events. Exposed light can also reveal a base. Build a controlled entrance, a retreat room, sightlines, an alternate exit, and a way to close the farm or workshop. Better Dungeons are trips: bring food, blocks, light, a way home, and a point where turning back is sensible.

### Animals: Naturalist

Naturalist adds animals, variants, drops, and behaviour that make biomes worth observing. It is not a complete population simulator. Watch creatures in their habitat before moving them into a pen, bring breeding stock home deliberately, and leave wild habitats intact. Record notable species, water, hazards, and routes with signs or a shared map.

### Terrain and travel: Terralith, Tectonic, Gliding

The useful question is not “what is the best seed?” but “what route and settlement does this place support?” Find water, food, a defensible approach, and two routes outward. Build small wayfinding infrastructure before flattening anything. Gliding makes height useful; treat launch points and outposts as shared infrastructure.

### Settlement: Supplementaries + Handcrafted

Use these to make work areas readable. Supplementaries supplies signposts, jars, ropes, planters, lights, and small mechanisms. Handcrafted supplies furniture and visual distinctions. Build the pantry, farm, entrance, workshop, storage room, and map wall before adding decorative rooms. Use JEI for any specific item.

### Logistics: Tom’s Simple Storage

Start with one terminal and a small connected set of inventories. Expand only when you know what is missing. Keep food, tools, raw materials, and project supplies visibly distinct even after they are searchable. A storage network should reduce friction without erasing shared understanding.

### Carrying and mapping: Traveler’s Backpack + Xaero

Traveler’s Backpack is portable storage, a sleeping bag, upgrades, and later fluid capacity. It is convenience, not a replacement for a base. Use the map as a record of routes, landmarks, farms, danger, and caches—not as a reason to stop exploring.

### Automation: CC:Tweaked + Oritech

Automate in this order: reliable, repeatable, large. A turtle needs fuel to move; if it stops, check fuel, inventory space, the block in front, and whether the program handled a `false` result. Start with a test lane and a boring job such as item transfer, a small tree row, or a marked tunnel. Give it a name and a stop procedure.

Use the in-game ComputerCraft help and the official turtle API for the commands. Use Oritech for a real material bottleneck: one generator, one processing chain, and one output store. Both players should know what an automation consumes, where output goes, how to stop it, and what happens when it fails.

## Self-sufficiency ladder

1. **Food independence:** mixed field, dependable crop or animal sources, emergency food, and enough variety for both players.
2. **A defensible home:** controlled entrance, sightlines, inner retreat, alternate exit, and a perimeter that responds to actual problems.
3. **Material independence:** renewable tree/crop area, organised raw materials, and marked expeditions for what is not renewable.
4. **Logistics independence:** searchable storage, labelled inputs and outputs, and a workshop where projects can resume.
5. **Labour independence:** one turtle job that is safe, observable, stoppable, and able to report failure.
6. **Industrial independence:** Oritech handles a real bottleneck, with power, processing, output, and maintenance understood by both players.

## Compatibility notes

- Both players use the 1.0.4 pack, Minecraft 1.21.1, Fabric Loader 0.19.3, and Java 21.
- Gameplay mods must match the server. Shaders, maps, and other client-only visuals may differ.
- Keep Iris 1.8.8 with Sodium 0.6.13 and Supplementaries 3.6.7.
- Do not re-add Realistic Wildlife (`wildlife-dynamics-1.0.0.jar`): its released implementation caused severe server tick stalls.

## Optional deeper references

Use these only when the guide and in-game tools are insufficient: [JEI](https://modrinth.com/mod/jei), [Naturalist](https://modrinth.com/mod/naturalist), [Zombie Awareness](https://modrinth.com/mod/zombie-awareness), [Farmer's Delight Refabricated](https://www.curseforge.com/minecraft/mc-mods/farmers-delight-refabricated), [CC:Tweaked turtles](https://tweaked.cc/module/turtle.html), [Supplementaries](https://modrinth.com/mod/supplementaries), and [Oritech](https://modrinth.com/mod/oritech).
