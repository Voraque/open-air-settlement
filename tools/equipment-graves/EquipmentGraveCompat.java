import net.fabricmc.api.ModInitializer;
import net.minecraft.class_3222;
import net.pneumono.gravestones.api.GravestonesApi;
import red.jackf.lenientdeath.api.LenientDeathAPI;
public class EquipmentGraveCompat implements ModInitializer {
 public void onInitialize(){GravestonesApi.registerItemSkipPredicate((player,stack)->player instanceof class_3222 sp && LenientDeathAPI.INSTANCE.shouldItemBePreserved(sp,stack));}
}
