# Benji quick start

This is the short path for a second player joining the existing world.

## Exact client baseline

- Minecraft **1.21.1**
- Fabric Loader **0.19.3**
- Java **21**
- Shared pack **1.0.6**
- Iris **1.8.8**
- Sodium **0.6.13**
- Distant Horizons **3.2.0-b** for Minecraft 1.21.1 Fabric

The host server does not need Iris, Sodium, Distant Horizons, shader ZIPs, or minimap files. Those are client-side.

## CurseForge

1. Use the **Open-Air Settlement** profile, not a generic Fabric profile.
2. Download [`Open-Air-Settlement-1.0.6-CurseForge.zip`](../downloads/Open-Air-Settlement-1.0.6-CurseForge.zip) and import it as a custom profile. The GitHub `.mrpack` is for the Modrinth App, Prism, or ATLauncher; CurseForge does not use that format.
3. In the profile's **Add More Content** screen, search for **Distant Horizons: A Level of Detail mod**.
4. Filter to **Minecraft 1.21.1** and **Fabric**, then choose **3.2.0-b**. The file name should be `DistantHorizons-3.2.0-b-1.21.1-fabric-neoforge.jar`.
5. Do not use CurseForge's “update all” on this profile. It may replace Sodium 0.6.13 with Sodium 0.8.x, which breaks Iris 1.8.8. Keep Supplementaries at 3.6.7.
6. Launch once before joining the server.

## Verify it

From the title screen, open **Mods** and search for Distant Horizons. In a world, open **Options → Video Settings → Distant Horizons**. The far view is not immediate: DH builds a local cache from terrain the client has loaded or explored.

Start with vanilla render distance 8–12 and DH distance 128. Raise DH only after the cache is building smoothly.

## If the client warns about G1

That is a performance warning, not a missing-mod error. Java 21 supports ZGC.

In CurseForge profile settings, add this JVM argument:

```
-XX:+UseZGC
```

Keep the profile memory around 4 GB. ZGC is a personal client setting and should not be added to the server.

## If something fails

- **Iris asks for Sodium 0.6.x:** remove Sodium 0.8.x and install Sodium 0.6.13.
- **Distant Horizons is absent from the Mods list:** check the profile's `mods` folder and confirm the jar name above; do not add a second copy.
- **No distant terrain appears:** turn shaders off once, join the world, move through unexplored terrain, and let DH build its cache.
- **The game starts but the shader reports uniform warnings:** keep shaders off until the base client and DH cache work. Complementary is optional.
- **The server rejects the connection:** verify that the client says Minecraft 1.21.1/Fabric 0.19.3 and that the host is using the current server address.
