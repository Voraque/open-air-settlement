import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerLifecycleEvents;
import net.minecraft.*;
import net.pneumono.gravestones.api.GravestonesApi;
import red.jackf.lenientdeath.api.LenientDeathAPI;
public class DeathAudit implements ModInitializer {
 static void check(boolean ok,String msg){if(!ok)throw new AssertionError(msg);System.out.println("DEATH_PASS "+msg);}
 public void onInitialize(){GravestonesApi.registerItemSkipPredicate((p,s)->p instanceof class_3222 sp && LenientDeathAPI.INSTANCE.shouldItemBePreserved(sp,s));
 ServerLifecycleEvents.SERVER_STARTED.register(server->{try{
 var w=server.method_30002();var p=new class_3222(server,w,new com.mojang.authlib.GameProfile(java.util.UUID.randomUUID(),"DeathAudit"),class_8791.method_53821());
 var inv=p.method_31548();String[] ids={"diamond_pickaxe","iron_chestplate","bow","shield","iron_sword","bread","cobblestone"};
 for(int i=0;i<ids.length;i++){var item=class_7923.field_41178.method_10223(class_2960.method_60654("minecraft:"+ids[i]));inv.method_5447(i,new class_1799(item));check(LenientDeathAPI.INSTANCE.shouldItemBePreserved(p,inv.method_5438(i))==(i<5),"classification_"+ids[i]);}
 var grave=GravestonesApi.getDataToInsert(p);System.out.println("GRAVE_DATA "+grave);
 for(int i=0;i<5;i++)check(!inv.method_5438(i).method_7960(),"grave_keeps_equipment_"+ids[i]);
 for(int i=5;i<7;i++)check(inv.method_5438(i).method_7960(),"grave_takes_material_"+ids[i]);
 inv.method_7388();for(int i=0;i<5;i++)check(!inv.method_5438(i).method_7960(),"death_drop_keeps_"+ids[i]);
 var respawn=new class_3222(server,w,p.method_7334(),class_8791.method_53821()); respawn.method_14203(p,false); for(int i=0;i<5;i++)check(!respawn.method_31548().method_5438(i).method_7960(),"respawn_keeps_"+ids[i]); System.out.println("DEATH_AUDIT_COMPLETE");
 }catch(Throwable e){e.printStackTrace();System.out.println("DEATH_AUDIT_FAILED");}finally{server.method_3747(false);}});}}
