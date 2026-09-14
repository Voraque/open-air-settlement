# Tree felling ownership

The FadeHost configuration allowed FallingTree to act on Dynamic Trees branches through vanilla log tags while also enabling Dynamic Trees' own falling animation. Ordinary trees used INSTANTANEOUS mode. This overlap is a plausible cause of inconsistent trunk/canopy behavior, not a confirmed rendered reproduction of the reported symptom.

Prepared changes in server-config/fallingtree.json:
- Exclude #dynamictrees:branches and #dynamictrees:stripped_branches from FallingTree log handling, and #dynamictrees:leaves from its leaf handling. Open Air Trees contributes its custom species to these tags.
- Use FALL_ITEM and LOWEST_FIRST for animated normal loot, rather than leaving fallen log and leaf blocks on the ground.
- Preserve allowMixedLogs=true as observed on FadeHost. Existing scan and size limits remain intact.

Dynamic Trees retains enableFallingTrees=true and its native tree/canopy animation. These changes do not implement independently simulated leaves for dynamic trees. Large or unsupported ordinary trees can still exceed the existing detector limits.

A disposable server test verifies the resolved branch and leaf exclusions, acceptance of ordinary oak/aspen logs, rejection of the custom dynamic aspen branch, and the selected animation mode. The fixture source is tools/pack-validation/fixtures/tree-felling/TreeFilterTest.java; it is a test-only Fabric entrypoint and must never be shipped in the pack. Source inspection confirms stripped_branches is a separate tag; it is excluded defensively as well.

The final behavior still needs a player felling one dynamic and one ordinary tree after server activation. No visual reproduction or live-server change was performed. Deploy with the pending coordinated restart.

Validation: 20260914T062112Z-14fa5fdc passed the runtime filter/mode assertion (20 branch types, 22 leaf types), with zero fatal findings and cooperative shutdown. Rendered felling and exact leaf motion remain unverified.

Activated on FadeHost on 2026-09-14 with explicit authorization to restart regardless of connected players. Uploaded both copper mod jars and the merged FallingTree configuration; verified uploaded SHA-256 hashes. Published pack 1.0.47 to main. Fresh server startup logged both new mod versions and Done; multiplayer status responded successfully. Server-side FALL_ITEM and dynamic/stripped branch exclusions were read back. The previous files and startup log are retained locally in deployment-backup-20260914. Both clients must relaunch to update. Whole-tree Dynamic Trees harvesting remains enabled; rendered leaf motion still needs a playtest.
