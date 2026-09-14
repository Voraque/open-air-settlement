import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents;
import fr.rakambda.fallingtree.fabric.FallingTree;
public class TreeFilterTest implements ModInitializer {
 public void onInitialize() {
  ServerLifecycleEvents.SERVER_STARTED.register(server -> {
   var mod=FallingTree.getMod();
   var branches=mod.getBlock("#dynamictrees:branches").toList();
   var leaves=mod.getBlock("#dynamictrees:leaves").toList();
   if(branches.isEmpty() || leaves.isEmpty()) throw new IllegalStateException("Missing dynamic tree tags");
   if(branches.stream().anyMatch(mod::isLogBlock)) throw new IllegalStateException("Dynamic branch accepted by FallingTree");
   if(leaves.stream().anyMatch(mod::isLeafBlock)) throw new IllegalStateException("Dynamic leaf accepted by FallingTree");
   for(String id:new String[]{"minecraft:oak_log","bloomingnature:aspen_log"}) {
    var block=mod.getBlock(id).findFirst().orElseThrow();
    if(!mod.isLogBlock(block)) throw new IllegalStateException("Ordinary log rejected: "+id);
   }
   var aspen=mod.getBlock("openairtrees:aspen_branch").findFirst().orElseThrow();
   if(mod.isLogBlock(aspen)) throw new IllegalStateException("Custom dynamic tree rejected by test");
   if(!mod.getConfiguration().getTrees().getBreakMode().name().equals("FALL_ITEM")) throw new IllegalStateException("Wrong falling mode");
   System.out.println("TREE_FILTER_PASS branches="+branches.size()+" leaves="+leaves.size());
  });
 }
}
