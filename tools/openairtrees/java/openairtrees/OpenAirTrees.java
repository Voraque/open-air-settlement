package openairtrees;
import com.dtteam.dynamictrees.api.DynamicTreesAddonEntrypoint;
import com.dtteam.dynamictrees.registry.FabricRegistryHandler;
public final class OpenAirTrees implements DynamicTreesAddonEntrypoint {
    @Override public void onDynamicTreesPreSetup() {
        FabricRegistryHandler.setup("openairtrees");
    }
}
