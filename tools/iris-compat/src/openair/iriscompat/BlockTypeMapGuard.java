package openair.iriscompat;

import java.util.Collections;
import net.fabricmc.loader.api.entrypoint.PreLaunchEntrypoint;

/**
 * Iris 1.8.x leaves WorldRenderingSettings.blockTypeIds null until a rendering
 * pipeline exists, but its ItemBlockRenderTypes mixin dereferences it. Any mod
 * that asks for a block's render layer during client init crashes (Iris #3084;
 * More Slabs Stairs & Walls 4.2.0 does this). Iris itself installs an empty map
 * for the vanilla pipeline, so installing one before any mod initialises is the
 * same state one step earlier. Iris replaces it when a shader pack loads.
 */
public final class BlockTypeMapGuard implements PreLaunchEntrypoint {
    @Override
    public void onPreLaunch() {
        try {
            Class<?> settings = Class.forName("net.irisshaders.iris.shaderpack.materialmap.WorldRenderingSettings");
            Object instance = settings.getField("INSTANCE").get(null);
            if (settings.getMethod("getBlockTypeIds").invoke(instance) == null) {
                settings.getMethod("setBlockTypeIds", java.util.Map.class).invoke(instance, Collections.emptyMap());
                System.out.println("[openair-iris-compat] pre-filled Iris block type map");
            }
        } catch (Throwable t) {
            System.err.println("[openair-iris-compat] block type guard skipped: " + t);
        }
    }
}
