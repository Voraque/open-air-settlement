# Tree texture audit — September 7, 2026

Client log confirms ten missing openairtrees branch item models, plus 27 missing Blooming Nature bark/stripped-bark texture names. The Fabric Dynamic Trees model loader constructs branch models directly from family primitive-log identifiers and texture_overrides. Correct block-model JSON textures alone do not override this path. The earlier static reference audit missed that generated-name behavior.

Prepared Open Air Trees 0.5.1 adds all forty explicit family texture mappings and ten item models using Dynamic Trees' branch item parent. All non-vanilla texture and model references resolve against the installed dependency jars. Java classes are unchanged. This is an asset correction; no tree identities, growth, world generation or player data changes.

The prepared jar and detailed audit are in the private book-village staging folder. It is not yet installed in the running client or server, nor published in the shared manifest. Client reload/render verification remains outstanding. The aspen distant-render fallback warning may be related but has not been proven resolved. Unrelated bird-feeder and equipment model warnings also exist and were not changed.

DH pregen cancellation and generation.enable=false were verified via console. The existing automation was updated to prohibit automatic resumption. Generated terrain and caches were retained. This stop does not mark the full 256-chunk pass complete or authorize a server restart.
