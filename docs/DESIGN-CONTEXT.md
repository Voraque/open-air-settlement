# Design context and future plans

This document records why the pack is shaped the way it is, so another agent or collaborator can contribute without turning it into an undirected mod collection.

## The experience we are optimizing for

We want Minecraft to feel like a place that asks something of us before it becomes a machine for satisfying us. The target is a two-player settlement game with:

- BOTW/TOTK-like expansiveness: terrain, routes, landmarks, and traversal should be reasons to go somewhere.
- A sustained first night: food and monsters should remain relevant into the early and middle game. The purpose is not arbitrary difficulty; it is to make a farm, pantry, wall, lookout, and defence system feel earned.
- Better building: rooms, paths, storage, workshops, signs, and logistics should make a settlement readable and inhabited.
- A satisfying graduation: automations, turtles, and machines should remove repetitive labour after we have understood the work, while leaving meaningful projects and choices.
- Ecology: animals should give biomes character and create observation, habitat, food, and interaction decisions. The pack should not claim a complete Rain World-style simulation when it does not have one.

## The core design rule

Each major convenience should answer a known friction rather than erase a source of meaning.

- Food systems should make farming and cooking worth doing, not produce a spreadsheet.
- Storage should reduce searching, not make the settlement's organisation meaningless.
- Backpacks should support expeditions, not make a base unnecessary.
- Turtles should remove a repeated chore after the chore has taught us what to automate.
- Oritech should solve a bottleneck, not become a second job of maintaining an opaque factory.
- Fast movement should reward landmarks and routes rather than bypass the world immediately.

Changes should also be proven where possible. Prefer a maintained, multiplayer-tested mod or datapack with a narrow purpose over a bespoke system. A custom tweak is appropriate only when it is small, reversible, documented, and expresses a behaviour already validated elsewhere; it should not become a second game-design project.

## Current pack decisions

- **Fabric 1.21.1:** retained because it gave us the best balance of performance, Iris/Sodium support, Naturalist, Oritech, CC:Tweaked, and the other chosen systems.
- **Naturalist:** kept as the lightweight creature and habitat layer. It adds many animals, variants, drops, and behaviours, but it is not a full population simulation.
- **Realistic Wildlife:** removed in 1.0.4. Its released `wildlife-dynamics-1.0.0.jar` performed full-world entity scans on server ticks and caused catastrophic lag. Do not restore it casually; a replacement must be profiled on both client and dedicated server.
- **NutritionZ + Farmer's Delight:** retained because food is the clearest way to keep survival relevant without simply increasing damage or spawn rates.
- **Hungrier:** retained as the small corrective to NutritionZ's awkward edge case: it lets a player eat a nutrient-balancing meal while technically full, without removing hunger or sprint costs.
- **Easy Mob Spawn Control:** retained as the adjustable, observable way to tune actual hostile populations. It is deliberately configured through the shared in-game panel after looking at live counts, rather than through an untested static spawn rewrite.
- **Custom Time Cycle:** retained because longer days create real expedition and building time, while longer-but-not-excessive nights preserve the value of returning to a defended settlement. It changes the clock only, not game tick speed, crops, machines, or redstone. The initial live trial is 20 minutes daylight / 12 minutes night.
- **Zombie leather + gravel sand:** deliberately small data-pack routes. They reduce the incentive to farm or strip natural ecosystems while retaining a fuel/time cost and vanilla items.
- **No Sapience:** deliberately excluded. A broad artificial-intelligence layer would add unpredictability and performance risk without yet giving us a legible settlement interaction we actually need. Retain and extend ordinary creature interactions instead.
- **Death and hearts:** deferred. Farming Experience Core contains the desired keep-inventory, one-heart-loss, golden-apple-recovery loop, but also bundles many unrelated world and combat changes. The focused 1.21.1 alternatives are new and lightly used. Revisit only when there is a mature standalone implementation or a clear reason to adopt a larger, tested system wholesale.
- **Zombie Awareness:** retained because it makes base defence legible: sound, blood, and light produce problems that architecture can answer.
- **Terralith + Tectonic + Gliding + Better Dungeons:** retained as the exploration spine. They make terrain, height, routes, and preparation matter.
- **Supplementaries + Handcrafted:** retained for settlement readability and building expression without a large decorative megamod.
- **Tom's Simple Storage → CC:Tweaked → Oritech:** the intended automation ladder: find things, automate labour, then industrialise bottlenecks.

## What the guide should do

The guide is not meant to replace JEI, Mod Menu, in-game help, or a focused troubleshooting page. It should instead answer the higher-level questions those tools do not:

1. What should we do next?
2. What problem is each mod meant to solve?
3. What should we build first, and why?
4. What does self-sufficiency mean for this settlement?
5. What should both players understand before an automation enters the shared world?

External links are optional deep dives. The guide should contain enough operating knowledge that Benji and Nicky can start playing without opening them.

## Future work, in order

1. **Playtest the first three sessions.** Record where food, danger, navigation, or mod interfaces fail to communicate what matters.
2. **Tune NutritionZ and Zombie Awareness.** The intended pressure is “problems worth answering,” not repetitive punishment or unavoidable deaths.
3. **Create a small CC:Tweaked starter library.** Include safe, inspectable examples for item transfer, a marked tree row, fuel checks, inventory-full handling, and a stop switch.
4. **Add Oritech milestones to the guide after we use them.** Prefer observed bottlenecks and actual layouts over a complete machine catalogue.
5. **Investigate creature interaction improvements carefully.** Any ecology addition must be tested for server cost, multiplayer compatibility, and whether it creates interesting observation rather than mere mob density.
6. **Consider AI-controlled companions only as an explicit bridge.** Claude/ChatGPT should not be assumed to have access to the game. Any bridge needs a narrow permission model, visible actions, a stop button, and a clear explanation of what data leaves the machine.
7. **Keep the pack small.** Every proposed mod should state which friction it addresses, what it replaces, its client/server requirements, and its measured performance cost.

## Contribution checklist

Before suggesting a mod or change, answer:

- Which player problem does it solve?
- Does it preserve food, danger, exploration, building, or automation as meaningful choices?
- Is it client-only, server-only, or required on both sides?
- Does it work on Fabric 1.21.1 with the pinned Iris/Sodium/Supplementaries combination?
- What happens to server tick time with two players and a fresh world?
- Can the change be removed or rolled back without invalidating the world?
- What should the guide say so a player can use it without following an external tutorial?
