# Optional shader setup

The compatible baseline is:

- Distant Horizons 3.2.0-b (client-side)
- Iris 1.8.8
- Sodium 0.6.13
- Complementary Reimagined r5.8.1

It is not required for multiplayer and does not belong on the server.

1. Download [Complementary Reimagined r5.8.1](https://modrinth.com/shader/complementary-reimagined/version/yCCduG44).
2. Leave the download as a `.zip`; do not extract it.
3. In Minecraft, open **Options → Video Settings → Shader Packs → Open Shader Pack Folder** and put the zip there.
4. Select **Complementary Reimagined r5.8.1** and start with the **Low** profile.
5. In Distant Horizons settings, start at 128–192 chunks. Keep vanilla render distance at 8–12. Let the far-terrain cache build before raising either distance.
6. If LOD terrain is missing or the seam is wrong, turn shaders off, let DH finish caching the explored area, then re-enable Complementary.

Complementary Reimagined r5.8.1 includes Distant Horizons terrain and water shader passes. Do not substitute an arbitrary shader if the far view matters.

The shader ZIP is deliberately not copied into this repository. The official download is the safe route and keeps the repository redistributable.

### Benji's Apple-silicon Mac

Treat shaders as experimental, not part of the shared baseline. Keep shaders off first; the game itself remains fully playable without them.
