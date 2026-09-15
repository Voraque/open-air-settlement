package openair.iriscompat;

import java.util.Map;
import net.fabricmc.api.ClientModInitializer;

/**
 * Inserts datapack/mod biome keys into Iris's biome map so Iris generates
 * BIOME_<PATH> defines for them (Iris 1.8 only registers keys created through
 * vanilla Biomes.register). Reflection keeps the compile classpath to fabric-loader.
 * shortcut: keys are a fixed list; upgrade path is reading them from a config file.
 */
public final class IrisPaleBiomes implements ClientModInitializer {
    private static final int BASE_ID = 4000;
    private static final String[] KEYS = {
        "com.perfectparitypg.world.biome.ModBiomes#PALE_GARDEN"
    };

    @Override
    public void onInitializeClient() {
        try {
            Class<?> uniforms = Class.forName("net.irisshaders.iris.uniforms.BiomeUniforms");
            @SuppressWarnings("unchecked")
            Map<Object, Integer> map = (Map<Object, Integer>) uniforms.getMethod("getBiomeMap").invoke(null);
            int id = BASE_ID;
            for (String spec : KEYS) {
                String[] parts = spec.split("#");
                Object key = Class.forName(parts[0]).getField(parts[1]).get(null);
                map.putIfAbsent(key, id++);
                System.out.println("[openair-iris-compat] " + key + " -> biome id " + map.get(key));
            }
        } catch (Throwable t) {
            System.err.println("[openair-iris-compat] biome defines skipped: " + t);
        }
    }
}
