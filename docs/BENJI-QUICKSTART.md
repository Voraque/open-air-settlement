# Benji quick start

This is the short path for a second player joining the existing world.

## Exact client baseline

- Minecraft **1.21.1**
- Fabric Loader **0.19.3**
- Java **21**
- Shared pack **1.0.14**
- Iris **1.8.8**
- Sodium **0.6.13**
- Distant Horizons **3.2.0-b** for Minecraft 1.21.1 Fabric

The host server does not need Iris, Sodium, AmbientSounds, Better Clouds, Particle Rain, shader ZIPs, or minimap files. It does have the matching Distant Horizons 3.2.0-b server build installed so it can pre-generate and stream far-terrain data; your client still needs its own Distant Horizons jar.

## Recommended Prism setup

For the least manual work, have Claude run the setup script from a checkout of this repository:

### macOS

```sh
cd /path/to/open-air-settlement
bash tools/setup-prism-packwiz.sh
open -a "Prism Launcher"
```

### Windows PowerShell

```powershell
Set-Location C:\path\to\open-air-settlement
powershell -ExecutionPolicy Bypass -File .\tools\setup-prism-packwiz.ps1
```

The script creates a normal Prism instance at Prism's standard data location, installs the official packwiz bootstrap, and records the GitHub `pack.toml` as the pre-launch sync source. It is intentionally conservative: if an instance with the same name already exists, it stops rather than overwriting it. Do not create a second Prism data root with `--dir` unless you are deliberately troubleshooting.

Prism's Microsoft sign-in is the one human step. After signing in, launch **Open-Air Settlement** once. The first launch may download Minecraft's client jar, libraries, assets, Fabric libraries, and uncached mod files; this is normal and does not mean the pack is changing. Later launches check the packwiz source and download only changes.

If Prism is not installed, install it first (`brew install --cask prismlauncher` on macOS or `winget install --exact PrismLauncher.PrismLauncher` on Windows), then run the matching script above. Do not copy `packwiz/` into `.minecraft` by hand: it is the pack recipe, not the installed instance.

## CurseForge

1. Use the **Open-Air Settlement** profile, not a generic Fabric profile.
2. Modrinth/Prism/ATLauncher users: download the GitHub `.mrpack` from the `downloads/` folder. CurseForge users: use the existing Open-Air Settlement profile, or run [`tools/build-curseforge-profile.ps1`](../tools/build-curseforge-profile.ps1) from a checkout to create a proper import ZIP.
3. In the profile's **Add More Content** screen, search for **Distant Horizons: A Level of Detail mod**.
4. Filter to **Minecraft 1.21.1** and **Fabric**, then choose **3.2.0-b**. The file name should be `DistantHorizons-3.2.0-b-1.21.1-fabric-neoforge.jar`.
5. Do not use CurseForge's “update all” on this profile. It may replace Sodium 0.6.13 with Sodium 0.8.x, which breaks Iris 1.8.8. Keep Supplementaries at 3.6.7.
6. Launch once before joining the server.

## Verify it

From the title screen, open **Mods** and search for Distant Horizons. In a world, open **Options → Video Settings → Distant Horizons**. The host has pre-generated a bounded far-terrain area around spawn; beyond that, the server can supply DH data as it becomes available. The far view still is not immediate everywhere: DH maintains a local cache on each client.

Start with vanilla render distance 16–20 and DH distance 128–256. The shared recommendation is balanced DH detail rather than maximum block-by-block detail; let the cache build before raising it further.

## If the client warns about G1

That is a performance warning, not a missing-mod error. Java 21 supports ZGC.

In Prism or CurseForge profile settings, add this JVM argument:

```
-XX:+UseZGC
```

Keep the profile memory around 4 GB. The dedicated server is also configured for ZGC on Java 21; Benji only needs to add it to his own client if Prism does not already show `-XX:+UseZGC`.

## Rebuilding the stockpile elsewhere

Yoz can place the migrated stockpile at a new location with:

```
/function open_air:warehouse
```

Stand two blocks above the intended warehouse floor before running it. The command recreates the supplied stockpile, so use it deliberately; it is useful for relocating the warehouse, not for making free duplicate copies.

## If something fails

- **Iris asks for Sodium 0.6.x:** remove Sodium 0.8.x and install Sodium 0.6.13.
- **Distant Horizons is absent from the Mods list:** check the profile's `mods` folder and confirm the jar name above; do not add a second copy.
- **No distant terrain appears:** turn shaders off once, join the world, move through unexplored terrain, and let DH build its cache.
- **The game starts but the shader reports uniform warnings:** keep shaders off until the base client and DH cache work. Complementary is optional.
- **The server rejects the connection:** verify that the client says Minecraft 1.21.1/Fabric 0.19.3 and that the host is using the current server address.
