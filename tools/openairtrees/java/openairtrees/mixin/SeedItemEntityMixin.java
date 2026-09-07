package openairtrees.mixin;

import com.dtteam.dynamictrees.item.Seed;
import com.dtteam.dynamictrees.config.DTConfigs;
import com.dtteam.dynamictrees.worldgen.BiomeDatabases;
import net.minecraft.class_1542;
import net.minecraft.class_1799;
import net.minecraft.class_1937;
import net.minecraft.class_2338;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/** Fabric 1.21.1 intermediary names; only restores DT 1.7.2's missing seed update hook. */
@Mixin(value = class_1542.class, remap = false)
public abstract class SeedItemEntityMixin {
    @Inject(method = "method_5773", at = @At("TAIL"), remap = false)
    private void openairtrees$plantExpiredSeed(CallbackInfo ci) {
        class_1542 entity = (class_1542)(Object)this;
        class_1937 level = entity.method_37908();
        if (level.field_9236 || !entity.method_5805()) return;
        class_1799 stack = entity.method_6983();
        if (!(stack.method_7909() instanceof Seed seed)) return;
        // Vanilla's saved item age survives world reloads and stack merging.
        if (entity.method_6985() < Math.max(1, seed.getTimeToLive(stack) - 20)) return;
        class_2338 pos = entity.method_24515();
        boolean forestAllowed = !DTConfigs.SERVER.seedOnlyForest.get()
            || BiomeDatabases.getDimensionalOrDefault(level.method_27983().method_29177())
                .getForestness(level.method_23753(pos)) > 0.0f;
        if (forestAllowed && seed.shouldPlant(level, pos, stack)) {
            seed.doPlanting(level, pos, null, stack);
        }
        // Match DT's intended one planting attempt per expired dropped stack.
        entity.method_31472();
    }
}
