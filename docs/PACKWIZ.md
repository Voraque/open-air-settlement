# Updating the shared pack

The `packwiz/` folder is the source of truth for the Open-Air Settlement client pack. It pins the Minecraft/Fabric versions and exact mod files, including Nullscape as a server-side data pack.

## For Benji

The easiest repeatable route is [`tools/setup-prism-packwiz.sh`](../tools/setup-prism-packwiz.sh) on macOS/Linux or [`tools/setup-prism-packwiz.ps1`](../tools/setup-prism-packwiz.ps1) on Windows. These scripts create a normal Prism instance, install the official bootstrap, and write the pre-launch command. They stop if an instance with the same name already exists so they cannot silently replace somebody's world or settings.

After running the script, sign into Microsoft in Prism once and launch the instance. Prism will separately download Minecraft's client jar, libraries, assets, Fabric libraries, and any uncached mod files on that first launch. That is expected: Prism's global cache is separate from the instance folder. It is not a pack-version change.

The exported `.mrpack` from the repository's Releases page remains a good fixed snapshot for Prism, Modrinth App, or CurseForge. Use the script when we want automatic GitHub-backed updates.

For faster updates, use a packwiz-compatible installer with the raw `packwiz/pack.toml` URL from this repository. The installer will pull the exact files and can update the instance when we publish a new commit.

Do not copy the `packwiz/` metadata into a normal Minecraft instance by hand. It is a recipe for the instance, not the instance itself. Do not launch a second Prism data folder with a custom `--dir` for ordinary setup; that creates a second empty-looking Prism window and separate account/cache state.

## For maintainers

Install packwiz from the [official instructions](https://packwiz.infra.link/installation/), then run these from the `packwiz/` folder:

```text
packwiz update
packwiz refresh
packwiz modrinth export
packwiz curseforge export
```

Add a mod by its exact project and version when possible:

```text
packwiz modrinth add --project-id <project> --version-id <version>
```

If a dependency is only distributed through CurseForge, pin its project and file IDs with `packwiz curseforge add`. Keep client-only visual/performance mods marked client-side and test any world-generation or dimension change in a disposable world first.

## Current release notes

The current release candidate is **1.0.21-rc1** (on branch `ecology-villagers-evidence-20260827`). It completes the evidence-accepted ecology pass: removes Ecological 0.3.0 (remedying global leaf random-ticking and broken textures), pins the source-built Green Cuts `1.0.4+openair.1` for dropped-sapling forest renewal, and applies the release-preserving Aether 1.5.11 recipe patch (making JEED and Supplementaries Squared conversions conditional). Both custom jars are hosted on release `v1.0.21-rc1`. The assembled server passed the headless smoke test with zero fatal findings.

The previous release is **1.0.20**. It adds the server-side Worn Path mechanic, which leaves only a restrained dirt-path trace where players repeatedly walk; it does not build roads, spread, or change paths into stone. The 1.0.19 release added BloomingNature and its Biolith world-generation library. BloomingNature changes only newly generated terrain; its richer detail and smaller biomes appear as new land is explored. Sensible Trade Overhaul applies to new or refreshed, unlocked villager offers. The FadeHost server receives the same mod and data-pack set during release deployment.

The 1.0.15 pack remains Fabric 1.21.1. It adds Celestria on client and server for synchronized shooting stars; the checked-in server setting explicitly disables its full-moon insomnia mechanic. It fixes the local server's missing Waystones and Balm installation. The visual additions—Interactive Foliage with SWAY, Euphoria Patches over Complementary Reimagined, Shoulder Surfing Reloaded with Smooth F5, EMF/ETF, Fresh Animations: Player Extension, and Camera Overhaul—are client-only. They may be configured or disabled per player without affecting a shared world. It retains the exact Sodium 0.6.13 / Iris 1.8.8 pairing used by the current 1.21.1 pack.

The checked-in server settings are `server-config/customtimecycle.json`, `server-config/cropxp.json`, `server-config/celestria.json`, and `server-config/worn_path.json5`. They are server-only, so neither player needs a client-side mod for these changes.

CropXp's shared rate is checked in at `server-config/cropxp.json`: a mature crop has a 25% chance to award one XP. This makes a tended garden a small XP source without making a crop field a new grinder.
