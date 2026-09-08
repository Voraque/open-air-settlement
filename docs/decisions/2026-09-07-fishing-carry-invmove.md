# Fishing and inventory convenience — September 7, 2026

Pack1.0.40 adds Fishing Real1.9.1, Carry On2.2.6 (jar2.2.6.13), InvMove0.9.3 and InvMoveCompats0.5.0. Exact Fabric1.21.1 versions and SHA512 downloads are pinned. InvMoveCompats uses a1.21.8 filename but declares Minecraft>=1.21 and InvMove>=0.9.0 and is listed for1.21.1 by Modrinth. Both InvMove components are client-only; the two gameplay mods require client and server. Existing dependencies satisfy their declared requirements.

Fishing Real turns supported caught fish items into live entities. Carry On uses sneak+right-click with empty hands to lift supported blocks/mobs, then right-click to place. InvMove allows movement with inventories open; its compatibility addon supports JEI. Defaults are retained. No new Naturalist fish mappings or villager transport restrictions are claimed.

Validation: both gameplay mods loaded in the existing full-pack disposable server, reached Done, and shut down with exit0. This is startup validation, not an in-game fishing/carrying test. Client movement and JEI typing remain untested interactively.

Deployment: all four jars prepared in the local Prism client. Only Fishing Real and Carry On uploaded and hash-verified in inactive FadeHost folder qol-stage-20260907. No live restart or active server mod change occurred. Activation waits for terrain generation to finish and a fresh consistent backup while empty. The follow-through automation should then move only these two verified jars into mods, start the server, and verify startup. Roll back these additions if startup fails. Never put either InvMove jar on the server.

Official descriptions: https://modrinth.com/mod/fishing-real , https://modrinth.com/mod/carry-on , https://modrinth.com/mod/invmove .
